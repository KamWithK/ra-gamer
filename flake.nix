{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      nixpkgs,
      ...
    }:
    let
      odinOverlay = final: prev: {
        odin = prev.odin.overrideAttrs (
          finalAttrs: oldAttrs: {
            version = "dev-2025-11";
            src = prev.fetchFromGitHub {
              inherit (oldAttrs.src) owner repo;
              tag = finalAttrs.version;
              hash = "sha256-Nyi8/52xexGPSnWIF8eMSMqaXFQD57dDRGl6IuZcppw=";
            };
          }
        );
        ols = prev.ols.overrideAttrs (oldAttrs: {
          src = prev.fetchFromGitHub {
            inherit (oldAttrs.src) owner repo;
            rev = "0d6f26fa21ceb6c656ed19e008f74091a4cf6686";
            hash = "sha256-R1tNni7h3JQAtMK5sSDWfVjEAa3rLxFqlmFYRBiY3ic=";
          };
          installPhase = oldAttrs.installPhase + ''
            cp -r builtin $out/bin/
          '';
        });
      };
      forEachSystem =
        f:
        nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (
          system:
          f {
            pkgs = import nixpkgs {
              inherit system;
              overlays = [ odinOverlay ];
            };
          }
        );
    in
    {
      devShells = forEachSystem (
        { pkgs }:
        let
          libPath =
            with pkgs;
            lib.makeLibraryPath [
              libGL
              vulkan-headers
              vulkan-loader

              libxkbcommon
              wayland
              libdecor

              xorg.libX11
              xorg.libXcursor
              xorg.libXext
              xorg.libXfixes
              xorg.libXi
              xorg.libXrandr
            ];
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              libGL
              libcxx
              vulkan-headers
              vulkan-loader
              vulkan-memory-allocator

              libxkbcommon
              wayland
              libdecor

              xorg.libX11
              xorg.libXScrnSaver
              xorg.libXcursor
              xorg.libXext
              xorg.libXfixes
              xorg.libXi
              xorg.libXrandr

              odin
              ols

              gdb
              directx-shader-compiler
              clang-tools
              shader-slang
              shaderc

              vulkan-tools
              vulkan-validation-layers
              spirv-tools
              renderdoc

              wineWowPackages.stable

              sdl3
              sdl3-image
              sdl3-ttf
              raylib
            ];

            LD_LIBRARY_PATH = libPath;
          };
        }
      );
    };
}
