{

  enable = true;

  userName = "Torsten Curdt";
  userEmail = "tcurdt@vafer.org";

  # ignores = [ "*~" "*.swp" ];

  aliases = {

    p = "push";

    r = "pull --rebase";
    rf = "pull --rebase --force";

    s = "status -s";

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
    # init.defaultBranch = "master";
    # pull.rebase = "false";
  };
}