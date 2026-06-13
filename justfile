rebuild: write-flake
    nh os switch .

update:
    nix flake update
    nix run .#write-flake

write-flake:
    nix run .#write-flake --option substitute false

repl hostname=`hostname`:
    nix repl .#nixosConfigurations.{{ hostname }}

clean:
    sudo nix profile wipe-history --profile /nix/var/nix/profiles/system
    sudo nix-collect-garbage --delete-old

fmt path=".":
    nix fmt --option substitute false -- {{ path }}

updatekeys:
    sops updatekeys secrets/*
    @just fmt secrets
