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
  ];

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

  
  # DONT CHANGE
  home.stateVersion = "23.11";
}

