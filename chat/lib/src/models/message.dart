//@dart=2.9
//  The comment above this one forces the dart compiler to use a specific version, that is 2.9

// This dart file represents the model that is to represent the message stored in the database in addition to the functions used to efficiently use the model

import 'package:flutter/foundation.dart'; // import the foundation library to use the @required attribute

// the message class represents the message object

class Message {
  String get id => _id;          // this is the getter that returns the message id
  final String from;            //  This attribute represents the sender of the message
  final String to;             //   This attribute represents the reciever of the message
  final DateTime timestamp;   //    This attribute represents the timestamp when the message was sent
  final String contents;     //     This attribute represents the contents of the message be it text, video or image
  String _id;               //      This attribute represents the id that is unique to the message

 // This is the message object constructor used to create a new message across the application

  Message({
    @required this.from,
    @required this.to,
    @required this.timestamp,
    @required this.contents,
  });

 // This is a method that takes the message object and its associated data and converts it to a json object to easily write it to the database

  toJson() => {
        'from': this.from,
        'to': this.to,
        'timestamp': this.timestamp,
        'contents': this.contents
      };
 
 // This is a factory that constructs message objects from a json object that represents a message

  factory Message.fromJson(Map<String, dynamic> json) {
    var message = Message(
        from: json['from'],
        to: json['to'],
        contents: json['contents'],
        timestamp: json['timestamp']);

    message._id = json['id'];
    return message;
  }
}
