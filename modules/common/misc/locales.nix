_: {
  i18n =
    let
      en_us = "en_US.UTF-8";
      de_de = "de_DE.UTF-8";
    in
    {
      defaultLocale = en_us;
      extraLocaleSettings = {
        LC_ADDRESS = de_de;
        LC_IDENTIFICATION = de_de;
        LC_MEASUREMENT = de_de;
        LC_MONETARY = de_de;
        LC_NAME = de_de;
        LC_NUMERIC = en_us;
        LC_PAPER = de_de;
        LC_TELEPHONE = de_de;
        LC_TIME = de_de;
      };
    };
}
