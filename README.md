# Fleet
> Config files for my machines.

Everything should be managed by the single `nix` flake, and I'm using `nh` as
the interface.

## Machines

- **Zhora** - Laptop
- **Roy** - Desktop
- **Leon** - Server
- **Brainiac** - NAS
- **Tom Servo & Crow** - Vorons

### Common

Here's are the common user environment bits between these machines.

You'll want to set up Tailscale with `tailscale login` after setup.

### Zhora
> An M1 MacBook Air

How to deploy from a fresh install:

1. Set up the user account (use `iaz` for consistency).
2. Check for and install any macOS system updates.
3. Install the Xcode CLI tools with `xcode-select --install`
4. Install [Brew](https://brew.sh), so we can use Casks for mac GUI apps.
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

#### Manual Steps

- Install fonts off Brainiac
- Set Desktop wallpaper
- 1Password Safari Extension
- Set terminal to God's own size (80x24) and fix fonts.
- Set up 1Password
  - Don't forget to set up the ssh agent, and git setup.

### Roy
> A NixOS box with a Ryzen 3600 and RX 5700 XT

I set the up after installing, but it's probably similar to Leon.

### Leon
> A NixOS Nuc with a i3-10110U

Install nixos using the default nixos-generate etc. Then reboot and log in, 
`git clone` fleet, and from there install from the flake.

#### Manual Steps

##### SMB share 

You'll need to manually create `/etc/smbcredentials`. After deploying a new 
machine, create the file and `chmod` it. It's also set up with `noperm` so it
doesn't really manage permissions for the various services which use it. I had
a lot of issues trying to get it to mount with a group, so I gave up and did
that instead.

```sh
sudo vi /etc/smbcredentials
sudo chmod 600 /etc/smbcredentials
```

Format for `smbcredentials`:

```
username=iaz
password=super-secure
```

##### Service config

You'll have to manually go to each media center service and configure it.

### Tom Server & Crow
> RPi 4 based V2.4r2 and V0.2 

A couple of Vorons, they're not nixified or really backed up or documented 
much at all. Maybe some day.
