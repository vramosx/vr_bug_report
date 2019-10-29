library vr_bug_report;

import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:vr_bug_report/configuration.dart';
import 'package:vr_bug_report/report.dart';
import 'package:vr_bug_report/screens/feedback.screen.dart';
import 'package:vr_bug_report/widgets/bug.button.dart';

class VRBugReport extends StatefulWidget {
  final String bugReportKey;
  final String bugReportServer;
  final Widget child;

  VRBugReport(
      {Key key,
      @required this.bugReportKey,
      @required this.bugReportServer,
      this.child})
      : super(key: key);

  @override
  _VRBugReportState createState() => _VRBugReportState();
}

class _VRBugReportState extends State<VRBugReport> {
  var scr = new GlobalKey();

  double notificationPosY = -100;
  Uint8List imageBytes;
  String base64Image;
  bool showReportScreen = false;
  bool sending = false;
  TextEditingController textController;
  bool showMessage = false;
  double navOpacity = 0;
  bool showNavigation = false;
  Widget screen;
  bool changeWidget = false;

  var txtStyle = const TextStyle(
      color: Colors.blueAccent, fontSize: 25, decoration: TextDecoration.none);

  @override
  void initState() {
    super.initState();

    Configuration.bugReportKey = this.widget.bugReportKey;
    Configuration.bugReportServer = this.widget.bugReportServer;
  }

  takeScreenshot() async {
    RenderRepaintBoundary boundary = scr.currentContext.findRenderObject();
    var image = await boundary.toImage();
    var byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    var pngBytes = byteData.buffer.asUint8List();

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return FeedbackScreen(
          pngBytes: pngBytes, sendFeedback: this.sendFeedback);
    }));
  }

  sendFeedback(String email, String desc, Uint8List image) async {
    var base64Image = base64Encode(image);

    if (!this.sending) {
      this.sending = true;

      String text = "E-mail: $email\nDescrição: $desc";

      var report =
          new Report(Configuration.bugReportServer, Configuration.bugReportKey);
      var sendStatus = await report.sendReport(text, base64Image);

      if (sendStatus == 200) {
        this.sending = false;
        this.setState(() {
          this.showMessage = true;
          this.notificationPosY = 0;
          this.showNavigation = false;
        });

        await Future.delayed(Duration(seconds: 2));

        this.setState(() {
          this.notificationPosY = -100;
        });

        await Future.delayed(Duration(milliseconds: 300));

        this.setState(() {
          this.showMessage = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(children: <Widget>[
            RepaintBoundary(key: scr, child: this.widget.child),
            BugButton(onTap: () {
              this.takeScreenshot();
            }),
            (this.showNavigation ? this.screen : Container()),
            (this.showMessage
                ? AnimatedContainer(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.black87,
                    alignment: Alignment.center,
                    height: 90,
                    transform:
                        Matrix4.translationValues(0, this.notificationPosY, 0),
                    duration: Duration(milliseconds: 300),
                    child: Text("Enviado! Obrigado.",
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'Roboto')))
                : Container())
          ]),
        ));
  }
}

/* Column(children: <Widget>[
            Text("Reportar um Bug",
                style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 25,
                    decoration: TextDecoration.none)),
            Image.memory(imageBytes)
          ])*/
