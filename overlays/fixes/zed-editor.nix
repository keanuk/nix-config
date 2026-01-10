# Disable checks for zed-editor to avoid test failures in Nix sandbox
# Issue: zed-editor tests fail because they require a graphical environment
#        Tests like test_open_workspace_with_directory, test_new_empty_workspace,
#        test_pane_actions, etc. need window/display access unavailable in sandbox
# Workaround: Disable doCheck
# Status: temporary - these tests require display/window access not available in Nix builds
# Last checked: 2025-01-09
_final: prev: {
  zed-editor = prev.zed-editor.overrideAttrs (_oldAttrs: {
    doCheck = false;
  });
}
