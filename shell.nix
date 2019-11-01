{ sources ? import ./nix/sources.nix }:
let
  nur-no-pkgs = import sources.nur {
    repoOverrides = {
      knopki = import sources.nur-knopki {};
      # knopki = import ../nixexprs {};
    };
  };
  pkgs = import sources.nixpkgs {
    overlays = [
      nur-no-pkgs.repos.knopki.overlays.morph
      nur-no-pkgs.repos.knopki.overlays.niv
      (
        self: super: {
          unstable = import sources.nixpkgs-unstable {
            config.allowUnfree = true;
          };
        }
      )
      (
        self: super: with super.lib; {
          # until 20.03 try to use unstable or upstream version
          nixpkgs-fmt = if (hasPrefix "0.6." super.nixpkgs-fmt.version) then super.nixfmt-pkgs else if (hasAttrByPath [ "unstable" "nixpkgs-fmt" ] pkgs) then super.unstable.nixpkgs-fmt else (import sources.nixpkgs-fmt {});
        }
      )
    ];
  };
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    ansible
    ansible-lint
    gitAndTools.pre-commit
    morph
    niv
    nix-prefetch-git
    nixpkgs-fmt
    openssh
    shellcheck
    shfmt
    stdenv
  ];
}
