{ pkgs, ... }:
{

  programs = {

    bash = {
      enable = true;
      initExtra = ''
        # Make Nix and home-manager installed things available in PATH.
        export PATH=/run/current-system/sw/bin/:/nix/var/nix/profiles/default/bin:$HOME/.nix-profile/bin:/etc/profiles/per-user/$USER/bin:$PATH
      '';
    };

    zsh = {
      enable = true;
      envExtra = ''
        # Make Nix and home-manager installed things available in PATH.
        export PATH=/run/current-system/sw/bin/:/nix/var/nix/profiles/default/bin:$HOME/.nix-profile/bin:/etc/profiles/per-user/$USER/bin:$PATH
      '';
    };


    # https://github.com/nix-community/home-manager/blob/master/modules/programs/git.nix
    git = {
      enable = true;

      userName = "Torsten Curdt";
      userEmail = "tcurdt@vafer.org";

      package = pkgs.gitMinimal;

      ignores = [
        # ".SyncID"
        # ".SyncArchive"
        # ".SyncIgnore"
        ".sync"
        ".DS_Store"
        # ".classpath"
        # ".settings"
        # ".testflight"
        # ".awestruct"
        # ".sass-cache"
        # ".release"
        # ".godeps"
        # ".idea"
        # "target"
        # "build"
        # "eclipse"

        # "research"
        # "Research"
        # "_Research"
        "_research"

        # "_site"
        # "_tmp"
        # "_old"
        # "dsa_priv.pem"
        # "node_modules"
        # "jspm_packages"

        "*~"
        ".#*"
        # "*.orig"
        # "*.rej"
        # "*.swp"
        # "*.obj"
        # "*.o"

        # "Pods"
        # "*.pbxproj -crlf -diff -merge"
        # "*~.nib"
        # "*.mode1v3"
        # "*.mode1"
        # "*.mode2"
        # "*.pbxuser"
        # "*.perspective"
        # "*.perspectivev3"
        # "xcuserdata"

        ".env"
        ".dev.vars"
      ];

      aliases = {

        p = "push";

        r = "pull --rebase";
        rf = "pull --rebase --force";

        st = "status -s";

        ci = "commit -v";
        co = "checkout";

        a = "add";
        au = "add -u";
        aa = "add --all";

        t = "tag";
        td = "!f() { git tag -d $1; git push --delete origin $1; }; f";
        tf = "!f() { git tag -f $1; git push --force origin HEAD:refs/tags/$1; }; f";

        b = "branch -av";
        bd = "branch -D";

        l = "log --graph --decorate --no-merges --pretty=format:'%Cred%h %Cblue%cN %Cgreen%cd%C(yellow)%d%Creset - %s' --date='format:%F %a'";
        la = "log --full-history --all --graph --abbrev-commit --pretty=format:'%Cred%h %Cblue%cN %Cgreen%cd%C(yellow)%d%Creset - %s' --date='format:%F %a'";
        lf = "log --graph --decorate --no-merges --oneline --name-status --pretty=format:'%Cred%h %Cblue%cN %Cgreen%cd%C(yellow)%d%Creset - %s %n' --date='format:%F %a'";
        lp = "log --abbrev-commit --date=relative -p";

        export = "archive -o latest.tar.gz -9 --prefix=latest/";

        setup = "!git init && git add . && git commit -m init";

      };

      extraConfig = {

        init.defaultBranch = "main";

        pull.rebase = 1;
        pull.ff-only = 1;

        rerere.enabled = 1;

        push.default = "current";
        push.followTags = 1;

        log.oneline = 1;

        gist.private = 1;
        gits.browse = 1;

        gpg.format = 1;

        github.user = "tcurdt";

        branch.sort = "-committerdate";

        # [remote "origin"]
        #   tagopt = --tags
        #   prune = true
        #   pruneTags = true
      };
    };

    lazygit.enable = true;

    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      extraConfig = ''
      '';
      # extraConfig = lib.fileContents ../path/to/your/init.vim;
      # colorschemes.gruvbox.enable = true;
      # plugins.lightline.enable = true;
      plugins = [
        pkgs.vimPlugins.nvim-treesitter.withAllGrammars
      ];
    };

  };

  home.shellAliases = {
    ll = "ls -la";
    cat = "bat";
    ls = "eza";
    g = "git";
    lg = "lazygit";
  };

  home.sessionVariables = {
    PAGER = "less";
    EDITOR = "nano";
    CLICOLOR = 1;
  };

  home.packages = [
    pkgs.nano
    pkgs.neovim
    pkgs.tmux
    pkgs.curl
    pkgs.jq
    pkgs.unzip
    pkgs.htop
    pkgs.gitMinimal
    pkgs.mmv
    pkgs.file
    pkgs.dnsutils # bind dig nslookup
    pkgs.parallel
    pkgs.just
    pkgs.xh # curl
    pkgs.pv # pipe progress
    pkgs.croc # whormhole
    pkgs.sd # sed
    pkgs.fd # find
    pkgs.eza # ls
    pkgs.bat # cat
    pkgs.procs # ps
    pkgs.ripgrep # grep
    pkgs.ruplacer # find && replace
    pkgs.du-dust # du
    # pkgs.hyperfine # benchmarking
    # pkgs.jo # json out
    # pkgs.jp # json plot
  ];

  home.file = {
    ".foo" = {
      text = ''
        bar
      '';
    };
  };

  home.stateVersion = "23.11";
}
