
import 'package:flutter/material.dart';

class CustomTextFiled extends StatefulWidget {
  final String hint;
  final IconData icon;
  final String error;
  const CustomTextFiled({Key? key,
  required this.hint,
  required this.icon,
  required this.error,})
   : super(key: key);

  @override
  State<CustomTextFiled> createState() => _CustomTextFiledState();
}

class _CustomTextFiledState extends State<CustomTextFiled> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),        
        filled: true,
        fillColor: Colors.white,
        border: const OutlineInputBorder(),
        hintText: widget.hint,

      )
    );
  }
}
class TextFieldWidget{
  static Widget base({
    required ValueChanged<String> onChanged,
    required onTap,
    TextEditingController? controller,
    FocusNode? focusNode,   
    InputDecoration? decoration,
    TextInputAction? textInputAction,
    TextStyle? style,    
    TextInputType? textInputType,
    String? hint,
    IconData? icon,
    String? error,
    bool isValidation = false,
  }
  ){
    return TextField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),        
        filled: true,
        fillColor: Colors.white,
        border: const OutlineInputBorder(),
        hintText: hint,
        prefixIcon: Icon(icon),
        errorText: !isValidation ? error : null,
        ),    
        
    );
    
  }
  
}