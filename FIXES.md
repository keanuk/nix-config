# Fixes and Workarounds System

This directory structure contains workarounds for temporary issues and permanent fixes needed across the Nix configuration. The fixes are organized by layer to match the Nix configuration hierarchy.

## Directory Structure

```
├── overlays/fixes/          # Package-level fixes (overlay modifications)
├── nixos/_mixins/fixes/     # NixOS system-level fixes
├── darwin/_mixins/fixes/    # macOS/Darwin system-level fixes
└── home/_mixins/fixes/      # Home-manager user-level fixes
```

## Usage

### Importing Fixes

Each fixes directory has a `default.nix` that serves as a registry of all active fixes:

```nix
# In your NixOS configuration
imports = [ ./nixos/_mixins/fixes ];

# In your Darwin configuration
imports = [ ./darwin/_mixins/fixes ];

# In your home-manager configuration
imports = [ ./home/_mixins/fixes ];
```

For overlays, ensure the fixes overlay is included in your overlays list.

### Creating a New Fix

1. Copy the `_template.nix` file in the appropriate fixes directory
2. Rename it descriptively (e.g., `package-name-build-failure.nix`)
3. Fill in all the header fields:
   - **Issue**: Link to upstream issue/bug report
   - **Upstream PR**: Link to PR if one exists
   - **Workaround**: Describe what the fix does
   - **Status**: Mark as `temporary` or `permanent`
   - **Last checked**: Date you verified it's still needed
   - **Remove after**: Condition for when to remove (version, date, etc.)
4. Implement the actual workaround
5. Add the file to the `default.nix` registry in that directory

## Documentation Standards

### Header Template

Every fix file must include these headers:

```nix
# Short description of the issue being fixed
# Issue: https://github.com/NixOS/nixpkgs/issues/XXXXX
# Upstream PR: https://github.com/NixOS/nixpkgs/pull/XXXXX (if exists)
# Workaround: Description of the fix applied
# Status: [temporary|permanent]
# Last checked: YYYY-MM-DD
# Remove after: nixpkgs > XX.XX or YYYY-MM-DD
```

### Status Types

- **temporary**: Expected to be fixed upstream eventually (track with issue/PR)
- **permanent**: Hardware-specific, vendor-specific, or intentional deviation from defaults

## Maintenance

### Regular Checks

Periodically review the fixes:

1. Check if upstream issues are closed
2. Test if the fix is still needed on newer nixpkgs versions
3. Update the "Last checked" date
4. Remove fixes that are no longer needed

### Automated Reminders

For temporary fixes, you can add assertions or warnings:

```nix
# Assertion that will fail on next build (to remind you to check)
assertions = [{
  assertion = true;  # Set to false to trigger reminder
  message = "Check if workaround for issue #XXXXX is still needed";
}];

# Warning that triggers after a specific nixpkgs version
warnings = lib.optional (lib.versionAtLeast lib.version "24.11")
  "Check if workaround in ${__curPos.file} is still needed";
```

### Dead Code Checking

This project uses [deadnix](https://github.com/astro/deadnix) to check for unused code. Template files use underscore-prefixed parameters to indicate they're intentionally unused examples.

To run deadnix locally:

```bash
# Run with the same settings as CI
deadnix --fail --no-underscore .

# Auto-fix issues (use with caution)
deadnix --edit --no-underscore .
```

The `--no-underscore` flag allows template files to have unused parameters prefixed with `_`.

## Examples by Layer

### Overlay Fixes (Package Level)

Use for:
- Disabling failing tests
- Overriding package versions
- Patching package builds
- Python package overrides

Example: `overlays/fixes/package-name-test-failure.nix`

### NixOS Fixes (System Level)

Use for:
- Systemd service overrides
- Kernel parameters
- Boot configuration
- System-wide settings

Example: `nixos/_mixins/fixes/network-manager-wait-online-timeout.nix`

### Darwin Fixes (macOS System Level)

Use for:
- Launchd service overrides
- System defaults
- Homebrew configuration
- macOS-specific settings

### Home-Manager Fixes (User Level)

Use for:
- Program configuration overrides
- XDG config files
- User services
- Environment variables

## Best Practices

1. **One fix per file** - Makes it easy to remove when no longer needed
2. **Descriptive filenames** - Use `package-or-service-description.nix` format
3. **Link to upstream** - Always include issue/PR URLs
4. **Set removal conditions** - Be specific about when to remove
5. **Update regularly** - Review fixes quarterly or when updating nixpkgs
6. **Comment inline** - Add TODO comments in the code for extra clarity
7. **Test removal** - Before deleting, verify the issue is actually fixed
8. **Use underscore prefix** - For intentionally unused template parameters, prefix with `_`

## Finding Fixes to Remove

Search for fixes that might be outdated:

```bash
# Find all fixes
find . -path "*/fixes/*.nix" ! -name "_template.nix" ! -name "default.nix"

# Check last-checked dates
grep -r "Last checked:" */fixes/

# Look for version-specific removal conditions
grep -r "Remove after:" */fixes/

# Check for issues that might be closed
grep -r "Issue:" */fixes/ | grep -o "issues/[0-9]*"
```

## Questions?

If you're unsure whether something should be a fix or part of regular configuration:

- **Use fixes** if: It's a workaround for a bug, a temporary issue, or something you expect to remove
- **Use regular config** if: It's a preference, a deliberate choice, or intended to be permanent

When in doubt, put it in fixes - it's easier to move to regular config later than to track down scattered workarounds.