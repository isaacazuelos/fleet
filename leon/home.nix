{ pkgs, ... }:
{
  imports = [ ../common/home.nix ];

  home = {
    stateVersion = "25.11";
    username = "iaz";
    homeDirectory = "/home/iaz";

    packages = with pkgs; [
      zed-editor-fhs

      obsidian
    ];
  };

  programs = {
    git = {
      signing.key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIQq7CgkSKrrcjT9wsYRA0NlVawmv4/s5X5SROwN/ont";
      settings = {
        core.sshCommand = "ssh";
        "gpg \"ssh\"".program = "${pkgs._1password-gui}/bin/op-ssh-sign";
      };
    };
    ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks."*" = {
        extraOptions = {
          IdentityAgent = "~/.1password/agent.sock";
        };
      };
    };
  };
}
