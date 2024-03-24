{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      <home-manager/nixos>
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  #  useXkbConfig = true; # use xkb.options in tty.
  };


  fonts.packages = with pkgs; [
  	(nerdfonts.override { fonts = [ "FiraCode"  ]; })
  ];

  # Enable the X11 windowing system.  
  services.xserver = {
    enable = true;
    # Disable mouse acceleration
    displayManager.sessionCommands = lib.mkBefore ''
      xinput --set-prop "Virtual Core Pointer" "libinput Accel Profile Enabled" 0, 1
      xinput --set-prop "Virtual Core Pointer" "libinput Accel Speed" -1
    '';
  };
  
  # Gnome
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Autologin
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "kowalski";
  # Autologin bug workaround
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Bin off all the gnome bloat
  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
  ]) ++ (with pkgs.gnome; [
    cheese # webcam tool
    gnome-music
    gedit # text editor
    epiphany # web browser
    geary # email reader
    evince # document viewer
    gnome-characters
    totem # video player
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
    gnome-weather
    gnome-calendar
    gnome-contacts
    gnome-maps
    simple-scan
    yelp
    gnome-clocks
  ]);

  # GPU
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  nixpkgs.config.allowUnfree = true;

  hardware.nvidia = {
    modesetting.enable = true;

    powerManagement.enable = false;

    powerManagement.finegrained = false;

    open = false;

    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable sound.
  sound.enable = true;

  # Allow Docker
  virtualisation.docker.enable = true;

  users.users.kowalski = {
    isNormalUser = true;
    extraGroups = [ 
    	"wheel" # Sudo
	"docker" 
	]; 
    packages = with pkgs; [
    ];
  };

# DO NOT CHANGE
  system.stateVersion = "23.11";
}

