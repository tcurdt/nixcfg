# infect

```
curl https://raw.githubusercontent.com/elitak/nixos-infect/master/nixos-infect | NIX_CHANNEL=nixos-22.11 bash -x
```

# switch

```
nix-shell -p gitMinimal
cd && git clone git@github.com:tcurdt/nixcfg.git && cd nixcfg
nixos-rebuild switch --flake .#utm-arm
```

```
nixos-rebuild switch --option "tarball-ttl 0" --flake git+ssh://git@github.com/tcurdt/nixcfg.git#utm-arm
```

# image

```
nix build .#nixosConfigurations.rpi-zero.config.system.build.sdImage --show-trace -L -v

```

# other

```
nix run github:numtide/nixos-anywhere -- --flake '.#mysystem' root@foo.com
nix run github:numtide/nixos-anywhere -- --flake '.#mysystem' --vm-test
```

````
nix build .#utm-arm
nix shell nixpks#foo
nix develop nixpks#foo
nix profile install nixpks#foo
nix profile install .#foo
nix eval .#foo
nix flake lock --update-input nixpkgs
nix build --update-input nixpkgs
```

```
$ nix-channel --list | grep nixos
nixos https://nixos.org/channels/nixos-23.05

$ nix-channel --add https://channels.nixos.org/nixos-23.11 nixos

$ nixos-rebuild boot --upgrade
$ nixos-rebuild switch --upgrade
$ nixos-rebuild switch --upgrade-all

$ shutdown -r now
```

```
docker-compose -p pc_prod up -d
docker-compose -p pc_test up -d
```
