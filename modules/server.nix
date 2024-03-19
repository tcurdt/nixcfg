{ config, pkgs, inputs, ... }:
{

  imports = [ inputs.impermanence.nixosModules.impermanence ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # time.timeZone = "Europe/Berlin";
  time.timeZone = "UTC";

  i18n.defaultLocale = "en_US.UTF-8";
  # i18n.extraLocaleSettings = {
  #   LC_ADDRESS = "";
  #   LC_IDENTIFICATION = "";
  #   LC_MEASUREMENT = "";
  #   LC_MONETARY = "";
  #   LC_NAME = "";
  #   LC_NUMERIC = "";
  #   LC_PAPER = "";
  #   LC_TELEPHONE = "";
  #   LC_TIME = "";
  # };

  # https://xeiaso.net/blog/paranoid-nixos-2021-07-18/

  zramSwap.enable = false;
  boot.tmp.cleanOnBoot = true;
  # boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # kernel

  boot.kernelPackages = pkgs.linuxPackages_hardened;
  boot.kernelModules = [ "tcp_bbr" ];

  # boot.supportedFilesystems = lib.mkForce [
  #   "btrfs"
  #   "reiserfs"
  #   "xfs"
  #   "f2fs"
  #   "vfat"
  #   "ntfs"
  #   "cifs"
  # ];

  # sysctl
  boot.kernel.sysctl = {
    "kernel.unprivileged_userns_clone" = 1;
    # disable magic SysRq key
    "kernel.sysrq" = 0;
    # ignore ICMP broadcasts to avoid participating in Smurf attacks
    "net.ipv4.icmp_echo_ignore_broadcasts" = 1;
    # ignore bad ICMP errors
    "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
    # reverse-path filter for spoof protection
    "net.ipv4.conf.default.rp_filter" = 1;
    "net.ipv4.conf.all.rp_filter" = 1;
    # SYN flood protection
    "net.ipv4.tcp_syncookies" = 1;
    # do not accept ICMP redirects (prevent MITM attacks)
    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv4.conf.default.accept_redirects" = 0;
    "net.ipv4.conf.all.secure_redirects" = 0;
    "net.ipv4.conf.default.secure_redirects" = 0;
    "net.ipv6.conf.all.accept_redirects" = 0;
    "net.ipv6.conf.default.accept_redirects" = 0;
    # do not send ICMP redirects (we are not a router)
    "net.ipv4.conf.all.send_redirects" = 0;
    # do not accept IP source route packets (we are not a router)
    "net.ipv4.conf.all.accept_source_route" = 0;
    "net.ipv6.conf.all.accept_source_route" = 0;
    # protect against tcp time-wait assassination hazards
    "net.ipv4.tcp_rfc1337" = 1;
    # TCP Fast Open (TFO)
    "net.ipv4.tcp_fastopen" = 3;
    # bufferbloat mitigations
    # requires >= 4.9 & kernel module
    "net.ipv4.tcp_congestion_control" = "bbr";
    # requires >= 4.19
    "net.core.default_qdisc" = "cake";
    #"net.core.default_qdisc" = "fq";
    # note that inotify watches consume 1kB on 64-bit machines.
    # "fs.inotify.max_user_watches"   = 1048576;   # default:  8192
    # "fs.inotify.max_user_instances" =    1024;   # default:   128
    # "fs.inotify.max_queued_events"  =   32768;   # default: 16384
  };

  # networking

  # networking.enableIPv6 = false;

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];
  networking.firewall.allowedUDPPorts = [ ];
  networking.firewall.allowPing = true;
  networking.firewall.logRefusedConnections = false;
  # networking.firewall.trustedInterfaces = [ "docker0" ];
  services.fail2ban.enable = true;

  # networking.useDHCP = false;
  # networking.useNetworkd = true;
  # networking.networkmanager.enable = true;
  # networking.networkmanager.dns = "systemd-resolved";
  # services.resolved.enable = true;

  services.chrony.enable = true;
  # networking.timeServers = [
  #   "10.7.89.1"
  #   "ch.pool.ntp.org"
  # ];


  # caching

  # you’ll first need to populate /etc/cachix-agent.token with the previously generated agent token with the contents:CACHIX_AGENT_TOKEN=XXX.
  # services.cachix-agent.enable = true;
  # agent name is inferred from the hostname
  # networking.hostName = "myhostname";
  # https://docs.cachix.org/deploy/deploying-to-agents/#deploying-to-agents


  # maintenance

  # nix.optimise.automatic = true;
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "Monday 01:00";
    options = "--delete-older-than 7d";
  };
  # nix.extraOptions = ''
  # min-free = ${toString (100 * 1024 * 1024)}
  # max-free = ${toString (1024 * 1024 * 1024)}
  # '';

  # system.autoUpgrade = {
  #   enable = true;
  #   dates = "04:00";
  #   # date = "hourly";
  #   # date = "minutely";
  #   # date = "*:0/5";
  #   allowReboot = true;
  #   flake = inputs.self.outPath;
  #   flake = "github:YourUser/yourRepo";
  #   flags = [
  #     "--update-input"
  #     "nixpkgs"
  #     "--no-write-lock-file"
  #     "-L" # print build logs
  #   ];
  #   randomizedDelaySec = "15min";
  # };

  systemd = {

    # services.sshd.wantedBy = pkgs.lib.mkForce ["multi-user.target"];

    network.wait-online.enable = false;
    services.NetworkManager-wait-online.enable = false;
    services.systemd-networkd.stopIfChanged = false;
    services.systemd-resolved.stopIfChanged = false;

    enableEmergencyMode = false;
    watchdog = {
      runtimeTime = "20s";
      rebootTime = "30s";
    };

    targets = {
      sleep.enable = false;
      suspend.enable = false;
      hibernate.enable = false;
      hybrid-sleep.enable = false;
    };

    # update system

    # # https://github.com/Infinisil/nixbot/blob/feefc301bbe44742570bce0974005a2714a950e6/module.nix#L84-L113
    # services.git-updater = {
    #   description = "pull from git";
    #   serviceConfig = {
    #     Type = "oneshot";
    #     User = "nixbot";
    #     WorkingDirectory = "/var/lib/nixbot/nixpkgs/master";
    #   };
    #   path = [ pkgs.git ];
    #   script = ''
    #     git -C repo config gc.autoDetach false
    #     if [ -d repo ]; then
    #       git -C repo fetch
    #       old=$(git -C repo rev-parse @)
    #       new=$(git -C repo rev-parse @{u})
    #       if [ $old != $new ]; then
    #         git -C repo rebase --autostash
    #         echo "Updated from $old to $new"
    #       fi
    #     else
    #       git clone https://github.com/NixOS/nixpkgs repo
    #       git -C repo remote add channels https://github.com/NixOS/nixpkgs-channels
    #       echo "Initialized at $(git -C repo rev-parse @)"
    #     fi
    #   '';
    # };
    # timers.git-updater = {
    #   wantedBy = [ "timers.target" ];
    #   partOf = [ "git-updater.service" ];
    #   timerConfig.OnUnitInactiveSec = 60;
    # };

    # log files

    services.cleanup-logs = {
      description = "cleanup logs older than 7d";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.systemd}/bin/journalctl --vacuum-time=7d";
      };
    };
    timers.cleanup-logs = {
      wantedBy = [ "timers.target" ];
      partOf = [ "cleanup-logs.service" ];
      timerConfig.OnCalendar = [
        "*-*-* 03:00:00" # daily at 3am
        # "daily"
      ];
    };

  };


  # packages trim down

  documentation.enable = false;
  documentation.info.enable = false;
  documentation.man.enable = false;
  documentation.nixos.enable = false;

  fonts.fontconfig.enable = false;
  sound.enable = false;

  nixpkgs.config.allowUnfree = true;

  environment.defaultPackages = pkgs.lib.mkForce []; # no default packages

  environment.systemPackages = [
    pkgs.nano
    pkgs.curl
    pkgs.gitMinimal

    # inputs.release-go.packages.${pkgs.system}.default

    (import ../scripts/foo.nix { inherit pkgs; })

    # pkgs.vulnix # vulnerability scanner
    # pkgs.clamav # virus scanner

  ];

  # environment.variables = {
  #   PATH = [
  #     "\${HOME}/.bin"
  #     "\$/usr/local/bin"
  #   ];
  # };

  environment.persistence."/nix/persist" = {
    directories = [
      { directory = "/secrets";   mode="0755"; } # secrets
      # { directory = "/etc/nixos"; mode="0755"; } # nixos system config files, can be considered optional
      # { directory = "/srv";       mode="0755"; } # service data
      # { directory = "/var/log";   mode="0755"; } # the place that journald dumps it logs to
      # { directory = "/var/lib";   mode="0755"; } # system service persistent data

      # { directory = "/var/lib/influxdb2";  mode="0755"; }
      # { directory = "/var/lib/postgresql"; mode="0755"; }
      # { directory = "/var/lib/mysql";      mode="0755"; }

    ];
  };
  # environment.etc."ssh/ssh_host_rsa_key".source
  #   = "/nix/persist/etc/ssh/ssh_host_rsa_key";
  # environment.etc."ssh/ssh_host_rsa_key.pub".source
  #   = "/nix/persist/etc/ssh/ssh_host_rsa_key.pub";
  # environment.etc."ssh/ssh_host_ed25519_key".source
  #   = "/nix/persist/etc/ssh/ssh_host_ed25519_key";
  # environment.etc."ssh/ssh_host_ed25519_key.pub".source
  #   = "/nix/persist/etc/ssh/ssh_host_ed25519_key.pub";

  # security.auditd.enable = true;
  # security.audit.enable = true;
  # security.audit.rules = [
  #   "-a exit,always -F arch=b64 -S execve"
  # ];

  # services.fstrim.enable = true;


  # ssh

  # programs.mosh.enable = true;
  # programs.ssh.startAgent = true;

  services.openssh = {
    enable = true;
    allowSFTP = true;
    settings = {
      # AllowUsers = [];
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      #PermitRootLogin = "without-password";
      #X11Forwarding = false;
    };
    extraConfig = ''
      IgnoreRhosts yes
      AllowTcpForwarding yes
      AllowAgentForwarding yes
      AllowStreamLocalForwarding no
      AuthenticationMethods publickey
    '';
  };

  # smtp

  programs.msmtp = {
    enable = true;
    setSendmail = false;
    accounts = {
      default = {
        auth = true;
        tls = true;
        # tls_starttls = false; # if sendmail hangs
        from = "tcurdt@vafer.org";
        host = "email-smtp.eu-central-1.amazonaws.com";
        user = "AKIA3V6SV2TSVUAMXT4D";
        passwordeval = "cat /secrets/msmtp.key";
      };
    };
  };


  # https://github.com/maralorn/nix-output-monitor
  # system.activationScripts.diff = {
  #   supportsDryActivation = true;
  #   text = ''
  #     if [[ -e /run/current-system ]]; then
  #        ${pkgs.nix}/bin/nix store diff-closures /run/current-system "$systemConfig"
  #     fi
  #   '';
  # };

}
