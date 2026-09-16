{ ... }:

{
  swapDevices = [
    {
      device = "/swapfile";
      size = 32768;
    }
  ];

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
    priority = 100;
  };

  boot.resumeDevice = "/dev/nvme0n1p2";

  boot.kernelParams = [
    "resume=/dev/nvme0n1p2"
    "resume_offset=119586816"
  ];

  services.upower = {
    enable = true;

    usePercentageForPolicy = true;

    percentageLow = 15;
    percentageCritical = 10;
    percentageAction = 1;

    criticalPowerAction = "Hibernate";
  };

  services.logind = {
    lidSwitch = "suspend";
    lidSwitchDocked = "suspend";
    lidSwitchExternalPower = "suspend";
  };

  services.power-profiles-daemon.enable = true;
}
