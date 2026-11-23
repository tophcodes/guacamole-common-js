{
  # The bundle is platform independent; one system covers CI and local builds.
  systems = ["x86_64-linux"];

  perSystem = {
    config,
    pkgs,
    ...
  }: {
    packages = {
      default = pkgs.callPackage ../package.nix {};

      # nix run .#update [-- --version=X] bumps package.nix to a Guacamole release.
      # nix-update runs in file mode on a generated entry point: in flake mode it
      # re-evaluates the flake from a store path that it does not materialise.
      update = pkgs.writeShellApplication {
        name = "update";
        text = ''
          entry=$(mktemp --suffix=.nix)
          trap 'rm -f "$entry"' EXIT
          echo "{...}: { default = (import ${pkgs.path} {}).callPackage $PWD/package.nix {}; }" > "$entry"
          ${pkgs.lib.escapeShellArgs config.packages.default.updateScript} --file "$entry" default "$@"
        '';
      };
    };

    # The install check runs test/smoke.mjs against the built package.
    checks.package = config.packages.default;

    formatter = pkgs.alejandra;
  };
}
