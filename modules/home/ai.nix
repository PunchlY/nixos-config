{
  config,
  lib,
  ...
}: let
  allExeNames = [
    "git status"
    "git log"
    "git diff"
    "git show"
    "git branch"
    "git remote"
    "git config"
    "git rev-parse"
    "git ls-files"
    "git ls-remote"
    "git describe"
    "git tag --list"
    "git blame"
    "git shortlog"
    "git reflog"
    "git add"
    "git commit -m"
    "nix search"
    "nix eval"
    "nix show-config"
    "nix flake show"
    "nix flake check"
    "nix log"
    "ls"
    "pwd"
    "find"
    "grep"
    "rg"
    "cat"
    "head"
    "tail"
    "mkdir"
    "chmod"
    "systemctl list-units"
    "systemctl list-timers"
    "systemctl status"
    "journalctl"
    "dmesg"
  ];
in {
  programs.opencode = lib.mkIf config.programs.opencode.enable {
    settings = {
      permission = {
        bash =
          {
            "*" = "ask";
          }
          // lib.foldl (
            acc: cmd:
              acc
              // {
                ${cmd} = "allow";
                "${cmd} *" = "allow";
              }
          ) {}
          allExeNames;
        edit = "ask";
      };
      provider = {
      };
    };
    context = ''
      - 使用中文进行交流.
      - 坚持前瞻性视角, 基于趋势与长期演进进行分析与判断.
      - 采用正式, 专业, 客观的表达方式. 观点明确, 结论清晰, 避免模糊表述.
      - 直接回应核心问题, 不进行无关铺垫.
      - 优先引用权威文档, 官方资料与可验证来源.
      - 在需要数据支持时, 尽可能通过联网检索获取最新, 真实, 可追溯的信息.
      - 避免使用比喻, 拟人, 排比等修辞手法, 保持表达严谨, 结构清晰, 逻辑自洽.
      - 永远不要使用道歉.
      - 永远不要在回复中加入emoji.
    '';
  };
}
