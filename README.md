# fleet
> Config files for my machines.

Everything should be managed by the single `nix` flake, and I'm using `nh` as
the interface.

## Machines

### Zhora
> An M1 MacBook Air

How to deploy from a fresh install:

1. Set up the user account (use `iaz` for consistency).
2. Check for and install any macOS system udpates.
3. Install the Xcode CLI tools with `xcode-select --install`
4. Install Brew
5. Install Nix
6. Clone this repo with `git clone https://github.com/isaacazuelos/fleet`
    - Put it in `~/src`, which you'll need to make.
7. Bootstrap it with `nix run nix-darwin -- switch --flake ~/src/fleet#zhora` 

Changes to the config file can applied with `nh darwin switch ~/src/fleet#zhora`

### Roy
> A NixOS box with a Ryzen 3600 and RX 5700 XT

Not fully set up yet.
