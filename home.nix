{ config, pkgs, ... }:

{
   # Let Home Manager install and manage itself.
   programs.home-manager.enable = true;

   home.stateVersion = "25.11";

   home.username = "kasten";
   home.homeDirectory = "/home/kasten";

   programs.bash.enable = true;

   home.shellAliases = {
     "cd.." = "cd ..";
   };

   programs.foot = {
     enable = true;
     settings = {
       main = {
         dpi-aware = "no";
         font = "Courier New:size=11";
       };
       
       scrollback.lines = 10000;
       key-bindings = {
         scrollback-home = "Shift+Home";
         scrollback-end  = "Shift+End";
       };
     };
   };
}

