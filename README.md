# fleet
> Config files for my machines.

Everything should be managed by the single `nix` flake, and I'm using `nh` as
the interface.

## Machines

### Common

Here's are the common user environment bits between these machines.

### Zhora
> An M1 MacBook Air

How to deploy from a fresh install:

1. Set up the user account (use `iaz` for consistency).
2. Check for and install any macOS system udpates.
3. Install the Xcode CLI tools with `xcode-select --install`
4. Install [Brew](https://brew.sh), so we can use Casks for mac GUI apss.
5. Install [Nix](https://nixos.org/download/).
6. Clone this repo with `git clone https://github.com/isaacazuelos/fleet`
    - Put it in `~/src`, which you'll need to make.
7. Bootstrap it. We need to run this with the `nix` command, and as a `flake`,
   and we need to run it as `root`, so the command is long.
   ```bash
   sudo NIX_CONFIG="experimental-features = nix-command flakes" \
        nix run nix-darwin -- switch --flake ~/src/fleet#zhora
   ```

From now on, you can use `nh darwin switch ~/src/fleet#zhora` to apply changes.

#### Manual things

- Install fonts off Brianiac
- Set Desktop wallpaper
- 1Password Safari Extension
- Set terminal to God's own size (80x24) and fix fonts.
- Set up 1Password
  - Don't forget to set up the ssh agent, and git setup.

### Roy
> A NixOS box with a Ryzen 3600 and RX 5700 XT

I set the up after installing, but I think starting with configuration.nix and
hardware.nix, then after install dropping the flake in should work.

### Chippy

I'm planning to nixify this soon, just putting the tricky bits down here for
when I do.
