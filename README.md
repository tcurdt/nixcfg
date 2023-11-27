
```
curl https://raw.githubusercontent.com/elitak/nixos-infect/master/nixos-infect | NIX_CHANNEL=nixos-23.05 bash -x
```

```
nixos-rebuild switch --option "tarball-ttl 0" --flake git+ssh://git@github.com/tcurdt/nixcfg.git#utm-arm
```

or

```
git clone git@github.com:tcurdt/nixcfg.git
nixos-rebuild switch --flake '.#utm-arm'
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
docker-compose -p pc_prod up -d
docker-compose -p pc_test up -d
```

```
--extra-experimental-features "nix-command flakes"
```