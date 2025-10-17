{ config, pkgs, lib, inputs, ... }:

{
   # Let Home Manager install and manage itself.
   programs.home-manager.enable = true;

   home.stateVersion = "25.11";

   imports = [
     inputs.walker.homeManagerModules.default
     inputs.nixvim.homeModules.nixvim
   ];


   home.username = "kasten";
   home.homeDirectory = "/home/kasten";

   programs.bash.enable = true;
   # A fuzzy search with Control+r
   programs.fzf = {
     enable = true;
     enableBashIntegration = true;
   };

   home.packages = with pkgs; [
     # disk space finders
     dust
     ncdu

     # Better find and grep commands
     fd
     ripgrep

     tldr # shorter man pages

     eza # Better ls command

     pasystray
   ];

  # Sound tray applet for volume control
  services.pasystray.enable = true;
  # Requires the following in configuration.nix
  # services.avahi.enable = true;

   home.shellAliases = {
     "cd.." = "cd ..";
     "ll" = "eza -lah";
   };


   programs.vim = {
     enable = true;
   };

   programs.nixvim = {
     enable = true;
     defaultEditor = true;

     opts = {
       shiftwidth = 2; # Tab width should be 2
     };
     diagnostic.settings = {
       virtual_text = true;
     };
     colorschemes.solarized-osaka.enable = true;

     plugins = {
       lsp = {
         enable = true;
         servers = {
           # nix lang
           nil_ls.enable = true;
         };
       };
       # Improved bottom status line
       lualine.enable = true;
     };
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
       window.commands = [
         # Sound control UI config;
         # Always float at the mouse cursor, so it's faster control
         {
           command = "floating on, move position cursor, move down [HEIGHT OF STATUS BAR]";
           criteria = { app_id = "pavucontrol"; };
         }
         {
           command = "floating on, move position cursor, move down [HEIGHT OF STATUS BAR]";
           criteria = { app_id = "blueman-manager"; };
         }
       ];
     };

     # Configs that don't have types yet in home-manager can go here
     extraConfig = ''
     '';
   };

   programs.swaylock.enable = true;
   services.mako.enable = true; # Lightweight notification UI
   services.blueman-applet.enable = true; # Enable bluetooth bar icon

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

   programs.obs-studio = {
     enable = true;
     plugins = [
       pkgs.obs-studio-plugins.obs-vkcapture
       pkgs.obs-studio-plugins.wlrobs
       pkgs.obs-studio-plugins.droidcam-obs
     ];
   };
}

