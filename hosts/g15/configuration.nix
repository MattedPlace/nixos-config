{
  pkgs,
  config,
  lib,
  hostUsers,
  hostTypes,
  inputs,
  ...
}:
let
  vars = import ./variables.nix { };
in
{
  # Use laptop template and add Razer-specific modules
  imports = hostTypes.laptop.imports ++ [
    # Hardware-specific imports
    ./nixos/hardware-configuration.nix
    ./nixos/filesystem.nix
    ./nixos/screens.nix
    ./nixos/network.nix
    ./nixos/power.nix
    ./nixos/boot.nix
    ./nixos/nvidia.nix
    ../common/nixos/i18n.nix
    ../common/nixos/hosts.nix
    ../common/nixos/envvar.nix
    ../common/nixos/host-class.nix
    ../common/nixos/inotify-limits.nix
    ./nixos/laptop.nix
    ./themes/stylix.nix # Re-enabled after upstream cache fix

    # Razer-specific additional modules
    ../../modules/development/default.nix
    ../../modules/security/secrets.nix
    ../../modules/secrets/api-keys.nix
    ../../modules/containers/docker.nix
    ../../modules/services/meeting-transcribe.nix # meet CLI (client; offloads processing to p620)

    #plex
    #../../modules/services/plex-mcp.nix # Plex MCP server (HTTP transport, tailnet-only)
    #../../modules/services/kometa # Plex Meta Manager — collections, posters, metadata
    #../../modules/services/plex-auto-languages # Per-show audio/sub track memorization
  ];

  host.class = "laptop";

  # NOPASSWD sudo for wheel members on razer.
  # `just razer` runs `nixos-rebuild switch --target-host razer.lan --sudo
  # --no-reexec`, which invokes the post-switch activation via `sudo
  # systemd-run ... switch-to-configuration switch`. Without NOPASSWD the
  # remote sudo step fails with exit 4 ("did you forget --ask-sudo-password?")
  # — the system DOES activate fully (via the early non-sudo path), but
  # `just razer` returns non-zero noise. Single-user personal laptop:
  # acceptable trade-off for a clean idempotent deploy.
  security.sudo.wheelNeedsPassword = false;

  # Consolidated networking configuration
  networking = {
    # Set hostname from variables
    inherit (vars) hostName;

    # Choose networking profile: "desktop", "server", or "minimal"
    profile = "desktop";

    # Note: Tailscale is enabled via services.tailscale (built-in NixOS module)
    # Custom networking.tailscale module was removed during anti-pattern cleanup

    # Use NetworkManager for simple network management
    networkmanager = {
      enable = true;
      dns = "default"; # Use NetworkManager's built-in DNS
      # Configure settings using new structured format
      settings = {
        main = {
          dns = "default";
        };
        # Note: global DNS domain settings are not supported in structured format
        # Will use networking.nameservers for DNS configuration instead
      };
    };
    useNetworkd = false;

    # Set custom nameservers as fallback
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];

    # Firewall disabled to allow all network access including SSH
    firewall.enable = lib.mkForce false;
  };

  # Tailscale VPN using built-in NixOS service
  services.tailscale = {
    enable = false;
    # "none": do not accept subnet routes. razer is directly on 192.168.1.0/24,
    # and p510 advertises that same /24 as a subnet route. With accept-routes on,
    # razer's routing table 52 sent LAN-destined replies back through tailscale0,
    # causing asymmetric routing that broke TCP/ICMP to LAN peers (e.g. p620).
    # Note: flipping this flag in Nix does not rewrite tailscale's persisted
    # prefs; run `sudo tailscale set --accept-routes=false` once after switch.
    useRoutingFeatures = "none";
    openFirewall = false;
  };

  # Time sync. razer roams onto networks (e.g. corporate/guest WiFi) that
  # block public NTP on UDP 123, leaving the clock free-running and drifting.
  # timesyncd uses the public pool whenever the network allows NTP; the
  # httpTimeFallback below covers networks that block it.
  services.timesyncd = {
    enable = false;
    servers = [
      "0.pool.ntp.org"
      "1.pool.ntp.org"
      "2.pool.ntp.org"
    ];
  };

  # Fallback for networks that block NTP (UDP 123): when timesyncd has not
  # synchronised, htpdate sets the clock from HTTPS (443) — sampling several
  # servers with latency compensation. Only acts when NTP is unsynced, so it
  # never fights normal NTP discipline.
  services.httpTimeFallback.enable = false;

  # COSMIC Notifications NG - Disabled: removed from active config
  # services.cosmic-ext-notifications = {
  #   enable = true;
  #   settings.max_image_size = 32;
  # };

  # COSMIC BG - Disabled pending upstream fix for startup race condition
  # See: https://github.com/Maxwell/cosmic-ext-bg/issues/32
  # services.cosmic-ext-bg.enable = true;

  # Use AI provider defaults with laptop profile (disables Ollama for battery life)
  aiDefaults = {
    enable = false;
    profile = "laptop";
  };

  # AI analysis services removed - were non-functional and consuming resources
  # ai.analysis = {
  #   enable = false;  # Removed completely - provided no meaningful analysis
  #   aiProvider = "openai";
  # };

  # NVIDIA GeForce NOW cloud gaming (official Flatpak)
  modules.services.geforcenow = {
    enable = false;
    autoInstall = false;
  };

  # Enable XDG portal for GNOME screen sharing
  modules.services.xdg-portal = {
    enable = false;
    backend = "gnome";
    enableScreencast = true;
  };

  # Use the new features system instead of multiple lib.mkForce calls
  features = {
    development = {
      enable = true;
      cargo = false;
      copilot-cli = false; # GitHub Copilot CLI
      spec-kit = false; # GitHub spec-kit for Spec-Driven Development
      github = false;
      go = false;
      java = false;
      lua = false;
      nix = true;
      shell = false;
      devshell = false; # Temporarily disabled due to patch issue
      python = false;
      nodejs = false;
    };

    # Enable Claude Code hooks for desktop notifications
    claude-hooks = {
      enable = false;
      enablePermissionNotifications = false;
      enableReadyNotifications = false;
    };

    gnome-remote-desktop = {
      enable = false;
    };

    virtualization = {
      enable = false;
      docker = false;
      incus = false;
      podman = false;
      spice = false;
      libvirt = false;
      # Waydroid Android emulation (NVIDIA GPU - requires GBM disable)
      waydroid = {
        enable = false;
        disableGbm = true; # Required for NVIDIA hybrid graphics
        enableWaydroidHelper = false;
      };
    };

    cloud = {
      enable = false;
      aws = false;
      azure = false; # Temporarily disabled due to msgraph-core build failure
      google = false;
      k8s = false;
      terraform = false;
    };

    security = {
      enable = false;
      onepassword = false;
      gnupg = false;
    };

    networking = {
      enable = false;
    };

    # Syncthing for ~/.claude and ~/.gemini sync across hosts
    syncthing = {
      enable = false;
      syncClaude = false;
      syncGemini = false;
      masterHost = "p620";
    };

    ai = {
      enable = false;
      antigravity-cli = false;
      claude-desktop = false; # Enable Claude Desktop GUI with MCP server support

      # Enable MCP (Model Context Protocol) servers for AI integration
      mcp = {
        enable = false;
        obsidian = {
          enable = false;
          implementation = "rest-api";
          restApi.apiKeyFile = config.age.secrets."obsidian-api-key".path;
        };
        # Enable Atlassian MCP server for Jira and Confluence integration
        atlassian = {
          enable = false;
          mode = "cloud"; # Atlassian Cloud mode
          jira = {
            enable = false;
            url = "https://synecloud.atlassian.net";
            username = "olaf.krasicki-freund@calitii.com";
            tokenFile = config.age.secrets."api-jira-token".path;
          };
          confluence = {
            enable = false;
            url = "https://synecloud.atlassian.net/wiki";
            username = "olaf.krasicki-freund@calitii.com";
            tokenFile = config.age.secrets."api-confluence-token".path;
          };
        };
        # Enable LinkedIn MCP server for professional networking
        # NOTE: Disabled until secret is created (see docs/LINKEDIN-MCP.md)
        # To enable: ./scripts/manage-secrets.sh create api-linkedin-cookie
        linkedin = {
          enable = false; # TODO: Enable after creating secret
          cookieFile = config.age.secrets."api-linkedin-cookie".path;
        };
        # Enable WhatsApp MCP server for AI-assisted messaging
        whatsapp = {
          enable = false; # Disabled - not working
          enableVoiceMessages = false;
        };
        # Enable additional MCP servers
        servers = {
          browsermcp = false; # Browser automation with privacy
          terraform = false; # Infrastructure as Code support
        };
      };
    };

    programs = {
      lazygit = true;
      thunderbird = false;
      obsidian = false;
      office = false;
      webcam = false; # OBS Virtual Camera support
      print = true;
      yt-x.enable = true;
    };

    media = {
      droidcam = false; # Disabled - building custom solution
    };

    # COSMIC disabled — GNOME only until COSMIC is more production-ready.
    # Module + packages parked under modules/desktop/cosmic.nix and
    # pkgs/cosmic-applets/ for easy re-enable.
    desktop.cosmic.enable = false;

    # Microsoft Intune Company Portal (custom package with version control)
    intune = {
      enable = false; # Disabled - no longer needed
      autoStart = false; # Manual launch - start from application menu as needed
      enableDesktopIntegration = false;
    };
  };

  # Display manager: GDM (was previously delegated to cosmic-greeter by the
  # cosmic module; the unified DM module defaults to "none" without it).
  # NOTE: must live at top-level, NOT inside the features = {...} block above —
  # the option path is `desktop.displayManager`, not `features.desktop.displayManager`.
  # No autoLogin here — this is NVIDIA Optimus PRIME-sync hardware where any
  # greeter respawn after first boot ("Unable to run session" → GdmLocal-
  # DisplayFactory gives up after 8 retries → black screen) is broken.
  # Keeping the boot-time greeter alive is the only reliable local UX, so
  # autologin loops are off. Trade-off: cold-RDP needs a physical login
  # first (see comment on `gnome.gnome-remote-desktop` below). p510 enables
  # autoLogin because p510 is pure NVIDIA without PRIME — greeter respawn
  # works there; not here.
  # Login manager: DankMaterialShell greeter (greetd), matching p620. backend=
  # "none" turns GDM off; the dms-greeter module auto-enables greetd and runs the
  # greeter inside a niri (wlroots) compositor — which sidesteps GDM's broken
  # greeter-respawn on this Optimus PRIME-sync NVIDIA hardware (see note above),
  # same non-GDM path the old noctalia-greeter used. It enumerates the same
  # wayland-sessions, so GNOME + all niri/labwc/mango (stock + -dms) entries stay
  # selectable. noctalia-greeter input kept available for revert.
  desktop.displayManager.backend = "none";

  services.displayManager.dms-greeter = {
    enable = true;
    compositor.name = "niri";
  };

  # Phase 1: niri + labwc + mango as selectable login sessions (alongside GNOME).
  desktop.niri.enable = true;
  desktop.hyprland.enable = false;

  # Adds "(DankMaterialShell)" login sessions for niri/labwc/mango next to the
  # stock (Noctalia) ones — pick per login in the greeter.
  desktop.dmsShell.enable = true;

  # ddcutil: software brightness/contrast control of external monitors (DDC/CI).
  modules.hardware.ddcutil.enable = false;

  # GDM greeter visual baseline — dark colour scheme + 24h clock so it
  # doesn't render as a near-blank Adwaita-light surface over RDP.
  programs.dconf.profiles.gdm.databases = [
    {
      settings = {
        "org/gnome/desktop/interface" = {
          clock-format = "24h";
          color-scheme = "prefer-dark";
        };
      };
    }
  ];

  # Disable system-mode GRD on razer. The GDM-greeter spawn path it uses
  # (`gdm-wayland-session: Unable to run session`) is broken on this host's
  # NVIDIA Optimus PRIME-sync hardware — verified by side-by-side journal
  # comparison with p510 (pure NVIDIA), where the same path succeeds. With
  # system-mode off, port 3389 frees up and the user-mode GRD daemon
  # binds it instead. User-mode requires a live Maxwell session, so
  # the RDP flow is: physically log in once after each boot, then `razer:3389`
  # serves your desktop for the rest of that uptime.
  services.gnome.gnome-remote-desktop.enable = lib.mkForce false;
  systemd.services.grd-bootstrap.enable = lib.mkForce false;
  # The shared module unconditionally adds wantedBy=[graphical.target] to
  # gnome-remote-desktop.service; with the service body gone (line above),
  # that orphan wantedBy makes systemd reject the partial unit ("bad unit
  # file setting"). Clear it.
  systemd.services.gnome-remote-desktop.wantedBy = lib.mkForce [ ];

  # Citrix Workspace for client project remote access
  # Disabled — no longer needed. Module + overlay + package retained so this
  # can be flipped back to true without re-installing anything.
  services.citrix-workspace = {
    enable = false;
    acceptLicense = false;
  };

  # MCP screenshot server for Claude Desktop
  services.rescreenshot-mcp = {
    enable = false;
    user = vars.username;
    logLevel = "info";
    autoConfigureClaudeDesktop = false;
  };

  # Auto-sync Chrome PWA icons into the XDG hicolor tree (issue #397).
  # Chrome stores PWA PNG files inside its profile dir, which no launcher indexes;
  # this module symlinks them where COSMIC/GNOME can find them.
  modules.programs.chrome-pwa-icons = {
    enable = true;
    user = vars.username;
  };

  # Claude Code managed-settings.json — read-only baseline (issue #398).
  # PARR hook lives here (highest precedence, cannot be disabled by the
  # user via `claude` CLI). User-scope ~/.claude/settings.json remains
  # writable for plugin installs and runtime mutations.

  # /use-ollama, /use-claude, /use-default slash commands + apiKeyHelper
  # that auto-selects router (p620 over Tailscale) or Anthropic cloud key
  # based on ANTHROPIC_BASE_URL. Phase 3 of Ollama+LiteLLM design.

  # Enable encrypted API keys
  secrets.apiKeys = {
    enable = false;
    enableEnvironmentVariables = false;
    enableUserEnvironment = false;
  };

  # Nix build optimizations
  nix = {
    settings = {
      max-jobs = lib.mkDefault 16; # i7-10875H has 8 cores/16 threads
      cores = lib.mkDefault 16; # Use all threads
      auto-optimise-store = true;
    };
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
  };

  # Consolidated services configuration
  services = {

    # GNOME Remote Desktop configuration moved to features.gnome-remote-desktop

    secure-dns.enable = false;

    # X server and desktop environment
    xserver = {
      enable = true;
      displayManager.xserverArgs = [
        "-nolisten tcp"
        "-dpi 96"
      ];
    };

    # Desktop environments — COSMIC is the primary session; GNOME is also
    # available as a choice in the login greeter.
    desktopManager.gnome.enable = false;
  };

  # Don't restart greetd on rebuild — a switch shouldn't tear down the login
  # manager mid-session. Matters more here: this host's greeter-respawn is
  # fragile (see Optimus note above). New greeter applies at next reboot/logout.
  systemd.services.greetd.restartIfChanged = false;

  # Hardware and service specific configurations
  services = {
    playerctld.enable = false;
    fwupd.enable = false;
    # Quiet sshd preauth-reset spam from Odin's :22 liveness probes (p510).
    openssh.settings.LogLevel = "ERROR";
    nfs.server = lib.mkIf vars.services.nfs.enable {
      enable = false;
      inherit (vars.services.nfs) exports;
    };
  };

  # Docker configuration
  modules.containers.docker = {
    enable = false;
    users = hostUsers; # Use all users for this host
    rootless = false;
  };

  # Use DHCP-provided DNS servers
  # networking.nameservers = vars.nameservers; # Commented out to use DHCP

  # CRITICAL: DNS Resolution Fix for Tailscale
  # Network profile handles service ordering automatically

  # Use standard NetworkManager for laptop - useNetworkd already set above
  networking.useHostResolvConf = false;

  environment.sessionVariables = {
    NH_FLAKE = vars.paths.flakeDir;
  };

  # Enable secrets management
  modules.security.secrets = {
    enable = false;
    userKeys = [ "/home/${vars.username}/.ssh/id_ed25519" ];
  };

  users.users = lib.genAttrs hostUsers (username: {
    isNormalUser = true;
    description = "User ${username}";
    extraGroups = [
      "wheel"
      "networkmanager"
      "ydotool" # /run/ydotoold/socket access for the voice-input client
    ];
    shell = pkgs.zsh;
    # Only use secret-managed password if the secret exists
    hashedPasswordFile = lib.mkIf (
      config.modules.security.secrets.enable
      && builtins.hasAttr "user-password-${username}" config.age.secrets
    ) config.age.secrets."user-password-${username}".path;
  });

  # System packages - consolidated from individual nixos modules
  environment.systemPackages =
    with pkgs;
    [
      # Qt theme control tools for Stylix
      inputs.yt-x.packages.${pkgs.stdenv.hostPlatform.system}.default
      libsForQt5.qt5ct
      kdePackages.qt6ct
      # Custom packages
      # qwen-code disabled due to npm registry network errors (HTTP/2 framing layer issue)
      # (callPackage ../../home/development/qwen-code/default.nix { })
      nix-doc # Interactive Nix documentation tool

      # Power management (from power.nix)
      cpupower-gui # GUI for CPU frequency scaling
      powertop # Power consumption analyzer
      lm_sensors # Hardware monitoring
      s-tui # Terminal UI stress test and monitoring tool
      htop # Process viewer with power info
      acpi # Command line battery info

      # Login manager (from greetd.nix)
      tuigreet
    ]
    # Every DE registered via services.xserver.desktopManager.*.enable —
    # needed so their share/wayland-sessions/*.desktop files land in
    # /run/current-system/sw/share/wayland-sessions where COSMIC Greeter
    # (and other display managers) actually look for session choices.
    ++ config.services.displayManager.sessionPackages;

  #hardware.nvidia-container-toolkit.enable = vars.gpu == "nvidia";

  # Enable ZSA keyboard support (Moonlander, Planck EZ, etc.)
  hardware.keyboard.zsa.enable = false;

  # Windows app integration
  # programs.winboat.enable = true; # DISABLED: npm dependency error in nixpkgs (@electron/windows-sign)

  # Agenix identity configuration - specify where to find decryption keys
  age.identityPaths = [
    "/home/Maxwell/.ssh/id_ed25519" # User key
    "/etc/ssh/ssh_host_ed25519_key" # Host key (Ed25519)
    "/etc/ssh/ssh_host_rsa_key" # Host key (RSA fallback)
  ];

  # ydotoold — kernel-level keystroke injection daemon. Used by the
  # voice-input client to type transcripts on GNOME Wayland where wtype
  # fails (Mutter doesn't implement virtual_keyboard_v1).
  programs.ydotool.enable = false;
  # User group membership for /run/ydotoold/socket access is added in the
  # `users.users = lib.genAttrs hostUsers ...` block above.

  # Meeting transcribe — razer is client-only. Records the meeting locally,
  # then rsyncs the .opus over Tailscale to p620 and SSHes to run
  # meet-process there. The brief comes back as ~/meetings/TS.md.
  features.meetingTranscribe = {
    enable = false;
    processHost = "p620";
    installProcessor = false;
    userName = "Olaf";
    userEmail = "olaf@freundcloud.com";
  };

  nixpkgs.config = {
    allowBroken = true;
    permittedInsecurePackages = [
      "olm-3.2.16"
      "python3.12-youtube-dl-2021.12.17"
      "python3.13-youtube-dl-2021.12.17" # newsboat (RSS reader) pulls youtube-dl for URL extraction
      "libsoup-2.74.3" # Temporary: Required by some GNOME packages until migration to libsoup-3
      "electron-35.7.5" # Temporary: Required until upstream packages migrate to newer electron
      "electron-39.8.10" # Newly marked EOL after nixpkgs bump on 2026-06-01 — still pulled in by some upstream package, audit + drop later
      "electron-40.10.5" # Newly marked insecure after nixpkgs bump on 2026-07-15 — still pulled in by some upstream package, audit + drop later
    ];
  };
  system.stateVersion = "25.11";
}
