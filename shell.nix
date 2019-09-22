let
  fetchFromGitHub = (import <nixpkgs> { }).fetchFromGitHub;
  versions = builtins.fromJSON
    (builtins.readFile ./nix/pkgs/versions.json);
  pkgs = import "${fetchFromGitHub versions.nixpkgs-stable}" {
    overlays = [
      (self: super: {
        unstable = import (fetchFromGitHub versions.nixpkgs-unstable) {
          config.allowUnfree = true;
        };
        morph = pkgs.callPackage "${fetchFromGitHub versions.morph}/nix-packaging" { };
        nixfmt = import (fetchFromGitHub versions.nixfmt) { };
        pulumi = pkgs.callPackage ./nix/pkgs/pulumi.nix { };
      })
    ];
  };
in pkgs.mkShell {
  buildInputs = with pkgs; [
    ansible
    bashInteractive
    morph
    nix-prefetch-git
    nixfmt
    nodejs
    openssh
    pulumi
    yarn
  ];
}
