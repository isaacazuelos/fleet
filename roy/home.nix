{ pkgs, ... }:
{
  imports = [ ../common/home.nix ];

  home = {
    stateVersion = "25.11";
    username = "iaz";
    homeDirectory = "/Users/iaz";

    packages = with pkgs; {
      vscode.fhs
      zed-editor-fhs
      github-desktop

      discord
      obsidian
      orca-slicer
      plex-desktop
    };
  };
}
