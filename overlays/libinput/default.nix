{ ... }: _final: prev: {
  libinput = prev.libinput.overrideAttrs (old: {
    postPatch = (old.postPatch or "") + ''
      substituteInPlace src/evdev-mt-touchpad-tap.c \
        --replace "DEFAULT_TAP_TIMEOUT_PERIOD ms2us(180)" \
                  "DEFAULT_TAP_TIMEOUT_PERIOD ms2us(90)"
    '';
  });
}
