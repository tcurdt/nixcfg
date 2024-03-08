{ config, pkgs, inputs, ... }:
{

  imports = [ inputs.home-manager.nixosModules.default ];
  # imports = [ home-manager.nixosModules.default ];
  # imports = [ <home-manager/nixos> ];
  # imports = [ (import "${home-manager}/nixos") ];

  users.users = {
    tcurdt = {
      isNormalUser = true;
      extraGroups = [ "wheel" "docker" ];
      openssh.authorizedKeys.keyFiles = [ ./tcurdt.pub ];

      # shell = pkgs.nushell;
      packages = with pkgs; [
        tmux
        htop
      ];

      hashedPassword = "*"; # no password allowed
    };
  };

  # programs.git = {
  #   enable = true;
  #   userName  = "tcurdt";
  #   userEmail = "tcurdt@vafer.org";
  # };

  # home.packages = with pkgs; [
  #   tmux
  #   htop
  # ];

  # programs.home-manager.enable = true;

  home-manager.users.tcurdt = { pkgs, ... }: {
    home.sessionVariables = {
      PAGER = "less";
      EDITOR = "nano";
      CLICOLOR = 1;
    };

    home.packages = [
      pkgs.unzip
    ];

    programs.git = {
      enable = true;
      userName = "Torsten Curdt";
      userEmail = "tcurdt@vafer.org";
    };

    home.file = {
      ".foo" = {
        text = ''
          bar
        '';
      };
    };

    home.stateVersion = "23.11";
  };

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

}