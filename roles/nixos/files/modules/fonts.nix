{pkgs, ...}:
{
  fonts = {
    enableFontDir = true;
    fonts = with pkgs; [
      hack-font
      noto-fonts
      noto-fonts-emoji
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
}
