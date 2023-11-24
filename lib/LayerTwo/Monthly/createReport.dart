import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:student/LayerTwo/Monthly/thisCreate.dart';

class CreateReportPage extends StatefulWidget {
  @override
  _CreateReportPageState createState() => _CreateReportPageState();
}

class _CreateReportPageState extends State<CreateReportPage> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool isBold = false;
  bool isItalic = false;
  bool isUnderline = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            size: 25,
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black87.withOpacity(0.7), // Use the specified color
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Create Report',
          style: TextStyle(
              color: Colors.black87,
              fontSize: 30,
              fontWeight: FontWeight.w800,
              fontFamily: 'Futura'),
        ),
        backgroundColor: Colors.white70,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: const IconThemeData(
          color: Color.fromRGBO(148, 112, 18, 1),
          size: 30,
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              ThisCreate newCreate = ThisCreate(
                info: _textController.text,
              );
              Navigator.pop(context, ThisCreate);
              //final content = _textController.text;
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(
                      isBold ? Icons.format_bold : Icons.format_bold_outlined),
                  onPressed: () {
                    setState(() {
                      isBold = !isBold;
                    });
                    _applyTextStyle();
                  },
                ),
                IconButton(
                  icon: Icon(isItalic
                      ? Icons.format_italic
                      : Icons.format_italic_outlined),
                  onPressed: () {
                    setState(() {
                      isItalic = !isItalic;
                    });
                    _applyTextStyle();
                  },
                ),
                IconButton(
                  icon: Icon(isUnderline
                      ? Icons.format_underline
                      : Icons.format_underline_outlined),
                  onPressed: () {
                    setState(() {
                      isUnderline = !isUnderline;
                    });
                    _applyTextStyle();
                  },
                ),
              ],
            ),
            Expanded(
              child: TextField(
                controller: _textController,
                focusNode: _focusNode,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Write your report here...',
                ),
                onChanged: (text) {
                  _applyTextStyle();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _applyTextStyle() {
    final TextStyle textStyle = TextStyle(
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      decoration: isUnderline ? TextDecoration.underline : TextDecoration.none,
    );
    _textController.value = _textController.value.copyWith(
      text: _textController.text,
      selection: TextSelection.collapsed(offset: _textController.text.length),
      composing: TextRange.empty,
    );
    _textController.selection =
        TextSelection.collapsed(offset: _textController.text.length);
    _textController.selection =
        TextSelection.collapsed(offset: _textController.text.length);
    _textController.selection =
        TextSelection.collapsed(offset: _textController.text.length);
  }
}
