import 'package:flutter/material.dart';
import 'package:vr_bug_report/screens/popup.template.dart';
import 'package:vr_bug_report/widgets/popup.button.dart';

class ChooseTypeScreen extends StatefulWidget {
  final Function onChoose;

  ChooseTypeScreen({Key key, this.onChoose}) : super(key: key);

  @override
  _ChooseTypeScreenState createState() => _ChooseTypeScreenState();
}

class _ChooseTypeScreenState extends State<ChooseTypeScreen> {
  bool showPopup = true;

  chooseOption(index) {
    this.setState(() {
      this.showPopup = false;
    });

    Future.delayed(Duration(milliseconds: 300), () {
      if (this.widget.onChoose != null) {
        this.widget.onChoose(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          this.setState(() {
            this.showPopup = false;
          });

          Future.delayed(Duration(milliseconds: 300), () {
            if (this.widget.onChoose != null) {
              this.widget.onChoose(2);
            }
          });
        },
        child: PopupTemplate(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.4,
            show: this.showPopup,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("O que deseja fazer?",
                      style: TextStyle(
                          color: Colors.black87,
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          decoration: TextDecoration.none)),
                  Text("Você pode enviar um feedback ou reportar um bug.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color(0xFFBEBEBE),
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          decoration: TextDecoration.none)),
                  Column(children: <Widget>[
                    PopupButton(
                      onTap: () {
                        this.chooseOption(0);
                      },
                      color: Colors.blueGrey,
                      label: "Enviar um Feedback",
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: PopupButton(
                        onTap: () {
                          this.chooseOption(1);
                        },
                        color: Colors.redAccent,
                        label: "Reportar um Bug",
                      ),
                    )
                  ]),
                ])));
  }
}
