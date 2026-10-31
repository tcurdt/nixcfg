set quiet

check:
    nix flake check --all-systems

update:
    nix flake update

# switch:
#     nixos-rebuild switch --flake .#

format:
    nix run nixpkgs#nixpkgs-fmt -- .
    # nix run nixpkgs#alejandra -- .

build machine:
    nix build --eval-store daemon --store ssh-ng://{{ machine }} --no-link .#nixosConfigurations.{{ machine }}.config.system.build.toplevel

test machine:
    nix run --inputs-from . nixpkgs#nixos-rebuild -- test --fast --use-remote-sudo --flake .#{{ machine }} --build-host {{ machine }} --target-host {{ machine }}
    # nix run --inputs-from . nixpkgs#nixos-rebuild -- test --no-reexec --flake .#{{ machine }} --build-host {{ machine }} --target-host {{ machine }}

switch machine:
    nix run --inputs-from . nixpkgs#nixos-rebuild -- switch --fast --use-remote-sudo --flake .#{{ machine }} --build-host {{ machine }} --target-host {{ machine }}
    # nix run --inputs-from . nixpkgs#nixos-rebuild -- switch --no-reexec --flake .#{{ machine }} --build-host {{ machine }} --target-host {{ machine }}
