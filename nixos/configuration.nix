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


  # Garbage Collection
  nix.gc = {
    automatic = true;
    persistent = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
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
    windowManager = {
        i3 = {
            enable = true;
            extraPackages = with pkgs; [
                dmenu
            ];
        };
    };
  };
  
  # Autologin
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "kowalski";
  # Autologin bug workaround
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

 
  # GPU
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;

    extraPackages = with pkgs; [
        libGL
    ];
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


  # Virt + Networking
    environment.systemPackages = with pkgs; [
    cni
    cni-plugins
    containerd
    iptables
  ];

  virtualisation.docker.enable = true;
   virtualisation.docker.extraOptions = ''
    --insecure-registry 192.168.1.30:5000
  '';

  virtualisation.containerd.enable = true;

 environment.etc."cni/net.d/10-mynet.conflist".text = ''
 {
  "cniVersion": "1.0.0",
  "name": "mynet",
  "plugins": [
    {
      "type": "bridge",
      "bridge": "cni0",
      "isGateway": true,
      "ipMasq": true,
      "ipam": {
        "type": "host-local",
        "subnet": "10.22.0.0/16",
        "routes": [
          { "dst": "0.0.0.0/0" }
        ]
      }
    },
    {
      "type": "portmap",
      "capabilities": {
        "portMappings": true
      },
      "snat": true
    }
  ]
}

  '';

  ## Postgres dev
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;  # Choose the version of PostgreSQL
    ensureDatabases = [ "hosting" ];
    ensureUsers = [
     {
        name = "hosting";
        ensureDBOwnership = true;
      }
    ];
    initialScript = pkgs.writeText "setup.sql" ''
      ALTER USER hosting WITH PASSWORD 'password';
    '';
  };


  nix.settings.experimental-features = [ "nix-command" "flakes" ];

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

