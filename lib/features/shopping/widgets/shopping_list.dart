import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pondrop/features/shopping/bloc/shopping_bloc.dart';
import 'package:pondrop/features/shopping/widgets/list_item.dart';
import 'package:pondrop/l10n/l10n.dart';
import 'package:pondrop/features/styles/styles.dart';

class ShoppingList extends StatelessWidget {
  const ShoppingList({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return RefreshIndicator(
      color: Theme.of(context).primaryColor,
      onRefresh: () {
        final bloc = context.read<ShoppingBloc>();
        bloc.add(const ListRefreshed());
        return Future.value();
      },
      child: BlocBuilder<ShoppingBloc, ShoppingState>(
        buildWhen: (previous, current) =>
            current.status != ShoppingStatus.loading,
        builder: (context, state) {
          if (state.status == ShoppingStatus.initial) {
            return _empty(isLoading: true);
          }

          if (state.lists.isEmpty) {
            return _empty();
          }

          return _shoppingList(context: context, state: state);
        },
      ),
    );
  }

  Widget _shoppingList(
      {required BuildContext context, required ShoppingState state}) {
    return Scrollbar(
      child: ReorderableListView.builder(
        padding: const EdgeInsets.fromLTRB(0, 15, 5, 10),
        itemBuilder: (BuildContext context, int index) {
          final list = state.lists[index];
          return Dismissible(
            key: Key(list.id),
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: Dims.xxLarge),
              color: Colors.red,
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              final bloc = context.read<ShoppingBloc>();
              bloc.add(ListDeleted(id: list.id));
            },
            child: ListItem(list: list),
          );
        },
        itemCount: state.lists.length,
        onReorder: (oldIndex, newIndex) {
          final bloc = context.read<ShoppingBloc>();
          bloc.add(ListReordered(oldIdx: oldIndex, newIdx: newIndex));
        },
      ),
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
              SvgPicture.asset('assets/shopping.svg'),
              const SizedBox(
                height: Dims.large,
              ),
              Stack(
                children: [
                  Opacity(
                    opacity: isLoading ? 0 : 1,
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            l10n.createFirstList,
                            style: PondropStyles.titleTextStyle,
                          ),
                          const SizedBox(
                            height: Dims.small,
                          ),
                          Text(l10n.addListToStart),
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
