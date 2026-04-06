{ pkgs, ... }: {
  system.stateVersion = 5;
  nixpkgs.hostPlatform = "aarch64-darwin";

  nix.enable = false;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  users.users.iaz = {
    name = "iaz";
    home = "/Users/iaz";
  };  

  environment = {
    systemPackages = with pkgs; [
      git
      nh
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
          { app = "/Applications/Safari.app"; }
          { app = "/Applications/Messages.app"; }
          { app = "/Applications/Mail.app"; }
          { app = "/Applications/Terminal.app"; }
        ];
        persistent-others = [  
          { folder = { path = "/Users/@username@/Downloads"; showas = "grid"; }; }
        ];
      };
    };
  };
}
