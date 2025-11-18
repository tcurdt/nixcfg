{
  # config,
  pkgs,
  inputs,
  ...
}:
{

  imports = [ inputs.home-manager.nixosModules.default ];

  # Optimize Home Manager
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  users.users.root = (import ./default.nix pkgs) // {

    openssh.authorizedKeys.keyFiles = [ ../keys/tcurdt.pub ];

    # password = "secret";
    # promptInitialPassword = true;
    # hashedPassword = "*"; # no password allowed

  };

  home-manager.users.root = (import ../home/tcurdt.nix pkgs) // { };
}
