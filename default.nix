# Entry point without the flake, for nix-update and CI: evaluating the flake
# fetches devkit, which is a private repository.
{pkgs ? import <nixpkgs> {}}: {
  guacamole-common-js = pkgs.callPackage ./package.nix {};
}
