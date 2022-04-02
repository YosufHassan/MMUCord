//@dart=2.9

import 'package:equatable/equatable.dart';

// ignore: camel_case_types
abstract class analyticsState extends Equatable{}


// ignore: camel_case_types
class analyticsInitial extends analyticsState{


  analyticsInitial();
  
  @override
  List<Object> get props => [];
}

// ignore: camel_case_types
class analyticsSent extends analyticsState{

  final String sentcount;
  final String recvcount;
  final String unreadCount;
  //final String chatActive;
  final String chatCount;
  final int chatnum;
  final int activechats;
  final String busy;
  final String unread;
  
  analyticsSent(this.sentcount,this.recvcount, this.unreadCount,/*this.chatActive,*/this.chatCount,this.chatnum,this.activechats,this.busy,this.unread);
  
  @override
  List<Object> get props => [sentcount,recvcount,unreadCount,/*chatActive,*/chatCount,chatnum,activechats,busy,unread];
}