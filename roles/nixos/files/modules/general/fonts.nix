{ config, pkgs, lib, ... }:

with lib;

{
  options = { local.general.fonts.enable = mkEnableOption "Fonts Options"; };

  config = mkIf config.local.general.fonts.enable {
    fonts = {
      enableFontDir = true;
      fonts = with pkgs; [
        emojione
        fira-code
        fira-code-symbols
        font-awesome_4
        hack-font
        noto-fonts
        powerline-fonts
        roboto
        roboto-mono
        roboto-slab
      ];
      fontconfig = {
        enable = true;
        defaultFonts = {
          monospace = [ "Roboto Mono 13" ];
          sansSerif = [ "Roboto 13" ];
          serif = [ "Roboto Slab 13" ];
        };
        ultimate.enable = true;
      };
      enableDefaultFonts = true;
    };
  };
}
