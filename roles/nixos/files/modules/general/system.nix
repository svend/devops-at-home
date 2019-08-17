{ config, pkgs, lib, ... }:

with lib;

{
  options = {
    local.general.system = {
      enable = mkEnableOption "System Options";
      latestKernel = mkEnableOption "Use latest kernel package";
    };
  };

  config = mkIf config.local.general.system.enable {
    boot = {
      kernelPackages =
        mkIf config.local.general.system.latestKernel pkgs.linuxPackages_latest;
    };

    # Save current configuration to generation every time
    environment.etc.current-configuration.source = "/etc/nixos";

    system = {
      autoUpgrade = {
        channel = "https://nixos.org/channels/nixos-19.03";
        dates = "2:15";
        enable = true;
      };
      copySystemConfiguration = true;
      stateVersion = "19.03";
    };
  };
}
