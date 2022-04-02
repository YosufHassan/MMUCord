//@dart = 2.9
// ignore: import_of_legacy_library_into_null_safe
import 'dart:io';
import 'package:dio/dio.dart';
// ignore: unused_import
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:mmucord/states_management/profile_screen/analytics_state.dart';


class SentCount{
  final String serverUrl;
  final String userId;

  SentCount(this.serverUrl,this.userId);

  Future<String> countSent(String id) async{
    var dio = Dio();
    dio.options.baseUrl = serverUrl;
    var route = '/sentcount/$userId';
    final response = await dio.get(route);
    return response.data;
  }
}

class RecvCount{
  final String serverUrl;
  final String userId;

  RecvCount(this.serverUrl,this.userId);

  Future<String> countRecv(String id) async{
    var dio = Dio();
    dio.options.baseUrl = serverUrl;
    var route = '/recvcount/$userId';
    final response = await dio.get(route);
    return response.data;
  }
}

class Countunread{
  final String serverUrl;
  final String userId;

  Countunread(this.serverUrl,this.userId);

  Future<String> countUnread(String id) async{
    var dio = Dio();
    dio.options.baseUrl = serverUrl;
    var route = '/countunread/$userId';
    final response = await dio.get(route);
    return response.data;
  }
}

class Chatcount{
  final String serverUrl;
  final String userId;

  Chatcount(this.serverUrl,this.userId);

  Future<String> chatCount(String id) async{
    var dio = Dio();
    dio.options.baseUrl = serverUrl;
    var route = '/chatcount/$userId';
    final response = await dio.get(route);
    return response.data;
  }
}

class ChatActive{
  final String serverUrl;
  final String userId;

  ChatActive(this.serverUrl,this.userId);

  Future<String> chatActive(String id) async{
    var dio = Dio();
    dio.options.baseUrl = serverUrl;
    var route = '/chatactive/$userId';
    final response = await dio.get(route);
    return response.data;
  }
}