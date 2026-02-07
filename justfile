rebuild:
	sudo true && sudo nixos-rebuild switch --flake . --log-format internal-json -v |& nom --json

update:
	nix flake update

clean:
	sudo nix profile wipe-history --profile /nix/var/nix/profiles/system
	sudo nix-collect-garbage --delete-old
