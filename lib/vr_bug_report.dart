library vr_bug_report;

import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:vr_bug_report/configuration.dart';
import 'package:vr_bug_report/report.dart';
import 'package:vr_bug_report/screens/bugreport.screen.dart';
import 'package:vr_bug_report/screens/choose.type.dart';
import 'package:vr_bug_report/screens/feedback.screen.dart';

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
  double xPos = 20;
  double yPos = 20;
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
    textController = TextEditingController();
    this.screen = ChooseTypeScreen(onChoose: this.chooseOption);

    Configuration.bugReportKey = this.widget.bugReportKey;
    Configuration.bugReportServer = this.widget.bugReportServer;
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();

    this.setState(() {
      xPos = MediaQuery.of(context).size.width - 40;
      yPos = MediaQuery.of(context).size.height * 0.07;
    });
  }

  takeScreenshot() async {
    RenderRepaintBoundary boundary = scr.currentContext.findRenderObject();
    var image = await boundary.toImage();
    var byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    var pngBytes = byteData.buffer.asUint8List();

    this.setState(() {
      imageBytes = pngBytes;
      showNavigation = true;
    });

    await Future.delayed(Duration(milliseconds: 300));

    this.setState(() {
      navOpacity = 1;
    });

    this.base64Image = base64Encode(pngBytes);
  }

  sendFeedback(String text, String image) async {
    if (!this.sending) {
      this.sending = true;

      var report =
          new Report(Configuration.bugReportServer, Configuration.bugReportKey);
      var sendStatus = await report.sendReport(text, image);

      if (sendStatus == 200) {
        this.sending = false;
        this.setState(() {
          this.showMessage = true;
          this.notificationPosY = 0;
          this.showNavigation = false;
          this.screen = ChooseTypeScreen(
            onChoose: this.chooseOption,
          );
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

  handleDrop(DraggableDetails details) {
    this.setState(() {
      this.xPos = details.offset.dx;
      this.yPos = details.offset.dy;
    });
  }

  feedbackChoose(option, text) {
    if (option == 0) {
      sendFeedback(text, this.base64Image);
      return;
    }

    // cancel
    if (option == 1) {
      this.setState(() {
        this.showNavigation = false;
        this.screen = ChooseTypeScreen(
          onChoose: this.chooseOption,
        );
      });
    }
  }

  chooseOption(index) {
    if (index == 0) {
      this.setState(() {
        this.screen = FeedbackScreen(
          onChoose: this.feedbackChoose,
        );
      });
    }

    if (index == 1) {
      this.setState(() {
        this.screen = BugReportScreen(
          onChoose: this.feedbackChoose,
        );
      });
    }

    if (index == 2) {
      this.setState(() {
        this.showNavigation = false;
        this.screen = ChooseTypeScreen(
          onChoose: this.chooseOption,
        );
      });
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
            Container(
              transform: Matrix4.translationValues(xPos, yPos, 0),
              child: Draggable(
                feedback: buildBugButton(),
                child: buildBugButton(),
                childWhenDragging: Container(),
                onDragEnd: this.handleDrop,
              ),
            ),
            (this.showNavigation
                ? BackdropFilter(
                    filter: ui.ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(color: Colors.black12, child: this.screen))
                : Container()),
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

  buildBugButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          this.takeScreenshot();
        },
        child: Opacity(
          opacity: 0.5,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.redAccent),
            child: Icon(Icons.bug_report, color: Colors.white),
          ),
        ),
      ),
    );
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
