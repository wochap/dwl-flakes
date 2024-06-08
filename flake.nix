{
  inputs = {
    nixpkgs.url =
      "github:nixos/nixpkgs?rev=b06025f1533a1e07b6db3e75151caa155d1c7eb3"; # nixos-unstable (mar 21 2024)
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    nixpkgs-wayland.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    scenefx.url =
      "github:wlrfx/scenefx?rev=2ec3505248e819191c37cb831197629f373326fb";
    scenefx.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-wayland, flake-utils, hyprland, scenefx }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs-wayland = nixpkgs-wayland.packages.${system};
        wlroots_0_17_main = pkgs-wayland.wlroots;
        pkgs = nixpkgs.legacyPackages.${system};
        wlroots_0_17 = pkgs.wlroots_0_17;
        scenefxPkg = pkgs.callPackage ./scenefx.nix { };
      in {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            bear # to generate compile_commands.json
            wlroots_0_17

            # dwl nativeBuildInputs
            installShellFiles
            pkg-config
            wayland-scanner

            # dwl buildInputs
            libinput
            xorg.libxcb
            libxkbcommon
            pixman
            wayland
            wayland-protocols
            xorg.libX11
            xorg.xcbutilwm
            xwayland
          ];

          WAYLAND_SCANNER = "wayland-scanner";
        };
        devShells.scenefx = pkgs.mkShell {
          packages = with pkgs; [
            bear # to generate compile_commands.json
            scenefxPkg

            # wlroots nativeBuildInputs
            meson
            ninja
            pkg-config
            wayland-scanner
            glslang

            # wlroots buildInputs
            libGL
            libcap
            libinput
            libpng
            libxkbcommon
            mesa
            pixman
            seatd
            vulkan-loader
            wayland
            wayland-protocols
            xorg.libX11
            xorg.xcbutilerrors
            xorg.xcbutilimage
            xorg.xcbutilrenderutil
            xorg.xcbutilwm
            xwayland
            ffmpeg
            hwdata
            libliftoff
            libdisplay-info
          ];

          WAYLAND_SCANNER = "wayland-scanner";
        };
        devShells.scenefx-flake = pkgs.mkShell {
          packages = with pkgs; [
            bear # to generate compile_commands.json
            scenefx.packages."${system}".scenefx
            libGL

            # nativeBuildInputs
            installShellFiles
            pkg-config
            wayland-scanner

            # buildInputs
            libinput
            xorg.libxcb
            libxkbcommon
            pixman
            wayland
            wayland-protocols
            wlroots
            xorg.libX11
            xorg.xcbutilwm
            xwayland
          ];

          WAYLAND_SCANNER = "wayland-scanner";
        };
        devShells.foot = pkgs.mkShell {
          packages = with pkgs; [
            wayland-scanner
            meson
            ninja
            ncurses
            scdoc
            pkg-config

            tllist
            wayland-protocols
            fontconfig
            freetype
            pixman
            wayland
            libxkbcommon
            fcft
            utf8proc
          ];

          CFLAGS = "-O3";

        };
        devShells.sfwbar = pkgs.mkShell {
          packages = with pkgs; [
            meson
            ninja
            pkg-config
            makeWrapper

            gtk3
            json_c
            gtk-layer-shell
            libpulseaudio
            libmpdclient
            libxkbcommon
            alsa-lib
          ];
        };
      });
}
