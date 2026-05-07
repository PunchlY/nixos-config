rebuild:
    nix run .#write-flake --option substitute false
    nh os switch .

update:
    nix flake update

repl:
    nix repl ".#nixosConfigurations.$(hostname)"

clean:
    sudo nix profile wipe-history --profile /nix/var/nix/profiles/system
    sudo nix-collect-garbage --delete-old
