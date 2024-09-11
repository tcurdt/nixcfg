{ pkgs, inputs, ... }: {

  networking.hostName = "shodan";
  networking.computerName = "shodan";

  system.stateVersion = 5;

  imports = [

    {
      services.nix-daemon.enable = true;
      nix.extraOptions = ''
        auto-optimise-store = true
        experimental-features = nix-command flakes
        extra-platforms = x86_64-darwin aarch64-darwin
      '';
      # nix.package = pkgs.nix;
      # nix.linux-builder.enable = true;
      nix.gc.automatic = true;
    }

    {
      # nix-env -qaP | grep wget
      environment.systemPackages = [
        # pkgs.vim
      ];
    }

    {
      security.pam.enableSudoTouchIdAuth = true;

      # system.defaults.finder.AppleShowAllExtensions = true;
      # system.defaults.dock.autohide = true;
      # system.defaults.NSGlobalDomain.InitialKeyRepeat = 14;
      # system.defaults.NSGlobalDomain.KeyRepeat = 1;
      # system.keyboard.enableKeyMapping = true;
      # system.keyboard.remapCapsLockToEscape = true;
      system.defaults = {
        dock.autohide = true;
      };
    }

    inputs.home-manager.darwinModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;

        users.tcurdt = (import ../home/tcurdt.nix pkgs) // {
          # home = "/Users/tcurdt";
        };
        # use extraSpecialArgs to pass arguments to home.nix
      };

    }


    # {
    #   homebrew = {
    #     enable = true;
    #     casks = [
    #     ];
    #   };
    # }

    {
      # programs.zsh.enable = true;
      # programs.zsh.shellAliases = {
      #   ls = "ls -la";
      # };
      # environment.shells = with pkgs; [
      #   bash
      #   zsh
      # ];
      # environment.loginShell = pkgs.zsh;

      # environment.systemPath = [ "/opt/homebrew/bin" ];
      # environment.systemPackages = with pkgs; [
      #   coreutils
      # ];

      # fonts.fontDir.enable = true; # DANGER
      # fonts.fonts = with pkgs; [
      #   (nerdfonts.override { fonts = [
      #     Meslo
      #   ];})
      # ];

      # needs manual install
      # homebrew = {
      #   enable = true;
      #   caskArgs.no_quarantine = true;
      #   global.brewfile = true;
      #   masApps = {};
      #   casks = [];
      #   taps = [];
      #   brews = [];
      # };

      # home.file."foo".text = ''
      # '';
      # home.file."bar".source = ./some/path;

    }

  ];
}
