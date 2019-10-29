import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:vr_bug_report/screens/image.editor.dart';

class FeedbackScreen extends StatefulWidget {
  final Uint8List pngBytes;
  final Function sendFeedback;

  FeedbackScreen({Key key, this.pngBytes, this.sendFeedback}) : super(key: key);

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  var showPopup = true;
  bool firstTime = true;
  bool sendingFeeback = false;
  TextEditingController emailController;
  TextEditingController descController;
  FocusNode emailFocus;
  Uint8List actualImage;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    descController = TextEditingController();
    emailFocus = new FocusNode(canRequestFocus: true);

    actualImage = this.widget.pngBytes;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (firstTime) {
      firstTime = false;
      FocusScope.of(context).requestFocus(emailFocus);
    }
  }

  doneEditing(newImage) {
    this.setState(() {
      this.actualImage = newImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.send),
              tooltip: 'Enviar',
              onPressed: () {
                if (this.widget.sendFeedback != null) {
                  this.widget.sendFeedback(this.emailController.text,
                      this.descController.text, this.actualImage);
                  Navigator.of(context).pop();
                }
              },
            )
          ],
          centerTitle: true,
          title: Text("Reportar um bug",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Roboto Regular")),
          iconTheme: IconThemeData(color: Colors.blue),
          elevation: 0,
          bottom: PreferredSize(
              preferredSize: Size(double.infinity, 1),
              child: Container(
                  width: double.infinity, height: 1, color: Color(0xFFDEDEDE))),
          backgroundColor: Color(0xFFEEEEEE),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                focusNode: emailFocus,
                autovalidate: true,
                controller: emailController,
                validator: (text) {
                  if (text == "") {
                    return "Seu e-mail não pode estar em branco";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFDEDEDE))),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)),
                    labelStyle: TextStyle(color: Color(0xFFDDDDDD)),
                    labelText: "Insira seu e-mail"),
              ),
              TextFormField(
                minLines: 5,
                maxLines: 5,
                controller: descController,
                autovalidate: true,
                validator: (text) {
                  if (text == "") {
                    return "A descrição não pode estar vazia!";
                  }
                  if (text.length < 15) {
                    return "Descreva o problema com mais detalhes";
                  }
                  return null;
                },
                style: TextStyle(fontSize: 14),
                decoration: InputDecoration(
                    alignLabelWithHint: true,
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFDEDEDE))),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)),
                    hasFloatingPlaceholder: false,
                    labelStyle: TextStyle(color: Color(0xFFDDDDDD)),
                    labelText:
                        "Por favor, seja o mais detalhista possível.\nO que você esperava e o que aconteceu?"),
              ),
              AttachmentImage(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return ImageEditorScreen(
                        backgroundImage: Image.memory(actualImage),
                        doneEditing: this.doneEditing,
                      );
                    }));
                  },
                  actualImage: actualImage)
            ],
          ),
        ));
  }
}

class AttachmentImage extends StatelessWidget {
  final Function onTap;

  const AttachmentImage({
    Key key,
    this.onTap,
    @required this.actualImage,
  }) : super(key: key);

  final Uint8List actualImage;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (this.onTap != null) {
          this.onTap();
        }
      },
      child: Container(
        margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
            border: Border.all(color: Color(0xFFDEDEDE)),
            borderRadius: BorderRadius.circular(7)),
        width: MediaQuery.of(context).size.width * 0.2,
        height: MediaQuery.of(context).size.height * 0.2,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(alignment: Alignment.center, children: <Widget>[
              Image.memory(this.actualImage),
              Container(
                  decoration: BoxDecoration(
                      color: Color(0x99DEDEDE),
                      borderRadius: BorderRadius.circular(50)),
                  padding: EdgeInsets.all(5),
                  child: Icon(Icons.edit))
            ])),
      ),
    );
  }
}
