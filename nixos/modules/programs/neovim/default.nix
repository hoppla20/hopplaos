{
  inputs,
  self,
  self',
  config,
  lib,
  ...
} @ moduleInputs: let
  cfg = config.hopplaos.programs.neovim;
in {
  options.hopplaos.programs.neovim = {
    enable = lib.mkEnableOption "NeoVIM";
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim = inputs.haumea.lib.load {
      src = ./config;
      inputs =
        builtins.removeAttrs moduleInputs ["self" "self'"]
        // {
          flakeRoot = self;
          flakeRoot' = self';
        };
      transformer = [inputs.haumea.lib.transformers.liftDefault];
    };
  };
}
