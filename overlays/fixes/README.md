# Overlay Fixes

This directory contains temporary overlay fixes for package build issues. Each fix is in a separate file for easy management.

## Purpose

When packages fail to build due to:
- Failing tests
- Version incompatibilities
- Build system issues
- Platform-specific problems

These overlays provide workarounds until upstream fixes are available.

## Structure

Each overlay file:
- Has a descriptive name (e.g., `batgrep.nix`, `qt6-packages.nix`)
- Contains a comment header explaining:
  - The issue being fixed
  - The workaround applied
  - Any relevant context
- Exports a single overlay function: `final: prev: { ... }`

## Active Fixes

### `batgrep.nix`
Disables tests for batgrep due to snapshot mismatches.

### `mercantile.nix`
Disables tests for Python mercantile package (dependency of alpaca) due to CLI test failures.

### `qt6-packages.nix`
Uses stable versions of Qt6-dependent packages (stellarium, protonmail-bridge-gui) to avoid build issues.

### `macos-ruby.nix`
Uses stable versions of Ruby/nokogiri-dependent packages (bash-preexec, bats) for macOS compatibility.

## Usage

Fixes are automatically imported in `overlays/default.nix`. 

### To disable a fix temporarily:

Comment it out in the `fixes` list in `overlays/default.nix`:

```nix
fixes = [
  ./fixes/batgrep.nix
  # ./fixes/mercantile.nix  # Commented out - no longer needed
  ./fixes/qt6-packages.nix
  ./fixes/macos-ruby.nix
];
```

### To add a new fix:

1. Copy `_template.nix` to a new file with a descriptive name
2. Fill in the issue description and workaround
3. Add your overlay function
4. Add the new file to the `fixes` list in `overlays/default.nix`
5. Run `git add overlays/fixes/your-fix.nix`
6. Test with `nix flake check`

Example:
```bash
cp overlays/fixes/_template.nix overlays/fixes/my-package.nix
# Edit the file
git add overlays/fixes/my-package.nix
```

Then in `overlays/default.nix`:
```nix
fixes = [
  ./fixes/batgrep.nix
  ./fixes/mercantile.nix
  ./fixes/qt6-packages.nix
  ./fixes/macos-ruby.nix
  ./fixes/my-package.nix  # Your new fix
];
```

## Maintenance

### Monthly Review Checklist

1. **Test each fix** - Try commenting it out and rebuilding
2. **Update "Last checked" date** if still needed
3. **Remove obsolete fixes** - Delete the file and remove from import list
4. **Update workarounds** if upstream solutions change
5. **Document any new findings** in the file comments

### When to Remove a Fix

- ✅ Rebuild succeeds without the fix
- ✅ Upstream package version has been updated
- ✅ The dependency causing issues has been removed

### When to Keep a Fix

- ❌ Build still fails without it
- ❌ Tests still fail without it
- ❌ Platform-specific issues persist

### Reporting Upstream

If a fix persists for more than 3 months:
1. Search for existing issues in nixpkgs
2. Open a new issue if none exists
3. Link the issue in the fix file comments
4. Consider contributing a proper fix upstream