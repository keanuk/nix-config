# Authelia Setup

This module configures Authelia as an authentication layer for your services exposed through Cloudflare Tunnel.

## Required Secrets

You need to add the following secrets to your SOPS secrets file (`secrets/sops/secrets.yaml`):

### 1. Generate the secrets

Run these commands to generate the required secrets:

```bash
# JWT Secret (64+ characters recommended)
openssl rand -hex 64

# Session Secret (64+ characters recommended)
openssl rand -hex 64

# Storage Encryption Key (must be exactly 64 hex characters = 32 bytes)
openssl rand -hex 32
```

### 2. Create a user password hash

Authelia uses Argon2id for password hashing. Generate a hash using:

```bash
# Using authelia binary (if installed)
authelia crypto hash generate argon2 --password 'your_secure_password'

# Or using Docker
docker run --rm authelia/authelia:latest authelia crypto hash generate argon2 --password 'your_secure_password'
```

### 3. Create the users file content

The `authelia-users` secret should contain YAML content like this:

```yaml
users:
  admin:
    displayname: "Admin User"
    password: "$argon2id$v=19$m=65536,t=3,p=4$YOUR_HASH_HERE"
    email: admin@oranos.org
    groups:
      - admins
      - users
```

### 4. Add secrets to SOPS

Edit your secrets file:

```bash
sops secrets/sops/secrets.yaml
```

Add these entries:

```yaml
authelia-jwt-secret: <your-generated-jwt-secret>
authelia-session-secret: <your-generated-session-secret>
authelia-storage-encryption-key: <your-generated-storage-key>
authelia-users: |
  users:
    admin:
      displayname: "Admin User"
      password: "$argon2id$v=19$m=65536,t=3,p=4$YOUR_HASH_HERE"
      email: admin@oranos.org
      groups:
        - admins
        - users
```

## DNS Configuration

Add a DNS record for `auth.oranos.org` pointing to your Cloudflare Tunnel.

In Cloudflare Dashboard:
1. Go to your domain's DNS settings
2. Add CNAME records for each service:
   - Name: `auth` → Target: `c7967aa7-6b7a-4f93-bb49-7663fe2ab21b.cfargotunnel.com`
   - Name: `sonarr` → Target: `c7967aa7-6b7a-4f93-bb49-7663fe2ab21b.cfargotunnel.com`
   - Name: `radarr` → Target: `c7967aa7-6b7a-4f93-bb49-7663fe2ab21b.cfargotunnel.com`
   - Name: `lidarr` → Target: `c7967aa7-6b7a-4f93-bb49-7663fe2ab21b.cfargotunnel.com`
   - Name: `prowlarr` → Target: `c7967aa7-6b7a-4f93-bb49-7663fe2ab21b.cfargotunnel.com`
   - Name: `bazarr` → Target: `c7967aa7-6b7a-4f93-bb49-7663fe2ab21b.cfargotunnel.com`
   - Proxy status: Proxied (orange cloud) for all

## Access Control

The configuration enforces layered security:

- **Bypass (no auth required):**
  - `auth.oranos.org` - Authelia portal itself

- **Two-factor authentication required (sensitive services):**
  - `git.oranos.org` - Forgejo (source code, CI/CD)
  - `cloud.oranos.org` - Nextcloud (files, documents)
  - `home.oranos.org` - Home Assistant (smart home control)
  - `photos.oranos.org` - Immich (private photos)
  - `sonarr.oranos.org` - Sonarr (can download content)
  - `radarr.oranos.org` - Radarr (can download content)
  - `lidarr.oranos.org` - Lidarr (can download content)
  - `prowlarr.oranos.org` - Prowlarr (indexer management)
  - `bazarr.oranos.org` - Bazarr (subtitle downloads)

- **One-factor authentication required (media consumption):**
  - `oranos.org` - Dashy dashboard
  - `chat.oranos.org` - Open WebUI (AI chat)
  - `media.oranos.org` - Jellyfin (media streaming)
  - `audio.oranos.org` - Audiobookshelf (audiobooks)
  - `plex.oranos.org` - Plex (media streaming)

## Customization

### Adjusting Authentication Requirements

Two-factor authentication is enabled by default for sensitive services. To change a service to one-factor, edit `access_control.rules` in `default.nix`:

```nix
{
  domain = "photos.${baseDomain}";
  policy = "one_factor";  # Change from "two_factor"
}
```

### Adding Email Notifications

Replace the filesystem notifier with SMTP in `default.nix`:

```nix
notifier = {
  smtp = {
    host = "smtp.example.com";
    port = 587;
    username = "authelia@example.com";
    sender = "Authelia <authelia@example.com>";
    # Add authelia-smtp-password to your sops secrets
  };
};
```

And add the corresponding sops secret:

```nix
sops.secrets.authelia-smtp-password = {
  owner = autheliaUser;
  group = autheliaGroup;
  mode = "0400";
};
```

### Adding More Users

Edit the `authelia-users` secret in SOPS:

```yaml
authelia-users: |
  users:
    admin:
      displayname: "Admin User"
      password: "$argon2id$v=19$m=65536,t=3,p=4$HASH1"
      email: admin@oranos.me
      groups:
        - admins
        - users
    john:
      displayname: "John Doe"
      password: "$argon2id$v=19$m=65536,t=3,p=4$HASH2"
      email: john@oranos.org
      groups:
        - users
```

## Troubleshooting

### Check Authelia logs

```bash
journalctl -u authelia-main -f
```

### Check nginx logs

```bash
journalctl -u nginx -f
```

### Verify secrets are loaded

```bash
sudo cat /run/secrets/authelia-jwt-secret
```

### Common Issues

1. **401 errors**: Check that the auth_request location is correctly configured
2. **Redirect loops**: Ensure the auth domain itself has `policy = "bypass"`
3. **Session not persisting**: Verify cookies are set for the correct domain

## Port Reference

| Service | Internal Port | Authelia Proxy Port | Domain | Auth Level |
|---------|--------------|---------------------|--------|------------|
| Authelia | 9091 | 9092 | auth.oranos.org | bypass |
| Dashy | 8082 | 9094 | oranos.org | 1FA |
| Open WebUI | 11435 | 9095 | chat.oranos.org | 1FA |
| Immich | 2283 | 9096 | photos.oranos.org | 2FA |
| Jellyfin | 8096 | 9097 | media.oranos.org | 1FA |
| Audiobookshelf | 8000 | 9098 | audio.oranos.org | 1FA |
| Plex | 32400 | 9099 | plex.oranos.org | 1FA |
| Sonarr | 8989 | 9100 | sonarr.oranos.org | 2FA |
| Radarr | 7878 | 9101 | radarr.oranos.org | 2FA |
| Lidarr | 8686 | 9102 | lidarr.oranos.org | 2FA |
| Prowlarr | 9696 | 9103 | prowlarr.oranos.org | 2FA |
| Bazarr | 6767 | 9104 | bazarr.oranos.org | 2FA |
| Home Assistant | 8123 | 9105 | home.oranos.org | 2FA |
| GitLab | 8929 | 9106 | git.oranos.org | 2FA |
| Nextcloud | 80 | 9107 | cloud.oranos.org | 2FA |

## Setting Up Two-Factor Authentication

After first login, you'll need to set up TOTP for 2FA-protected services:

1. Log in to `https://auth.oranos.org` with your username and password
2. You'll be prompted to set up TOTP
3. Scan the QR code with an authenticator app (Google Authenticator, Authy, etc.)
4. Enter the 6-digit code to verify
5. Your 2FA is now configured for all services requiring it