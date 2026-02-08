{
  config,
  pkgs,
  ...
}: {

  nixpkgs = {
    config = {
      allowUnfree = true;
      # allowUnfreePredicate can be used to only allow specific packages
      # allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "package-name" ]; 
    };
  };

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "danl";
  home.homeDirectory = "/home/danl";
  home.stateVersion = "25.11"; # Please read the comment before changing.
  home.packages = with pkgs; [
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    git
    git-lfs
    curl
    which
    cmake
    ninja
    eza
    starship
    just
    glow
    wget
    dropbox-cli
 
    helix
    claude-code
    meld
    serie
 ];

  # programs.zsh = {
  #   enable = true;
  #   enableCompletion = true;
  #
  #   shellAliases = {
  #     ls = "exa --color=auto";
  #     ll = "ls -lF";
  #     hm = "home-manager";
  #     ##rk="${pkgs.racket}/bin/racket";
  #     e = "nohup ${pkgs.emacs}/Contents/MacOS/Emacs $@ &";
  #     lg = "${pkgs.lazygit}/bin/lazygit $@";
  #   };
  #
  #   initContent = ''
  #     # Ensure auto-wrap (margin mode) is enabled
  #     tput smam 2>/dev/null || true
  #
  #     . "$HOME/.cargo/env"
  #
  #     eval "$(direnv hook zsh)"
  #     eval "$(starship init zsh)"
  #   '';
  # };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    ".gitignore_global".source = ./config/git/gitignore_global;
    ".zsh_aliases".text = ''
      # Directory listing
      # alias ls='eza --color=auto'
      # alias ll='eza -lF'
      # alias la='eza -laF'
      # alias lt='eza -lT'

      # grep colors
      alias grep='grep --color=auto'
      alias egrep='egrep --color=auto'
      alias fgrep='fgrep --color=auto'

      # Home Manager
      alias hm='home-manager'
      alias hms='home-manager switch'

      # Git shortcuts (supplementing git aliases)
      alias gst='git status'
      alias gco='git checkout'
      alias gci='git commit'
      alias lg='lazygit'
      alias o='obsidian --disable-gpu'
    '';
    ".zsh_git_tools".source = ./shell/git-tools.sh;
    ".zsh_hm".text = ''
      source ~/.zsh_aliases
      source ~/.zsh_git_tools
    '';
    # ".config/zed/settings.json".source = ./config/zed/settings.json;
    # ".config/starship.toml".source = ./config/starship.toml;
    ".config/nixpkgs/config.nix".source = ./config/nixpkgs/config.nix;
    # ".vimrc".source = ./config/vimrc;
    ".local/share/development/cicd".source = ./config/claude/skills/cicd;
    ".local/share/development/justfile".source = ./config/claude/skills/justfile;
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/dliebgold/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "Dan Liebgold";
        email = "dan.liebgold@gmail.com";
      };
      aliases = {
        st = "status";
        co = "checkout";
        ci = "commit";
        br = "branch";
        df = "diff";
        lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --";
      };
      core = {
        whitespace = "trailing-space,space-before-tab";
        excludesfile = "${config.home.homeDirectory}/.gitignore_global";
      };
      init.defaultBranch = "main";
      filter = {
        lfs = {
          clean = "git-lfs clean -- %f";
          smudge = "git-lfs smudge -- %f";
          process = "git-lfs filter-process";
          required = true;
        };
      };
      diff.tool = "meld";
      merge.tool = "meld";
      url = {
        "ssh://git@host" = {
          insteadOf = "otherhost";
        };
      };
    };
  };
}
