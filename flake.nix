{
  description = "desktop-thumbnailer flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      rust-overlay,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system;
          overlays = overlays;
        };

        rustToolchain = pkgs.rust-bin.stable.latest.default;
      in
      {
        packages.default = pkgs.rustPlatform.buildRustPackage {
          pname = "desktop-thumbnailer";
          version = "0.1.0";

          src = ./.;

          cargoLock = {
            lockFile = ./Cargo.lock;
          };

          RUSTC = "${rustToolchain}/bin/rustc";
          CARGO = "${rustToolchain}/bin/cargo";

          nativeBuildInputs = [ rustToolchain ];

          buildPhase = ''
            cargo build --release
          '';

          installPhase = ''
            runHook preInstall
            mkdir -p $out/bin
            install -Dm755 target/release/desktop-thumbnailer $out/bin/

            mkdir -p $out/share/thumbnailers/
            cp desktop-thumbnailer.thumbnailer $out/share/thumbnailers/
            runHook postInstall
          '';

          meta = with nixpkgs.lib; {
            homepage = "https://github.com/sachesi/desktop-thumbnailer/";
            description = "Fast, lightweight and minimalistic Wayland terminal emulator";
            license = licenses.gpl3;
            maintainers = [
              {
                name = "sachesi x";
                email = "sachesi.bb.passp@proton.me";
                github = "sachesi";
              }
            ];
            platforms = platforms.linux;
          };
        };
      }
    );
}
