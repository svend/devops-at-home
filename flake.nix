{
  description = "Configuration management of the my personal machines, my dotfiles, my other somethings.";

  inputs = {
    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-20.03";
    };

    nixpkgs-unstable = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-unstable";
    };

    nixos-hardware = {
      type = "github";
      owner = "NixOS";
      repo = "nixos-hardware";
      flake = false;
    };

    # Provides a basic system for managing a user environment
    # using the Nix package manager together with the Nix
    # libraries found in Nixpkgs: https://github.com/rycee/home-manager
    home = {
      type = "github";
      owner = "rycee";
      repo = "home-manager";
      ref = "bqv-flakes";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay = {
      type = "github";
      owner = "nix-community";
      repo = "emacs-overlay";
    };

    chemacs = {
      type = "github";
      owner = "plexus";
      repo = "chemacs";
      flake = false;
    };
  };

  outputs = inputs@{ self, home, nixpkgs, nixpkgs-unstable, nixos-hardware, emacs-overlay, chemacs, ... }:
    let
      inherit (builtins) attrNames attrValues baseNameOf elem filter listToAttrs readDir;
      inherit (nixpkgs.lib) genAttrs filterAttrs hasSuffix removeSuffix;
      systems = [ "x86_64-linux" "i686-linux" "x86_64-darwin" "aarch64-linux" ];
      forAllSystems = f: genAttrs systems (system: f system);

      # Memoize nixpkgs for different platforms for efficiency.
      nixpkgsFor = forAllSystems (
        system:
          import nixpkgs {
            inherit system;
            config = { allowUnfree = true; };
            overlays = attrValues self.overlays;
          }
      );

      outerOverlays = {
        emacsOverlay = emacs-overlay.overlay;
        chemacs = final: prev: {
          inherit chemacs;
        };
      };
    in
      {
        nixosConfigurations = let
          configs = import ./hosts (inputs // { inherit nixpkgsFor; });
        in
          configs;

        overlay = import ./pkgs;

        overlays = let
          filenames = filter (hasSuffix ".nix") (attrNames (readDir ./overlays));
          names = map (removeSuffix ".nix") filenames;
          overlays = genAttrs names (name: import (./overlays + "/${name}.nix"));
        in
          outerOverlays // overlays;

        packages = forAllSystems (
          system: filterAttrs (n: v: elem system v.meta.platforms) {
            inherit (nixpkgsFor.${system}) winbox winbox-bin;
          }
        );

        nixosModules = let
          prep = map (
            path: {
              name = removeSuffix ".nix" (baseNameOf path);
              value = import path;
            }
          );
          # binary cache
          cachix = import ./cachix.nix;
          cachixAttrs = { inherit cachix; };

          # modules
          moduleList = import ./modules/list.nix;
          modulesAttrs = listToAttrs (prep moduleList);
          hmModuleList = import ./hm-modules/list.nix;
          hmModulesAttrs = { home-manager = listToAttrs (prep hmModuleList); };

          # profiles
          profileList = import ./profiles/list.nix;
          profilesAttrs = { profiles = listToAttrs (prep profileList); };
        in
          cachixAttrs // modulesAttrs // hmModulesAttrs // profilesAttrs;

        checks.x86_64-linux = self.packages.x86_64-linux // {
          alien = self.nixosConfigurations.alien.config.system.build.toplevel;
          iso = self.nixosConfigurations.iso.config.system.build.isoImage;
        };

        devShell = forAllSystems (
          system:
            with nixpkgsFor.${system};
            pkgs.mkShell {
              NIX_CONF_DIR = let
                current = pkgs.lib.optionalString (builtins.pathExists /etc/nix/nix.conf)
                  (builtins.readFile /etc/nix/nix.conf);
                nixConf = pkgs.writeTextDir "opt/nix.conf" ''
                  ${current}
                  experimental-features = nix-command flakes ca-references
                '';
              in
                "${nixConf}/opt";

              nativeBuildInputs = with pkgs; [ ansible git git-crypt nixFlakes pass ];

              shellHook = ''
                mkdir -p secrets
              '';
            }
        );
      };
}
