import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  MyButton({required this.buttonColor, required this.text, required this.textColor, required this.onPressed});
  Color buttonColor;
  String text;
  Function onPressed;
  Color textColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: buttonColor??Colors.blue,
          borderRadius: BorderRadius.circular(15)
      ),
      child: MaterialButton(onPressed:(){onPressed.call();},
        child: Text(text, style: TextStyle(color: textColor??Colors.white),),
        splashColor: Colors.white,),
    );
  }
}
