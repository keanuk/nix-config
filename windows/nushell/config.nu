# Nushell Config (config.nu)

# Starship Integration
# Note: Nushell 'source' requires a literal path at parse-time.
# We source the file from a predictable location.
# If you get an error that the file doesn't exist on first launch, restart Nu.
source ~/.cache/starship/init.nu

# Settings from NixOS config
$env.config = {
    show_banner: false,
    table: {
        mode: rounded
    },
    completions: {
        case_sensitive: false
        quick: true
        partial: true
        algorithm: "fuzzy"
        external: {
            enable: true
            max_results: 100
        }
    }
}

# Run Fastfetch
if (which fastfetch | is-not-empty) {
    fastfetch
}
