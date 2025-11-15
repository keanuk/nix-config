# Disable tuba due to BreakpointCondition compilation errors
# Issue: tuba 0.10.1 fails to compile with Vala errors about duplicating BreakpointCondition instances
#        Error: "duplicating `BreakpointCondition' instance, use unowned variable or explicitly invoke copy method"
#        This occurs in three locations:
#        - src/Dialogs/Composer/Dialog.vala:344
#        - src/Views/TabbedBase.vala:104
#        - src/Views/Admin/Pages/Accounts.vala:56
#        The issue is caused by newer versions of Vala (0.56.18) being stricter about reference
#        counting for GObject types like BreakpointCondition. The code pattern:
#          var condition = new Adw.BreakpointCondition.length(...);
#          var breakpoint = new Adw.Breakpoint (condition);
#        causes duplication errors because passing 'condition' to the Breakpoint constructor
#        attempts to duplicate the reference-counted object.
# Workaround: Mark the package as broken so it won't be built. Remove 'tuba' from your
#             home.packages list until upstream releases a fix.
# Status: temporary - waiting for upstream tuba to fix compatibility with Vala 0.56.18+
# Reference: https://github.com/GeopJr/Tuba
#            Similar issues: https://gitlab.gnome.org/GNOME/vala/-/issues
# Last checked: 2025-01-26
_final: prev: {
  tuba = prev.tuba.overrideAttrs (oldAttrs: {
    meta =
      oldAttrs.meta
      // {
        broken = true;
      };
  });
}
