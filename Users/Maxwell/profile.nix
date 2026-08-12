{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkDefault optionals;
  gnomeProfile = config.desktop.gnome.profile;
in
{
  imports = [
    ../common/default.nix
    ../../home/default.nix
    ../../home/games/steam.nix
    ../../home/media/reddit.nix
    ./private.nix
  ];

  # Terminal app desktop entries
  programs.neovim.desktopEntry.enable = lib.mkForce true;

  # GNOME desktop environment.
  # desktop.gnome.profile is declared in home/desktop/gnome/host-profile.nix
  # (imported transitively via home/desktop/gnome/default.nix).
  # Per-host stubs set the profile value; this file reads it to gate
  # profile-conditional extension picks.
  desktop.gnome = {
    enable = false;
    theme = {
      enable = true;
      variant = "dark";
    };
    extensions = {
      enable = true;
      # Shared extensions live in home/desktop/gnome/extensions.nix.
      # Only profile-specific additions go here.
      packages =
        with pkgs.gnomeExtensions;
        optionals (gnomeProfile == "laptop") [
          battery-health-charging
        ];
    };
    apps = {
      enable = true;
      packages = with pkgs; [
        gnome-tweaks
        dconf-editor
      ];
    };
    keybindings.enable = true;
  };

  features = {
    terminals = {
      enable = true;
      alacritty = false;
      foot = false;
      wezterm = false;
      # kitty/ghostty: workstation (p620) only — defaults off; stub overrides
      kitty = mkDefault false;
      ghostty = mkDefault false;
      warp = false;
      wave = false;
    };

    editors = {
      enable = true;
      cursor = false;
      neovim = true;
      vscode = false;
      windsurf = false;
      zed = false;
    };

    browsers = {
      enable = true;
      chrome = false;
      firefox = true;
      edge = false;
      brave = true;
      opera = false;
    };

    desktop = {
      enable = true;
      zathura = true;
      # obsidian: p620 enables; razer keeps off (#370 electron-39 breakage)
      obsidian = mkDefault false;
      # flameshot: razer enables; p620 keeps off (Wayland multi-monitor issues)
      flameshot = mkDefault false;
      waylandScreenshots = mkDefault false;
      kooha = false;
      remotedesktop = false;
      obs = true;
      evince = true;
      kdeconnect = false;
      slack = false;
    };

    cli = {
      enable = true;
      bat = true;
      direnv = true;
      fzf = true;
      lf = true;
      starship = true;
      yazi = true;
      zoxide = true;
      gh = true;
      markdown = true;
    };

    multiplexers = {
      enable = false;
      tmux = false;
      # zellij: razer enables it; p620 does not
      zellij = mkDefault false;
    };

    gaming = {
      enable = true;
      steam = true;
    };

    development = {
      enable = false;
      languages = false;
      workflow = false;
      productivity = false;
    };
  };

  # GitLab: runner disabled by default (battery savings on laptop).
  # p620 stub overrides runner.enable = true.
  development.gitlab = {
    enable = false;
    runner.enable = mkDefault false;
    fluxcd.enable = false;
    ciLocal.enable = false;
  };

  # Proton applications suite (identical across interactive hosts)

  # Packages common to all interactive (non-headless) hosts
  home.packages = [
    # Antigravity IDE 2.0.1 — Google's rebranded Antigravity Desktop.
    # Local derivation in pkgs/antigravity-ide/. See pkgs/default.nix
    # for the rationale (upstream antigravity-nix is still on 1.x).
    # glab-tui — terminal UI for GitLab on top of the `glab` CLI.
    # herdr — TUI "agent multiplexer": run multiple AI coding agents in one
    # terminal workspace (tmux/zellij-style). From github:ogulcancelik/herdr.
    # FlyCrys — GTK4-native Claude Code GUI. Wraps the local `claude`
    # binary (installed via programs.claude-code.enable in home/default.nix).

    # Google Antigravity Python SDK — Python env with `google.antigravity`
    # importable for building Gemini-powered AI agents. See
    # pkgs/google-antigravity-py/ for the platform-wheel install.
  ];

  # Windsurf LSP/formatter packages (identical across interactive hosts)
  editor.windsurf.extraPackages = with pkgs; [
    nixpkgs-fmt
    nil
  ];

  # Firefox (identical across interactive hosts)
  programs.firefox = {
    enable = true;
    profiles.default = {
      settings = {
        "widget.use-xdg-desktop-portal.file-picker" = 1;
        "media.ffmpeg.vaapi.enabled" = true;
      };
    };
  };
}
