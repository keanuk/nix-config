{ config, ... }:

{
  services.xmrig = {
    enable = true;
    settings = {
      autosave = true;
      cpu = true;
      opencl = true;
      cuda = false;
      pools = [
        {
          url = "pool.supportxmr.com:443";
          user = "47CsEd6nSitR9W3VqieiV2VreNgt2atW3K1RciVS5sadGQnPcA73P7M61aFe4oeVxYNhG8wgQ9d4F6hJLbXd8nrq4tYZmqW";
          keepalive = true;
          tls = true;
        }
        #{
        #  algo = "rx/0";
        #  url = "stratum+ssl://kawpow.auto.nicehash.com:443";
        #  user = "bc1qat0x22c5qg6gdmh5te8xnksnqmufxm622gaxdg.${config.networking.hostName}";
        #  pass = "x";
        #  keepalive = true;
        #  tls = true;
        #}        
      ];
    };
  };
}
