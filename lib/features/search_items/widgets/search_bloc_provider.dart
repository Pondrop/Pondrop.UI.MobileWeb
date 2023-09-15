import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:pondrop/features/search_items/bloc/search_items_bloc.dart';
import 'package:pondrop/features/search_items/search_items.dart';

class SearchBlocProvider extends StatelessWidget {
  const SearchBlocProvider(
      {Key? key,
      required this.type,
      this.child,
      this.productRepository})
      : super(key: key);

  final SearchItemType type;
  final Widget? child;

  final ProductRepository? productRepository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => SearchItemsBloc(
              type: type,
              productRepository: productRepository ??
                  RepositoryProvider.of<ProductRepository>(context),
            ),
        child: child);
  }
}
