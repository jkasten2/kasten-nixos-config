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
    unzip

    # disk space finders
    dust
    ncdu

    # Better find and grep commands
    fd
    ripgrep

    tldr # shorter man pages

    eza # Better ls command

    jq

    parsec-bin

    sm64coopdx

    gparted # Must run with sudo -E

    grim # Screenshot util
  ];

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
      treesitter-context = {
        enable = true;
      };
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
        scrollback-end = "Shift+End";
      };
      colors-dark = {
        background = "000000";
      };
    };
  };

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    systemd.variables = [ "--all" ];

    config = rec {
      modifier = "Mod4";
      keybindings =
        let
          modifier = config.wayland.windowManager.sway.config.modifier;
          pipewire_inc_foreground_volume = pkgs.writeShellApplication {
            name = "pipewire-inc-foreground-volume";
            text = ''
              # PURPOSE: Work around for "wpctl set-volume -p PID" bug with increase / decrease volume.
              #   If a PID has two outputs, one of the volumes will jump way up.
              #   Example, happens in Firefox when there are two YouTube tabs open. Also with some games.
              FOREGROUND_PID="$(swaymsg -t get_tree | jq -r '.. | select(.type?) | select(.focused==true) | .pid')"
              PWDUMP_OUTPUT=$(pw-dump)
              OBJ_IDS=$(echo "$PWDUMP_OUTPUT" | jq --argjson pid "$FOREGROUND_PID" '.[] | select(.info.props."application.process.id"==$pid) | .id')
              NODE_IDS=$(echo "$OBJ_IDS" | while IFS= read -r line; do echo "$PWDUMP_OUTPUT" | jq --argjson line "$line" '.[] | select(.info.props."client.id"==$line) | .id'; done)

              for node_id in $NODE_IDS; do
                wpctl set-volume "$node_id" "$1"
              done
            '';
          };

          # mkOptionDefault keeps defaults for all other keybindings
        in
        lib.mkOptionDefault {
          "${modifier}+control+l" = "exec swaylock";
          "${modifier}+d" = "exec walker";

          "${modifier}+alt+equal" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%+";
          "${modifier}+alt+minus" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-";
          "${modifier}+control+alt+equal" = "exec ${lib.getExe pipewire_inc_foreground_volume} 2%+";
          "${modifier}+control+alt+minus" = "exec ${lib.getExe pipewire_inc_foreground_volume} 2%-";

          "Shift+Control+F12" =
            "exec grim -o $(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name') - | wl-copy";
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
        "type:pointer" = {
          accel_profile = "flat";
        };
      };

      fonts = {
        names = [ "Roboto" ];
        style = "Normal";
        size = 11.0;
      };

      bars = [
        {
          position = "top";
          statusCommand = "while date +'%Y-%m-%d %X'; do sleep 1; done";
          fonts = {
            names = [ "Roboto Mono" ];
            style = "Bold";
            size = 11.0;
          };
        }
      ];
      window.commands = [
        # Sound control UI config;
        # Always float at the mouse cursor, so it's faster control
        {
          command = "floating on, move workspace current, urgent enable, sticky enable, move position cursor, move down [HEIGHT OF STATUS BAR]";
          criteria = {
            app_id = "pwvucontrol";
          };
        }
        {
          command = "floating on, move workspace current, urgent enable, sticky enable, move position cursor, move down [HEIGHT OF STATUS BAR]";
          criteria = {
            app_id = "blueman-manager";
          };
        }
      ];
    };

    # Configs that don't have types yet in home-manager can go here
    extraConfig = "";
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

  programs.obs-studio = {
    enable = true;
    plugins = [
      pkgs.obs-studio-plugins.obs-vkcapture
      pkgs.obs-studio-plugins.wlrobs
      pkgs.obs-studio-plugins.droidcam-obs
    ];
  };
}
