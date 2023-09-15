import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pondrop/features/shopping_list/bloc/shopping_list_bloc.dart';
import 'package:pondrop/features/shopping_list/widgets/list_item.dart';
import 'package:pondrop/l10n/l10n.dart';
import 'package:pondrop/features/styles/styles.dart';

class ShoppingListList extends StatelessWidget {
  const ShoppingListList({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return RefreshIndicator(
      color: Theme.of(context).primaryColor,
      onRefresh: () {
        final bloc = context.read<ShoppingListBloc>();
        bloc.add(const ItemRefreshed());
        return Future.value();
      },
      child: BlocBuilder<ShoppingListBloc, ShoppingListState>(
        buildWhen: (previous, current) =>
            current.status != ShoppingListStatus.loading,
        builder: (context, state) {
          if (state.status == ShoppingListStatus.initial) {
            return _empty(isLoading: true);
          }

          if (state.items.isEmpty) {
            return _empty();
          }

          return _shoppingList(context: context, state: state);
        },
      ),
    );
  }

  Widget _shoppingList(
      {required BuildContext context, required ShoppingListState state}) {
    return ReorderableListView.builder(
      padding: const EdgeInsets.fromLTRB(0, 15, 5, 10),
      itemBuilder: (BuildContext context, int index) {
        final item = state.items[index];
        return Dismissible(
          key: Key(item.id),
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: Dims.xxLarge),
            color: Colors.red,
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            final bloc = context.read<ShoppingListBloc>();
            bloc.add(ItemDeleted(id: item.id));
          },
          child: ListItem(item: item),
        );
      },
      itemCount: state.items.length,
      onReorder: (oldIndex, newIndex) {
        final bloc = context.read<ShoppingListBloc>();
        bloc.add(ItemReordered(oldIdx: oldIndex, newIdx: newIndex));
      },
    );
  }

  Widget _empty({bool isLoading = false}) {
    return LayoutBuilder(builder: (context, constraints) {
      final l10n = context.l10n;
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: constraints.maxHeight,
          ),
          child: Center(
            child: Column(children: [
              SvgPicture.asset('assets/shopping_list.svg'),
              const SizedBox(
                height: Dims.large,
              ),
              Stack(
                children: [
                  Opacity(
                    opacity: isLoading ? 1 : 0,
                    child: const Padding(
                      padding: Dims.mediumEdgeInsets,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                  Opacity(
                    opacity: isLoading ? 0 : 1,
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            l10n.needSomethingShops,
                            style: PondropStyles.titleTextStyle,
                          ),
                          const SizedBox(
                            height: Dims.small,
                          ),
                          Text(l10n.searchToAddToShoppingList),
                          const SizedBox(
                            height: 96,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ]),
          ),
        ),
      );
    });
  }
}
