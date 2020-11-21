{ config, pkgs, stdenv, lib, ... }:

{
  programs.home-manager.enable = true;
  programs.direnv.enable = true;
  programs.direnv.enableNixDirenvIntegration = true;

  imports = [ 
    ./dconf.nix
    ./vscode.nix
    ./custom_pkg.nix
  ];

  # zsh shell
  programs.zsh = {
      enable = true;
      enableCompletion = true;
      
      oh-my-zsh = {
        enable = true;
        theme = "gentoo";
        plugins = [ "git" "kubectl" ];
      };
      plugins = [ 
          {
            name = "zsh-nix-shell";
            file = "nix-shell.plugin.zsh";
            src = pkgs.fetchFromGitHub {
              owner = "chisui";
              repo = "zsh-nix-shell";
              rev = "v0.1.0";
              sha256 = "0snhch9hfy83d4amkyxx33izvkhbwmindy0zjjk28hih1a9l2jmx";
            };
          }
      ];
  };

  home.packages = with pkgs; [
    # shell stuff
    htop
    bat
    mtr
    git
    ntfs3g
    mc
    hunspellDicts.en-us-large
    vault
    lazydocker
    k9s
    
    # gnome3 apps
    gnome3.eog    # image viewer
    gnome3.evince # pdf reader
    simplescreenrecorder
    gimp
    transmission-remote-gtk
    google-chrome
    barrier
    syncthing-tray
    dconf2nix

    # desktop look & feel
    gnome3.gnome-tweak-tool
    arc-theme
    zuki-themes
    
    # extensions
    gnomeExtensions.appindicator
    gnomeExtensions.dash-to-dock
    gnomeExtensions.clipboard-indicator

    # chat and conf
    discord
    slack
    bluejeans-gui

    # embedded stuff
    platformio
    minicom

    # prusa
    prusa-slicer

    # 3d stuff
    freecad
    fstl

    # docker and kube
    kubectl
    docker-compose
    hugo

  ];
}
