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
              mkdir -p "$BUN_INSTALL"

              curl -fsSL https://bun.sh/install | bash

              chgrp -R users "$BUN_INSTALL"
              chmod -R g+rwX "$BUN_INSTALL"

              SHELL=bash "$BUN_INSTALL/bin/bun" completions /etc/bash_completion.d
              tee /etc/profile.d/bun.sh >/dev/null <<'EOF'
              export BUN_INSTALL="/usr/local/bun"
              export PATH="$BUN_INSTALL/bin:$PATH"
              EOF
            ''}"
            "${pkgs.writeShellScript "nvm" ''
              export NVM_DIR=/usr/local/nvm
              [ -d "$NVM_DIR" ] && exit
              mkdir -p "$NVM_DIR"

              curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/refs/heads/master/install.sh | PROFILE=/dev/null bash

              ( \. "$NVM_DIR/nvm.sh"; nvm install --lts )

              chgrp -R users "$NVM_DIR"
              chmod -R g+rwX "$NVM_DIR"

              tee /etc/profile.d/nvm.sh >/dev/null <<'EOF'
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
