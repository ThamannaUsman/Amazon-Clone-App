import 'dart:math';
import 'dart:typed_data';

import 'package:amazon_app/utils/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';


class Utils {
  Size getScreenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }
  showSnackBar({required BuildContext context,required String content}){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.orange,
          shape:const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10)
            )
          ),
          content:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(content),
            ],
          ) )
    );
  }
  Future<Uint8List?> pickImage() async{
    ImagePicker picker=ImagePicker();
   XFile? file= await picker.pickImage(source: ImageSource.gallery);
    return file!.readAsBytes();
  }
  String getUid(){
    return (100000+Random().nextInt(10000)).toString();
  }
  void flutterToast(String text) {
    Fluttertoast.showToast(
        msg: text,
        backgroundColor: yellowColor,
        textColor: Colors.white,
        timeInSecForIosWeb: 4,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_SHORT,
        fontSize: 15);
  }
}