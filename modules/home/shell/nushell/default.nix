# NOTE: Not imported by any host; kept intentionally for future use.
{
  flake.modules.homeManager.nushell =
    { pkgs, ... }:
    {
      programs.nushell = {
        enable = true;
        package = pkgs.nushell;
        shellAliases = import ../_aliases.nix;
        extraConfig = ''
          let carapace_completer = {|spans|
            carapace $spans.0 nushell $spans | from json
          }
          $env.config = {
            show_banner: false,
            filesize: { metric: true },
            table: { mode: "rounded" },
            ls: { use_ls_colors: true },
            completions: {
              case_sensitive: false
              quick: true
              partial: true
              algorithm: "fuzzy"
              external: {
                enable: true
                max_results: 100
                completer: $carapace_completer
              }
            }
          }

          fastfetch
        '';
      };
    };
}
