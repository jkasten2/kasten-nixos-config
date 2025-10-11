{ config, pkgs, lib, inputs, ... }:

{
   # Let Home Manager install and manage itself.
   programs.home-manager.enable = true;

   home.stateVersion = "25.11";

   home.username = "kasten";
   home.homeDirectory = "/home/kasten";

   programs.bash.enable = true;
   # A fuzzy search with Control+r
   programs.fzf = {
     enable = true;
     enableBashIntegration = true;
   };

   home.shellAliases = {
     "cd.." = "cd ..";
   };

   home.pointerCursor = {
     package = pkgs.adwaita-icon-theme;
     name = "Adwaita";
     size = 24;
   };

   programs.foot = {
     enable = true;
     settings = {
       main = {
         dpi-aware = "no";
         font = "monospace:size=11";
       };
       
       scrollback.lines = 10000;
       key-bindings = {
         scrollback-home = "Shift+Home";
         scrollback-end  = "Shift+End";
       };
       colors = {
         background = "000000";
       };
     };
   };

   wayland.windowManager.sway = {
     enable = true;
     wrapperFeatures.gtk = true;
     config = rec {
       modifier = "Mod4";
       keybindings =
         let
             modifier = config.wayland.windowManager.sway.config.modifier;
         # mkOptionDefault keeps defaults for all other keybindings
         in lib.mkOptionDefault {
           "${modifier}+control+l" = "exec swaylock";
           "${modifier}+d" = "exec walker";
         };

       output = {
         "*" = {
           scale = "2";
           allow_tearing = "yes";
           max_render_time = "off";
         };
         HDMI-A-1 = {
           mode = "3840x2160@120Hz";
           hdr = "on";
         };
       };

       input = {
         # disable mouse acceleration
         #   (enabled by default; to set it manually, use "adaptive" instead of "flat"
         "type:pointer" = { accel_profile = "flat"; };
       };

       fonts = {
         names = [ "Roboto" ];
         style = "Normal";
         size = 11.0;
       };

       bars = [{
         position = "top";
         statusCommand = "while date +'%Y-%m-%d %X'; do sleep 1; done";
         fonts = {
           names = [ "Roboto Mono" ];
           style = "Bold";
           size = 11.0;
         };
       }];
     };

     # Configs that don't have types yet in home-manager can go here
     extraConfig = ''
     '';
   };

   programs.swaylock.enable = true;
   services.mako.enable = true; # Lightweight notification UI
   services.blueman-applet.enable = true; # Enable bluetooth bar icon

   imports = [inputs.walker.homeManagerModules.default];
   programs.walker = {
     enable = true;
     # runAsService = true;
     config = {
       force_keyboard_focus = true;
       debug = false;
     };
   };

   programs.elephant = {
     installService = true;
   };

   systemd.user.services.elephant = {
     # https://github.com/abenz1267/elephant/issues/69
     Service.Environment = "PATH=/home/kasten/.nix-profile/bin/:/run/current-system/sw/bin/";
   };
}

