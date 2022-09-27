import 'package:flutter/material.dart';

import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/home_view_bloc/home_view_bloc.dart';
import '../bloc/home_view_bloc/home_view_event.dart';
import '../bloc/home_view_bloc/home_view_state.dart';
import '../model/image_item_model.dart';
import 'widgets/display_card_item_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool isLoading = false;
  late HomeViewBloc _bloc;
  Icon icon = const Icon(
    Icons.search,
    color: Colors.white,
  );
  @override
  void initState() {
    super.initState();
    _bloc = HomeViewBloc(InitState())..add(InitEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocConsumer<HomeViewBloc, HomeViewState>(
        listener: (BuildContext context, HomeViewState state) {
          if (state is FailureState) {}
        },
        builder: (_, HomeViewState state) {
          if (state is LoadingState) {
            return Container(
              color: Colors.white.withOpacity(0.4),
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.red[400],
                ),
              ),
            );
          } else {
            return mainBody();
          }
        },
      ),
    );
  }

  Widget mainBody() {
    return SafeArea(
      child: Scaffold(
        drawerEnableOpenDragGesture: false,
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildAppBar(context),
              // _bloc.controller.text!=""?:
              SizedBox(
                  height: MediaQuery.of(context).size.height -
                      (MediaQuery.of(context).padding.top +
                          MediaQuery.of(context).padding.bottom +
                          75),
                  child: LazyLoadScrollView(
                    isLoading: isLoading,
                    onEndOfPage: () => null, // _loadMore(),
                    child: StreamBuilder<List<Rows>>(
                        stream: _bloc.controller.text != ""
                            ? _bloc.searchImageListStream
                            : _bloc.imageListStream,
                        builder: (context, snapshot) {
                          return ListView.builder(
                              itemCount: snapshot.data?.length ?? 0,
                              itemBuilder: (context, position) {
                                if (isLoading &&
                                    position == snapshot.data!.length - 1) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  return DisplayCardItem(
                                      snapshot.data![position]);
                                }
                              });
                        }),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAppBar(BuildContext context) {
    return new AppBar(
        toolbarHeight: 75,
        centerTitle: true,
        title: appBarTitle,
        actions: <Widget>[
          new IconButton(
            icon: icon,
            onPressed: () {
              _handleSearchStart();
            },
          ),
        ]);
  }

  void _handleSearchStart() {
    setState(() {
      if (icon.icon == Icons.search) {
        icon = new Icon(
          Icons.close,
          color: Colors.white,
        );
        appBarTitle = new TextField(
          controller: _bloc.controller,
          style: new TextStyle(
            color: Colors.white,
          ),
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search, color: Colors.white),
              hintText: "Search...",
              hintStyle: new TextStyle(color: Colors.white)),
          onChanged: _bloc.searchOperation,
        );
      } else {
        _handleSearchEnd();
      }
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.icon = new Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = new Text(
        "Search",
        style: new TextStyle(color: Colors.white),
      );
      _bloc.controller.clear();
    });
  }

  Widget appBarTitle = Text(
    "Search",
    style: new TextStyle(color: Colors.white),
  );
}
