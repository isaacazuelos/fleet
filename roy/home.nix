{pkgs, ...}: {
  imports = [../common/home.nix];

  nixpkgs.config.allowUnfree = true;

  home = {
    stateVersion = "25.11";
    username = "iaz";
    homeDirectory = "/home/iaz";

    packages = with pkgs; [
      vscode.fhs
      zed-editor-fhs
      github-desktop

      discord
      obsidian
      orca-slicer
      plex-desktop
    ];
  };

  programs = {
    git = {
      signing.key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIQq7CgkSKrrcjT9wsYRA0NlVawmv4/s5X5SROwN/ont";
      settings = {
        core.sshCommand = "ssh";
      };
    };
    ssh = {
      enable = true;
      extraConfig = ''
          Host *
            IdentityAgent ~/.1password/agent.sock
      '';
    };
  };
}
