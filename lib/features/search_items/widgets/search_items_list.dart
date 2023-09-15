import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pondrop/features/search_items/search_items.dart';
import 'package:pondrop/l10n/l10n.dart';
import 'package:pondrop/features/search_items/bloc/search_items_bloc.dart';
import 'package:pondrop/features/search_items/widgets/search_list_item.dart';
import 'package:pondrop/features/global/widgets/bottom_loader.dart';
import 'package:pondrop/features/styles/styles.dart';

class SearchItemsList extends StatefulWidget { 

  const SearchItemsList({Key? key, required this.header, this.onTap, this.excludedIds = const []}) : super(key: key);

  final String header;
  final List<String> excludedIds;
  final Function(BuildContext, SearchItem)? onTap;

  @override
  State<SearchItemsList> createState() => _SearchItemsListState();
}

class _SearchItemsListState extends State<SearchItemsList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Theme.of(context).primaryColor,
      onRefresh: () {
        final bloc = context.read<SearchItemsBloc>()..add(const SearchRefreshed());
        return bloc.stream.firstWhere((e) => e.status != SearchStatus.loading);
      },
      child: BlocBuilder<SearchItemsBloc, SearchItemsState>(
        builder: (context, state) {
          switch (state.status) {
            case SearchStatus.failure:
              return const Center(child: NoResultsFound());
            case SearchStatus.loading:
            case SearchStatus.success:
              if (state.items.isEmpty &&
                  state.status != SearchStatus.loading) {
                return const Center(child: NoResultsFound());
              }

              return Scrollbar(
                controller: _scrollController,
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(
                      0, Dims.large, Dims.xSmall, Dims.medium),
                  itemBuilder: (BuildContext context, int index) {
                    if (index >= state.items.length) {
                      return const BottomLoader();
                    }
              
                    return index >= state.items.length
                        ? const BottomLoader()
                        : widget.excludedIds.contains(state.items[index].id)
                          ? const SizedBox.shrink()
                          : SearchListItem(item: state.items[index], onTap: widget.onTap,);
                  },
                  itemCount: state.hasReachedMax
                      ? state.items.length
                      : state.items.length + 1,
                  controller: _scrollController,
                ),
              );
            case SearchStatus.initial:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<SearchItemsBloc>().add(const SearchFetched());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}

class NoResultsFound extends StatelessWidget {
  const NoResultsFound({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.noResultsFound,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
          Padding(
              padding: Dims.xSmallTopEdgeInsets,
              child: Center(child: Text(l10n.tryAgainUsingOtherSearchTerms))),
        ]);
  }
}
