{
  flake.modules.nixos.gnome =
    {
      config,
      pkgs,
      ...
    }:
    {
      nixpkgs.overlays = [
        (
          final: prev: with final; {
            gnomeExtensions = prev.gnomeExtensions // {
              forge = stdenv.mkDerivation rec {
                pname = "gnome-ext-forge";
                version = "unstable-2026-05-03";
                uuid = "forge@jmmaranan.com";

                src = fetchFromGitHub {
                  owner = "forge-ext";
                  repo = "forge";
                  rev = "0319a7125db1088556b159a69bbec77e111afca7";
                  hash = "sha256-IyjHjL1RqxZZZgMnRlmavnae3OqZvRT6aSwKouQRopc=";
                };

                nativeBuildInputs = [
                  glib
                  gettext
                ];

                dontConfigure = true;
                dontBuild = true;

                installPhase = ''
                  runHook preInstall
                  target="$out/share/gnome-shell/extensions/${uuid}"
                  install -d "$target"

                  # Compile gsettings schemas in-place, then copy the whole schemas
                  # directory (the compiled file lands beside the .xml inputs).
                  glib-compile-schemas schemas

                  # Stub the contributors file that the Makefile would generate from
                  # `git shortlog`. Empty list — prefs page renders without names.
                  install -d lib/prefs
                  cat > lib/prefs/metadata.js <<'EOF'
                  export const developers = Object.entries([].reduce((acc, x) => ({ ...acc, [x.email]: acc[x.email] ?? x.name }), {})).map(([email, name]) => name + ' <' + email + '>');
                  EOF

                  # Compile translation catalogs (best-effort — translations are
                  # nice-to-have, not load-blocking).
                  if [ -d po ]; then
                    for po in po/*.po; do
                      [ -e "$po" ] || continue
                      name=$(basename "$po" .po)
                      install -d "$target/locale/$name/LC_MESSAGES"
                      msgfmt -c "$po" -o "$target/locale/$name/LC_MESSAGES/forge.mo" || true
                    done
                  fi

                  # Copy the runtime files (mirrors the Makefile's `build` target).
                  cp metadata.json "$target/"
                  cp ./*.js "$target/"
                  cp ./*.css "$target/"
                  cp LICENSE "$target/"
                  cp -r resources "$target/"
                  cp -r schemas "$target/"
                  cp -r config "$target/"
                  cp -r lib "$target/"

                  runHook postInstall
                '';

                meta = with lib; {
                  description = "i3/sway-style tiling and window manager for GNOME Shell";
                  longDescription = ''
                    Forge provides tree-based tiling with vertical and horizontal split
                    containers similar to i3-wm and sway-wm, plus Vim-like keybindings
                    for navigating, swapping, and moving windows in the containers.
                    Works on both X11 and Wayland.
                  '';
                  homepage = "https://github.com/forge-ext/forge";
                  license = licenses.gpl3Plus;
                  platforms = platforms.linux;
                  maintainers = [ ];
                };
              };
            };
          }
        )
      ];
      services = {
        displayManager.gdm.enable = true;
        desktopManager.gnome.enable = true;
        gnome = {
          core-apps.enable = true;
          core-developer-tools.enable = true;
          games.enable = false;
        };
        xserver = {
          enable = true;
          xkb = {
            layout = "us";
            options = "numpad:mac"; # numpad always enters digits
          };
        };
      };

      home-manager.users.${config.host.user.name} = {
        dconf.settings = {
          "org/gnome/shell" = {
            favorite-apps = [
              "steam.desktop"
              "brave-browser.desktop"
              "signal-desktop.desktop"
              "kitty.desktop"
            ];
            disable-user-extensions = false;
            enabled-extensions = [
              "clipboard-indicator@tudmotu.com"
              "blur-my-shell@aunetx"
              "caffeine@patapon.info"
              "pip-on-top@rafostar.github.com"
              "forge@jmmaranan.com"
              "system-monitor@gnome-shell-extensions.gcampax.github.com"
            ];
          };

          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
            enable-hot-corners = false;
            clock-show-weekday = true;
            show-battery-percentage = true;
          };
          "org/gnome/desktop/privacy" = {
            report-technical-problems = "false";
          };
          "org/gnome/desktop/calendar" = {
            show-weekdate = true;
          };
          "org/gnome/desktop/background" = {
            color-shading-type = "solid";
            picture-options = "zoom";
            picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/blobs-l.svg";
            picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/blobs-d.svg";
            primary-color = "#241f31";
            secondary-color = "#000000";
          };
          "org/gnome/desktop/screensaver" = {
            color-shading-type = "solid";
            picture-options = "zoom";
            picture-uri = "file:///run-current-system/sw/share/backgrounds/gnome/blobs-l.svg";
            primary-color = "#241f31";
            secondary-color = "#000000";
          };
          "org/gnome/desktop/wm/preferences" = {
            action-right-click-titlebar = "toggle-maximize";
            action-middle-click-titlebar = "minimize";
            resize-with-right-button = true;
            mouse-button-modifier = "<super>";
            button-layout = ":minimize,close";
          };
          "org/gnome/desktop/wm/keybindings" = {
            # maximize = ["<super>up"]; # Floating
            # unmaximize = ["<super>down"];
            maximize = [ "@as []" ]; # Tiling
            unmaximize = [ "@as []" ];
            switch-input-source = [ "@as []" ];
            switch-input-source-backward = [ "@as []" ];
            switch-to-workspace-left = [ "<alt>left" ];
            switch-to-workspace-right = [ "<alt>right" ];
            switch-to-workspace-1 = [ "<super><alt>1" ];
            switch-to-workspace-2 = [ "<super><alt>2" ];
            switch-to-workspace-3 = [ "<super><alt>3" ];
            switch-to-workspace-4 = [ "<super><alt>4" ];
            switch-to-workspace-5 = [ "<super><alt>5" ];
            move-to-workspace-left = [ "<shift><alt>left" ];
            move-to-workspace-right = [ "<shift><alt>right" ];
            move-to-workspace-1 = [ "<shift><alt>1" ];
            move-to-workspace-2 = [ "<shift><alt>2" ];
            move-to-workspace-3 = [ "<shift><alt>3" ];
            move-to-workspace-4 = [ "<shift><alt>4" ];
            move-to-workspace-5 = [ "<shift><alt>5" ];
            move-to-monitor-left = [ "<super><alt>left" ];
            move-to-monitor-right = [ "<super><alt>right" ];
            close = [
              "<super>q"
              "<alt>f4"
            ];
            toggle-fullscreen = [ "<super>f" ];
          };

          "org/gnome/mutter" = {
            workspaces-only-on-primary = false;
            center-new-windows = true;
            edge-tiling = false; # Tiling
          };
          "org/gnome/mutter/keybindings" = {
            #toggle-tiled-left = ["<super>left"]; # Floating
            #toggle-tiled-right = ["<super>right"];
            toggle-tiled-left = [ "@as []" ]; # Tiling
            toggle-tiled-right = [ "@as []" ];
          };

          "org/gnome/settings-daemon/plugins/power" = {
            sleep-interactive-ac-type = "nothing";
          };
          "org/gnome/settings-daemon/plugins/media-keys" = {
            custom-keybindings = [
              "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
              "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
              "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
              "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
            ];
            search = [ "<super>space" ];
          };
          "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
            binding = "<super>return";
            command = "kitty";
            name = "open-terminal";
          };
          "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
            binding = "<super>t";
            command = "kitty nvim";
            name = "open-editor";
          };
          "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
            binding = "<super>e";
            command = "nautilus";
            name = "open-file-browser";
          };
          "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
            binding = "<super>b";
            command = "brave";
            name = "open-web-browser";
          };
          "org/gnome/shell/extensions/caffeine" = {
            enable-fullscreen = true;
            restore-state = true;
            show-indicator = true;
            show-notification = false;
          };
          "org/gnome/shell/extensions/blur-my-shell" = {
            brightness = 0.9;
          };
          "org/gnome/shell/extensions/blur-my-shell/panel" = {
            customize = true;
            sigma = 0;
          };
          "org/gnome/shell/extensions/blur-my-shell/overview" = {
            customize = true;
            sigma = 0;
          };
          "org/gnome/shell/extensions/pip-on-top" = {
            stick = true;
          };
          "org/gnome/shell/extensions/forge" = {
            window-gap-size = 8;
            dnd-center-layout = "swap";
          };
          "org/gnome/shell/extensions/forge/keybindings" = {
            # Set Manually
            focus-border-toggle = true;
            float-always-on-top-enabled = true;
            window-focus-up = [ "<super>up" ];
            window-focus-down = [ "<super>down" ];
            window-focus-left = [ "<super>left" ];
            window-focus-right = [ "<super>right" ];
            window-move-up = [ "<shift><super>up" ];
            window-move-down = [ "<shift><super>down" ];
            window-move-left = [ "<shift><super>left" ];
            window-move-right = [ "<shift><super>right" ];
            window-swap-last-active = [ "@as []" ];
            window-toggle-float = [ "<shift><super>f" ];
          };
        };

        home.packages = with pkgs.gnomeExtensions; [
          clipboard-indicator
          blur-my-shell
          caffeine
          forge
          pip-on-top
          system-monitor
        ];

        # xdg.desktopEntries.GDrive = {
        #   name = "GDrive";
        #   exec = "${pkgs.rclone}/bin/rclone mount --daemon gdrive: /GDrive --vfs-cache-mode=writes";
        # };
      };
    };
}
