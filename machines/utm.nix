{ nixpkgs, agenix, ... }: let

  hardware = "utm";
  hostPlatform = "aarch64-linux";
  hostName = "nixos";

  pkgs = nixpkgs.legacyPackages.${hostPlatform};

in nixpkgs.lib.nixosSystem {

  modules = [
    ../hardware/${hardware}.nix
    ../modules/server.nix
    ../modules/users.nix
    # ../modules/k3s.nix
    ../modules/podman.nix
    # ../modules/docker.nix
    # ../modules/ssh-hook.nix
    # ../modules/web-hook.nix
    # agenix.nixosModules.default

    {
      nixpkgs.hostPlatform = hostPlatform;
      networking.hostName = hostName;
      networking.domain = "utm";
      system.stateVersion = "23.11";
    }

    {
      services.caddy = {
        enable = true;

        # curl -k --resolve whoami.vafer.work:443:127.0.0.1 https://whoami.vafer.work
        virtualHosts."whoami.vafer.work" = {
          extraConfig = ''
            reverse_proxy http://127.0.0.1:8080
            tls internal
          '';
        };
      };
    }

    {
      virtualisation.oci-containers.containers = {
        whoami = {
          image = "docker.io/traefik/whoami:v1.9.0";
          # image = "ghcr.io/tcurdt/foo:live";
          # image = "ghcr.io/tcurdt/foo:test";
          ports = [ "127.0.0.1:8080:80" ];
          # volumes = [
          #   "a:b"
          # ];
          # environment = {
          # };
          # extraOptions = [ "--pod=foo" ];
          # login = {
          #   registry = "ghcr.io";
          #   username = "tcurdt";
          #   passwordFile = "";
          # };
        };
      };
    }

    {
      services.postgresql = {
        enable = true;
        ensureDatabases = [
          "foo"
        ];
        authentication = pkgs.lib.mkOverride 10 ''
          #type database  DBuser  auth-method
          local all       all     trust
        '';
        # enableTCPIP = true;
      };
    }

    {
      services.mysql = {
        enable = true;
        package = pkgs.mariadb;
        settings.mysqld = {
          bind-address = "localhost";
        };
        # bind = "localhost";
        ensureDatabases = [
          "foo"
        ];
        initialScript = pkgs.writeText "setup.sql" ''
          CREATE USER IF NOT EXISTS 'root'@'localhost' IDENTIFIED WITH mysql_native_password;
          ALTER USER 'root'@'localhost' IDENTIFIED BY 'secret';
          GRANT ALL PRIVILEGES ON foo.* TO 'root'@'localhost';
        '';
        # initialScript = nixpkgs.writeText "setup.sql" ''
        #       CREATE DATABASE IF NOT EXISTS `foo`;
        #       CREATE USER IF NOT EXISTS 'root'@'localhost' IDENTIFIED WITH mysql_native_password;
        #       ALTER USER 'root'@'localhost' IDENTIFIED BY 'secret';
        #       GRANT ALL PRIVILEGES ON foo.* TO 'root'@'localhost';
        # '';
        # ensureUsers = [
        #   {
        #     name = "root";
        #     ensurePermissions = {
        #       "foo.*" = "ALL PRIVILEGES";
        #     };
        #   }
        # ];
        # [
        #   {
        #     name = "nextcloud";
        #     ensurePermissions = {
        #       "nextcloud.*" = "ALL PRIVILEGES";
        #     };
        #   }
        #   {
        #     name = "backup";
        #     ensurePermissions = {
        #       "*.*" = "SELECT, LOCK TABLES";
        #     };
        #   }
        # ]
        # initialScript = nixpkgs.writeText "setup.sql" ''
        #   GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
        #   CREATE DATABASE foo;
        #   CREATE TABLE identity.ident (name VARCHAR(25) NOT NULL);
        #   INSERT INTO identity.ident (name) VALUES ("${target.name}");
        #         GRANT ALL PRIVILEGES ON *.* TO 'myapp'@'10.50.2.%' IDENTIFIED BY "password" WITH GRANT OPTION;
        #         GRANT ALL PRIVILEGES ON *.* TO 'repl'@'10.50.2.%' IDENTIFIED BY "password" WITH GRANT OPTION;
        #         DROP DATABASE IF EXISTS myapp;
        #         CREATE DATABASE myapp;
        # '';
        # initialScript = nixpkgs.writeText "setup.sql" ''
        #       CREATE DATABASE IF NOT EXISTS `example`;
        #       CREATE USER IF NOT EXISTS 'laravel'@'webserver' IDENTIFIED WITH mysql_native_password;
        #       ALTER USER 'laravel'@'webserver' IDENTIFIED BY '${databasePassword}';
        #       GRANT ALL PRIVILEGES ON example.* TO 'laravel'@'webserver';
        # '';
      };
    }

    # podman network create foo
    # podman pod create --network foo --publish 80 foo
    # podman run --pod foo --name foo-frontend -dt docker.io/traefik/whoami:v1.9.0

  ];
}
