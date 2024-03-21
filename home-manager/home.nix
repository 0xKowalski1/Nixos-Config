{ pkgs, lib, config, ... }:


let
   gitPath = "${pkgs.git}/bin";
   sshPath = "${pkgs.openssh}/bin";   
   
   cloneNvimConfig = pkgs.writeShellScript "cloneNvimConfig" ''
    export PATH=${gitPath}:${sshPath}:$PATH 
    if [ ! -d /home/kowalski/Nvim-Config ]; then
      git clone git@github.com:0xKowalski1/Nvim-Config.git /home/kowalski/Nvim-Config
    fi
  '';

    alacrittyConfig = pkgs.writeText "alacritty.yml" ''
    font:
      normal:
        family: 'FiraCode Nerd Font Mono'
        style: Regular
      size: 12.0
  '';
in {
  programs.home-manager.enable = true;

  home.username = "kowalski";
  home.homeDirectory = "/home/kowalski";


  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
             "discord"
  ];
  
  nixpkgs.config.allowUnfree = true;

  home.packages =  with pkgs; [
	brave
	htop
	discord
	spotify
	steam
	desktop-file-utils
	ripgrep
        alacritty
        gnome.dconf-editor
        xclip
        nodejs
        slither-analyzer
        solc-select
        nodePackages.vercel
        gnome.gnome-tweaks
        gnomeExtensions.gtile
        python3
        evince
        mdcat
  ];


  home.file.".config/alacritty/alacritty.yml".source = alacrittyConfig;

  
  home.activation.cloneNvimConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    ${cloneNvimConfig}
  '';

  programs.neovim = {
    enable = true;
    plugins = [ pkgs.vimPlugins.packer-nvim ];
    extraConfig = ''
      set runtimepath^=~/Nvim-Config
      luafile ~/Nvim-Config/init.lua
    '';
  };


  programs.git = {
    enable = true;
    userName = "0xkowalski1";
    userEmail = "0xkowalskiaudit@gmail.com";
  };

  programs.ssh = {
   enable = true;
  };

  dconf.settings = {
      "org/gnome/shell" = {
            favorite-apps = ["discord.desktop" 
            "spotify.desktop"
            "brave-browser.desktop"
            "Alacritty.desktop"];
          };
     "org/gnome/shell/extensions/hidetopbar" = {
        enable-active-window = false;
        enable-intellihide = false; 
      };
      "org/gnome/desktop/interface" = {
        clock-show-seconds = false;
        clock-show-weekday = false;
        color-scheme = "prefer-dark";
        enable-hot-corners = false;
        font-antialiasing = "grayscale";
        font-hinting = "slight";
        gtk-theme = "Nordic";
        toolkit-accessibility = false;
      };

      "org/gnome/desktop/wm/keybindings" = {
          toggle-fullscreen = ["f11"];
      };

      "org/gnome/desktop/session" = {
          idle-delay = 0;
      };

      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        ];
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        name = "Open Terminal";
        command = "alacritty";
        binding = "<Ctrl><Alt>t";
      };
  };
 
  # DONT CHANGE
  home.stateVersion = "23.11";
}

