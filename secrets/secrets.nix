let
  alex =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINF5KDy1T6Z+RlDb+Io3g1uSZ46rhBxhNE39YlG3GPFM";
  users = [ alex ];

  mole =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF2cUpFVFLAXnAq9wtc5DXYjUfjnegSmW8TpBjN+PrkA";
  router =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHoe/I5CQ++Vr+4EXURrh3dphT/wGbCWSClu7FOB8zbs";
  public =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILV6UQMKSSpnmPstQTXD54Q4OiOun2hIbp25Nh8whGoF";
  runner =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEt5lXWlcNxeS/dZtKiJDyzHXnLlVFUe9iC0LPHPly6X";
  highterum =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBioDhlj6H4xSK8K2sr9uxz1g9y6OD87mNrpQX0NL9OW";
  systems = [ mole router public runner highterum ];
in {
  "passwords/alex.age".publicKeys = users ++ systems;

  "router-wg-key.age".publicKeys = users ++ [ router ];
  "cloudflare-credentials.age".publicKeys = users ++ [ router public ];
  "gitsrv-runner-token.age".publicKeys = users ++ [ runner ];
  "highterum-pgsql.age".publicKeys = users ++ [ highterum ];
  "crsrv-token.age".publicKeys = users ++ [ public highterum ];
  "ht-cabinet-api.age".publicKeys = users ++ [ highterum ];

  "docker-registries-ro.age".publicKeys = users ++ [ public highterum ];
}
