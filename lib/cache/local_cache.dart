//@dart = 2.9

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

// The Interface for the LocalCache class

abstract class ILocalCache {

  Future<void> save(String key, Map<String, dynamic> json);

  Map<String, dynamic> fetch(String key);
}

/* 
        LocalCache() Class

        Description:
        
                  A class that handles both retrieving and storing keys in the device's local storage

        Methods:

                  fetch:

                      Description:
        
                        A method that is used to retrieve the data stored in the local storage under a key

                      Parameters: 

                        1. Key : String 

                  save:

                      Description:
        
                        save data in local storage under a key
                      
                      Parameters:

                        1. Key: String
                        2. json: Map<String>
      */

class LocalCache implements ILocalCache {

  final SharedPreferences _sharedPreferences; // instantiate the shared prefrences class, the class that provide access to the local storage on device

  LocalCache(this._sharedPreferences); // The constructor of the LocalCache class

  @override
  Map<String, dynamic> fetch(String key) {
    return jsonDecode(_sharedPreferences.getString(key) ?? '{}'); // returns a json object representing the data stored under the key
  }

  @override
  Future<void> save(String key, Map<String, dynamic> json) async {
    await _sharedPreferences.setString(key, jsonEncode(json)); // parses the passed string and converts to json object and saves it under the key in local storage
  }
}