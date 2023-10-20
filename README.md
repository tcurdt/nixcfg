
```
curl https://raw.githubusercontent.com/elitak/nixos-infect/master/nixos-infect | NIX_CHANNEL=nixos-23.05 bash -x
```

```
nix build .#foo
nix shell nixpks#foo
nix develop nixpks#foo
nix profile install nixpks#foo
nix profile install .#foo
nix eval .#foo
nix flake lock --update-input nixpkgs
nix build --update-input nixpkgs
```