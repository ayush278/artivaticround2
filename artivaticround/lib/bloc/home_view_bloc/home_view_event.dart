import 'package:flutter/material.dart';

abstract class HomeViewEvent {}

class InitEvent extends HomeViewEvent {
  InitEvent();
}

class ButtonEvent extends HomeViewEvent {
  final BuildContext context;
  ButtonEvent(this.context);
}
