{ ... }:
{
  home.file = {
    ".npmrc".text = ''
      cache="''${XDG_CACHE_HOME}/npm"
      prefix="''${XDG_DATA_HOME}/npm"
    '';
  };
}
