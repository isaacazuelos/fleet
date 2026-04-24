{pkgs, inputs, ...}: {
  system.stateVersion = 6;

  nixpkgs = {
    hostPlatform = "aarch64-darwin";
    config.allowUnfree = true;
    overlays = [
      (final: prev: {
        unstable = import inputs.nixpkgs-unstable {
          inherit (prev.stdenv.hostPlatform) system;
          config.allowUnfree = true;
        };
      })
    ];
  };

  nix.enable = true;
  nix.settings = {
    warn-dirty = false;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  networking = {
    hostName = "zhora";
    computerName = "Zhora";
    applicationFirewall = {
      enable = true;
      enableStealthMode = true;
      blockAllIncoming = true;
    };
  };

  users.users.iaz = {
    name = "iaz";
    home = "/Users/iaz";
  };

  programs.fish.enable = true;

  environment = {
    systemPackages = with pkgs; [
      mas
      nh
    ];
  };

  # This won't install homebrew, so we need to do that first.
  homebrew = {
    enable = true;
    # Nix fish is only ad-hoc signed (no TeamIdentifier), so macOS kills it.
    # We install fish via Homebrew for ghostty, and rely on
    # `programs.fish.enable` to manage the config and integrations.
    brews = ["fish"];
    # Mac App Store apps aren't working, but I keep these here so I know what
    # to go get manually.
    masApps = {
      # "1Password 7 - Password Manager" = 1333542190;
      # "Things 3" = 904280696;
      # "Shapr3D CAD modeling" = 1091675654;
    };
    casks = [
      "1password"
      "claude"
      "cyberduck"
      "discord"
      "firefox"
      "github"
      "obsidian"
      "orcaslicer"
      "plex"
      "tailscale-app"
      "transmission"
      "whatsapp"
      "vlc"
      "zed"
    ];
  };

  system = {
    primaryUser = "iaz";
    startup.chime = true;
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
    defaults = {
      finder = {
        AppleShowAllExtensions = true;
        NewWindowTarget = "Home";
        ShowPathbar = true;
      };
      menuExtraClock = {
        Show24Hour = true;
      };
      trackpad = {
        Clicking = true;
        TrackpadPinch = true;
        TrackpadRightClick = true;
        TrackpadRotate = true;
        TrackpadThreeFingerVertSwipeGesture = 2;
      };
      dock = {
        autohide = true;
        magnification = true;
        tilesize = 48;
        largesize = 64;
        mineffect = "scale";
        orientation = "left";
        show-recents = false;
        persistent-apps = [
          {app = "/Applications/Firefox.app";}
          {app = "/System/Applications/Messages.app";}
          {app = "/System/Applications/Mail.app";}
          {app = "/Applications/Things.app";}
          {app = "/Applications/Obsidian.app";}
          {app = "/Users/iaz/Applications/Home Manager Apps/Ghostty.app";}
        ];
        persistent-others = [
          {
            folder = {
              path = "/Users/iaz/Downloads";
              showas = "grid";
            };
          }
        ];
      };
    };
  };
}
