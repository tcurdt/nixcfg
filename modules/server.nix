{ config, pkgs, ... }:
{

  zramSwap.enable = false;

  boot.tmp.cleanOnBoot = true;

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";

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
    # note that inotify watches consume 1kB on 64-bit machines.
    # "fs.inotify.max_user_watches"   = 1048576;   # default:  8192
    # "fs.inotify.max_user_instances" =    1024;   # default:   128
    # "fs.inotify.max_queued_events"  =   32768;   # default: 16384
  };

  # networking

  networking.firewall.enable = false;
  # networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ];
  # networking.firewall.trustedInterfaces = [ "docker0" ];
  # networking.networkmanager.enable = true;


  # maintenance

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.settings.auto-optimise-store = true;
  # nix.optimise.automatic = true;
  nix.gc = {
    automatic = true;
    dates = "Monday 01:00";
    options = "--delete-older-than 7d";
  };
  # nix.extraOptions = ''
  # min-free = ${toString (100 * 1024 * 1024)}
  # max-free = ${toString (1024 * 1024 * 1024)}
  # '';

  system.autoUpgrade = {
    enable = true;
    dates = "04:00";
    allowReboot = true;
    # flake = inputs.self.outPath;
    # flags = [
    #   "--update-input"
    #   "nixpkgs"
    #   "--no-write-lock-file"
    #   "-L" # print build logs
    # ];
    # randomizedDelaySec = "15min";
  };


  # log files

  systemd = {
    services.clear-log = {
      description = "clear logs older than 14d";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.systemd}/bin/journalctl --vacuum-time=14d";
      };
    };
    timers.clear-log = {
      wantedBy = [ "timers.target" ];
      partOf = [ "clear-log.service" ];
      timerConfig.OnCalendar = [
        "*-*-* 03:00:00"
        # "daily"
      ];
    };
  };


  # packages

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    git
    curl
    file
  ];


  # services

  services.openssh.enable = true;

  # services.influxdb2.enable = true;
  # services.grafana.enable = true;
  # services.grafana.settings = {};
  # services.telegraf = {
  #   enable = true;
  #   extraConfig = {
  #     global_tags = {
  #       dc = "dc1";
  #     };
  #     agent = {
  #       interval = "10s";
  #     };
  #     inputs.mem = {};
  #     outputs.file = {
  #       files = [ "/tmp/metrics.out" ];
  #     };
  #   };
  # };

}
