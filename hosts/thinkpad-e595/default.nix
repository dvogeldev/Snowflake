{ pkgs, config, lib, ... }: {
  imports = [ ./hardware.nix ];

  modules = {
    shell = {
      default = "zsh";
      git.enable = true;
      gnupg.enable = true;
      android.enable = true;
    };
    networking = {
      networkManager.enable = true;
      # borsippaNET.enable = true;
    };
    services = { ssh.enable = true; };
    containers.transmission = {
      enable = false; # TODO: Once fixed -> enable = true;
      username = "alonzo";
      #  password = builtins.readFile config.age.secrets.torBylon.path;
    };
    develop = {
      dart.enable = true;
      haskell.enable = true;
      python.enable = true;
      rust.enable = true;
      scientific = {
        latex.enable = true;
        typst.enable = true;
      };
    };
    themes.active = "rose-pine";

    desktop = {
      qtile = {
        enable = true;
        backend = "wayland";
      };
      terminal = {
        default = "alacritty";
        alacritty.enable = true;
      };
      editors = {
        default = "nvim";
        neovim.agasaya.enable = true;
        emacs.irkalla.enable = true;
      };
      browsers = {
        default = "firefox";
        ungoogled.enable = true;
        firefox.enable = true;
      };
      education = {
        memory.enable = true;
        vidcom.enable = true;
      };
      toolset = {
        downloader.transmission.enable = true;
        # graphics = {
        #   raster.enable = true;
        #   vector.enable = true;
        # };
        player = {
          music.enable = true;
          video.enable = true;
        };
        social.base.enable = true;
        # docView.sioyek.enable = true;
        docView.zathura.enable = true;
      };
    };
  };

  # KDE-Connect + Start-up indicator
  programs.kdeconnect.enable = true;
  systemd.user.services.kdeconnect-indicator = {
    serviceConfig.ExecStart =
      "${pkgs.plasma5Packages.kdeconnect-kde}/bin/kdeconnect-indicator";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
  };
}
