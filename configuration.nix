{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];
   
  
  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  services.xserver = {
  	enable = true;
  	windowManager.i3 = {
  		enable = true;
		extraPackages = with pkgs; [
			dmenu
		];
  	};
  };
  
  # Autologin
  services.displayManager = {
  	autoLogin.enable = true;
  	autoLogin.user = "kowalski";
  };

  # Enables touchpad
  services.libinput.enable = true;

  time.timeZone = "Europe/London";

  # Audio
  security.rtkit.enable = true;

  services.pipewire = {
  	enable = true;
	alsa.enable = true;
	alsa.support32Bit = true;
	pulse.enable = true;
	jack.enable = false;
  };

  # Bluetooth 
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

   users.users.kowalski = {
     isNormalUser = true;
     extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
     packages = with pkgs; [
       brave
       acpi
       neovim
       alacritty
       spotify
       discord
     ];
   };

   home-manager = {
   	extraSpecialArgs = { inherit inputs; };
	users = {
		"kowalski" = import ./home.nix;
	};
   };

  system.stateVersion = "24.05"; # DO NOT CHANGE
}

