# Short description of the issue being fixed
# Issue: https://github.com/NixOS/nixpkgs/issues/XXXXX (link to upstream issue)
# Upstream PR: https://github.com/NixOS/nixpkgs/pull/XXXXX (if exists)
# Workaround: Description of the fix applied
# Status: [temporary|permanent] - whether this is expected to be needed long-term
# Last checked: YYYY-MM-DD - when you last verified this is still needed
# Remove after: nixpkgs > XX.XX or YYYY-MM-DD (condition when safe to remove)
_: {
  # Optional: Add assertion to remind yourself to check if fix is still needed
  # assertions = [{
  #   assertion = true;  # Set to false to get a reminder on next build
  #   message = ''
  #     Workaround for issue #XXXXX may no longer be needed.
  #     Check if upstream fix has landed and remove this file if so.
  #   '';
  # }];

  # Optional: Add build-time warning with removal reminder
  # warnings = lib.optional (lib.versionAtLeast lib.version "XX.XX")
  #   "Check if workaround in ${__curPos.file} is still needed";

  # Example: Override a launchd service
  # launchd.daemons.service-name = {
  #   serviceConfig = {
  #     ProgramArguments = [ "${pkgs.package}/bin/command" ];
  #   };
  # };

  # Example: Set system defaults
  # system.defaults.NSGlobalDomain = {
  #   KeyName = value;
  # };

  # Example: Override homebrew configuration
  # homebrew.casks = lib.mkForce [ "allowed-cask" ];

  # Example: Set environment variables
  # environment.variables = {
  #   VARIABLE_NAME = "value";
  # };

  # Example: Apply conditional fixes
  # system.keyboard.enableKeyMapping = lib.mkIf (condition) true;

  # Example: Override system activation scripts
  # system.activationScripts.postActivation.text = ''
  #   # Custom activation script
  # '';

  # Note: For temporary fixes, add a TODO comment:
  # TODO: Remove this workaround after checking nixpkgs > XX.XX or upstream issue #XXXXX
}
