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
  final TextEditingController controller = TextEditingController();

  //List<Rows> imageList = [];
  List<Rows> searchImageList = [];

  final _imageListStreamController = BehaviorSubject<List<Rows>>();
  Stream<List<Rows>> get imageListStream => _imageListStreamController.stream;
  StreamSink<List<Rows>> get countryListSink {
    return _imageListStreamController.sink;
  }

  Function(List<Rows>) get imageListChanged =>
      _imageListStreamController.sink.add;

  final _searchImageListStreamController = BehaviorSubject<List<Rows>>();
  Stream<List<Rows>> get searchImageListStream =>
      _searchImageListStreamController.stream;
  StreamSink<List<Rows>> get searchImageListSink {
    return _searchImageListStreamController.sink;
  }

  Function(List<Rows>) get searchImageListChanged =>
      _searchImageListStreamController.sink.add;

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

  void searchOperation(String searchText) {
    searchImageList.clear();
    searchImageList = [];
    _imageListStreamController.value.forEach((element) {
      if (element.title != null &&
          element.title!.toLowerCase().contains(searchText.toLowerCase())) {
        searchImageList.add(element);
      }
    });
    if (searchImageList.length == 0) {
      searchImageList.add(Rows(title: "Not found"));
    }
    _searchImageListStreamController.value = searchImageList;
  }
}
