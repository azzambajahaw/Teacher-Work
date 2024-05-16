import 'package:flutter/material.dart';

class ButtonS extends StatelessWidget {
  const ButtonS({Key? key, this.ButtonText, required this.onTap}) : super(key: key);
  final String? ButtonText ;
  final VoidCallback onTap ;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: 45,
        decoration: BoxDecoration(
          color: Color.fromRGBO(73, 105,137,1),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
            )
          ]
        ),
        child: Text(ButtonText! ,style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),),
      ),
    );
  }
}
