# Short description of the issue being fixed
# Issue: Detailed description of the problem
# Workaround: Description of the fix applied
# Status: [temporary|permanent] - whether this is expected to be needed long-term
# Last checked: YYYY-MM-DD - when you last verified this is still needed
_final: _prev: {
  # Example: Disable tests for a package
  # package-name = prev.package-name.overrideAttrs (oldAttrs: {
  #   doCheck = false;
  # });

  # Example: Use stable version of a package
  # package-name = final.stable.package-name or prev.package-name;

  # Example: Override Python package
  # python3 = prev.python3.override {
  #   packageOverrides = pyfinal: pyprev: {
  #     package-name = pyprev.package-name.overridePythonAttrs (oldAttrs: {
  #       doCheck = false;
  #     });
  #   };
  # };

  # Example: Apply multiple fixes to a package set
  # package-set = prev.package-set // {
  #   sub-package = prev.package-set.sub-package.overrideAttrs (oldAttrs: {
  #     # modifications here
  #   });
  # };
}
