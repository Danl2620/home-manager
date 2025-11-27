{
  config,
  pkgs,
  ...
}: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "dliebgold";
  home.homeDirectory = "/Users/dliebgold";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    git
    curl
    which
    eza
  ];

  ## please convert my .gitconfig in to the equivalent nix home-manager program.git configuration

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
    ".config/zed/settings.json".source = ./config/zed/settings.json;
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
      diff.tool = "sourcetree";
      merge.tool = "sourcetree";
      difftool.sourcetree = {
        cmd = "/Applications/Sourcetree.app/Contents/Resources/opendiff-w.sh \$LOCAL \$REMOTE";
        trustExitCode = true;
      };
      mergetool.sourcetree = {
        cmd = "/Applications/Sourcetree.app/Contents/Resources/opendiff-w.sh \$LOCAL \$REMOTE -ancestor \$BASE -merge \$MERGED";
        trustExitCode = true;
      };
      url = {
        "ssh://git@host" = {
          insteadOf = "otherhost";
        };
      };
    };
  };
}
