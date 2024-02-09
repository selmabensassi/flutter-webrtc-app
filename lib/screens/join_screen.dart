import 'package:flutter/material.dart';
import 'package:flutter_webrtc_app/models/meeting_details.dart';
import 'package:flutter_webrtc_app/screens/meeting_page.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class JoinScreen extends StatefulWidget {
  final MeetingDetail? meetingDetail;

  const JoinScreen({Key? key, this.meetingDetail}) : super(key: key);

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _userName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Join Syndicate Meeting"),
        backgroundColor: Colors.redAccent,
      ),
      body: Form(
        key: _formKey,
        child: _buildFormUI(),
      ),
    );
  }

  Widget _buildFormUI() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            FormHelper.inputFieldWidget(
              context,
              "userId",
              "Enter your Name",
              (val) {
                if (val.isEmpty) {
                  return "Name can't be empty";
                }
                return null;
              },
              (onSaved) {
                _userName = onSaved;
              },
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
                      _validateAndSave();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _validateAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      _navigateToMeetingPage();
    }
  }

  void _navigateToMeetingPage() {
    if (widget.meetingDetail != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MeetingPage(
            meetingId: widget.meetingDetail!.id,
            name: _userName,
            meetingDetail: widget.meetingDetail!,
          ),
        ),
      );
    } else {
      // Handle null meeting detail scenario
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Meeting detail is missing'),
        ),
      );
    }
  }
}
