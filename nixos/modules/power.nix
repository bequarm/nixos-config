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
    "resume_offset=202979328"
  ];

  services.upower = {
    enable = true;

    usePercentageForPolicy = true;

    percentageLow = 15;
    percentageCritical = 10;
    percentageAction = 2;

    criticalPowerAction = "Hibernate";
  };

  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchDocked = "suspend";
    HandleLidSwitchExternalPower = "suspend";
  };

  services.power-profiles-daemon.enable = true;

  # Режим сбережения батареи Lenovo (аналог Conservation Mode в Lenovo Vantage).
  # Порог заряда задаёт прошивка ноутбука, числом его выставить нельзя.
  # Временно выключить: echo Standard | sudo tee /sys/class/power_supply/BAT0/charge_types
  systemd.services.battery-conservation = {
    description = "Lenovo battery conservation mode (Long_Life)";
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "oneshot";
    script = ''
      echo Long_Life > /sys/class/power_supply/BAT0/charge_types
    '';
  };
}
