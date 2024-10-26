{ pkgs, inputs, ... }:
{

  networking.hostName = "shodan";
  networking.computerName = "shodan";

  system.stateVersion = 5;

  imports = [

    { nixpkgs.hostPlatform = "aarch64-darwin"; }

    {
      services.nix-daemon.enable = true;
      nix.extraOptions = ''
        experimental-features = nix-command flakes
        extra-platforms = x86_64-darwin aarch64-darwin
      '';
      # nix.package = pkgs.nix;

      nix.linux-builder.enable = true;
      # settings.trusted-users = [ "@admin" ];

      nix.gc.automatic = true;
      nix.optimise.automatic = true;
    }

    # {
    #   # nix-env -qaP | grep wget
    #   environment.systemPackages = [
    #     # pkgs.vim
    #   ];
    # }

    {
      security.pam.enableSudoTouchIdAuth = true;

      # system.defaults.finder.AppleShowAllExtensions = true;
      # system.defaults.dock.autohide = true;
      # system.defaults.NSGlobalDomain.InitialKeyRepeat = 14;
      # system.defaults.NSGlobalDomain.KeyRepeat = 1;
      # system.keyboard.enableKeyMapping = true;
      # system.keyboard.remapCapsLockToEscape = true;
      # system.defaults = {
      #   dock.autohide = true;
      # };
    }

    inputs.home-manager.darwinModules.home-manager
    {
      programs.zsh.enable = true;
      programs.bash.enable = true;

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.tcurdt = {
          imports = [ ../home/tcurdt.nix ];

          home.shellAliases = {
            xallow = "f(){ xattr -cr $1 }; f";
            xclear = "f(){ xattr -c $1 }; f";
          };

          home.sessionVariables = {
            JAVA_HOME = "/opt/homebrew/opt/openjdk";
          };

          home.packages = [
            pkgs.nixd
            # pkgs.colmena
            # pkgs.deploy-rs
          ];

        };
      };
      users.users.tcurdt.home = "/Users/tcurdt";
    }

    # {
    #   homebrew = {
    #     enable = true;
    #     caskArgs.no_quarantine = true;
    #     global.brewfile = true;
    #     masApps = {};
    #     casks = [];
    #     taps = [];
    #     brews = [];
    #   };
    # }

    # {
    #   environment.shells = [
    #     pkgs.bash
    #     pkgs.zsh
    #   ];
    #   environment.loginShell = pkgs.zsh;
    #   environment.systemPath = [ "/opt/homebrew/bin" ];
    # }

    # {
    #   fonts.fontDir.enable = true; # DANGER
    #   fonts.fonts = with pkgs; [
    #     (nerdfonts.override { fonts = [
    #       Meslo
    #     ];})
    #   ];
    # }

    # {
    #   home.file."foo".text = ''
    #   '';
    #   home.file."bar".source = ./some/path;
    # }

  ];
}
