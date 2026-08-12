{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./profile.nix
    ../../home/desktop/noctalia # Noctalia shell for niri/labwc sessions
  ];

  desktop.gnome.profile = "laptop";
  desktop.gnome.enable = false;

  # razer runs no Ollama of its own, but both Neovim AI plugins default to
  # http://localhost:11434 — so minuet-ai (which fires on every InsertEnter)
  # and codecompanion were silently failing here while working fine on p620.
  # Both already read this variable; it was simply never set. p620 serves
  # Ollama on 0.0.0.0:11434 and is reachable from razer over the LAN.

  # gscratch — i3/Sway-style scratchpad for GNOME (testing on razer first).
  # Configure bindings via: gnome-extensions prefs scratchpad@wastedintelligence.com
  programs.gnome-shell = {
    enable = false;
    extensions = [
      { package = inputs.gscratch.packages.${pkgs.system}.default; }
    ];
  };

  # gnome-quick-web-apps — GTK4 web-app manager (PWA install, scope
  # confinement, CEF rendering). Native GNOME alternative to
  # cosmic-utils/web-apps.
  home.packages = [
    inputs.gnome-quick-web-apps.packages.${pkgs.system}.default
  ];

  # Laptop: enable zellij (session management for mobile use)

  # Ghostty: profile.nix defaults this off ("workstation only"); razer wants
  # it too as the primary terminal alongside the existing wave/warp/foot/etc.
  features.terminals.ghostty = true;

  # Laptop: flameshot works fine on Razer (single-monitor Wayland)
  features.desktop.flameshot = true;

  # obsidian stays disabled — see #370 (electron-39 build broken upstream)

  # splashboard — terminal splash screen on shell startup + cd. Same as p620.

  # Windsurf theme derived from host variables (razer uses orange-desert variant)

  # Razer Chrome — GPU completely disabled for stability on Optimus hybrid
  programs.chromium = {
    commandLineArgs = lib.mkForce [
      "--enable-features=UseOzonePlatform"
      "--ozone-platform=wayland"
      "--disable-features=VizDisplayCompositor"
    ];
  };
}
