import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

@protected
class Report {
  final String bugReportServer;
  final String bugReportKey;
  Report(this.bugReportServer, this.bugReportKey);

  Future<int> sendReport(String message, String image) async {
    debugPrint("[Sending Report] [${this.bugReportKey}] - $message");

    var url = '$bugReportServer/new-report';
    var _headers = Map<String, String>();

    _headers["Content-Type"] = "application/json";

    var response = await http.post(url,
        headers: _headers,
        body: json.encode(
            {'key': this.bugReportKey, 'message': message, 'image': image}));

    return response.statusCode;
  }
}
