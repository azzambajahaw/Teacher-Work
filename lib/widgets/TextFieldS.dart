import 'package:flutter/material.dart';

class TextFields extends StatelessWidget {
  TextFields({Key? key, required this.controller, required this.textinput, required this.obsuc, required this.hitext}) : super(key: key);
  final TextEditingController controller;
  final TextInputType textinput;
  final bool obsuc;
  final String hitext;
  get text => null;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.only(top: 1, left: 15),
      decoration: BoxDecoration(
          color:Color.fromRGBO(251,255,255, 1),
          borderRadius: BorderRadius.circular(6),
          boxShadow: [ BoxShadow( color: Color.fromRGBO(73, 105,137,1).withOpacity(0.1),
      blurRadius: 7,
    ),], // boxshadow
    ), // boxdecoration
    child: TextFormField(
    controller: controller,
    keyboardType:textinput,
    obscureText: obsuc,
    decoration: InputDecoration(
        hintText: hitext,
        border: InputBorder.none,
    contentPadding: EdgeInsets.all(0),
    hintStyle: TextStyle(
    height: 1,)
    ),),);
  }
}
