//@dart=2.9

import 'package:chat/chat.dart';
import 'package:equatable/equatable.dart';

// ignore: camel_case_types
abstract class boardingState extends Equatable {}


// ignore: camel_case_types
class boardingInitial extends boardingState {

  @override
  List<Object> get props => [];
}

class Loading extends boardingState {

  @override
  List<Object> get props => [];
}

// ignore: camel_case_types
class boardingSuccess extends boardingState {

  final User user;

  boardingSuccess(this.user);
  @override
  List<Object> get props => [user];
}