{ nixpkgs, darwin, home-manager, ... }: let

  hardware = "shodan";
  hostPlatform = "aarch64-darwin";
  hostName = "shodan";

  pkgs = nixpkgs.legacyPackages.${hostPlatform};

in darwin.lib.darwinSystem {

  modules = [

    {
      nixpkgs.hostPlatform = hostPlatform;
      # networking.hostName = hostName;
      # networking.domain = "local";
      # system.stateVersion = "23.11";
      # system.stateVersion = "4";
      nix.extraOptions = ''
        experimental-features = nix-command flakes
      '';
      services.nix-daemon.enable = true;
      #nix.package = pkgs.nix;

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

      # system.keyboard.enableKeyMapping = true;
      # system.keyboard.remapCapsLockToEscape = true;

      # fonts.fontDir.enable = true; # DANGER
      # fonts.fonts = with pkgs; [
      #   (nerdfonts.override { fonts = [
      #     Meslo
      #   ];})
      # ];

      # system.defaults.finder.AppleShowAllExtensions = true;
      # system.defaults.dock.autohide = true;
      # system.defaults.NSGlobalDomain.InitialKeyRepeat = 14;
      # system.defaults.NSGlobalDomain.KeyRepeat = 1;

      # home-manager.darwinModules.home-manager = {
      #   home-manager = {
      #     useGlobalPkgs = true;
      #     useUserPkgs = true;
      #     users.tcurdt = {
      #       home.packages = with pkgs; [
      #         ripgrep
      #         curl
      #         less
      #       ];
      #       home.sessionVariables = {
      #         PAGER = "less";
      #         EDITOR = "nano";
      #         CLICOLOR = 1;
      #       };
      #     };
      #   };
      # };

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
