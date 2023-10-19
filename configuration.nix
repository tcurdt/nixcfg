{ config, pkgs, ... }:


{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # https://mdleom.com/blog/2020/03/04/caddy-nixos-part-2/
  system.stateVersion = "23.05";
  #extra-experimental-features = nix-command flakes repl-flake;
  #nix.settings.experimental-features = [ "nix-command" "flakes" ];

  zramSwap.enable = false;

  # boot.loader.grub.device = "/dev/sda";   # (for BIOS systems only)
  # boot.loader.systemd-boot.enable = true; # (for UEFI systems only)
  # boot.loader.efi.canTouchEfiVariables = true;
  # boot.supportedFilesystems = [ "zfs" ];
  boot.tmp.cleanOnBoot = true;

  # kernel
  # boot.kernelPackages = pkgs.linuxPackages_hardened;
  # boot.kernelModules = [ "tcp_bbr" ];
  # sysctl
  # boot.kernel.sysctl = {
  #   "kernel.unprivileged_userns_clone" = 1;
  #   # disable magic SysRq key
  #   "kernel.sysrq" = 0;
  #   # ignore ICMP broadcasts to avoid participating in Smurf attacks
  #   "net.ipv4.icmp_echo_ignore_broadcasts" = 1;
  #   # ignore bad ICMP errors
  #   "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
  #   # reverse-path filter for spoof protection
  #   "net.ipv4.conf.default.rp_filter" = 1;
  #   "net.ipv4.conf.all.rp_filter" = 1;
  #   # SYN flood protection
  #   "net.ipv4.tcp_syncookies" = 1;
  #   # do not accept ICMP redirects (prevent MITM attacks)
  #   "net.ipv4.conf.all.accept_redirects" = 0;
  #   "net.ipv4.conf.default.accept_redirects" = 0;
  #   "net.ipv4.conf.all.secure_redirects" = 0;
  #   "net.ipv4.conf.default.secure_redirects" = 0;
  #   "net.ipv6.conf.all.accept_redirects" = 0;
  #   "net.ipv6.conf.default.accept_redirects" = 0;
  #   # do not send ICMP redirects (we are not a router)
  #   "net.ipv4.conf.all.send_redirects" = 0;
  #   # do not accept IP source route packets (we are not a router)
  #   "net.ipv4.conf.all.accept_source_route" = 0;
  #   "net.ipv6.conf.all.accept_source_route" = 0;
  #   # protect against tcp time-wait assassination hazards
  #   "net.ipv4.tcp_rfc1337" = 1;
  #   # TCP Fast Open (TFO)
  #   "net.ipv4.tcp_fastopen" = 3;
  #   # bufferbloat mitigations
  #   # requires >= 4.9 & kernel module
  #   "net.ipv4.tcp_congestion_control" = "bbr";
  #   # requires >= 4.19
  #   "net.core.default_qdisc" = "cake";
  #   # note that inotify watches consume 1kB on 64-bit machines.
  #   # "fs.inotify.max_user_watches"   = 1048576;   # default:  8192
  #   # "fs.inotify.max_user_instances" =    1024;   # default:   128
  #   # "fs.inotify.max_queued_events"  =   32768;   # default: 16384
  # };

  networking.hostName = "nixos";
  networking.domain = "utm";

  # networking.networkmanager.enable = true;

  networking.firewall.enable = false;
  # networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ];
  # networking.firewall.trustedInterfaces = [ "docker0" ];

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users = {

    tcurdt = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      # openssh.authorizedKeys.keyFiles = [ ./ssh_pub_tcurdt ];
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA2CLOzyXcqk4uo6hCkkQAtozJCebA/Dh4ps6Vr2GVNTC7j7nF5HuT+penp/Y9yPAuTorxunmFn7BPwZggzopEgfmUQ4gf0CysTwPQMxt9yK3ZHpxgkGoJyR0n91OdPAbukqwWZHYxGGxvHNoap59kobUrIImIa97gKxW+IVKwL9iyWXyqonRpue1mf1N1ioDtPLS1yvzf4Jo7aDND+4I/34X6436VwZItUwzvhFcuNh/gQmvKpmVjD+ED2Q/yRtGq0EzsPfrDZg1ZKV5V1cT/3w7QtYFcZB9+AQxq88jVRcIlf3K45kpmbsWVfBFN6ND+NeZK1mlp/3TV8C6dNVqU2w== tcurdt@shodan.local"
      ];
      packages = with pkgs; [
      ];
    };

    # root.openssh.authorizedKeys.keyFiles = [ ./ssh_pub_tcurdt ];
    root.openssh.authorizedKeys.keys = [
     "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA2CLOzyXcqk4uo6hCkkQAtozJCebA/Dh4ps6Vr2GVNTC7j7nF5HuT+penp/Y9yPAuTorxunmFn7BPwZggzopEgfmUQ4gf0CysTwPQMxt9yK3ZHpxgkGoJyR0n91OdPAbukqwWZHYxGGxvHNoap59kobUrIImIa97gKxW+IVKwL9iyWXyqonRpue1mf1N1ioDtPLS1yvzf4Jo7aDND+4I/34X6436VwZItUwzvhFcuNh/gQmvKpmVjD+ED2Q/yRtGq0EzsPfrDZg1ZKV5V1cT/3w7QtYFcZB9+AQxq88jVRcIlf3K45kpmbsWVfBFN6ND+NeZK1mlp/3TV8C6dNVqU2w== tcurdt@shodan.local"
    ];
  };

  security.sudo.wheelNeedsPassword = false;
  users.mutableUsers = false;
  # users.root.hashedPassword = "*"; # disable root

  nixpkgs.config.allowUnfree = true;
  # environment.systemPackages = with pkgs; [
  #   tmux
  #   git
  #   docker-compose
  # ];

  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "Monday 01:00";
    options = "--delete-older-than 7d";
  };
  nix.extraOptions = ''
    min-free = ${toString (500 * 1024 * 1024)}
    experimental-features = nix-command flakes
  '';

  # nix.settings = {
  #   trusted-users = [ "@wheel" ];
  #   allowed-users = [ "@wheel" ];
  # };


  system.autoUpgrade = {
    enable = true;
    dates = "04:00";
    allowReboot = true;
  };

  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  # programs.bash = {
  #   interactiveShellInit = "export HISTSIZE=-1 HISTFILESIZE=-1 HISTCONTROL=ignoreboth:erasedups; shopt -s histappend; export PROMPT_COMMAND=\"history -a;$PROMPT_COMMAND\"";
  #   shellAliases = {
  #   };
  # };
  # environment.shellAliases = {
  #   ll = "ls -la";
  # };

  systemd = {
    services.clear-log = {
      description = "clear >1 month-old logs every week";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.systemd}/bin/journalctl --vacuum-time=30d";
      };
    };
    timers.clear-log = {
      wantedBy = [ "timers.target" ];
      partOf = [ "clear-log.service" ];
      timerConfig.OnCalendar = "weekly UTC";
    };
  };

  services.openssh.enable = true;

  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true; # required for podman-compose
      autoPrune = {
        enable = true;
        dates = "Monday 02:00";
        flags = [ "--all" ];
      };
    };
    oci-containers.backend = "podman";
  };

  # virtualisation.oci-containers.containers = {
  #    echo = {
  #       image = "ealen/echo-server";
  #       ports = [ "127.0.0.1:8080:80" ];
  #       # volumes = [
  #       #   "a:b"
  #       # ];
  #       # environment = {
  #       # };
  #       # extraOptions = [ "--pod=live-pc" ];
  #    };
  # };

  # services.influxdb2.enable = true;
  # services.n8n.enable = true;
  # services.n8n.settings = {};
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

  # services = {
  #   my_service = {
  #     enable = true;
  #     executable = "/path/to/your/binary";
  #     capabilities = ["cap_net_bind_service"];
  #   };
  # };

  # security.unprivilegedUsernsClone = true;
  # networking.firewall.trustedInterfaces = [ "podman0" ]
  # networking.firewall.interfaces.podman0.allowedUDPPorts = [ 53 ];
  # virtualisation = {
  #   docker = {
  #     enable = true;
  #     # rootless = {
  #     #   enabled = true;
  #     #   setSocketVariable = true;
  #     # };
  #   };
  #   oci-containers.backend = "docker";
  # };

}
