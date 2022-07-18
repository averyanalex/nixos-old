let
  alex =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINF5KDy1T6Z+RlDb+Io3g1uSZ46rhBxhNE39YlG3GPFM";
  users = [ alex ];

  ferret =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJCrSdgjm9hxyFMCVCW+SzgF7AThC+fZy8RBQoFqCWT2";

  hawk =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF2cUpFVFLAXnAq9wtc5DXYjUfjnegSmW8TpBjN+PrkA";

  router =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHoe/I5CQ++Vr+4EXURrh3dphT/wGbCWSClu7FOB8zbs";
  public =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILV6UQMKSSpnmPstQTXD54Q4OiOun2hIbp25Nh8whGoF";
  runner =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEt5lXWlcNxeS/dZtKiJDyzHXnLlVFUe9iC0LPHPly6X";
  highterum =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBioDhlj6H4xSK8K2sr9uxz1g9y6OD87mNrpQX0NL9OW";
  personal =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHYfrCDEFDQJBdL76VsAf1rFdGDuwrfDkd3fjHQNQgci";

  systems = [ ferret hawk router public runner highterum personal ];
in {
  "passwords/alex.age".publicKeys = users ++ systems;
  "passwords/alexey.age".publicKeys = users ++ [ ferret ];

  "router-wg-key.age".publicKeys = users ++ [ router ];
  "public-wg-key.age".publicKeys = users ++ [ public ];
  "hawk-wg-key.age".publicKeys = users ++ [ hawk ];
  "personal-wg-key.age".publicKeys = users ++ [ personal ];
  "wireguard/highterum.age".publicKeys = users ++ [ highterum ];

  "cloudflare-credentials.age".publicKeys = users ++ [ router public hawk ];
  "cf-creds-frsqr.age".publicKeys = users ++ [ public hawk ];

  "gitsrv-runner-token.age".publicKeys = users ++ [ runner ];
  "highterum-pgsql.age".publicKeys = users ++ [ highterum ];
  "crsrv-token.age".publicKeys = users ++ [ public highterum ];
  "ht-cabinet-api.age".publicKeys = users ++ [ highterum ];

  "docker-registries-ro.age".publicKeys = users ++ [ public highterum ];
}
