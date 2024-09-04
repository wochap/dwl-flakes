{
  inputs = {
    nixpkgs.url =
      "github:nixos/nixpkgs?rev=9f918d616c5321ad374ae6cb5ea89c9e04bf3e58"; # nixos-unstable (aug 02 2024)
    flake-utils.url = "github:numtide/flake-utils";
    scenefx.url =
      "github:wlrfx/scenefx?rev=7a7c35750239bd117931698b121a072f30bc1cbe";
    scenefx.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-wayland.url =
      "github:nix-community/nixpkgs-wayland?rev=52b72b12c456a5c0c87c40941ef79335e8d61104"; # master (sep 03 2024)
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
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            bear # to generate compile_commands.json
            # wlroots_0_17
            wlroots_0_18

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
        devShells.latest = pkgs.mkShell {
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
        devShells.scenefx = pkgs.mkShell {
          packages = with pkgs; [
            bear # to generate compile_commands.json
            # wlroots_0_17
            wlroots_0_18

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
      });
}
