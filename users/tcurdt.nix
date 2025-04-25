{
  # config,
  pkgs,
  inputs,
  ...
}:
{

  imports = [ inputs.home-manager.nixosModules.default ];

  users.users.tcurdt = (import ./default.nix pkgs) // {

    openssh.authorizedKeys.keyFiles = [ ../keys/tcurdt.pub ];

    isNormalUser = true;
    extraGroups = [
      "wheel"
      "docker"
    ];
    hashedPassword = "*"; # no password allowed

  };

  home-manager.users.tcurdt = (import ../home/tcurdt.nix pkgs) // { };

}
