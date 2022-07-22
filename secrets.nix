let
  alex =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINF5KDy1T6Z+RlDb+Io3g1uSZ46rhBxhNE39YlG3GPFM";
  users = [ alex ];

  ferret =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJCrSdgjm9hxyFMCVCW+SzgF7AThC+fZy8RBQoFqCWT2";
  alligator =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE7y1Vw/aeF69RDccAB2BB1IATUvVEQ7sIgAO5fUZKyC";

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

  systems = [ alligator ferret hawk router public runner highterum personal ];
in
{
  "secrets/passwords/alex.age".publicKeys = users ++ systems;
  "secrets/passwords/alexey.age".publicKeys = users ++ [ ferret ];

  "secrets/wayvnc.age".publicKeys = users ++ [ alligator ];
  "secrets/wayvnc-key.age".publicKeys = users ++ [ alligator ];
  "secrets/wayvnc-cert.age".publicKeys = users ++ [ alligator ];

  "secrets/router-wg-key.age".publicKeys = users ++ [ router ];
  "secrets/public-wg-key.age".publicKeys = users ++ [ public ];
  "secrets/hawk-wg-key.age".publicKeys = users ++ [ hawk ];
  "secrets/personal-wg-key.age".publicKeys = users ++ [ personal ];
  "secrets/wireguard/highterum.age".publicKeys = users ++ [ highterum ];

  "secrets/cloudflare-credentials.age".publicKeys = users ++ [ router public hawk ];
  "secrets/cf-creds-frsqr.age".publicKeys = users ++ [ public hawk ];

  "secrets/gitsrv-runner-token.age".publicKeys = users ++ [ runner ];
  "secrets/highterum-pgsql.age".publicKeys = users ++ [ highterum ];
  "secrets/crsrv-token.age".publicKeys = users ++ [ public highterum ];
  "secrets/ht-cabinet-api.age".publicKeys = users ++ [ highterum ];

  "secrets/docker-registries-ro.age".publicKeys = users ++ [ public highterum ];
}
