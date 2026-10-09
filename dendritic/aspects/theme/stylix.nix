{
  inputs,
  ...
}:

{
  flake.modules.nixos.theme =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      baseTheme = {
        # `scheme` is a display name only (cosmic-theme.nix stamps it into COSMIC's
        # theme file). `schemeFile` is what Stylix actually reads — a local base16
        # yaml rather than a name in pkgs.base16-schemes.
        scheme = "alien-hud";
        schemeFile = ../../../assets/alien-hud.yaml;
        cursor = {
          name = "Bibata-Modern-Classic";
          size = 16;
        };
        font = {
          mono = "Adwaita Mono";
          sans = "Noto Sans";
          serif = "Noto Serif";
          sizes = {
            applications = 11;
            terminal = 13;
            desktop = 12;
            popups = 12;
          };
        };
        opacity = {
          desktop = 1.0;
          terminal = 1.0; # No transparency - fixes COSMIC/GTK issues
          popups = 1.0; # No transparency
        };
      };
    in
    {
      imports = [
        inputs.stylix.nixosModules.stylix
      ];

      stylix = {
        enable = true;
        enableReleaseChecks = false;
        polarity = "dark";
        autoEnable = true;
        base16Scheme = baseTheme.schemeFile;

        fonts = {
          monospace = {
            # adwaita-fonts ships AdwaitaMono-{Regular,Bold,Italic,BoldItalic}.ttf.
            # gnome-themes-extra (used previously) ships zero font files — that
            # was a silent misconfiguration.
            package = pkgs.adwaita-fonts;
            name = baseTheme.font.mono;
          };
          sansSerif = {
            package = pkgs.noto-fonts;
            name = baseTheme.font.sans;
          };
          serif = {
            package = pkgs.noto-fonts;
            name = baseTheme.font.serif;
          };
          sizes = baseTheme.font.sizes;
        };

        opacity = baseTheme.opacity;

        cursor = {
          name = baseTheme.cursor.name;
          package = pkgs.bibata-cursors;
          size = baseTheme.cursor.size;
        };

        # Icons are artwork, not base16 colours, so no icon set tracks the
        # scheme automatically. Papirus is the closest fit available: it is
        # colour-neutral apart from its folders, and nixpkgs exposes a `color`
        # argument that runs papirus-folders over the build — "green" is the
        # stop nearest the HUD's phosphor accent (base0B). It replaces
        # the previous icon set, whose warm orange folders were the last
        # obviously off-palette surface left on the desktop.
        #
        # Driving the icon theme THROUGH Stylix (rather than fighting it) is what
        # stops Stylix clobbering the icon choice on every rebuild. Note the
        # modern `stylix.icons` namespace; the old `stylix.iconTheme` is
        # deprecated and emits a warning.
        #
        # Stylix installs this package itself — do NOT also add
        # pkgs.papirus-icon-theme to home.packages, or the plain and
        # green-foldered builds collide on the same share/icons/Papirus* paths.
        icons = {
          enable = true;
          package = pkgs.papirus-icon-theme.override { color = "green"; };
          dark = "Papirus-Dark";
          light = "Papirus-Light";
        };

        targets = {
          chromium.enable = false;

          # kmscon: stylix's kmscon target still sets the removed-in-nixpkgs-50
          # `services.kmscon.fonts` option, which now fails the build. We don't
          # theme the Linux text console anyway (Wayland sessions are what
          # matters here), so disable the target until upstream stylix updates.
          kmscon.enable = false;

          # regreet: stylix's regreet target still writes `programs.regreet.*`,
          # renamed in nixpkgs to `services.displayManager.regreet`, so every
          # eval prints 8 rename warnings (one per option it sets). The target
          # auto-enables on all Linux hosts, but this fleet greets with SDDM /
          # cosmic-greeter and never uses regreet. Disable until upstream
          # stylix migrates to the new option path.
          regreet.enable = false;

          # COSMIC's GTK theme sync is disabled on this fleet, so cosmic-comp
          # does NOT clobber ~/.config/gtk-{3,4}.0/gtk.css at runtime. Stylix
          # can own that file safely and theme GTK3 / non-libadwaita GTK4 apps
          # everywhere. libadwaita apps still ignore third-party themes by
          # upstream policy regardless of gtk.css contents.
          gtk.enable = true;

          # GNOME target writes org.gnome.desktop.interface/* via gsettings and
          # ships a generated GTK theme package. COSMIC stores its own theme in
          # ~/.config/cosmic/com.system76.CosmicTheme.* and ignores these
          # gsettings keys, so the two desktops stay isolated.
          gnome.enable = false;

          qt = {
            enable = true;
            platform = lib.mkForce "qtct";
          };

          # Off because it costs a cache miss for no visible gain. The target's
          # only effect is a postFixup that copies one base16 .xml into
          # $out/share/gtksourceview-4/styles/stylix.xml -- which changes
          # gtksourceview4's derivation hash, so it can no longer substitute from
          # cache.nixos.org and every host compiles it locally. That build then
          # fails: its test-buffer test aborts with SIGABRT under the sandbox
          # (22 of 23 pass), taking virt-manager and system-path down with it.
          #
          # What is given up is base16 syntax-highlighting colours inside the few
          # GtkSourceView apps here (virt-manager's XML editor, gedit). The app
          # chrome around them is still themed through the gtk target above.
          gtksourceview.enable = false;
        };
      };
    };
}
