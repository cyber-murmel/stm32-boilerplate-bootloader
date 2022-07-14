{ pkgs, ...} :
with pkgs;
[
  gnumake gcc-arm-embedded openocd clang-tools stm32cubemx stlink-gui wmname
]
