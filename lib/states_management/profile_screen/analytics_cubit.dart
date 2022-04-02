//@dart=2.9

// ignore_for_file: camel_case_types

import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:mmucord/data/services/analyticsService.dart';
import 'package:mmucord/states_management/profile_screen/analytics_state.dart';
import 'package:mmucord/view_models/analytics_view_model.dart';

class analyticsCubit extends Cubit<analyticsState>{
  final User user;
  final SentCount _sentCount;
  final RecvCount _recvCount;
  final Chatcount _chatcount;
  //final ChatActive _chatActive;
  final Countunread _countUnread;
  final AnalyticsViewModel analyticsViewModel;

  analyticsCubit(this.user, this._sentCount, this._recvCount, this._chatcount, /*this._chatActive,*/ this._countUnread, this.analyticsViewModel) : super(analyticsInitial());

  
  Future<void> analyticsSent1(String baseUrl,String id)async {
    final sent = await _sentCount.countSent(id);
    final recv = await _recvCount.countRecv(id);
    final unread = await analyticsViewModel.unread();
    //final chatActive = await _chatActive.chatActive(id);
    final unreadCount = _countUnread.countUnread(id);

    final chatCount = await _chatcount.chatCount(id);
    final chatNum = await analyticsViewModel.numchats();
    final activeChat = await analyticsViewModel.activechats();
    String busy;
    final nonActiveChat = chatNum-activeChat;
    final percentNonActive = (nonActiveChat/chatNum)*100;
    final percentActive = (activeChat/chatNum)*100;
    final percentUnread = (unread/(int.parse(sent)+int.parse(recv)))*100;

    percentActive>30.0 || percentUnread>30.0?busy='based on recent activity ${user.username} may be busy':busy = 'based on recent activity ${user.username} may be available';

    emit(analyticsSent(sent,recv,unread.toString(),/*chatActive,*/chatCount,chatNum,activeChat,busy,unreadCount.toString()));
  }

} 