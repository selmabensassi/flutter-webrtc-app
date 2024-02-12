import 'dart:convert';

import 'package:flutter_webrtc_app/utils/user.utils.dart';
import 'package:http/http.dart' as http;

String MEETING_API_URL = 'http://192.168.1.16:52390/api/meeting';

var client = http.Client();

Future<http.Response?> startMeeting() async {
  Map<String, String> requestHeaders = {'Content-type': 'application/json'};

  var userId = await loadUserId();

  var response = await client.post(Uri.parse('$MEETING_API_URL/start'),
      headers: requestHeaders,
      body: jsonEncode({'hostId': userId, 'hostName': ''}));

  if (response.statusCode == 200) {
    return response;
  } else {
    return null;
  }
}

Future<http.Response?> joinMeeting(String meetingId) async {
  final uri = Uri.parse('http://192.168.1.16:52390/joinMeeting')
      .replace(queryParameters: {
    'id': meetingId, // Ensure the 'id' parameter is correctly included
  });

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    print("Successfully joined the meeting");
    return response;
    
  } else {
    print("Failed to join the meeting");
    return null;
   
  }
}

// Future<void> startOrJoinMeeting(String meetingId) async {
//   final response = meetingId.isEmpty
//       ? await startMeeting() // This should retrieve and return a meeting ID
//       : await joinMeeting(meetingId);
//   if (response != null && response.statusCode == 200) {
//     final meetingDetails = jsonDecode(response.body);
//   } else {}
// }
