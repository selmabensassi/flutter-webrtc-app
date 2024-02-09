import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_webrtc_app/models/meeting_details.dart';
import 'package:flutter_webrtc_app/screens/home_screen.dart';
import 'package:flutter_webrtc_app/utils/user.utils.dart';
import 'package:flutter_webrtc_app/widgets/control_panal.dart';
import 'package:flutter_webrtc_app/widgets/remote_connection.dart';
import 'package:flutter_webrtc_wrapper/flutter_webrtc_wrapper.dart';

class MeetingPage extends StatefulWidget {
  const MeetingPage(
      {super.key, this.meetingId, this.name, required this.meetingDetail});

  final String? meetingId;
  final String? name;
  final MeetingDetail meetingDetail;

  @override
  State<MeetingPage> createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> {
  final _localRendere = RTCVideoRenderer();
  final Map<String, dynamic> mediaConstraints = {"audio": true, "video": true};
  bool isConnectionFailed = false;
  WebRTCMeetingHelper? meetingHelper;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: _buildMeetingRoom(),
      bottomNavigationBar: ControlePanal(
        onAudioToggle: onAudiotoggle,
        onVideoToggle: onVideoToggle,
        videoEnaabled: isVideoEnabled(),
        audioEnabled: isAudioEnable(),
        isConnectionFailed: isConnectionFailed,
        onReconnect: handleReconnect(),
        OnMeetingEnd: onMeetingEnd,
      ),
    );
  }

  void startMeeting() async {
    final String userId = await loadUserId();
    meetingHelper = WebRTCMeetingHelper(
      url: 'http://192.168.1.13:4000',
      meetingId: widget.meetingDetail.id,
      userId: userId,
      name: widget.name,
    );
    MediaStream _localStream =
        await navigator.mediaDevices.getUserMedia(mediaConstraints);

    _localRendere.srcObject = _localStream;
    meetingHelper!.stream = _localStream;

    meetingHelper!.on("open", context, (ev, context) {
      setState(() {
        isConnectionFailed = false;
      });
    });
    meetingHelper!.on("connection", context, (ev, context) {
      setState(() {
        isConnectionFailed = false;
      });
    });
    meetingHelper!.on("user-left", context, (ev, context) {
      setState(() {
        isConnectionFailed = false;
      });
    });
    meetingHelper!.on("video-toggle", context, (ev, context) {
      setState(() {});
    });
    meetingHelper!.on("audio-toggle", context, (ev, context) {
      setState(() {});
    });

    meetingHelper!.on("meeting-ended", context, (ev, context) {
      onMeetingEnd();
    });
    meetingHelper!.on("connection-setting-changed", context, (ev, context) {
      setState(() {
        isConnectionFailed = false;
      });
    });
    meetingHelper!.on("stream-changed", context, (ev, context) {
      setState(() {
        isConnectionFailed = false;
      });
    });

    setState(() {});
  }

  initRenderes() async {
    await _localRendere.initialize();
  }

  @override
  void initState() {
    super.initState();
    initRenderes();
    startMeeting();
  }

  @override
  void deactivate() {
    super.deactivate();
    _localRendere.dispose();
    if (meetingHelper != null) {
      meetingHelper!.destroy();
      meetingHelper = null;
    }
  }

  void onMeetingEnd() {
    if (meetingHelper != null) {
      meetingHelper!.endMeeting();
      meetingHelper = null;
      goToHomePAge();
    }
    ;
  }

  void goToHomePAge() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const HomeScreen()));
  }

  _buildMeetingRoom() {
    return Stack(
      children: [
        meetingHelper != null && meetingHelper!.connections.isNotEmpty
            ? GridView.count(
                crossAxisCount: meetingHelper!.connections.length < 3 ? 1 : 2,
                children:
                    List.generate(meetingHelper!.connections.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.all(1),
                    child: RemoteConnection(
                      renderer: meetingHelper!.connections[index].renderer,
                      connection: meetingHelper!.connections[index],
                    ),
                  );
                }),
              )
            : const Center(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Waiting foe participants to join th meeting",
                    style: TextStyle(color: Colors.grey, fontSize: 24),
                  ),
                ),
              ),
        Positioned(
          bottom: 10,
          right: 0,
          child: SizedBox(
            width: 150,
            height: 200,
            child: RTCVideoView(_localRendere),
          ),
        )
      ],
    );
  }

  void onAudiotoggle() {
    if (meetingHelper != null) {
      setState(() {
        meetingHelper!.toggleAudio();
      });
    }
  }

  void onVideoToggle() {
    if (meetingHelper != null) {
      setState(() {
        meetingHelper!.toggleVideo();
      });
    }
  }

  bool isVideoEnabled() {
    return meetingHelper != null ? meetingHelper!.audioEnabled! : false;
  }

  bool isAudioEnable() {
    return meetingHelper != null ? meetingHelper!.videoEnabled! : false;
  }

  handleReconnect() {
    if (meetingHelper != null) {
      meetingHelper!.reconnect();
    }
  }
}
