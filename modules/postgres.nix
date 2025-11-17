{
  # config,
  pkgs,
  lib,
  ...
}:

let
  dbPort = 5432;
  pgBouncerPort = 15432;
  numberOfClientCerts = 5; # Generate this many client certificates
  certValidityDays = 365;

  clientCertNames = map (i: "client-${toString i}") (lib.range 1 numberOfClientCerts);
in
{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_17;

    # listen only on localhost since PgBouncer is on same host
    settings = {
      listen_addresses = "localhost";
      port = dbPort;

      ssl = true;
      ssl_cert_file = "/var/lib/postgresql/certs/server.crt";
      ssl_key_file = "/var/lib/postgresql/certs/server.key";
      ssl_ca_file = "/var/lib/postgresql/certs/ca.crt";
      ssl_crl_file = "/var/lib/postgresql/certs/root.crl";

      ssl_client_auth = "verify-ca";

      log_connections = true;
      log_disconnections = true;
      log_statement = "ddl";

      shared_buffers = "256MB";
      effective_cache_size = "1GB";
      work_mem = "4MB";
      maintenance_work_mem = "64MB";
    };

    authentication = pkgs.lib.mkOverride 10 ''
      # require SSL and certificates for all connections
      hostssl all all 127.0.0.1/32 cert
      hostssl all all ::1/128 cert
      # local connections for maintenance
      local all postgres peer
    '';
  };

  services.pgbouncer = {
    enable = true;
    listenAddress = "0.0.0.0";
    listenPort = pgBouncerPort;

    databases = {
      # myapp = "host=localhost port=5432 dbname=myapp";
    };

    poolMode = "transaction";
    maxClientConn = 1000;
    defaultPoolSize = 25;
    minPoolSize = 5;
    reservePoolSize = 5;

    authType = "cert";
    authFile = "/var/lib/pgbouncer/userlist.txt";

    extraConfig = ''
      server_tls_sslmode = require
      server_tls_cert_file = /var/lib/pgbouncer/certs/server.crt
      server_tls_key_file = /var/lib/pgbouncer/certs/server.key
      server_tls_ca_file = /var/lib/pgbouncer/certs/ca.crt

      client_tls_sslmode = require
      client_tls_cert_file = /var/lib/pgbouncer/certs/server.crt
      client_tls_key_file = /var/lib/pgbouncer/certs/server.key
      client_tls_ca_file = /var/lib/pgbouncer/certs/ca.crt

      server_connect_timeout = 15
      server_login_retry = 15
      client_login_timeout = 60
      autodb_idle_timeout = 3600

      log_connections = 1
      log_disconnections = 1
      syslog = 1
    '';
  };

  systemd.services.postgres-certs = {
    description = "Generate PostgreSQL certificates";
    wantedBy = [
      "postgresql.service"
      "pgbouncer.service"
    ];
    before = [
      "postgresql.service"
      "pgbouncer.service"
    ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      User = "root";
    };

    script = ''
      CERT_DIR="/var/lib/postgresql/certs"
      PGBOUNCER_CERT_DIR="/var/lib/pgbouncer/certs"
      CLIENT_DIR="/var/lib/postgresql/client-certs"

      mkdir -p "$CERT_DIR" "$PGBOUNCER_CERT_DIR" "$CLIENT_DIR"

      if [[ ! -f "$CERT_DIR/ca.key" ]]; then
        echo "generating CA certificate..."
        ${pkgs.openssl}/bin/openssl genrsa -out "$CERT_DIR/ca.key" 4096
        ${pkgs.openssl}/bin/openssl req -new -x509 -days $((${toString certValidityDays} * 10)) \
          -key "$CERT_DIR/ca.key" \
          -out "$CERT_DIR/ca.crt" \
          -subj "/C=US/ST=State/L=City/O=Organization/OU=Database/CN=PostgreSQL-CA"
      fi

      # generate server certificate if it doesn't exist or is expiring soon
      if [[ ! -f "$CERT_DIR/server.key" ]] || ! ${pkgs.openssl}/bin/openssl x509 -in "$CERT_DIR/server.crt" -checkend $((30 * 24 * 3600)) -noout 2>/dev/null; then
        echo "generating server certificate..."
        ${pkgs.openssl}/bin/openssl genrsa -out "$CERT_DIR/server.key" 4096
        ${pkgs.openssl}/bin/openssl req -new \
          -key "$CERT_DIR/server.key" \
          -out "$CERT_DIR/server.csr" \
          -subj "/C=US/ST=State/L=City/O=Organization/OU=Database/CN=$(hostname)"
        ${pkgs.openssl}/bin/openssl x509 -req -days ${toString certValidityDays} \
          -in "$CERT_DIR/server.csr" \
          -CA "$CERT_DIR/ca.crt" \
          -CAkey "$CERT_DIR/ca.key" \
          -CAcreateserial \
          -out "$CERT_DIR/server.crt"
        rm -f "$CERT_DIR/server.csr"
      fi

      # generate client certificates
      ${lib.concatMapStringsSep "\n" (clientName: ''
        if [[ ! -f "$CLIENT_DIR/${clientName}.key" ]] || ! ${pkgs.openssl}/bin/openssl x509 -in "$CLIENT_DIR/${clientName}.crt" -checkend $((30 * 24 * 3600)) -noout 2>/dev/null; then
          echo "Generating client certificate: ${clientName}"
          ${pkgs.openssl}/bin/openssl genrsa -out "$CLIENT_DIR/${clientName}.key" 4096
          ${pkgs.openssl}/bin/openssl req -new \
            -key "$CLIENT_DIR/${clientName}.key" \
            -out "$CLIENT_DIR/${clientName}.csr" \
            -subj "/C=US/ST=State/L=City/O=Organization/OU=Clients/CN=${clientName}"
          ${pkgs.openssl}/bin/openssl x509 -req -days ${toString certValidityDays} \
            -in "$CLIENT_DIR/${clientName}.csr" \
            -CA "$CERT_DIR/ca.crt" \
            -CAkey "$CERT_DIR/ca.key" \
            -CAcreateserial \
            -out "$CLIENT_DIR/${clientName}.crt"
          rm -f "$CLIENT_DIR/${clientName}.csr"
        fi
      '') clientCertNames}

      # create empty CRL if it doesn't exist
      if [[ ! -f "$CERT_DIR/root.crl" ]]; then
        touch "$CERT_DIR/root.crl"
      fi

      # copy certificates for PgBouncer
      cp "$CERT_DIR"/* "$PGBOUNCER_CERT_DIR/" 2>/dev/null || true

      # copy CA to client directory
      cp "$CERT_DIR/ca.crt" "$CLIENT_DIR/"

      # set permissions
      chown -R postgres:postgres "$CERT_DIR"
      chmod 700 "$CERT_DIR"
      chmod 600 "$CERT_DIR"/*.key
      chmod 644 "$CERT_DIR"/*.crt "$CERT_DIR"/*.crl

      chown -R pgbouncer:pgbouncer "$PGBOUNCER_CERT_DIR"
      chmod 700 "$PGBOUNCER_CERT_DIR"
      chmod 600 "$PGBOUNCER_CERT_DIR"/*.key
      chmod 644 "$PGBOUNCER_CERT_DIR"/*.crt "$PGBOUNCER_CERT_DIR"/*.crl

      chmod 755 "$CLIENT_DIR"
      chmod 644 "$CLIENT_DIR"/*

      echo "client certificates available in: $CLIENT_DIR"
      echo "available client certificates:"
      ls -1 "$CLIENT_DIR"/*.crt | sed 's/.*\///' | sed 's/\.crt$//'
    '';
  };

  systemd.timers.postgres-cert-rotation = {
    description = "Rotate PostgreSQL certificates";
    wantedBy = [ "timers.target" ];

    timerConfig = {
      # check daily for certificates expiring in 30 days
      OnCalendar = "daily";
      Persistent = true;
      RandomizedDelaySec = "1h";
    };
  };

  systemd.services.postgres-cert-rotation = {
    description = "Rotate PostgreSQL certificates";
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };

    script = ''
      # trigger certificate regeneration (will only regenerate if expiring soon)
      systemctl start postgres-certs.service

      # restart services if certificates were updated
      if systemctl is-active postgres-certs.service --quiet; then
        echo "Certificates updated, restarting services..."
        systemctl reload-or-restart postgresql.service
        systemctl reload-or-restart pgbouncer.service
      fi
    '';
  };

  # firewall configuration
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ pgBouncerPort ]; # Only expose PgBouncer
  };

  # monitoring with fail2ban
  services.fail2ban = {
    enable = true;
    jails = {
      pgbouncer = ''
        enabled = true
        port = ${toString pgBouncerPort}
        filter = postgresql
        logpath = /var/log/messages
        maxretry = 5
        bantime = 3600
        findtime = 600
        ignoreip = 127.0.0.1/8 ::1
      '';
    };
  };

  # system packages for manual administration
  environment.systemPackages = with pkgs; [
    postgresql_17
    pgbouncer
    openssl
  ];

  # create helper script for managing client certificates
  environment.etc."postgres-client-mgmt.sh" = {
    text = ''
      #!/bin/bash

      CLIENT_DIR="/var/lib/postgresql/client-certs"

      case "$1" in
        list)
          echo "Available client certificates:"
          ls -1 "$CLIENT_DIR"/*.crt 2>/dev/null | sed 's/.*\///' | sed 's/\.crt$//' || echo "No certificates found"
          ;;
        show)
          if [[ -z "$2" ]]; then
            echo "Usage: $0 show <client-name>"
            exit 1
          fi
          if [[ -f "$CLIENT_DIR/$2.crt" ]]; then
            echo "Certificate details for $2:"
            ${pkgs.openssl}/bin/openssl x509 -in "$CLIENT_DIR/$2.crt" -text -noout
          else
            echo "Certificate for $2 not found"
            exit 1
          fi
          ;;
        revoke)
          if [[ -z "$2" ]]; then
            echo "Usage: $0 revoke <client-name>"
            exit 1
          fi
          echo "Certificate revocation not implemented yet"
          echo "For now, manually remove: $CLIENT_DIR/$2.{crt,key}"
          ;;
        package)
          if [[ -z "$2" ]]; then
            echo "Usage: $0 package <client-name>"
            exit 1
          fi
          if [[ -f "$CLIENT_DIR/$2.crt" ]]; then
            TEMP_DIR=$(mktemp -d)
            cp "$CLIENT_DIR/$2.crt" "$TEMP_DIR/"
            cp "$CLIENT_DIR/$2.key" "$TEMP_DIR/"
            cp "$CLIENT_DIR/ca.crt" "$TEMP_DIR/"
            echo "host=$(hostname)" > "$TEMP_DIR/connection.conf"
            echo "port=${toString pgBouncerPort}" >> "$TEMP_DIR/connection.conf"
            echo "sslmode=require" >> "$TEMP_DIR/connection.conf"
            echo "sslcert=$2.crt" >> "$TEMP_DIR/connection.conf"
            echo "sslkey=$2.key" >> "$TEMP_DIR/connection.conf"
            echo "sslrootcert=ca.crt" >> "$TEMP_DIR/connection.conf"

            tar -czf "/tmp/$2-postgres-client.tar.gz" -C "$TEMP_DIR" .
            rm -rf "$TEMP_DIR"
            echo "Client package created: /tmp/$2-postgres-client.tar.gz"
          else
            echo "Certificate for $2 not found"
            exit 1
          fi
          ;;
        *)
          echo "Usage: $0 {list|show|revoke|package} [client-name]"
          echo ""
          echo "Commands:"
          echo "  list                 - List all available client certificates"
          echo "  show <client>        - Show certificate details"
          echo "  revoke <client>      - Revoke a client certificate"
          echo "  package <client>     - Package client certificates for deployment"
          exit 1
          ;;
      esac
    '';
    mode = "0755";
  };
}
