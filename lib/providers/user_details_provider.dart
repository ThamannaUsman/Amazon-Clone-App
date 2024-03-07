import 'package:amazon_app/models/user_details_model.dart';
import 'package:amazon_app/resources/cloudfirestore_method.dart';
import 'package:flutter/material.dart';

class UserDetailsProvider with ChangeNotifier {
  UserDetailsModel userDetails;

  UserDetailsProvider()
      : userDetails = UserDetailsModel(name: "Loading", address: "Loading");

  Future getData() async {
    userDetails = await CloudFireStoreClass().getNameAndAddress();
    notifyListeners();
  }
}
