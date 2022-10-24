{ config
, options
, lib
, pkgs
, ...
}:
with lib;
with lib.my;

let cfg = config.modules.desktop.toolset.social;
in {
  options.modules.desktop.toolset.social = {
    common.enable = mkBoolOpt true;
  };

  config = mkMerge [
    (mkIf cfg.common.enable {
      user.packages = with pkgs; [
        element-desktop
        unstable.discord
        signal-desktop
        tdesktop
      ];

      # TODO: discord (powercord) + declerative setup.
      # home.configFile = mkIf cfg.essential.enable {
      #   Powercord-related settings..
      # };
    })
  ];
}
