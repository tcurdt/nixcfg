{ pkgs, ... }:
{

  home.packages = [
    pkgs.nano
    # pkgs.neovim # via config
    # pkgs.oh-my-zsh # via config
    # pkgs.tmux # via config
    pkgs.curl
    pkgs.yq
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

    # pkgs.delta # git diff
    # pkgs.git-lfs
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

      # signing = {
      #   key = "/Users/tcurdt/.ssh/id_rsa.pub";
      #   signByDefault = true;
      # };

      package = pkgs.gitMinimal;

      ignores = [
        ".sync"
        ".DS_Store"
        "_research"
        "*~"
        ".#*"
        ".env"
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

        github.user = "tcurdt";
        gpg.format = "ssh";

        init.defaultBranch = "main";

        branch.sort = "-committerdate";
        branch.autosetuprebase = "always";
        branch.autosetupmerge = "always";

        push.autosetupremote = true;
        push.default = "current";
        push.followTags = 1;

        remote.origin.tagopt = "--tags";
        remote.origin.prune = true;
        remote.origin.prunetags = true;

        pull.rebase = 1;
        pull.ff-only = 1;

        rerere.enabled = 1;
        rebase.updateRefs = true;

        merge.ff = "only";

        log.oneline = 1;

        gist.private = 1;
        gits.browse = 1;

        # filter.lfs.clean = "git-lfs clean -- %f";
        # filter.lfs.smudge = "git-lfs smudge -- %f";
        # filter.lfs.process = "git-lfs filter-process";
        # filter.lfs.required = true;
      };
    };

    bat.config = {
      enable = true;
      config = {
        color = "never";
        paging = "never";
      };
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
    };
  };

  home.shellAliases = {
    cat = "bat --style=plain";
    bat = "bat --style=numbers";

    ll = "eza -la --group --octal-permissions --no-permissions --time-style long-iso";
    ls = "eza";

    g = "git";
    lg = "lazygit";

    tssh = "ssh -A -o UserKnownHostsFile=/dev/null ";
    passphrase = "diceware --no-caps -n 7 -d -";

    p = "pnpm";

    k = "kubectl";
    kall = "kubectl get all -A";

    date_utc = "date -u -Iseconds";
    date_berlin = "TZ=Europe/Berlin date -Iseconds";
    dates = "date_utc && date_berlin";

    systemtime = "chronyc makestep && chronyc tracking";

  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true; # makes integration much faster
    config = {
      global = {
        load_dotenv = false;
      };
    };
  };

  home.sessionPath = [
    "$HOME/go/bin"
    "$HOME/.bin"
  ];

  home.sessionVariables = {
    PAGER = "less";
    EDITOR = "nano";
    CLICOLOR = 1;
    # KUBECONFIG = "$HOME/.kube/config";
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
