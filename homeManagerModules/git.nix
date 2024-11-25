{inputs, lib, config, ...}: {
  options = {
      git.enable = lib.mkEnableOptions "enables git";
  };

  config = lib.mkIf config.git.enable {
    programs.git = {
      enable = true;
      userEmail = "hansen-jonathan@hotmail.com";
      userName = "LittleVaaty";
    };
  };
}
