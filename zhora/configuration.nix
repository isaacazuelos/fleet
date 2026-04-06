{ pkgs, ... }:
{
  system.stateVersion = "25.11";
  nixpkgs.hostPlatform = "aarch64-darwin";

  nix.enable = false;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  users.users.iaz = {
    name = "iaz";
    home = "/Users/iaz";
  };

  environment = {
    systemPackages = with pkgs; [
      mas
      nh
      tailscale
    ];
  };

  # This won't install homebrew, so we need to do that first.
  # - Mac App Store apps aren't working, but I keep a list here.
  # - We use casks elsewhere for gui apps.
  # - Comment out lines are things which have failed.
  homebrew = {
    enable = true;
    masApps = {
      # "1Password 7 - Password Manager" = 1333542190;
      # "Things 3" = 904280696;
      # "Shapr3D CAD modeling" = 1091675654;
    };
    casks = [
      "1password"
      "cyberduck"
      "discord"
      "firefox"
      "github"
      "obsidian"
      "orcaslicer"
      # "private-internet-access"
      "transmission"
      "vlc"
      "zed"
    ];
  };

  system = {
    primaryUser = "iaz";
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
    defaults = {
      finder = {
        AppleShowAllExtensions = true;
      };
      dock = {
        autohide = true;
        magnification = true;
        largesize = 24;
        mineffect = "scale";
        orientation = "left";
        show-recents = false;
        persistent-apps = [
          # Huh? No idea why these are not just in /Applications
          { app = "/System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app"; }
          { app = "/System/Applications/Messages.app"; }
          { app = "/System/Applications/Mail.app"; }
          { app = "/System/Applications/Utilities/Terminal.app"; }
        ];
        persistent-others = [
          {
            folder = {
              path = "/Users/@username@/Downloads";
              showas = "grid";
            };
          }
        ];
      };
    };
  };
}
