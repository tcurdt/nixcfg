{ pkgs, ... }:
{

  home.packages = [
    pkgs.nano
    # pkgs.neovim # via config
    # pkgs.oh-my-zsh # via config
    # pkgs.tmux # via config
    pkgs.curl
    pkgs.jq
    # pkgs.jo # json out
    # pkgs.jp # json plot
    pkgs.openssl
    pkgs.unzip
    pkgs.htop
    pkgs.gitMinimal
    pkgs.mmv
    pkgs.file
    pkgs.dnsutils # bind dig nslookup
    pkgs.parallel
    pkgs.just
    pkgs.diceware
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
    pkgs.nh
    pkgs.nixfmt-rfc-style
  ];

  programs = {

    bash = {
      enable = true;
      # initExtra = ''
      #   export PATH=/run/current-system/sw/bin/:/nix/var/nix/profiles/default/bin:$HOME/.nix-profile/bin:/etc/profiles/per-user/$USER/bin:$PATH
      # '';
    };

    zsh = {
      enable = true;
      # envExtra = ''
      #   export PATH=/run/current-system/sw/bin/:/nix/var/nix/profiles/default/bin:$HOME/.nix-profile/bin:/etc/profiles/per-user/$USER/bin:$PATH
      # '';
      history = {
        ignoreDups = true;
        ignoreSpace = true;
      };
      oh-my-zsh = {
        enable = true;
        plugins = [ ];
        theme = "daveverwer";
      };
    };

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
        sha = "rev-parse --short HEAD";

        ci = "commit -v";
        co = "checkout";

        clean = "!git restore . && git clean -fdx";

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

        standup = "!f() { git log --since=$1.days --author=tcurdt --pretty=format':%Cgreen%cd:%Creset %s' --date='format:%F %a' --all; }; f";
        standupr = "!f() { git log --reverse --since=$1.days --author=tcurdt --pretty=format':%Cgreen%cd:%Creset %s' --date='format:%F %a' --all; }; f";

        export = "archive -o latest.tar.gz -9 --prefix=latest/";

        setup = "!git init && git add . && git commit -m init";

      };

      extraConfig = {

        init.defaultBranch = "main";

        pull.rebase = 1;
        pull.ff-only = 1;

        rerere.enabled = 1;
        rebase.updateRefs = true;

        push.default = "current";
        push.followTags = 1;

        log.oneline = 1;

        gist.private = 1;
        gits.browse = 1;

        github.user = "tcurdt";

        branch.sort = "-committerdate";

        # [remote "origin"]
        #   tagopt = --tags
        #   prune = true
        #   pruneTags = true
      };
    };

    bat.config = {
      enable = true;

      # map-syntax = [
      #   "*.jenkinsfile:Groovy"
      #   "*.props:Java Properties"
      # ];

      # pager = "less -FR";
      # theme = "TwoDark";

      # bat-extras = [
      #   pkgs.bat-extras.batdiff
      #   pkgs.bat-extras.batman
      #   pkgs.bat-extras.batgrep
      #   pkgs.bat-extras.batwatch
      # ];
    };

    lazygit.enable = true;

    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      extraConfig = '''';
      # extraConfig = lib.fileContents ../path/to/your/init.vim;
      plugins = [
        # pkgs.vimPlugins.nvim-treesitter.withAllGrammars
      ];
    };

    tmux = {
      enable = true;
      clock24 = true;
      # mouse = true;
    };
  };

  home.shellAliases = {
    cat = "bat --style plain --paging=never";
    bat = "bat --style numbers --paging=never";

    ll = "eza -la --group --octal-permissions --no-permissions --time-style long-iso";
    ls = "eza";

    g = "git";
    lg = "lazygit";

    tssh = "ssh -A -o UserKnownHostsFile=/dev/null ";
    passphrase = "diceware --no-caps -n 7 -d -";

    systemtime = "chronyc makestep && chronyc tracking";

    k = "kubectl";
    kall = "kubectl get all -A";
    # kdebug = "kubectl debug -it <pod-name> --image=busybox --target=<container-name> --namespace=<namespace>";

    # dp = "docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.CreatedAt}}\t{{.Status}}\t{{.Ports}}'";
  };

  home.sessionPath = [
    "$HOME/go/bin"
  ];

  home.sessionVariables = {
    PAGER = "less";
    EDITOR = "nano";
    CLICOLOR = 1;
  };

  # home.file = {
  #   ".foo" = {
  #     text = ''
  #       bar
  #     '';
  #   };
  # };

  home.stateVersion = "23.11";
}
