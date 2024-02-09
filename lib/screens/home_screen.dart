import 'package:flutter/material.dart';
import 'package:flutter_webrtc_app/api/meeting_api.dart';
import 'package:flutter_webrtc_app/models/meeting_details.dart';
import 'package:flutter_webrtc_app/screens/join_screen.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'dart:convert';
import 'package:http/http.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  String meetingId = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Syndicate"),
          backgroundColor: Colors.redAccent,
        ),
        body: Form(
          key: globalKey,
          child: formUI(),
        ));
  }

  formUI() {
    return Center(
        child: Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("welcome to the syndicate",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
              )),
          const SizedBox(
            height: 20,
          ),
          FormHelper.inputFieldWidget(
            context,
            "meetingId",
            "Enter your Meeting Id",
            (val) {
              if (val.isEmpty) {
                return "Meeting Id can't be empty";
              }
              return null;
            },
            (onSaved) {
              meetingId = onSaved;
            },
            borderRadius: 10,
            borderFocusColor: Colors.redAccent,
            borderColor: Colors.redAccent,
            hintColor: Colors.grey,
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: FormHelper.submitButton(
                  "join Meeting",
                  () {
                    if (validateAndSave()) {
                      validateMeeting(meetingId);
                    }
                  },
                ),
              ),
              Flexible(
                child: FormHelper.submitButton(
                  "Start Meeting",
                  () async {
                    var response = await startMeeting();
                    final body = json.decode(response!.body);
                    final meetId = body['data'];
                    ;
                    validateMeeting(meetId);
                  },
                ),
              )
            ],
          )
        ],
      ),
    ));
  }

  void validateMeeting(String meetingId) async {
    try {
      Response response = await joinMeeting(meetingId);
      print("Network request status code: ${response.statusCode}"); // Debug response
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        final meetingDetails = MeetingDetail.fromJson(data["data"]);
        goToJoinScreen(meetingDetails);
      } else {
        print("Failed to join meeting: ${response.body}");
        // Handle failure case
      }
    } catch (err) {
      print("Error occurred: $err"); // Log any errors
    }
  }

  goToJoinScreen(MeetingDetail meetingDetail) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => JoinScreen(meetingDetail: meetingDetail),
      ),
    );
  }

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form != null && form.validate()) {
      form.save(); // This calls the onSaved method on each form field
      return true; // Indicates form is valid and data is saved
    }
    return false; // Indicates form is invalid
  }
}
