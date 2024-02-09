import 'package:flutter/material.dart';

import 'package:snippet_coder_utils/FormHelper.dart';

class ControlePanal extends StatelessWidget {
  final bool? videoEnaabled;
  final bool? audioEnabled;
  final bool? isConnectionFailed;
  final VoidCallback? onVideoToggle;
  final VoidCallback? onAudioToggle;
  final VoidCallback? onReconnect;
  final VoidCallback? OnMeetingEnd;

  const ControlePanal(
      {this.videoEnaabled,
      this.audioEnabled,
      this.isConnectionFailed,
      this.onVideoToggle,
      this.onAudioToggle,
      this.onReconnect,
      this.OnMeetingEnd});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey[900],
      height: 60.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: buildControls(),
      ),
    );
  }

  List<Widget> buildControls() {
    if (!isConnectionFailed!) {
      return <Widget>[
        IconButton(
          onPressed: onVideoToggle,
          icon: Icon(videoEnaabled! ? Icons.videocam : Icons.videocam_off),
          color: Colors.white,
          iconSize: 32.0,
        ),
        IconButton(
          onPressed: onAudioToggle,
          icon: Icon(audioEnabled! ? Icons.mic : Icons.mic_off),
          color: Colors.white,
          iconSize: 32.0,
        ),
        const SizedBox(
          width: 25,
        ),
        Container(
          width: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.red,
          ),
          child: IconButton(
            icon: const Icon(
              Icons.call_end,
            ),
            onPressed: OnMeetingEnd!,
          ),
        )
      ];
    } else {
      return <Widget>[
        FormHelper.submitButton(
          "Reconnect",
          onReconnect!,
          btnColor: Colors.red,
          borderRadius: 10,
          width: 200,
          height: 40,
        )
      ];
    }
  }
}
