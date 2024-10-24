{ pkgs, lib, inputs, ... }:
{

  imports = [ inputs.impermanence.nixosModules.impermanence ];

  # sdImage.compressImage = false;

  nixpkgs.config.allowUnsupportedSystem = true;
  # https://github.com/NixOS/nixpkgs/issues/154163#issuecomment-1350599022
  nixpkgs.overlays = [
    (final: super: {
      makeModulesClosure = x:
        super.makeModulesClosure (x // { allowMissing = true; });
    })
  ];

  boot.supportedFilesystems = lib.mkForce [ "vfat" "ext4" ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  time.timeZone = "UTC";

  i18n.defaultLocale = "en_US.UTF-8";

  zramSwap.enable = false;
  boot.tmp.cleanOnBoot = true;

  # kernel

  boot.kernelPackages = pkgs.linuxPackages_hardened;
  boot.kernelModules = [ "tcp_bbr" ];

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
    "net.core.rmem_max" = 2500000;
    "net.core.wmem_max" = 2500000;
    # "net.core.somaxconn" = 4096;
    # "vm.overcommit_memory" = 1;
  };

  # networking

  # networking.enableIPv6 = false;

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];
  networking.firewall.allowedUDPPorts = [ ];
  networking.firewall.allowPing = true;
  networking.firewall.logRefusedConnections = false;

  services.chrony.enable = true;

  # maintenance

  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "Monday 01:00";
    options = "--delete-older-than 7d";
  };

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
      ];
    };

  };

  # packages trim down

  documentation.enable = false;
  documentation.info.enable = false;
  documentation.man.enable = false;
  documentation.nixos.enable = false;

  fonts.fontconfig.enable = false;
  sound.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.defaultPackages = pkgs.lib.mkForce []; # no default packages

  environment.systemPackages = [
    pkgs.nano
    pkgs.curl
    pkgs.gitMinimal
  ];

  environment.sessionVariables = {
    FLAKE = "/etc/nixos/flake";
  };

  environment.persistence."/nix/persist" = {
    directories = [
      { directory = "/secrets";         mode="0755"; } # secrets
      { directory = "/var/lib/nixos";   mode="0755"; } # system service persistent data
    ];
  };

  # ssh

  services.openssh = {
    enable = true;
    allowSFTP = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
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

}
