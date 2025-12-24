# Nushell Environment Config (env.nu)

# Set Starship Config Path using the anchor from PowerShell
if ($env | get NIX_CONFIG_ROOT? | is-not-empty) {
    $env.STARSHIP_CONFIG = ([$env.NIX_CONFIG_ROOT "home" "_mixins" "shell" "starship" "starship.toml"] | path join)
}

# Initialize Starship
# We use a fixed path for the init script to avoid source-time constant errors
let starship_cache = ([$env.USERPROFILE ".cache" "starship"] | path join)
if not ($starship_cache | path exists) {
    mkdir $starship_cache
}
let starship_init = ([$starship_cache "init.nu"] | path join)

# Generate init script if it doesn't exist or we want to ensure it is fresh
if (which starship | is-not-empty) {
    starship init nu | save -f $starship_init
}
