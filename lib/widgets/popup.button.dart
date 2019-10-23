import 'package:flutter/material.dart';

class PopupButton extends StatefulWidget {
  final Function onTap;
  final Color color;
  final String label;
  final String labelLoading;
  final bool isLoading;

  PopupButton(
      {Key key,
      this.onTap,
      this.color = Colors.blueGrey,
      this.isLoading = false,
      this.labelLoading,
      this.label = "Button"})
      : super(key: key);

  @override
  _PopupButtonState createState() => _PopupButtonState();
}

class _PopupButtonState extends State<PopupButton> {
  final Duration transition = Duration(milliseconds: 2500);
  Color loadingColor = Colors.transparent;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (this.widget.isLoading) {
      this.animateLoading();
    }
  }

  @override
  void didUpdateWidget(PopupButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (this.widget.isLoading && !oldWidget.isLoading) {
      this.animateLoading();
    }
  }

  animateLoading() {
    this.setState(() {
      this.loadingColor = Colors.white54;
    });

    Future.delayed(transition, () {
      this.setState(() {
        this.loadingColor = Colors.transparent;
      });

      Future.delayed(transition, () {
        if (this.widget.isLoading) {
          this.animateLoading();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
          onTap: () {
            if (this.widget.isLoading) {
              return;
            }
            if (this.widget.onTap != null) {
              this.widget.onTap();
            }
          },
          child: Stack(alignment: Alignment.center, children: <Widget>[
            Container(
                width: MediaQuery.of(context).size.width * 0.7,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: this.widget.color,
                    borderRadius: BorderRadius.circular(7)),
                child: Text(
                    (this.widget.isLoading && this.widget.labelLoading != null)
                        ? this.widget.labelLoading
                        : this.widget.label,
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Colors.white,
                        fontSize: 16,
                        decoration: TextDecoration.none))),
            AnimatedContainer(
                width: MediaQuery.of(context).size.width * 0.7,
                height: 50,
                decoration: BoxDecoration(
                    color: this.loadingColor,
                    borderRadius: BorderRadius.circular(7)),
                duration: transition)
          ])),
    );
  }
}
