let
  users = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ7XCi9Zqg4KxlH3r/9BRAfXeohUTsOzYxp83oztTfiW punchly9lin@gmail.com"
  ];
  systems = [
  ];
in
{
  "mihomo.age".publicKeys = users ++ systems;
}
