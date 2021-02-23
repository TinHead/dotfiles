# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

  with lib;
  let
    nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
      export __NV_PRIME_RENDER_OFFLOAD=1
      export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
      export __GLX_VENDOR_LIBRARY_NAME=nvidia
      export __VK_LAYER_NV_optimus=NVIDIA_only
      exec -a "$0" "$@"
    '';
    pkgsUnstable = import <unstable> {};

  in

{

  nix.buildMachines = [ 
    {
    hostName = "ssh://darker.me:7722";
    sshUser = "razvan";
          sshKey = "/home/razvan/.ssh/id_rsa";
    system = "x86_64-linux";
    # if the builder supports building for multiple architectures, 
    # replace the previous line by, e.g.,
    systems = ["x86_64-linux" "aarch64-linux"];
    maxJobs = 6;
    speedFactor = 2;
    supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
    mandatoryFeatures = [ ];
    }
    {
      hostName = "ssh://vault";
      sshUser = "razvan";
      sshKey = "/home/razvan/.ssh/id_rsa";
      system = "x86_64-linux";
      # if the builder supports building for multiple architectures, 
      # replace the previous line by, e.g.,
      systems = ["x86_64-linux" "aarch64-linux"];
      maxJobs = 6;
      speedFactor = 2;
      supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      mandatoryFeatures = [ ];
    }
  ];

  nix.distributedBuilds = true;
	# optional, useful when the builder has a faster internet connection than yours
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ({options, lib, ...}: lib.mkIf (options ? virtualisation.memorySize) {
        users.users.razvan.password = "foo";
      })
       <home-manager/nixos>
    ];

  nix.package = pkgs.nixUnstable;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
   #  builders-use-substitutes = true
  '';
  
  nixpkgs.config = {
    pulseaudio = true;
    allowUnfree = true;
    xsession.preferStatusNotifierItems = true;
  };
  # Use the systemd-boot EFI boot loader.

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    supportedFilesystems = [ "ntfs" ];
    kernelModules = [ "kvm-intel" ];
    kernelPackages = pkgs.linuxPackages_latest;
    plymouth.enable = true;
    kernelParams = [ "quiet" ];
  };

  hardware = { 
    bluetooth.enable = true;
    openrazer.enable = true;
    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
    };
    video.hidpi.enable = true;
    nvidia.modesetting.enable = true;
    nvidia.prime.offload.enable = true;
    nvidia.prime = {
      # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
      intelBusId = "PCI:0:2:0";
      # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
      nvidiaBusId = "PCI:2:0:0";
    };
    sane = {
      enable = true;
      brscan4.enable = true;

      brscan4.netDevices = {
        livingRoom = { model = "DCP-T500W"; ip = "192.168.1.10"; };
      };
    };
  };

  powerManagement = {
    enable = true;
    powertop.enable = false;
  };
  
  virtualisation = { 
    docker.enable = true;
    libvirtd.enable = true;
  };

  sound.enable = true;

  networking = {
    hostName = "razernix";
    networkmanager.enable = true;
    useDHCP = false;
    interfaces.wlo1.useDHCP = true;
    firewall.enable = false;
  };
  environment.pathsToLink = [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw 

  services = { 
    tlp = {
      enable = true;
      # The following prevents the battery from charging fully to
      # preserve lifetime. Run `tlp fullcharge` to temporarily force
      # full charge.
      settings = {
        CPU_SCALING_GOVERNOR_ON_BAT="powersave";
        CPU_SCALING_GOVERNOR_ON_AC="powersave";

        # The following prevents the battery from charging fully to
        # preserve lifetime. Run `tlp fullcharge` to temporarily force
        # full charge.
        # https://linrunner.de/tlp/faq/battery.html#how-to-choose-good-battery-charge-thresholds
        START_CHARGE_THRESH_BAT0=40;
        STOP_CHARGE_THRESH_BAT0=80;

        # 100 being the maximum, limit the speed of my CPU to reduce
        # heat and increase battery usage:
        CPU_MAX_PERF_ON_AC=95;
        CPU_MAX_PERF_ON_BAT=75;
      };
    };
    printing = {
      enable = true;
      drivers = [ ];
    };
    xserver = {
      enable = true;
      layout = "us";
      xkbOptions = "eurosign:e";
      videoDrivers = [ "nvidia" ];
      libinput = { 
        enable = true;
        touchpad.disableWhileTyping = true;
      };
      displayManager.gdm.enable = true;
      displayManager.gdm.nvidiaWayland = true;
      desktopManager.gnome3.enable = true;
    };
    udev.packages = with pkgs; [ gnome3.gnome-settings-daemon openocd ];

    dbus = {
      enable = true;
      packages = [ pkgs.gnome3.dconf ];
    };
    gvfs.enable = true;
    gnome3.gnome-keyring.enable = true;
    upower.enable = true;
  };
  systemd.services.upower.enable = true;

  # Select internationalisation properties.
  i18n = {
     defaultLocale = "en_US.UTF-8";
     extraLocaleSettings = {
       LC_MESSAGES = "en_US.UTF-8";
       LC_TIME = "ro_RO.UTF-8";
       LC_NUMERIC = "ro_RO.UTF-8";
     };
  };

  # Set your time zone.
  time.timeZone = "Europe/Bucharest";
  
  environment.systemPackages = with pkgs; [
   git tlp powertop s-tui wget nvidia-offload brightnessctl
  ] ++ [ config.boot.kernelPackages.cpupower ];

  programs.ssh.startAgent = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = false; };
  programs.zsh.enable = true;
 

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.razvan = {
     isNormalUser = true;
     extraGroups = [ "video" "wheel" "libvirtd" "networkmanager" "plugdev" "docker" "uucp" "dialout" ]; # Enable ‘sudo’ for the user.
  };
  home-manager.users.razvan = {
      imports = [];
  programs.direnv.enable = true;
  programs.direnv.enableNixDirenvIntegration = true;
  xdg.enable = true;
  gtk = {
      enable = true;
      iconTheme = {
        name = "Adwaita-dark";
        package = pkgs.gnome3.adwaita-icon-theme;
      };
      theme = {
        name = "Zukitre-dark";
        package = pkgs.zuki-themes;
      };
    };
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      
      oh-my-zsh = {
        enable = true;
        theme = "gentoo";
        plugins = [ "git" "kubectl" ];
      };
      envExtra = "export NIX_PATH=$HOME/.nix-defexpr/channels\${NIX_PATH:+:}$NIX_PATH" ;
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
      programs.vscode = {
            enable = true;
            package = pkgs.vscode;    
            extensions = with pkgs.vscode-extensions; [
                # Nix language support
                bbenoist.Nix
                ms-vscode.cpptools
                ms-python.python
                redhat.vscode-yaml
                ms-vscode-remote.remote-ssh
                ms-azuretools.vscode-docker
                ms-kubernetes-tools.vscode-kubernetes-tools
            ] 
            ++  pkgs.vscode-utils.extensionsFromVscodeMarketplace [
                {
                  name = "better-toml";
                  publisher = "bungcip";
                  version = "0.3.2";
                  sha256 = "08lhzhrn6p0xwi0hcyp6lj9bvpfj87vr99klzsiy8ji7621dzql3";
                }
                {
                  name = "spellright";
                  publisher = "ban";
                  version = "3.0.56";
                  sha256 = "0y0plri6z7l49h4j4q071hn7khf9j9r9h3mhz0y96xd0na4f2k3v";
                }
                {
                  name = "language-hugo-vscode";
                  publisher = "budparr";
                  version = "1.3.0";
                  sha256 = "1xq5xnnigip1xk54yaa5cwyyj74b6jraka8sbi4sw5c88rdi602f";
                }
                {
                  name = "chef";
                  publisher = "chef-software";
                  version = "1.9.0";
                  sha256 = "1hl0wcxivdxx804ds8i8hfrz5im030h7y6qflnnacx6bl6xr5z91";
                }
                {
                  name = "gitlens";
                  publisher = "eamodio";
                  version = "11.2.1";
                  sha256 = "1ba72sr7mv9c0xzlqlxbv1x8p6jjvdjkkf7dn174v8b8345164v6";
                }
                {
                    name = "platformio-ide";
                    publisher = "platformio";
                    version = "2.2.1";
                    sha256 = "04rbcj0jc1m3xlmqlqj5p58w7wv1xqvkm7wjh97cbk03gr0vfqyx";
                }
                {
                    name = "vscode-direnv";
                    publisher = "Rubymaniac";
                    version = "0.0.2";
                    sha256 = "1gml41bc77qlydnvk1rkaiv95rwprzqgj895kxllqy4ps8ly6nsd";
                }
                {
                    name = "rust";
                    publisher = "rust-lang";
                    version = "0.7.8";
                    sha256 = "039ns854v1k4jb9xqknrjkj8lf62nfcpfn0716ancmjc4f0xlzb3";
                }
                {
                    name = "jenkins-jack";
                    publisher = "tabeyti";
                    version = "1.1.2";
                    sha256 = "18mjzvxlw7spjh7lxpq2bc6gjn4nrp11fka0lshbb91rsadm4v57";
                }
                {
                    name = "markdown-all-in-one";
                    publisher = "yzhang";
                    version = "3.4.0";
                    sha256 = "0ihfrsg2sc8d441a2lkc453zbw1jcpadmmkbkaf42x9b9cipd5qb";
                }
                {
                    name = "terraform";
                    publisher = "hashicorp";
                    version = "2.7.0";
                    sha256 = "0lpsng7rd88ppjybmypzw42czr6swwin5cyl78v36z3wjwqx26xp";
                }
            ];
    };
  nixpkgs.overlays = [
    (final: previous: {
      syncthing = pkgsUnstable.syncthing;
      chrome = pkgsUnstable.google-chrome;
      materialshell = pkgsUnstable.gnomeExtensions.material-shell;
    })
  ];
  services.syncthing.enable = true;

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
#    alacritty
    wirelesstools
#    polkit_gnome
    #feh
 
#    betterlockscreen
    libnotify
    pavucontrol
    #paprefs
    #pasystray
    pulsemixer
    #xclip
    dejavu_fontsEnv
    font-awesome
    material-design-icons
    networkmanagerapplet
    
    # gnome3 apps
    gnome3.eog    # image viewer
    gnome3.evince # pdf reader
  
    #simplescreenrecorder
    gimp
    transmission-remote-gtk
    libxkbcommon
    google-chrome
    solvespace
    #firefox
    barrier
    syncthing-tray
    dconf2nix
    #xfce.thunar
    mpv

    # desktop look & feel
    gnome3.gnome-tweak-tool
    arc-theme
    zuki-themes
    
    # extensions
    gnomeExtensions.appindicator
    #gnomeExtensions.dash-to-dock
    gnomeExtensions.clipboard-indicator
    #materialshell

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
    #freecad
    fstl

    # docker and kube
    kubectl
    docker-compose
    hugo
  ];
  # ] ++ (with pkgsUnstable; [
  #   gnomeExtensions.material-shell
  # ]);
}; 

  users.defaultUserShell = pkgs.zsh;
  system.stateVersion = "20.09"; # Did you read the comment?
}


