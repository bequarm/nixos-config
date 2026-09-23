{ pkgs, ... }:
{
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;

    # Шаг 1: эхоподавление (WebRTC), моно
    extraConfig.pipewire."60-echo-cancel" = {
      "context.modules" = [
        {
          name = "libpipewire-module-echo-cancel";
          args = {
            "library.name" = "aec/libspa-aec-webrtc";
            # Эталон эха берётся с монитора вывода по умолчанию
            "monitor.mode" = true;
            "audio.channels" = 1;
            "audio.position" = [ "MONO" ];
            "capture.props" = {
              "node.name" = "capture.echo-cancel";
              "node.passive" = true;
            };
            "source.props" = {
              "node.name" = "echo-cancel-source";
              "node.description" = "Микрофон (эхоподавление)";
            };
            "aec.args" = {
              "webrtc.noise_suppression" = false; # шум убирает RNNoise
              "webrtc.high_pass_filter" = true;
              "webrtc.gain_control" = false;
              "webrtc.extended_filter" = false;
            };
          };
        }
      ];
    };

    # Шаг 2: шумоподавление (RNNoise), моно → стерео
    extraConfig.pipewire."61-rnnoise" = {
      "context.modules" = [
        {
          name = "libpipewire-module-filter-chain";
          args = {
            "node.description" = "Микрофон (эхо + шумоподавление)";
            "media.name" = "Микрофон (эхо + шумоподавление)";
            "filter.graph" = {
              nodes = [
                {
                  type = "ladspa";
                  name = "rnnoise";
                  plugin = "${pkgs.rnnoise-plugin}/lib/ladspa/librnnoise_ladspa.so";
                  label = "noise_suppressor_mono";
                  control = {
                    "VAD Threshold (%)" = 50.0;
                    "VAD Grace Period (ms)" = 200;
                    "Retroactive VAD Grace (ms)" = 0;
                  };
                }
                # Копируем обработанный моно-сигнал в левый и правый каналы
                { type = "builtin"; name = "copyL"; label = "copy"; }
                { type = "builtin"; name = "copyR"; label = "copy"; }
              ];
              links = [
                { output = "rnnoise:Output"; input = "copyL:In"; }
                { output = "rnnoise:Output"; input = "copyR:In"; }
              ];
              inputs = [ "rnnoise:Input" ];
              outputs = [ "copyL:Out" "copyR:Out" ];
            };
            "capture.props" = {
              "node.name" = "capture.rnnoise_source";
              "node.passive" = true;
              "audio.rate" = 48000;
              "audio.channels" = 1;
              "audio.position" = [ "MONO" ];
              "target.object" = "echo-cancel-source";
            };
            "playback.props" = {
              "node.name" = "rnnoise_source";
              "media.class" = "Audio/Source";
              "audio.rate" = 48000;
              "audio.channels" = 2;
              "audio.position" = [ "FL" "FR" ];
            };
          };
        }
      ];
    };
  };
}
