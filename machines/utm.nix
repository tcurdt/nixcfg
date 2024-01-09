{ nixpkgs, impermanence, ... }@inputs: let

  hardware = "utm";
  hostPlatform = "aarch64-linux";
  hostName = "nixos";

  pkgs = nixpkgs.legacyPackages.${hostPlatform};

in nixpkgs.lib.nixosSystem {

  specialArgs = { inherit inputs; };

  modules = [
    # agenix.nixosModules.default
    ../hardware/${hardware}.nix
    ../modules/server.nix
    ../modules/users.nix
    # ../modules/docker.nix
    # ../modules/podman.nix
    # ../modules/k3s.nix
    # ../modules/ssh-hook.nix
    # ../modules/web-hook.nix
    ../modules/backup.nix

    {
      nixpkgs.hostPlatform = hostPlatform;
      networking.hostName = hostName;
      networking.domain = "utm";
      system.stateVersion = "23.11";
    }

    # ../users/tcurdt.nix

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
        };
        skyguard = {
          image = "ghcr.io/tcurdt/skyguard:latest";
          ports = [ "127.0.0.1:8081:2015" ];
          environment = {
            PGHOST = "127.0.0.1";
            PGDATABASE = "bluesky";
            PGUSER = "postgres";
            PGPASSWORD = "secret";
            SERVICE = "dev.vafer.org";
          };
          login = {
            registry = "ghcr.io";
            username = "tcurdt";
            passwordFile = "/run/secrets/registry.github";
          };
        };
      };
    }

    {
      # sudo -u postgres psql
      # \l
      services.postgresql = {
        enable = true;
        # ensureDatabases = [
        #   "bluesky"
        # ];
        ensureUsers = [{
          name = "postgres";
          # ensureDBOwnership = true;
          # ensurePermissions = {
          #   "bluesky.*" = "ALL PRIVILEGES";
          # };
        }];
        # initialScript = pkgs.writeText "setup.sql" ''
        #   ALTER USER postgres PASSWORD 'secret';
        #   GRANT ALL PRIVILEGES ON DATABASE "bluesky" to postgres;
        # '';
        # authentication = pkgs.lib.mkOverride 10 ''
        #   #type database  DBuser auth-method
        #   local all       all    trust
        # '';
        # enableTCPIP = true;
      };
    }

    {
      # sudo -u mysql mysql
      # show databases;
      services.mysql = {
        enable = true;
        package = pkgs.mariadb;
        settings.mysqld = {
          bind-address = "127.0.0.1";
        };
        # ensureDatabases = [
        #   "bluesky"
        # ];
        ensureUsers = [{
          name = "root";
          # ensureDBOwnership = true;
          # ensurePermissions = {
          #   "bluesky.*" = "ALL PRIVILEGES";
          # };
        }];
        # initialScript = pkgs.writeText "setup.sql" ''
        #   ALTER USER 'root'@'localhost' IDENTIFIED BY 'secret';
        #   GRANT ALL PRIVILEGES ON bluesky.* TO 'root'@'localhost';
        # '';
        # CREATE USER IF NOT EXISTS 'root'@'localhost' IDENTIFIED WITH mysql_native_password;
        #     ensurePermissions = {
        #       "*.*" = "SELECT, LOCK TABLES";
      };
    }

    # podman network create foo
    # podman pod create --network foo --publish 80 foo
    # podman run --pod foo --name foo-frontend -dt docker.io/traefik/whoami:v1.9.0

  ];
}
