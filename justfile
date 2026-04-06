rebuild:
    nh os switch .

update:
    nix flake update

clean:
    sudo nix profile wipe-history --profile /nix/var/nix/profiles/system
    sudo nix-collect-garbage --delete-old
