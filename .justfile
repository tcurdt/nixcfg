set quiet

check:
    nix flake check --all-systems

update:
    nix flake update

format:
    nix run nixpkgs#nixpkgs-fmt -- .
    # nix run nixpkgs#alejandra -- .

build machine:
    nix build --eval-store daemon --store ssh-ng://{{ machine }} --no-link .#nixosConfigurations.{{ machine }}.config.system.build.toplevel

diff machine:
    ssh {{ machine }} nvd diff /run/current-system $(nix eval --raw .#nixosConfigurations.{{ machine }}.config.system.build.toplevel.outPath)

test machine:
    nix run --inputs-from . nixpkgs#nixos-rebuild -- test --no-reexec --sudo --flake .#{{ machine }} --build-host {{ machine }} --target-host {{ machine }}

switch machine:
    nix run --inputs-from . nixpkgs#nixos-rebuild -- switch --no-reexec --sudo --flake .#{{ machine }} --build-host {{ machine }} --target-host {{ machine }}

darwin:
    sudo darwin-rebuild switch --flake .#shodan
