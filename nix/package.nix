{
  perSystem = {
    config,
    pkgs,
    ...
  }: {
    packages.default = pkgs.callPackage ../package.nix {};
    # The install check runs test/smoke.mjs against the built package.
    checks.package = config.packages.default;
  };
}
