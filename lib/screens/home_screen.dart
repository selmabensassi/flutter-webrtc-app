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

  Widget formUI() {
    return Center(
        child: Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Welcome to the Syndicate",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 25)),
          const SizedBox(height: 20),
          FormHelper.inputFieldWidget(
            context,
            "meetingId",
            "Enter your Meeting Id",
            (val) => val.isEmpty ? "Meeting Id can't be empty" : null,
            (onSaved) => meetingId = onSaved,
            borderRadius: 10,
            borderFocusColor: Colors.redAccent,
            borderColor: Colors.redAccent,
            hintColor: Colors.grey,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: FormHelper.submitButton(
                  "Join Meeting",
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
                    try {
                      var response = await startMeeting();
                      if (response != null && response.statusCode == 200) {
                        final body = json.decode(response.body);
                        final meetId = body['data'][
                            'meetingId']; // Ensure this matches the backend response structure
                        validateMeeting(meetId);
                      } else {
                        // Handle non-200 responses or add error handling here
                        print("Failed to start meeting: ${response?.body}");
                      }
                    } catch (err) {
                      print("Error starting meeting: $err");
                    }
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
      Response? response = await joinMeeting(meetingId);
      if (response?.statusCode == 200) {
        var data = json.decode(response!.body);
        final meetingDetails = MeetingDetail.fromJson(data["data"]);
        goToJoinScreen(meetingDetails);
      } else {
        // Implement user-friendly error handling
        print("Failed to join meeting: ${response?.body}");
        showErrorDialog("Failed to join meeting.");
      }
    } catch (err) {
      print("Error occurred: $err");
      showErrorDialog("An error occurred: $err");
    }
  }

  void goToJoinScreen(MeetingDetail meetingDetail) {
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
      form.save();
      return true;
    }
    return false;
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text("Ok"),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }
}
