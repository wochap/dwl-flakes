{
  inputs = {
    nixpkgs.url =
      "github:nixos/nixpkgs?rev=00d80d13810dbfea8ab4ed1009b09100cca86ba8"; # nixos-unstable (jul 04 2024)
    flake-utils.url = "github:numtide/flake-utils";
    scenefx.url =
      "github:wlrfx/scenefx?rev=2ec3505248e819191c37cb831197629f373326fb";
    scenefx.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, scenefx }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        wlroots_0_17 = pkgs.wlroots_0_17;
        scenefx-final = scenefx.packages."${system}".scenefx;
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
            wlroots
            xorg.libX11
            xorg.xcbutilwm
            xwayland
          ];

          WAYLAND_SCANNER = "wayland-scanner";
        };
      });
}
