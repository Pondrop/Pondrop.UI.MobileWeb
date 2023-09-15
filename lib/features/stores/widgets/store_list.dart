import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pondrop/l10n/l10n.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/features/global/widgets/bottom_loader.dart';
import 'package:pondrop/features/stores/bloc/store_bloc.dart';
import 'package:pondrop/features/stores/widgets/store_list_item.dart';
import 'package:pondrop/features/styles/styles.dart';

class StoresList extends StatefulWidget {
  final String header;

  const StoresList(Key? key, this.header) : super(key: key);

  @override
  State<StoresList> createState() => _StoresListState();
}

class _StoresListState extends State<StoresList> with WidgetsBindingObserver {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final bloc = context.read<StoreBloc>();
      final durationSinceLastRefresh = Duration(
          milliseconds: DateTime.now().millisecondsSinceEpoch -
              bloc.state.campaignCountsRefreshedMs);
      if (durationSinceLastRefresh > const Duration(minutes: 3)) {
        bloc.add(StoreCampaignCountsRefreshed(
            storeIds: bloc.state.stores.map((e) => e.id).toList()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Theme.of(context).primaryColor,
      onRefresh: () {
        final bloc = context.read<StoreBloc>()..add(const StoreRefreshed());
        return bloc.stream.firstWhere((e) => e.status != StoreStatus.loading);
      },
      child: BlocBuilder<StoreBloc, StoreState>(
        buildWhen: (previous, current) => current.status != StoreStatus.loading,
        builder: (context, state) {
          if (state.status == StoreStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == StoreStatus.failure || state.stores.isEmpty) {
            return _noStoresFound();
          }

          return _storesList(state);
        },
      ),
    );
  }

  Widget _storesList(StoreState state) {
    return Scrollbar(
      controller: _scrollController,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(0, 15, 5, 10),
        itemBuilder: (BuildContext context, int index) {
          Widget getItem(int idx, List<Store> stores) {
            return idx >= stores.length
                ? const BottomLoader()
                : StoreListItem(store: stores[index]);
          }

          if (index == 0) {
            return Column(children: [
              // The header
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(
                    horizontal: Dims.large, vertical: Dims.medium),
                child: Text(widget.header,
                    style: TextStyle(
                        color: Colors.grey[800],
                        letterSpacing: 0.5,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold)),
              ),
              getItem(index, state.stores)
            ]);
          }

          return getItem(index, state.stores);
        },
        itemCount:
            state.hasReachedMax ? state.stores.length : state.stores.length + 1,
        controller: _scrollController,
      ),
    );
  }

  Widget _noStoresFound() {
    return LayoutBuilder(builder: (context, constraints) {
      final l10n = context.l10n;
      return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Center(
                child: Text(l10n.noItemFound(l10n.stores.toLowerCase()))),
          ));
    });
  }

  void _onScroll() {
    if (_isBottom) context.read<StoreBloc>().add(const StoreFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
