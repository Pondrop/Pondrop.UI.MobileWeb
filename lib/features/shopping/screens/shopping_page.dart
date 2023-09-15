import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pondrop/features/shopping/screens/add_list_page.dart';
import 'package:pondrop/features/shopping/widgets/shopping_list.dart';
import 'package:pondrop/l10n/l10n.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:pondrop/features/styles/styles.dart';

import '../bloc/shopping_bloc.dart';

class ShoppingPage extends StatelessWidget {
  const ShoppingPage({super.key});

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const ShoppingPage());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocProvider(
        create: (_) => ShoppingBloc(
              shoppingRepository:
                  RepositoryProvider.of<ShoppingRepository>(context),
              productRepository:
                  RepositoryProvider.of<ProductRepository>(context),
              storeRepository: RepositoryProvider.of<StoreRepository>(context),
              locationRepository:
                  RepositoryProvider.of<LocationRepository>(context),
            )..add(const ListRefreshed()),
        child: BlocListener<ShoppingBloc, ShoppingState>(
          listener: (context, state) =>
              _showErrorSnackBar(context, state.action),
          listenWhen: (previous, current) =>
              current.status == ShoppingStatus.failure &&
              previous.status != ShoppingStatus.failure,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 0,
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.fromLTRB(Dims.medium, 0, 0, Dims.small),
                  child: Text(l10n.myLists,
                      style: Theme.of(context).textTheme.headline4),
                ),
                const Expanded(
                  child: ShoppingList(),
                ),
              ],
            ),
            floatingActionButton: BlocBuilder<ShoppingBloc, ShoppingState>(
              builder: (context, state) {
                switch (state.status) {
                  case ShoppingStatus.loading:
                    return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: PondropColors.primaryLightColor,
                            foregroundColor: Colors.black),
                        onPressed: () {},
                        child: const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(),
                        ));
                  case ShoppingStatus.success:
                  case ShoppingStatus.failure:
                    return ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: Text(l10n.addItem(l10n.list.toLowerCase())),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: PondropColors.primaryLightColor,
                          foregroundColor: Colors.black),
                      onPressed: () async {
                        final bloc = context.read<ShoppingBloc>();
                        final listCreated = await Navigator.of(context)
                            .push(AddListPage.route());
                        if (listCreated != null) {
                          bloc.add(listCreated);
                        }
                      },
                    );
                  default:
                    return const SizedBox.shrink();
                }
              },
            ),
          ),
        ));
  }

  void _showErrorSnackBar(BuildContext context, ShoppingAction action) {
    final l10n = context.l10n;

    var actionString = '';

    switch (action) {
      case ShoppingAction.refresh:
        actionString = l10n.refreshing;
        break;
      case ShoppingAction.create:
        actionString = l10n.addingItem(l10n.list);
        break;
      case ShoppingAction.delete:
        actionString = l10n.removingItem(l10n.list);
        break;
      case ShoppingAction.reorder:
        actionString = l10n.reorderingItem(l10n.list);
        break;
      default:
        return;
    }

    final snackBar = SnackBar(
        content: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: Dims.smallEdgeInsets,
          child: Icon(
            Icons.warning_amber_outlined,
            color: PondropColors.warningColor,
          ),
        ),
        Expanded(
            child: Text(
          l10n.itemFailedPleaseTryAgain(actionString),
        ))
      ],
    ));

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
