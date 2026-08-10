{
  flake.modules.homeManager.base = {
    config,
    pkgs,
    lib,
    ...
  }: {
    config = lib.mkIf config.programs.distrobox.enable {
      programs.distrobox = {
        settings.container_additional_volumes = "/nix/store:/nix/store:ro /etc/profiles/per-user:/etc/profiles/per-user:ro /etc/static/profiles/per-user:/etc/static/profiles/per-user:ro";

        containers.fedora = {
          image = "fedora-toolbox:latest";
          init_hooks = [
            "${pkgs.writeShellScript "bun" ''
              export BUN_INSTALL=/usr/local/bun
              [ -d "$BUN_INSTALL" ] && exit
              sudo mkdir -p "$BUN_INSTALL"
              sudo chown -R root:users "$BUN_INSTALL"
              sudo chmod -R g+rwX "$BUN_INSTALL"

              curl -fsSL https://bun.sh/install | bash

              SHELL=bash sudo "$BUN_INSTALL/bin/bun" completions /etc/bash_completion.d
              sudo tee /etc/profile.d/bun.sh >/dev/null <<'EOF'
              export BUN_INSTALL="/usr/local/bun"
              export PATH="$BUN_INSTALL/bin:$PATH"
              EOF
            ''}"
            "${pkgs.writeShellScript "nvm" ''
              export NVM_DIR=/usr/local/nvm
              [ -d "$NVM_DIR" ] && exit
              sudo mkdir -p "$NVM_DIR"
              sudo chown -R root:users "$NVM_DIR"
              sudo chmod -R g+rwX "$NVM_DIR"

              curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/refs/heads/master/install.sh | PROFILE=/dev/null bash

              sudo tee /etc/profile.d/nvm.sh >/dev/null <<'EOF'
              export NVM_DIR=/usr/local/nvm
              [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
              EOF
            ''}"
          ];
        };
      };
    };
  };
}
