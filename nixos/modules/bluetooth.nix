{ ... }: {
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.Experimental = true; # только для показа заряда наушников
  };

  services.blueman.enable = true;
}
