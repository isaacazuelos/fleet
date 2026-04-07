# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  # config,
  # lib,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware.nix
  ];

  hardware.enableAllFirmware = true;
  hardware.graphics.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.config.allowUnfree = true;

  # Use the GRUB 2 boot loader.
  boot.loader = {
    grub = {
      enable = true;
      efiSupport = true;
      useOSProber = true;
      device = "nodev";
    };
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
  };

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking = {
    hostName = "roy";
    networkmanager.enable = true;
    firewall = {
      allowedTCPPorts = [
        3000
        11434
      ];
    };
  };

  # Set your time zone.
  time.timeZone = "Canada/Mountain";

  virtualisation = {
    docker.enable = true;
    oci-containers = {
      backend = "docker";
      containers.open-webui = {
        image = "ghcr.io/open-webui/open-webui:main";
        ports = ["3000:8080"];
        volumes = ["open-webui:/app/backend/data"];
        extraOptions = ["--add-host=host.docker.internal:host-gateway"];
        environment = {
          OLLAMA_BASE_URL = "http://host.docker.internal:11434";
        };
      };
    };
  };

  services = {
    resolved = {
      enable = true;
    };
    displayManager.gdm = {
      enable = true;
    };
    desktopManager.gnome.enable = true;
    gnome = {
      games.enable = false;
    };
    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
    };
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
        AllowUsers = ["iaz"];
      };
    };
    tailscale = {
      enable = true;
    };
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };

  users.users.iaz = {
    isNormalUser = true;
    description = "Isaac Azuelos";
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
      "render"
      "video" # GPU access
      "dialout"
      "tty" # For MCU nonsense
      "docker" # No points for guessing
    ];
    home = "/home/iaz";
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIQq7CgkSKrrcjT9wsYRA0NlVawmv4/s5X5SROwN/ont"
    ];
  };

  programs = {
    _1password.enable = true;
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = ["iaz"];
    };
    firefox.enable = true;
    fish.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 14d --keep 5";
    };
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    cifs-utils

    fishPlugins.fzf-fish
  ];

  # for vscode on wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?
}
