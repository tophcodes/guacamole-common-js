{inputs, ...}: {
  imports = [inputs.devkit.flakeModules.default];

  perSystem = {pkgs, ...}: {
    devkit.packages = [pkgs.nix-update pkgs.nodejs pkgs.watchexec];
    treefmt.programs.biome.enable = true;
  };
}
