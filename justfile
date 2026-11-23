# list recipes
default:
    @just --list

# rebuild the package on every change
dev:
    watchexec -e nix,mjs,json -- nix build -L

# build the package and run the smoke test
test:
    nix build -L

# format all files
fmt:
    treefmt

# everything CI checks
check:
    nix flake check

# bump to the newest Guacamole release, or to the given one (--version=1.5.1)
update *args:
    nix-update --file default.nix guacamole-common-js --version-regex '^(\d+\.\d+\.\d+)$' {{ args }}
