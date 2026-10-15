{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager # TODO: Move to a seperate file
  ];

  nixpkgs.config.allowUnfree = true;

  nix = {
    settings.experimental-features = "nix-command flakes";
    channel.enable = false;
  };

  # BootLoader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.plymouth.enable = true;
  boot.plymouth.theme = "breeze";

  # Networking / Time synch
  time.timeZone = "Europe/Warsaw";
  networking.hostName = "Renoir";
  networking.networkmanager.enable = true;

  # Locale
  i18n.defaultLocale = "en_US.UTF-8";

  # Printing
  services.printing.enable = true;

  # Sound
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Hardware - Bluetooth
  hardware.keyboard.qmk.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  # For blueman manager
  services.blueman.enable = true;

  # Hardware - TouchPad
  services.libinput.enable = true;

  # WM
  services.gnome.gnome-keyring.enable = true;

  # Greeter
  services.greetd.enable = true;
  services.greetd.settings.default_session.command = "${pkgs.greetd.tuigreet}/bin/tuigreet";
  services.greetd.settings.default_session.user = "greeter";

  # Programs - TODO, commented out ones should be moved to user
  programs.firefox.enable = true;
  #programs.k3b.enable = true;
  #programs.kdeconnect.enable = true;
  services.flatpak.enable = true;
  #programs.steam.enable = true;
  programs.ccache.enable = true;
  nix.settings.extra-sandbox-paths = [ config.programs.ccache.cacheDir "/var/cache/ccache" ];

  # Compatibility
  services.envfs.enable = true;
  programs = {
    nix-ld = {
      enable = true;
        libraries = with pkgs; [
          stdenv.cc.cc.lib
          zlib
          libz
        ];
    };
  };

  # VMs
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "igor" ];
  virtualisation.virtualbox.host.enableExtensionPack = true;

  # CDs
  services.udev.extraRules = ''
    # Optical Drive access for K3b
    KERNEL=="sr[0-9]*", GROUP="cdrom", MODE="0660"
  '';

  # User
  users.users.igor = {
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" "cdrom" ];
  };

  # Home manager
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      # Import home-manager configuration
      igor = import ../home-manager/home.nix;
    };
  };

  # Idek anymore
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config = {
      sway = {
        default = [ "gtk" ];
        "org.freedesktop.impl.portal.Screencast" = [ "wlr" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
      };
    };
  };

  # Shell
  # Disable bash
  programs.bash.enable = false;

  # Enable zsh
  programs.zsh.enable = true;

  # Set zsh as default
  users.defaultUserShell = pkgs.zsh;
  environment.shells = [ pkgs.zsh ];

  # Fix CNF
  programs.command-not-found.enable = false;

  # Moved from /etc/nixos/config.nix
    environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    bintools
    dnsmasq
    spice-gtk
    tree
    python3
    qbittorrent
    (retroarch.withCores (cores: with cores; [
      genesis-plus-gx
      snes9x
      beetle-psx-hw
      swanstation
      pcsx2
    ]))
    pcsx2
    vesktop
    spotify
    obs-studio
    telegram-desktop
    filezilla
    wineWow64Packages.stable
    wineWow64Packages.staging
    winetricks
    ffmpeg
    bpm-tools
    mixxx
    media-downloader
    vlc
    qmk
    dos2unix
    gnumake
    prismlauncher
    p7zip
    okteta
    python314Packages.pyghidra
    unrar
    file
    gcc
    clang-tools
    cmakeCurses
    marksman
    ripgrep
    binwalk
    python314Packages.ninja
    gdb
    javaPackages.compiler.temurin-bin.jdk-25
    android-tools
    wl-clipboard # Copy/Paste functionality.
    mako # Notification utility.
    kdePackages.kate
    neovim
    killall
    libreoffice
];

  system.stateVersion = "25.11";
}
