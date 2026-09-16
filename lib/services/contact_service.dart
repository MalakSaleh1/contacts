import 'dart:async';
import 'dart:convert';

import 'package:contact/model/contact_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactService {


  Future<void> saveContacts(List<ContactModel> contact) async {
    final prefs=await SharedPreferences.getInstance();
    List<String> data=contact.map((c)=> jsonEncode(c.toJson())).toList();
    await prefs.setStringList("data", data);
  }


  Future<List<ContactModel>> loadContacts()async{
    final prefs=await SharedPreferences.getInstance();
    final List<String>? jsonList = prefs.getStringList("data");

    if (jsonList==null) return [];

    return jsonList.map((c) => ContactModel.fromJson(jsonDecode(c))).toList();

  }

  Future<void> clearContacts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("data");
  }



  









}