{
  networking.firewall = {
    allowedUDPPorts = [ 1900 ];
    extraInputRules = ''
      udp sport 1900 accept
    '';
  };
}
