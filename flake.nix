{
  description = "guacamole-common-js, the Apache Guacamole JavaScript client packaged for npm";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    devkit = {
      url = "git+ssh://git@github.com/tophcodes/devkit";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
  };

  # Every .nix file under nix/, tools/ and packages/ is a flake-parts module.
  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;}
    (inputs.import-tree (builtins.filter builtins.pathExists [./nix ./tools ./packages]));
}
