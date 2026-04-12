set -gx PATH $HOME/.nix-profile/bin /nix/var/nix/profiles/default/bin /run/current-system/sw/bin $PATH

# HACK: nix-your-shell is only ad-hoc signed and gets killed by macOS.
# It's not on Homebrew either, so we can't easily get a signed build.
# Instead, we do roughly what `nix-your-shell fish | source` does, just
# a little worse.
function nix
    if test (count $argv) -gt 0
        switch $argv[1]
        case develop shell run
            command nix $argv --command /opt/homebrew/bin/fish
        case '*'
            command nix $argv
        end
    else
        command nix $argv
    end
end
