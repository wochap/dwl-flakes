{
  description = "A basic flake with a shell";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
  inputs.nixpkgs-wayland.inputs.nixpkgs.follows = "nixpkgs";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, nixpkgs-wayland, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        pkgs-wayland = nixpkgs-wayland.packages.${system};
        wlroots_0_16 = pkgs.wlroots_0_16;
        wlroots_0_17 = pkgs.wlroots_0_16.overrideAttrs (oldAttrs: {
          version = "fe53ec693789afb44c899cad8c2df70c8f9f9023";
          buildInputs = with pkgs;
            oldAttrs.buildInputs ++ [ hwdata libdisplay-info ];
          src = pkgs.fetchFromGitLab {
            domain = "gitlab.freedesktop.org";
            owner = "wlroots";
            repo = "wlroots";
            rev = "fe53ec693789afb44c899cad8c2df70c8f9f9023";
            sha256 = "sha256-ah8TRZemPDT3NlPAHcW0+kUIZojEGkXZ53I/cNeCcpA=";
          };
        });
        wlroots_0_17_main = pkgs-wayland.wlroots;
        packages = with pkgs; [
          installShellFiles
          pkg-config
          wayland-scanner

          bashInteractive

          libinput
          xorg.libxcb
          libxkbcommon
          pixman
          wayland
          wayland-protocols

          xorg.libX11
          xorg.xcbutilwm
          xwayland

          bear # to generate compile_commands.json
        ];
      in {
        devShells.default = pkgs.mkShell {
          packages = packages ++ [ wlroots_0_17 ];

          WAYLAND_SCANNER = "wayland-scanner";
        };
        devShells.wlroots_0_16 = pkgs.mkShell {
          packages = packages ++ [ wlroots_0_16 ];

          WAYLAND_SCANNER = "wayland-scanner";
        };
      });
}
