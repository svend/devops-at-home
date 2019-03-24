{ config, pkgs, lib, ... }:

with lib;

{
  options = {
    local.apps.swaywm.enable = mkEnableOption "Enable SwayWM";
  };

  config = mkIf config.local.apps.swaywm.enable {
    environment.systemPackages = with pkgs; [
      gnome3.dconf-editor
    ];

    programs = {
      sway = {
        enable = true;
        extraPackages = with pkgs; [
          albert
          grim
          i3status
          light
          mako
          python36Packages.py3status
          rofi
          rofi-pass
          slurp
          swayidle
          swaylock
          termite
          wf-recorder
          wl-clipboard
        ];
      };
    };

    services = {
      dbus.packages = with pkgs; [ gnome3.dconf ];
      gnome3.gnome-keyring.enable = true;
      xserver = {
        enable = true;
        displayManager.session = [
          {
            manage = "desktop";
            name = "SwayWM";
            start = ''
            ${pkgs.sway}/bin/sway
            '';
          }
        ];
      };
    };
  };
}
