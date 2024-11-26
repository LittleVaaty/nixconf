{ pkgs, lib, ... }: {
    imports = [
      ./cliPrograms/git.nix
    ];

    git.enable = true;
}
