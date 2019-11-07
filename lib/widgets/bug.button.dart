import 'package:flutter/material.dart';

class BugButton extends StatefulWidget {
  final Function onTap;
  final Function onLongPress;

  BugButton({Key key, this.onTap, this.onLongPress}) : super(key: key);

  @override
  _BugButtonState createState() => _BugButtonState();
}

class _BugButtonState extends State<BugButton> {
  double xPos = 20;
  double yPos = 20;

  handleDrop(DraggableDetails details) {
    this.setState(() {
      this.xPos = details.offset.dx;
      this.yPos = details.offset.dy;
    });
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();

    this.setState(() {
      xPos = MediaQuery.of(context).size.width - 40;
      yPos = MediaQuery.of(context).size.height * 0.07;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      transform: Matrix4.translationValues(xPos, yPos, 0),
      child: Draggable(
        feedback: buildBugButton(),
        child: buildBugButton(),
        childWhenDragging: Container(),
        onDragEnd: this.handleDrop,
      ),
    );
  }

  buildBugButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onLongPress: () {
          if (this.widget.onLongPress != null) {
            this.widget.onLongPress();
          }
        },
        onTap: () {
          if (this.widget.onTap != null) {
            this.widget.onTap();
          }
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
