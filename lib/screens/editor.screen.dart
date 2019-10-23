import 'package:flutter/material.dart';

class EditorScreen extends StatefulWidget {
  EditorScreen({Key key}) : super(key: key);

  @override
  _EditorScreenState createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        height: MediaQuery.of(context).size.height * 0.82,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: MediaQuery.of(context).size.height * 0.12,
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  child: Icon(Icons.feedback, color: Colors.white, size: 45)),
              Container(
                  padding: EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: MediaQuery.of(context).size.height * 0.7,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text("Enviar um Feedback",
                          style: TextStyle(
                              color: Colors.black87,
                              fontFamily: 'Roboto',
                              fontSize: 16,
                              decoration: TextDecoration.none)),
                      Text("O que gostaria de dizer?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color(0xFFBEBEBE),
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              decoration: TextDecoration.none)),
                      Material(
                        child: TextFormField(
                          textInputAction: TextInputAction.done,
                          minLines: 10,
                          maxLines: 10,
                        ),
                      ),
                      Column(children: <Widget>[
                        buildButton(context, Colors.lightBlue, "Enviar", 0),
                        Container(
                            margin: EdgeInsets.only(top: 5),
                            child: buildButton(
                                context, Colors.grey, "Cancelar", 1)),
                      ])
                    ],
                  ))
            ]),
      ),
    );
  }

  Material buildButton(
      BuildContext context, Color bg, String label, int option) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: bg, borderRadius: BorderRadius.circular(7)),
            child: Text(label,
                style: TextStyle(
                    fontFamily: 'Roboto',
                    color: Colors.white,
                    fontSize: 16,
                    decoration: TextDecoration.none))),
      ),
    );
  }
}
