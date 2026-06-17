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
- **`build-and-cache.yml`** - Builds all x86_64-linux NixOS and Home configurations on the self-hosted beehive runner and pushes closures to Cachix

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

2. **Package Caching Only** - Packages from `packages.x86_64-linux` are built and pushed to Cachix by the self-hosted `build-and-cache.yml` workflow's `build-packages` job, not full system configurations.

3. **Local Builds** - Full system builds happen on your local machines where disk space is not constrained.

## Self-Hosted Runner (beehive)

A self-hosted GitHub Actions runner is configured on `beehive` (the Beelink SER9 Pro home server). It automatically builds all x86_64-linux configurations on every push to `main` and pushes closures to Cachix.

- **Workflow:** `build-and-cache.yml`
- **Labels:** `self-hosted`, `nixos`, `x86_64-linux`
- **What it builds:**
  - All x86_64-linux NixOS configs (beehive, earth, hyperion, miranda, phoebe, tethys, titan)
  - All x86_64-linux Home configs (including VPS stable configs)
  - All flake packages

### NixOS-managed runner

The runner is managed declaratively via `modules/nixos/services/github-runner/` and enabled on beehive in `modules/hosts/beehive/_github-runner.nix`.

**Token setup:**
1. Generate a GitHub Personal Access Token (classic) with `repo` scope at https://github.com/settings/tokens
2. Add it to `secrets/sops/secrets.yaml` as `github-runner-token: <token>`
3. Run `just switch-host beehive` to activate
4. The runner auto-registers with GitHub on first start

### Manual runner setup (fallback)

If you need a runner on a different machine:
```bash
cd /opt
sudo mkdir actions-runner && cd actions-runner
sudo chown $USER:$USER .

curl -o actions-runner-linux-x64-2.311.0.tar.gz -L \
  https://github.com/actions/runner/releases/download/v2.311.0/actions-runner-linux-x64-2.311.0.tar.gz
tar xzf ./actions-runner-linux-x64-2.311.0.tar.gz

./config.sh --url https://github.com/keanuk/nix-config --token YOUR_TOKEN
sudo ./svc.sh install
sudo ./svc.sh start
```

## Cache Strategy

- **magic-nix-cache** is enabled on every workflow that runs Nix via `DeterminateSystems/magic-nix-cache-action@v14`. It uses the GitHub Actions built-in cache to share builds between workflow runs, costs nothing, and falls back to `https://cache.nixos.org` on rate-limit errors (`HTTP error 418`).
- The official NixOS cache at `https://cache.nixos.org` is always available as a fallback
- Cachix is used for custom packages to speed up local development

## Troubleshooting

### "No space left on device"
This means a build exceeded available disk space. Options:
1. Move the build to a self-hosted runner
2. Reduce the size of what's being built
3. Use evaluation-only checks instead of full builds

### "HTTP error 418" from magic-nix-cache
This is a transient GitHub API rate-limit issue. The caching daemon and Nix both handle this gracefully and won't cause your CI to fail. The workflow will fall back to the official NixOS cache automatically.

### Build times out
GitHub Actions has a 6-hour limit per job and 72 hours per workflow. Large builds may need to be split into smaller jobs or moved to self-hosted runners.

## Contributing

When adding new workflows:
- Test locally with `act` if possible
- Consider disk space requirements
- Use evaluation instead of building when possible
- Add appropriate error handling
- Document any new workflows in this README