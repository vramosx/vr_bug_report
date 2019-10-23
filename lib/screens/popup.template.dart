import 'package:flutter/material.dart';

@protected
class PopupTemplate extends StatefulWidget {
  final Widget child;
  final double height;
  final double width;
  final bool show;
  final Color headerColor;
  final IconData headerIcon;

  PopupTemplate(
      {Key key,
      this.child,
      this.height = 200,
      this.width = 200,
      this.headerColor = Colors.blueAccent,
      this.headerIcon = Icons.help_outline,
      this.show = false})
      : super(key: key);

  @override
  _PopupTemplateState createState() => _PopupTemplateState();
}

class _PopupTemplateState extends State<PopupTemplate> {
  double posY = 0;
  double opacity = 0;

  @override
  void initState() {
    super.initState();
    this.posY = this.widget.height;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (this.widget.show) {
      this.setState(() {
        this.posY = 0;
        this.opacity = 1;
      });
    }
  }

  @override
  void didUpdateWidget(PopupTemplate oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!oldWidget.show && this.widget.show) {
      this.setState(() {
        this.posY = 0;
        this.opacity = 1;
      });
    } else if (oldWidget.show && !this.widget.show) {
      this.setState(() {
        this.posY = this.widget.height;
        this.opacity = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: this.opacity,
      duration: Duration(milliseconds: 300),
      child: AnimatedContainer(
        transform: Matrix4.translationValues(0, this.posY, 0),
        duration: Duration(milliseconds: 300),
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  width: this.widget.width,
                  height: MediaQuery.of(context).size.height * 0.12,
                  decoration: BoxDecoration(
                      color: this.widget.headerColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  child: Icon(this.widget.headerIcon,
                      color: Colors.white, size: 45)),
              Container(
                  padding: EdgeInsets.all(20),
                  width: this.widget.width,
                  height: this.widget.height,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                  child: this.widget.child)
            ]),
      ),
    );
  }
}
