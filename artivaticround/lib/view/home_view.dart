import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/home_view_bloc/home_view_bloc.dart';
import '../bloc/home_view_bloc/home_view_event.dart';
import '../bloc/home_view_bloc/home_view_state.dart';
import '../main.dart';
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
            return SafeArea(
              child: Scaffold(
                drawerEnableOpenDragGesture: false,
                body: StreamBuilder<List<Rows>>(
                    stream: _bloc.imageListStream,
                    builder: (context, snapshot) {
                      return LazyLoadScrollView(
                        isLoading: isLoading,
                        onEndOfPage: () => null, // _loadMore(),
                        child: ListView.builder(
                            itemCount: snapshot.data?.length ?? 0,
                            itemBuilder: (context, position) {
                              if (isLoading &&
                                  position == snapshot.data!.length - 1)
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              else
                                return DisplayCardItem(
                                    snapshot.data![position]);
                            }),
                      );
                    }),
              ),
            );
          }
        },
      ),
    );
  }
}
