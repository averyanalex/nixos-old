let
  alex =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINF5KDy1T6Z+RlDb+Io3g1uSZ46rhBxhNE39YlG3GPFM";
  users = [ alex ];

  router =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHoe/I5CQ++Vr+4EXURrh3dphT/wGbCWSClu7FOB8zbs";
  public =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILV6UQMKSSpnmPstQTXD54Q4OiOun2hIbp25Nh8whGoF";
  systems = [ router public ];
in {
  "router-wg-key.age".publicKeys = users ++ [ router ];
  "cloudflare-credentials.age".publicKeys = users ++ [ router public ];
}
