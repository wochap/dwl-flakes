{
  inputs = {
    nixpkgs.url =
      "github:nixos/nixpkgs?rev=b681065d0919f7eb5309a93cea2cfa84dec9aa88"; # nixos-24.11 (04 dec 2024)
    flake-utils.url = "github:numtide/flake-utils";
    scenefx.url =
      "github:wlrfx/scenefx?rev=87c0e8b6d5c86557a800445e8e4c322f387fe19c"; # main (17 feb 2024)
    scenefx.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-wayland.url =
      "github:nix-community/nixpkgs-wayland?rev=52b72b12c456a5c0c87c40941ef79335e8d61104"; # master (03 sep 2024)
    nixpkgs-wayland.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, scenefx, nixpkgs-wayland }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        wlroots_0_17 = pkgs.wlroots_0_17;
        wlroots_0_18 = pkgs.wlroots_0_18;
        wlroots_0_19 =
          nixpkgs-wayland.packages."${system}".wlroots; # wlroots beb9a9ad
        scenefx-final = scenefx.packages."${system}".scenefx;
      in {
        devShells = {
          default = pkgs.mkShell {
            packages = with pkgs; [
              bear # to generate compile_commands.json
              # wlroots_0_17
              wlroots_0_18
              # wlroots_0_19

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

          latest = pkgs.mkShell {
            packages = with pkgs; [
              bear # to generate compile_commands.json
              # wlroots_0_17
              # wlroots_0_18
              wlroots_0_19

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

          scenefx = pkgs.mkShell {
            packages = with pkgs; [
              bear # to generate compile_commands.json
              # wlroots_0_17
              wlroots_0_18
              # wlroots_0_19

              scenefx-final
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
              xorg.libX11
              xorg.xcbutilwm
              xwayland
            ];

            WAYLAND_SCANNER = "wayland-scanner";
          };
        };
      });
}
