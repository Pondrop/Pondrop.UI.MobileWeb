import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pondrop/features/shopping_list/widgets/category_list_item.dart';
import 'package:pondrop/features/shopping_list/widgets/shopping_list_list.dart';
import 'package:pondrop/l10n/l10n.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:pondrop/features/styles/styles.dart';

import '../bloc/shopping_list_bloc.dart';

class ShoppingListPage extends StatefulWidget {
  const ShoppingListPage({super.key});

  static Route<ShoppingList> route(ShoppingList list) {
    return MaterialPageRoute<ShoppingList>(
        builder: (_) => const ShoppingListPage(),
        settings: RouteSettings(arguments: list));
  }

  @override
  State<ShoppingListPage> createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  static const double _minExtent = 0.175;
  static const double _maxExtent = 0.800;

  static const Duration _sheetAnimationDuration = Duration(microseconds: 350);

  final _sheetController = DraggableScrollableController();
  final _searchTextController = TextEditingController(text: '');

  double _previousExtent = _minExtent;
  double _currentExtent = _minExtent;

  @override
  void dispose() {
    super.dispose();

    _sheetController.dispose();
    _searchTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => ShoppingListBloc(
              list: ModalRoute.of(context)!.settings.arguments as ShoppingList,
              shoppingRepository:
                  RepositoryProvider.of<ShoppingRepository>(context),
              productRepository:
                  RepositoryProvider.of<ProductRepository>(context),
              storeRepository: RepositoryProvider.of<StoreRepository>(context),
              locationRepository:
                  RepositoryProvider.of<LocationRepository>(context),
            )..add(const ItemRefreshed()),
        child: BlocListener<ShoppingListBloc, ShoppingListState>(
          listener: (context, state) =>
              _showErrorSnackBar(context, state.action),
          listenWhen: (previous, current) =>
              current.status == ShoppingListStatus.failure &&
              previous.status != ShoppingListStatus.failure,
          child: Scaffold(
            body: Builder(builder: (context) {
              return Stack(
                children: [
                  _mainPage(context),
                  if (_currentExtent > _minExtent)
                    Opacity(
                      opacity: math.min(_currentExtent / _maxExtent, 1),
                      child: GestureDetector(
                        onTap: () async {
                          await _sheetController.animateTo(_minExtent,
                              duration: _sheetAnimationDuration,
                              curve: Curves.easeIn);
                        },
                        child: Container(
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  NotificationListener<DraggableScrollableNotification>(
                    onNotification:
                        (DraggableScrollableNotification notification) {
                      setState(() {
                        _previousExtent = _currentExtent;
                        _currentExtent = notification.extent;
                      });

                      if (notification.extent <= _minExtent &&
                          _previousExtent > _currentExtent) {
                        final bloc = context.read<ShoppingListBloc>();
                        bloc.add(const ItemCategorySearchTextChanged(text: ''));
                        _searchTextController.clear();
                        FocusScope.of(context).unfocus();
                      }

                      return false;
                    },
                    child: DraggableScrollableSheet(
                      controller: _sheetController,
                      // Hack to workaround minChildSize getting set
                      // after calling jumpTo/animateTo
                      initialChildSize: _currentExtent,
                      minChildSize: _minExtent,
                      maxChildSize: _maxExtent,
                      snap: true,
                      snapSizes: const [_minExtent, _maxExtent],
                      builder: (context, scrollController) {
                        return SizedBox(
                          height: maxExtentPixels(context: context),
                          child: _bottomSheetContainer(
                              context: context,
                              scrollController: scrollController),
                        );
                      },
                    ),
                  )
                ],
              );
            }),
          ),
        ));
  }

  Widget _bottomSheetContainer(
      {required BuildContext context,
      required ScrollController scrollController}) {
    return Container(
      decoration: const BoxDecoration(
        color: PondropColors.bottomSheetBgColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: _bottomSheetScrollView(
          context: context, scrollController: scrollController),
    );
  }

  Widget _bottomSheetScrollView(
      {required BuildContext context,
      required ScrollController scrollController}) {
    return Material(
      color: Colors.transparent,
      child: SingleChildScrollView(
          controller: scrollController,
          physics: const ClampingScrollPhysics(),
          child: SizedBox(
              height: maxExtentPixels(context: context),
              child: Column(
                children: [
                  const SizedBox(
                    height: Dims.medium,
                  ),
                  Container(
                    width: 50,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(
                    height: Dims.small,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Dims.large),
                    child: Row(
                      children: [
                        Expanded(
                          child: _searchTextField(context: context),
                        ),
                      ],
                    ),
                  ),
                  if (_currentExtent >= 0.25)
                    Expanded(
                      child: _categoryListView(context: context),
                    )
                ],
              ))),
    );
  }

  Widget _categoryListView({required BuildContext context}) {
    return BlocBuilder<ShoppingListBloc, ShoppingListState>(
        builder: (context, state) {
      final l10n = context.l10n;
      final bloc = context.read<ShoppingListBloc>();
      if (state.status != ShoppingListStatus.loading &&
          state.categorySearchText.length >= bloc.minQueryLength &&
          state.categoriesFiltered.isEmpty) {
        return Padding(
          padding: Dims.largeEdgeInsets,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.noResultsFound,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                Padding(
                    padding: Dims.xSmallTopEdgeInsets,
                    child: Center(
                        child: Text(l10n.tryAgainUsingOtherSearchTerms))),
              ]),
        );
      }

      return Scrollbar(
        child: ListView.builder(
          primary: false,
          padding: const EdgeInsets.fromLTRB(
              Dims.xSmall, Dims.small, Dims.small, Dims.xxLarge),
          itemBuilder: (BuildContext context, int index) {
            final item = state.categoriesFiltered[index];
            return CategoryListItem(
              item: item,
              onTap: (context, category) async {
                final bloc = context.read<ShoppingListBloc>();
                bloc.add(ItemAdded(
                    categoryId: category.id,
                    name: category.name,
                    sortOrder: 0));
                await _sheetController.animateTo(_minExtent,
                    duration: _sheetAnimationDuration, curve: Curves.easeIn);
              },
            );
          },
          itemCount: state.categoriesFiltered.length,
        ),
      );
    });
  }

  Widget _searchTextField({required BuildContext context}) {
    final l10n = context.l10n;
    return Focus(
      onFocusChange: (hasFocus) async {
        if (hasFocus && _currentExtent < _maxExtent) {
          await _sheetController.animateTo(_maxExtent,
              duration: _sheetAnimationDuration, curve: Curves.easeOut);
        }
      },
      child: TextField(
        controller: _searchTextController,
        decoration: InputDecoration(
            border: const OutlineInputBorder(
              borderSide: BorderSide(width: 0, style: BorderStyle.none),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 0, style: BorderStyle.none),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            filled: true,
            fillColor: Theme.of(context).scaffoldBackgroundColor,
            hintText: _currentExtent == _maxExtent
                ? l10n.egItem(l10n.milk)
                : l10n.itemEllipsis(l10n.search),
            prefixIcon: const Icon(
              Icons.search,
              color: Colors.grey,
            ),
            suffixIcon: BlocBuilder<ShoppingListBloc, ShoppingListState>(
                buildWhen: (previous, current) =>
                    previous.categorySearchText != current.categorySearchText,
                builder: (context, state) {
                  if (state.categorySearchText.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return IconButton(
                    icon: const Icon(
                      Icons.clear,
                      color: Colors.black,
                    ),
                    onPressed: (() {
                      final bloc = context.read<ShoppingListBloc>();
                      bloc.add(const ItemCategorySearchTextChanged(text: ''));
                      _searchTextController.text = '';
                    }),
                  );
                })),
        onChanged: (value) {
          final bloc = context.read<ShoppingListBloc>();
          bloc.add(ItemCategorySearchTextChanged(text: value));
        },
      ),
    );
  }

  Widget _mainPage(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        final bloc = context.read<ShoppingListBloc>();
        final list = bloc.state.list.copyWith(
            items: bloc.state.items, itemCount: bloc.state.items.length);
        Navigator.of(context).pop(list);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(Dims.medium, 0, 0, Dims.small),
              child: BlocBuilder<ShoppingListBloc, ShoppingListState>(
                  buildWhen: (previous, current) =>
                      previous.list.name != current.list.name,
                  builder: (context, state) {
                    return Text(
                      state.list.name,
                      style: Theme.of(context).textTheme.headline4,
                      overflow: TextOverflow.ellipsis,
                    );
                  }),
            ),
            const Expanded(child: ShoppingListList()),
          ],
        ),
      ),
    );
  }

  double maxExtentPixels({required BuildContext context}) {
    return MediaQuery.of(context).size.height * _maxExtent;
  }

  void _showErrorSnackBar(BuildContext context, ShoppingListAction action) {
    final l10n = context.l10n;

    var actionString = '';

    switch (action) {
      case ShoppingListAction.refresh:
        actionString = l10n.refreshing;
        break;
      case ShoppingListAction.create:
        actionString = l10n.adding;
        break;
      case ShoppingListAction.delete:
        actionString = l10n.removing;
        break;
      case ShoppingListAction.reorder:
        actionString = l10n.reordering;
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
