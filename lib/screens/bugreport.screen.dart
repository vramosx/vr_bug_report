import 'package:flutter/material.dart';
import 'package:vr_bug_report/screens/popup.template.dart';
import 'package:vr_bug_report/widgets/popup.button.dart';

class BugReportScreen extends StatefulWidget {
  final Function onChoose;
  BugReportScreen({Key key, this.onChoose}) : super(key: key);

  @override
  _BugReportScreenState createState() => _BugReportScreenState();
}

class _BugReportScreenState extends State<BugReportScreen> {
  var showPopup = true;
  bool sendingFeeback = false;
  TextEditingController textController;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return PopupTemplate(
      headerColor: Colors.red,
      headerIcon: Icons.bug_report,
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.70,
      show: this.showPopup,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Column(children: <Widget>[
              Text("Reportar um Bug",
                  style: TextStyle(
                      color: Colors.black87,
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      decoration: TextDecoration.none)),
              Container(
                margin: EdgeInsets.only(top: 5),
                child: Text("Qual problema que encontrou?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color(0xFFBEBEBE),
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        decoration: TextDecoration.none)),
              ),
            ]),
          ),
          Expanded(
            flex: 8,
            child: Container(
              child: Flex(direction: Axis.vertical, children: <Widget>[
                Expanded(
                  child: Material(
                    child: TextFormField(
                        minLines: 200,
                        maxLines: 200,
                        controller: textController,
                        decoration: InputDecoration(
                            alignLabelWithHint: true,
                            labelText: 'Descreva aqui:',
                            labelStyle: TextStyle(
                                color: Color(0xFFBEBEBE), fontSize: 14),
                            focusedBorder: InputBorder.none),
                        textInputAction: TextInputAction.newline),
                  ),
                )
              ]),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              margin: EdgeInsets.only(top: 20),
              child: Column(children: <Widget>[
                PopupButton(
                  onTap: () {
                    this.setState(() {
                      this.sendingFeeback = true;
                    });

                    if (this.widget.onChoose != null) {
                      this.widget.onChoose(0, textController.text);
                    }
                  },
                  isLoading: this.sendingFeeback,
                  labelLoading: 'Enviando...',
                  color: Colors.redAccent,
                  label: "Enviar",
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  child: PopupButton(
                    onTap: () {
                      this.setState(() {
                        this.showPopup = false;
                      });

                      Future.delayed(Duration(milliseconds: 300), () {
                        if (this.widget.onChoose != null) {
                          this.widget.onChoose(1, null);
                        }
                      });
                    },
                    color: Colors.grey,
                    label: "Cancelar",
                  ),
                )
              ]),
            ),
          )
        ],
      ),
    );
  }
}