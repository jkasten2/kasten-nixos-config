{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "25.11";

  imports = [
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

  programs.mangohud.enable = true;

  home.packages = with pkgs; [
    efibootmgr

    unzip
    p7zip # 7z command

    # disk space finders
    dust
    ncdu

    # Better find and grep commands
    fd
    ripgrep

    tldr # shorter man pages

    eza # Better ls command
    bat

    jq
    expect # Utils like unbuffer

    nvd # nix package version diff tool

    parsec-bin

    # sm64coopdx
    xemu
    dolphin-emu

    gparted # Must run with sudo -E

    haruna # Video player
    gnome-calculator # Calculator GUI

    hardinfo2 # GUI hardware info
  ];

  home.shellAliases =
    let
      nixconf-dir = "~/.config/nixos";
      win-boot-disk = "0002";
    in
    {
      "cd.." = "cd ..";
      "ll" = "eza -lah";

      "nix_dir" = "cd ${nixconf-dir}";
      "nix_switch" = "sudo nixos-rebuild switch";
      "nix_edit" = "nvim -p ${nixconf-dir}/*";
      "nix_check-update" =
        "cd ${nixconf-dir}/ && nix flake update && nixos-rebuild build && unbuffer nvd diff /run/current-system ./result | tee results.log";
      "nix_gc" =
        "sudo nix-collect-garbage --delete-older-than 7d && nix-collect-garbage --delete-older-than 7d";

      "reboot_bios" = "systemctl reboot --firmware-setup";
      "reboot_win" = "sudo efibootmgr --bootnext ${win-boot-disk} && sudo reboot";

      "sleep_now" = "systemctl suspend";
    };

  programs.vim = {
    enable = true;
  };

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    opts = {
      shiftwidth = 2; # Tab width should be 2
      list = true; # Shows tab character and trailing white space
      spell = true;
    };
    diagnostic.settings = {
      virtual_text = true;
    };
    colorschemes.solarized-osaka.enable = true;

    plugins = {
      # Improved bottom status line
      lualine.enable = true;
      which-key.enable = true;

      # LSP provides syntax errors
      # Treesitter provides syntax highlighting for nesting languages,
      #  such as JS inside of HTML
      lsp = {
        enable = true;
        servers = {
          # nix lang
          nil_ls.enable = true;
        };
      };
      # Formats the file on save, also if :Format is called
      lsp-format = {
        enable = true;
      };

      treesitter = {
        enable = true;
        withAllGrammars = true;
        settings = {
          highlight = {
            enable = true;
          };
        };
      };
      # Nix lang context is normally too many lines
      # treesitter-context = {
      #  enable = true;
      # };
    };
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
        scrollback-end = "Shift+End";
      };
      colors-dark = {
        background = "000000";
      };
    };
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
