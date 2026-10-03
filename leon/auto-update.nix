# Weekly self-update for Leon.
#
# Pulls the fleet repo, bumps `flake.lock`, builds Leon from it, switches to
# the result, and only then commits and pushes the new lock. So every lock
# update that lands on `main` is one Leon has actually booted into.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.fleet-auto-update;

  script = pkgs.writeShellApplication {
    name = "fleet-auto-update";
    runtimeInputs = with pkgs; [
      coreutils
      git
      nix
      openssh
      util-linux # runuser
      systemd
    ];
    text = ''
      repo=${lib.escapeShellArg cfg.repo}
      host=${config.networking.hostName}

      as_user() {
        runuser -u ${cfg.user} -- env \
          HOME=${config.users.users.${cfg.user}.home} \
          GIT_SSH_COMMAND="ssh -i ${cfg.sshKey} -o IdentitiesOnly=yes" \
          "$@"
      }

      cd "$repo"

      # Don't touch a checkout I'm in the middle of editing.
      if [ -n "$(as_user git status --porcelain)" ]; then
        echo "$repo has uncommitted changes, skipping update." >&2
        exit 1
      fi
      if [ "$(as_user git symbolic-ref --short HEAD)" != main ]; then
        echo "$repo is not on main, skipping update." >&2
        exit 1
      fi

      as_user git pull --ff-only ${cfg.remote} main
      as_user nix flake update

      if ! out=$(as_user nix build --no-link --print-out-paths \
          ".#nixosConfigurations.$host.config.system.build.toplevel"); then
        echo "Build failed, leaving the lock file alone." >&2
        as_user git checkout -- flake.lock
        exit 1
      fi

      nix-env --profile /nix/var/nix/profiles/system --set "$out"
      if ! "$out/bin/switch-to-configuration" switch; then
        echo "Switch failed, leaving the lock file alone." >&2
        as_user git checkout -- flake.lock
        exit 1
      fi

      if ! as_user git diff --quiet -- flake.lock; then
        as_user git -c commit.gpgsign=false commit \
          -m "$host: weekly flake.lock update" -- flake.lock
        as_user git push ${cfg.remote} HEAD:main
      fi

      ${lib.optionalString cfg.allowReboot ''
        # Reboot if the kernel changed, same check as system.autoUpgrade.
        booted=$(readlink /run/booted-system/{initrd,kernel,kernel-modules})
        built=$(readlink "$out"/{initrd,kernel,kernel-modules})
        if [ "$booted" != "$built" ]; then
          systemctl reboot
        fi
      ''}
    '';
  };
in
{
  options.services.fleet-auto-update = {
    enable = lib.mkEnableOption "weekly flake.lock update and switch";

    repo = lib.mkOption {
      type = lib.types.str;
      default = "/home/iaz/src/fleet";
      description = "Local checkout of the fleet repo.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "iaz";
      description = "User who owns the checkout; git and nix build run as them.";
    };

    remote = lib.mkOption {
      type = lib.types.str;
      default = "git@github.com:isaacazuelos/fleet.git";
      description = "Where to pull from and push the updated lock to.";
    };

    sshKey = lib.mkOption {
      type = lib.types.str;
      default = "/etc/fleet-deploy-key";
      description = "Private key with push access (a GitHub deploy key), readable by `user`.";
    };

    dates = lib.mkOption {
      type = lib.types.str;
      default = "Wed *-*-* 05:00:00";
      description = "When to run, in systemd OnCalendar format (local time).";
    };

    allowReboot = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Reboot after switching if the kernel or initrd changed.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.ssh.knownHosts."github.com".publicKey =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";

    systemd.services.fleet-auto-update = {
      description = "Update fleet flake.lock and switch ${config.networking.hostName}";
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      restartIfChanged = false; # it switches the system, don't let a switch kill it
      serviceConfig = {
        Type = "oneshot";
        ExecStart = lib.getExe script;
      };
    };

    systemd.timers.fleet-auto-update = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = cfg.dates;
        Persistent = true; # catch up if Leon was off at the time
      };
    };
  };
}
