# GitHub Actions Workflows

This directory contains the CI/CD workflows for this NixOS configuration repository.

## Workflows Overview

### Linting and Formatting

- **`lint.yml`** - Runs `statix` to check for Nix anti-patterns and style issues
- **`deadnix-check.yml`** - Checks for unused Nix code with `deadnix`
- **`format-check.yml`** - Verifies Nix code formatting with `nix fmt`

### Build and Evaluation

- **`build-check.yml`** - Evaluates all NixOS and Darwin configurations to ensure they are valid
  - **Note:** Only evaluates configurations, does not build them (see limitations below)
- **`cachix.yml`** - Builds and caches packages to Cachix for faster local builds

### Maintenance

- **`update-flake.yml`** - Automatically updates `flake.lock` daily
- **`link-check.yml`** - Checks for broken links in Markdown and Nix files (weekly)
- **`release.yml`** - Creates GitHub releases when tags are pushed

## Disk Space Limitations

GitHub Actions runners have limited disk space:
- **ubuntu-latest**: ~14GB free by default, ~25-30GB after aggressive cleanup
- **macos-latest**: Similar constraints

### Why We Don't Build Full System Configurations

Full NixOS system builds can easily exceed **50-75GB** including:
- Base system packages
- Desktop environments (GNOME, KDE, etc.)
- Development tools
- All dependencies and closures

This exceeds GitHub Actions' available disk space, causing builds to fail with "No space left on device" errors.

### What We Do Instead

1. **Evaluation Only** - The `build-check.yml` workflow evaluates configurations to ensure they are syntactically correct and all references resolve properly, without actually building anything.

2. **Package Caching Only** - The `cachix.yml` workflow only builds and caches individual packages from `packages.x86_64-linux`, not full system configurations.

3. **Local Builds** - Full system builds happen on your local machines where disk space is not constrained.

## Alternative: Self-Hosted Runners

If you need to build full system configurations in CI, you can set up a self-hosted GitHub Actions runner:

1. **Requirements:**
   - Machine with 100GB+ free disk space
   - Nix installed
   - Network access to GitHub

2. **Setup:**
   ```bash
   # On your build machine
   cd /opt
   sudo mkdir actions-runner && cd actions-runner
   sudo chown $USER:$USER .
   
   # Download the latest runner (check GitHub for current version)
   curl -o actions-runner-linux-x64-2.311.0.tar.gz -L \
     https://github.com/actions/runner/releases/download/v2.311.0/actions-runner-linux-x64-2.311.0.tar.gz
   tar xzf ./actions-runner-linux-x64-2.311.0.tar.gz
   
   # Configure (you'll need a token from GitHub repo settings)
   ./config.sh --url https://github.com/YOUR_USERNAME/nix-config --token YOUR_TOKEN
   
   # Install as a service
   sudo ./svc.sh install
   sudo ./svc.sh start
   ```

3. **Update workflows to use self-hosted runners:**
   ```yaml
   jobs:
     build:
       runs-on: self-hosted  # Instead of ubuntu-latest
   ```

## Cache Strategy

- **magic-nix-cache** is intentionally removed from lightweight workflows (linting, formatting) as it can be unreliable and these workflows don't benefit much from caching
- The official NixOS cache at `https://cache.nixos.org` is always available as a fallback
- Cachix is used for custom packages to speed up local development

## Troubleshooting

### "No space left on device"
This means a build exceeded available disk space. Options:
1. Move the build to a self-hosted runner
2. Reduce the size of what's being built
3. Use evaluation-only checks instead of full builds

### "HTTP error 418" from magic-nix-cache
This is a transient GitHub API issue. The workflow will fall back to the official NixOS cache automatically.

### Build times out
GitHub Actions has a 6-hour limit per job and 72 hours per workflow. Large builds may need to be split into smaller jobs or moved to self-hosted runners.

## Contributing

When adding new workflows:
- Test locally with `act` if possible
- Consider disk space requirements
- Use evaluation instead of building when possible
- Add appropriate error handling
- Document any new workflows in this README