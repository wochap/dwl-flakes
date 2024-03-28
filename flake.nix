{
  inputs.nixpkgs.url =
    "github:nixos/nixpkgs?rev=b06025f1533a1e07b6db3e75151caa155d1c7eb3"; # nixos-unstable (mar 21 2024)
  inputs.nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
  inputs.nixpkgs-wayland.inputs.nixpkgs.follows = "nixpkgs";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, nixpkgs-wayland, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs-wayland = nixpkgs-wayland.packages.${system};
        wlroots_0_17_main = pkgs-wayland.wlroots;
        pkgs = nixpkgs.legacyPackages.${system};
        wlroots_0_17 = pkgs.wlroots_0_17;
        scenefx = pkgs.callPackage ./scenefx.nix { };
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
            libxcb
            libxkbcommon
            pixman
            wayland
            wayland-protocols
            libX11
            xcbutilwm
            xwayland
          ];

          WAYLAND_SCANNER = "wayland-scanner";
        };
        devShells.scenefx = pkgs.mkShell {
          packages = with pkgs; [
            bear # to generate compile_commands.json
            scenefx

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
      });
}
