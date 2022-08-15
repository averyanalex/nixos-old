{
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
  };

  programs.gpg = {
    enable = true;
    mutableKeys = false;
    mutableTrust = false;
    publicKeys = [
      {
        # AveryanAlex
        source = ./configs/gpg/averyanalex.asc;
        trust = 5;
      }
      {
        # Cofob
        source = ./configs/gpg/cofob.asc;
        trust = 4;
      }
    ];
  };
}
