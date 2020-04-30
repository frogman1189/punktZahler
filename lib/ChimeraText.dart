/*
 Custom wrapper class that displays either a text widget or text field
 widget in order to reduce lag on web app with many text fields.

Needs to sort out default coloring
*/

import 'package:flutter/material.dart';

typedef dataUpdateCallback = void Function(String value);

class ChimeraText extends StatefulWidget {

  const ChimeraText({
      Key key,
      this.value = 'Default Value',
      this.callback,
      this.width = 200,
      this.padding = const EdgeInsets.all(6),
      this.decoration = const BoxDecoration(
          border: const Border(
            bottom: const BorderSide(
              width: 4,
              color: Colors.grey,
            ),
            left: const BorderSide(
              width: 2,
              color: Colors.grey
            ),
            right: const BorderSide(
              width: 2,
              color: Colors.grey
            )
          ),
          //color: Colors.green,
        ),
  }) : super(key: key);

  final BoxDecoration decoration;
  final EdgeInsets padding;
  final String value;
  final dataUpdateCallback callback;
  final width;
  
  @override _ChimeraText createState() => _ChimeraText();
}

class _ChimeraText extends State<ChimeraText> {
  bool _input = true;
  String value;
  dataUpdateCallback callback;

  // set inital state of ChimerText state
  @override
  void initState() {
    super.initState();
    value = widget.value;
  }

  void toggleForm() {
    _input = ! _input;
  }

  //wraps callback incase callback is null
  void callbackWrapper(String value) {
    if(widget.callback != null) {
      widget.callback(value);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    //return text if input true else return textfield.
    return _input ?
    GestureDetector(
      onTap: () {
          setState(() {
            _input = false;
        });
      },
      child: Container(
        width: widget.width,
        child: Text(value),
        padding: widget.padding,
        decoration: widget.decoration,
    ))
      :
      Container(
        width: widget.width,
        //child: TextField(controller: scoreTable[x][(index-1)~/2]),
        child: TextField(
          controller: TextEditingController(
            text: value,
          ),
          onSubmitted: (String val) {
            setState(() {
                _input = true;
                print("editing complete");
                value = val;
                callbackWrapper(value);
            });
          },
        ),
        padding: widget.padding,
        decoration: widget.decoration,
    );
    }
  }
