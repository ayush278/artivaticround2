import 'dart:async';

import 'package:artivaticround/services/repositry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/src/subjects/behavior_subject.dart';

import '../../model/image_item_model.dart';
import 'home_view_event.dart';
import 'home_view_state.dart';

class HomeViewBloc extends Bloc<HomeViewEvent, HomeViewState> {
  HomeViewBloc(super.initialState);

  List<Rows> imageList = [];
  final _imageListStreamController = BehaviorSubject<List<Rows>>();
  Stream<List<Rows>> get imageListStream => _imageListStreamController.stream;
  StreamSink<List<Rows>> get countryListSink {
    return _imageListStreamController.sink;
  }

  Function(List<Rows>) get imageListChanged =>
      _imageListStreamController.sink.add;

  @override
  Stream<HomeViewState> mapEventToState(HomeViewEvent event) async* {
    if (event is InitEvent) {
      yield LoadingState();
      ImageItemModel imageItemModel = ImageItemModel();
      Repositry repositry = Repositry();
      imageItemModel = await repositry.fetchImageList();
      _imageListStreamController.value = imageItemModel.rows!;
      yield SuccessfulState();
    } else if (event is ButtonEvent) {}
  }
}
