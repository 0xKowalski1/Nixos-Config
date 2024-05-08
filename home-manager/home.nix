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

  primaryMonitor = "HDMI-1-0";
  secondaryMonitor = "HDMI2";
  mod = "Mod4";
  terminal = "alacritty";
  ws1 = "1: Browser";
  ws2 = "2";
  ws3 = "3";
  ws4 = "4";
  ws5 = "5";
  ws6 = "6: Main";
  ws7 = "7";
  ws8 = "8";
  ws9 = "9";
  ws0 = "0";
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
      
      extraConfig = ''
        exec --no-startup-id xrandr --output ${primaryMonitor} --primary --auto --output ${secondaryMonitor} --left-of ${primaryMonitor} --auto

        exec --no-startup-id i3-msg 'workspace ${ws1}; exec brave'
        exec --no-startup-id i3-msg 'workspace ${ws6}; exec alacritty'
      ''; 

      config = {
        terminal=terminal;
        
        modifier = mod;
         
        defaultWorkspace = "${ws1}";

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
"${mod}+1" = "workspace ${ws1}; move workspace to output ${secondaryMonitor}";
"${mod}+2" = "workspace ${ws2}; move workspace to output ${secondaryMonitor}";
"${mod}+3" = "workspace ${ws3}; move workspace to output ${secondaryMonitor}";
"${mod}+4" = "workspace ${ws4}; move workspace to output ${secondaryMonitor}";
"${mod}+5" = "workspace ${ws5}; move workspace to output ${secondaryMonitor}";
"${mod}+6" = "workspace ${ws6}; move workspace to output ${primaryMonitor}";
"${mod}+7" = "workspace ${ws7}; move workspace to output ${primaryMonitor}";
"${mod}+8" = "workspace ${ws8}; move workspace to output ${primaryMonitor}";
"${mod}+9" = "workspace ${ws9}; move workspace to output ${primaryMonitor}";
"${mod}+0" = "workspace ${ws0}; move workspace to output ${primaryMonitor}";

"${mod}+Shift+1" = "move container to workspace ${ws1}; workspace ${ws1}; move workspace to output ${secondaryMonitor}";
"${mod}+Shift+2" = "move container to workspace ${ws2}; workspace ${ws2}; move workspace to output ${secondaryMonitor}";
"${mod}+Shift+3" = "move container to workspace ${ws3}; workspace ${ws3}; move workspace to output ${secondaryMonitor}";
"${mod}+Shift+4" = "move container to workspace ${ws4}; workspace ${ws4}; move workspace to output ${secondaryMonitor}";
"${mod}+Shift+5" = "move container to workspace ${ws5}; workspace ${ws5}; move workspace to output ${secondaryMonitor}";
"${mod}+Shift+6" = "move container to workspace ${ws6}; workspace ${ws6}; move workspace to output ${primaryMonitor}";
"${mod}+Shift+7" = "move container to workspace ${ws7}; workspace ${ws7}; move workspace to output ${primaryMonitor}";
"${mod}+Shift+8" = "move container to workspace ${ws8}; workspace ${ws8}; move workspace to output ${primaryMonitor}";
"${mod}+Shift+9" = "move container to workspace ${ws9}; workspace ${ws9}; move workspace to output ${primaryMonitor}";
"${mod}+Shift+0" = "move container to workspace ${ws0}; workspace ${ws0}; move workspace to output ${primaryMonitor}";


        };
      }; 
  };


 
  # DONT CHANGE
  home.stateVersion = "23.11";
}

