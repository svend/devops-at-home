{ config, pkgs, lib, ... }:
with lib;
with import <nixpkgs> {};
let
  versions = builtins.fromJSON (builtins.readFile ../../pkgs/versions.json);
  homeManager = fetchFromGitHub versions.home-manager;
  nixpkgsSrcStable = fetchFromGitHub versions.nixpkgs-stable;
  rebuild-throw = pkgs.writeText "rebuild-throw.nix"
    ''throw "I'm sorry Dave, I'm afraid I can't do that... Please deploy this host with morph or specify NIX_PATH with nixos-config."'';
in
{
  imports = [ "${homeManager}/nixos" ];

  options = { local.general.nixpkgs.enable = mkEnableOption "Nixpkgs"; };

  config = mkIf config.local.general.nixpkgs.enable {
    nixpkgs = {
      config.allowUnfree = true;

      pkgs = import "${nixpkgsSrcStable}" {
        config = config.nixpkgs.config;
        overlays = config.nixpkgs.overlays;
      };

      overlays = [
        (
          self: super: {
            nixpkgs-with-kustomize-1 =
              import (fetchFromGitHub versions.nixpkgs-kustomize-1) {
                config.allowUnfree = true;
              };
            nur = import (fetchFromGitHub versions.nur) { inherit super; };
            unstable = import (fetchFromGitHub versions.nixpkgs-unstable) {
              config.allowUnfree = true;
            };
          }
        )
        (
          self: super: {
            fira-code-nerd = super.callPackage ../../pkgs/fira-code-nerd.nix {};
            fish-kubectl-completions =
              super.callPackage ../../pkgs/fish-kubectl-completions.nix {};
            fish-theme-pure = super.callPackage ../../pkgs/fish-theme-pure.nix {};
            kube-score = super.callPackage ../../pkgs/kube-score {};
            neovim-gtk = super.callPackage ../../pkgs/neovim-gtk.nix {};
            telepresence = super.callPackage ../../pkgs/telepresence.nix {};
            trapd00r-ls-colors =
              super.callPackage ../../pkgs/trapd00r-ls-colors.nix {};
            waybar = super.unstable.waybar.override { pulseSupport = true; };
            wf-recorder = super.unstable.wf-recorder;
            wl-clipboard = super.unstable.wl-clipboard;
          }
        )
        (import ../../pkgs/tmux-plugins.nix)
      ];
    };

    nix.nixPath = [
      "nixpkgs=${nixpkgsSrcStable}"
      "nixos-config=${rebuild-throw}"
    ];

    environment.etc."nixos/configuration.nix".source = rebuild-throw;
  };
}
