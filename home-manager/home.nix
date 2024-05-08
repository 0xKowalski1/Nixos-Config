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
  extraNodePackages = import ~/nixConfig/node-packages/default.nix {}; 

  mod = "Mod4";
  terminal = "alacritty";
in {
  programs.home-manager.enable = true;

  home.username = "kowalski";
  home.homeDirectory = "/home/kowalski";


  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
             "discord"
  ];
  
  nixpkgs.config.allowUnfree = true;

  programs.java = {
  enable = true;
  package = pkgs.openjdk21; # for minecraft
};

  home.packages =  with pkgs; [
    docker
	brave
	htop
	discord
	spotify
	desktop-file-utils
	ripgrep
        alacritty # Terminal
        gnome.dconf-editor
        xclip # Clipboard
        nodejs
        slither-analyzer
        solc-select
        nodePackages.vercel
        gnome.gnome-tweaks
        gnomeExtensions.gtile
        python3
        mdcat # Markdown cat
        feh # Image viewer
        cloc # Sloc calculator
        qemu # VM utils
        go
        gopls # Go language server
        etcd
        air # Go live dev server

        # PDF Stuff
        chromium # Turn html to pdf
        evince # Pdf viewer
        pandoc 
        texliveFull

        prismlauncher # minecraft

        # Node Packages
        extraNodePackages.solidity-ls
        extraNodePackages.typescript
        extraNodePackages.typescript-language-server
        extraNodePackages.pyright
        extraNodePackages.vscode-langservers-extracted
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
   extraConfig = ''
      Host localhost
        HostName localhost
        Port 2222
        StrictHostKeyChecking no
        UserKnownHostsFile /dev/null
        LogLevel ERROR
    Host localhost
        HostName localhost
        Port 2223
        StrictHostKeyChecking no
        UserKnownHostsFile /dev/null
        LogLevel ERROR
    '';
  };

  # I3
  xsession.windowManager.i3 = {
      enable = true;
      config = {
        terminal=terminal;
        
        modifier = mod;

        keybindings = {
            # Basic Window Management
            "${mod}+Return" = "exec ${terminal}";
            "${mod}+space" = "exec dmenu_run";
            "${mod}+Escape" = "kill";

            # Change Focus Between Windows
            "${mod}+Left" = "focus left";
            "${mod}+Right" = "focus right";
            "${mod}+Up" = "focus up";
            "${mod}+Down" = "focus down";

            # Move Windows
            "${mod}+Shift+Left" = "move left";
            "${mod}+Shift+Right" = "move right";
            "${mod}+Shift+Up" = "move up";
            "${mod}+Shift+Down" = "move down";
            
            "${mod}+h" = "split h";
            "${mod}+v" = "split v";

            "${mod}+F11" = "fullscreen toggle";

            "${mod}+r" = "restart";

            # Workspaces
            "${mod}+1" = "workspace 1";
            "${mod}+2" = "workspace 2";
            "${mod}+3" = "workspace 3";
            "${mod}+4" = "workspace 4";
            "${mod}+5" = "workspace 5";
            "${mod}+6" = "workspace 6";
            "${mod}+7" = "workspace 7";
            "${mod}+8" = "workspace 8";
            "${mod}+9" = "workspace 9";
            "${mod}+0" = "workspace 0";

            "${mod}+Shift+1" = "move container to workspace 1";
            "${mod}+Shift+2" = "move container to workspace 2";
            "${mod}+Shift+3" = "move container to workspace 3";
            "${mod}+Shift+4" = "move container to workspace 4";
            "${mod}+Shift+5" = "move container to workspace 5";
            "${mod}+Shift+6" = "move container to workspace 6";
            "${mod}+Shift+7" = "move container to workspace 7";
            "${mod}+Shift+8" = "move container to workspace 8";
            "${mod}+Shift+9" = "move container to workspace 9";
            "${mod}+Shift+0" = "move container to workspace 0";
        };
      }; 
  };


 
  # DONT CHANGE
  home.stateVersion = "23.11";
}

