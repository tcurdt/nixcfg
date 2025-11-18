{
  pkgs,
  lib,
  ...
}:
{

  networking.hostName = "utm-x86-desktop";
  networking.domain = "utm";
  system.stateVersion = "23.11";

  imports = [

    ../hardware/utm-x86.nix

    ../modules/server.nix
    ../modules/users.nix

    ../users/root.nix
    ../users/ops.nix
    { ops.keyFiles = [ ../keys/tcurdt.pub ]; }

    {
      users.users.ops.hashedPassword = lib.mkForce null;
      users.users.ops.password = "secret";

      users.users.root.hashedPassword = lib.mkForce null;
      users.users.root.password = "secret";
    }

    {
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          mesa
          libglvnd
          egl-wayland
        ];
      };
      boot.initrd.kernelModules = [ "virtio_gpu" ];

      environment.variables = {
        LIBGL_ALWAYS_SOFTWARE = "1";
        WLR_RENDERER_ALLOW_SOFTWARE = "1";
      };

      programs.niri.enable = true;
      programs.sway.enable = true;
      programs.waybar.enable = true; # top bar

      # programs.alacritty.enable = true; # Super+T in the default setting (terminal)
      # programs.fuzzel.enable = true; # Super+D in the default setting (app launcher)
      # programs.swaylock.enable = true; # Super+Alt+L in the default setting (screen locker)
      # programs.waybar.enable = true; # launch on startup in the default setting (bar)

      # services.mako.enable = true; # notification daemon
      # services.swayidle.enable = true; # idle management daemon
      # services.polkit-gnome.enable = true; # polkit

      security.polkit.enable = true; # polkit
      security.pam.services.swaylock = { };
      services.gnome.gnome-keyring.enable = true; # secret service

      services.greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd niri-session";
            user = "greeter";
          };
        };
        vt = 1;
      };

      users.groups.video.members = [ "greeter" ];

      environment.systemPackages = [
        pkgs.alacritty
        pkgs.fuzzel
        pkgs.swaylock
        pkgs.mako
        pkgs.swayidle
        pkgs.xwayland-satellite
        pkgs.swaybg # wallpaper
        pkgs.mesa-demos # for glxinfo/eglinfo debugging
      ];
    }
  ];
}
