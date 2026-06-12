rebuild: write-flake
    nh os switch .

update:
    nix flake update

write-flake:
    nix run .#write-flake --option substitute false

repl:
    nix repl ".#nixosConfigurations.$(hostname)"

clean:
    sudo nix profile wipe-history --profile /nix/var/nix/profiles/system
    sudo nix-collect-garbage --delete-old

fmt:
    nix fmt --option substitute false

updatekeys: && fmt
    sops updatekeys secrets/*
