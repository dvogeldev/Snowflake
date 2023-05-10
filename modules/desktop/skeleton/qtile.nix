{ inputs, options, config, lib, pkgs, ... }:

let
  inherit (lib.attrsets) attrValues optionalAttrs;
  inherit (lib.modules) mkIf;

  cfg = config.modules.desktop.qtile;
in {
  options.modules.desktop.qtile = let
    inherit (lib.options) mkEnableOption mkOption;
    inherit (lib.types) enum;
  in {
    enable = mkEnableOption "python x11/wayland WM";
    backend = mkOption {
      type = enum [ "x11" "wayland" ];
      default = "x11";
    };
  };

  config = mkIf cfg.enable {
    modules.desktop = {
      envProto = cfg.backend;
      toolset.fileBrowse = { nautilus.enable = true; };
      extensions = {
        fcitx5.enable = true;
        mimeApps.enable = true; # mimeApps -> default launch application
        picom.enable = mkIf (cfg.backend == "x11");
        dunst.enable = true;
        rofi.enable = true;
      };
    };
    modules.shell.scripts = {
      brightness.enable = true;
      microphone.enable = true;
      volume.enable = true;
      screenshot.enable = true;
    };
    modules.hardware.kmonad.enable = true;

    services.greetd.settings.initial_session = mkIf (cfg.backend == "wayland") {
      command = "none+qtile";
      user = "${config.user.name}";
    };

    environment.systemPackages = attrValues ({
      inherit (pkgs) libnotify playerctl gxmessage clipboard-jh;
    } // optionalAttrs (cfg.backend == "x11") { inherit (pkgs) xdotool feh; }
      // optionalAttrs (cfg.backend == "wayland") {
        inherit (pkgs) imv hyprpicker wf-recorder;
      });

    services.xserver = {
      displayManager.defaultSession = "none+qtile";
      windowManager.qtile = {
        enable = true;
        configFile = "${config.snowflake.configDir}/qtile/config.py";
        qtile.backend = cfg.backend;
        # extraPackages =
        # attrValues ({ inherit (pkgs.python3Packages) qtile-extras; });
      };
    };
  };
}
