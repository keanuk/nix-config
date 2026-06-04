{
  # OLED panels (Lenovo X1 Carbon Gen 13 OLED, etc.) are susceptible to
  # burn-in from static UI chrome. Forces a dark color scheme, lowers the
  # screen-blank idle delay, and enables idle-dim via dconf so the panel
  # isn't asked to hold bright static UI for long stretches.
  flake.modules.nixos.oled = _: {
    environment.etc."dconf/db/local.d/01-oled-care".text = ''
      [org/gnome/desktop/interface]
      color-scheme='prefer-dark'
      gtk-theme='adw-gtk3-dark'
      icon-theme='Adwaita-dark'

      [org/gnome/desktop/session]
      # Blank the screen after 3 minutes of idle activity to protect pixels.
      idle-delay=uint32 180

      [org/gnome/settings-daemon/plugins/power]
      idle-dim=true
      ambient-enabled=true
    '';
  };
}
