{
  pkgs ?
  import (builtins.fetchGit {
    # Descriptive name to make the store path easier to identify
    name = "nixos-21.11-2022_01_05";
    url = "https://github.com/nixos/nixpkgs/";
    # Commit hash for nixos-21.11 as of 2021-01-05
    # `git ls-remote https://github.com/nixos/nixpkgs nixos-21.11`
    ref = "refs/heads/nixos-21.11";
    rev = "c6019d8efb5530dcf7ce98086b8e091be5ff900a";
  }) {config.allowUnfree = true;}
}:

pkgs.mkShell {
  buildInputs = import ./packages.nix { inherit pkgs; };
}
