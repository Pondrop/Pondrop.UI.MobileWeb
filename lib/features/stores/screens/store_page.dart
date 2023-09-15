import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pondrop/features/app/widgets/loading_overlay.dart';
import 'package:pondrop/features/authentication/bloc/authentication_bloc.dart';
import 'package:pondrop/features/barcode_scanner/barcode_scanner.dart';
import 'package:pondrop/features/global/global.dart';
import 'package:pondrop/features/shopping/shopping.dart';
import 'package:pondrop/features/store_report/screens/store_report_page.dart';
import 'package:pondrop/features/stores/widgets/store_list.dart';
import 'package:pondrop/l10n/l10n.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:pondrop/features/search_items/search_items.dart';
import 'package:pondrop/features/search_store/screens/search_store_page.dart';
import 'package:pondrop/features/stores/bloc/store_bloc.dart';
import 'package:pondrop/features/styles/styles.dart';

class StorePage extends StatelessWidget {
  const StorePage({super.key});

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const StorePage());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final email = context.read<AuthenticationBloc>().state.user.email;

    return BlocProvider(
        create: (_) => StoreBloc(
              storeRepository: RepositoryProvider.of<StoreRepository>(context),
              submissionRepository:
                  RepositoryProvider.of<SubmissionRepository>(context),
              locationRepository:
                  RepositoryProvider.of<LocationRepository>(context),
            )..add(const StoreRefreshed()),
        child: Scaffold(
          appBar: AppBar(
              title: Text(l10n.selectAItem(l10n.store.toLowerCase()),
                  style: PondropStyles.appBarTitleTextStyle),
              actions: <Widget>[
                Padding(
                  padding: Dims.mediumRightEdgeInsets,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, SearchStorePage.route());
                    },
                    child: const Icon(Icons.search),
                  ),
                )
              ],
              centerTitle: true),
          drawer: Drawer(
              child: Column(
            children: [
              Expanded(
                child: BlocBuilder<StoreBloc, StoreState>(
                    builder: (context, state) {
                  return ListView(
                    children: [
                      ListTile(
                        leading: SvgPicture.asset(
                          'assets/pondrop.svg',
                          height: 24,
                        ),
                        dense: true,
                      ),
                      ListTile(
                        leading: const Icon(Icons.account_circle_outlined),
                        minLeadingWidth: 0,
                        title: Text(email,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(
                                    fontSize: 12, fontWeight: FontWeight.w400)),
                        dense: true,
                      ),
                      ListTile(
                        leading: const Icon(Icons.storefront),
                        title: Text(l10n.offers),
                        selected: true,
                        selectedColor: Colors.black,
                        selectedTileColor: PondropColors.selectedListItemColor,
                      ),
                      ListTile(
                        leading: const Icon(Icons.shopping_cart_outlined),
                        title: Text(l10n.shopping),
                        selectedColor: Colors.black,
                        iconColor: Colors.black,
                        selectedTileColor: PondropColors.selectedListItemColor,
                        onTap: () {
                          Navigator.of(context).push(ShoppingPage.route());
                        },
                      ),
                      if (state.communityStore != null)
                        ListTile(
                          leading: const Icon(Icons.store_outlined),
                          title: Text(l10n.communityStore),
                          selectedColor: Colors.black,
                          iconColor: Colors.black,
                          selectedTileColor:
                              PondropColors.selectedListItemColor,
                          onTap: () async {
                            await Navigator.of(context).push(
                                StoreReportPage.route(state.communityStore!));
                          },
                        ),
                      ListTile(
                        leading: const Icon(Icons.category_outlined),
                        title: Text(l10n.categories),
                        selectedColor: Colors.black,
                        iconColor: Colors.black,
                        selectedTileColor: PondropColors.selectedListItemColor,
                        onTap: () {
                          Navigator.of(context).push(SearchItemPage.route(
                              type: SearchItemType.category));
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.local_offer_outlined),
                        title: Text(l10n.products),
                        selectedColor: Colors.black,
                        iconColor: Colors.black,
                        selectedTileColor: PondropColors.selectedListItemColor,
                        onTap: () {
                          Navigator.of(context).push(SearchItemPage.route(
                              type: SearchItemType.product));
                        },
                      ),
                      ListTile(
                        leading: SvgPicture.asset('assets/barcode_scanner.svg'),
                        title: Text(l10n.barcodeScan),
                        selectedColor: Colors.black,
                        iconColor: Colors.black,
                        selectedTileColor: PondropColors.selectedListItemColor,
                        onTap: () {
                          Navigator.of(context)
                              .push(BarcodeScannerPage.route(false));
                        },
                      ),
                      BlocListener<AuthenticationBloc, AuthenticationState>(
                        listenWhen: (previous, current) =>
                            previous.isLoggingOut != current.isLoggingOut,
                        listener: (context, state) {
                          if (state.isLoggingOut) {
                            LoadingOverlay.of(context)
                                .show(l10n.itemEllipsis(l10n.loggingOut));
                          } else {
                            LoadingOverlay.of(context).hide();
                          }
                        },
                        child: ListTile(
                          leading: Icon(
                            Icons.logout,
                            color: Theme.of(context).errorColor,
                          ),
                          title: Text(
                            l10n.logOut,
                            style:
                                TextStyle(color: Theme.of(context).errorColor),
                          ),
                          onTap: () => context
                              .read<AuthenticationBloc>()
                              .add(AuthenticationLogoutRequested()),
                        ),
                      ),
                    ],
                  );
                }),
              ),
              const Padding(
                  padding: EdgeInsets.symmetric(vertical: Dims.small),
                  child: TsAndCs()),
              FutureBuilder(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final packageInfo = snapshot.data as PackageInfo;
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(
                            0, Dims.small, 0, Dims.xxLarge),
                        child: Text(
                          '${packageInfo.version} (${packageInfo.buildNumber})',
                          style: Theme.of(context)
                              .textTheme
                              .caption!
                              .copyWith(fontSize: 11),
                        ),
                      );
                    }

                    return const SizedBox.shrink();
                  })
            ],
          )),
          body: StoresList(null, l10n.storesNearby.toUpperCase()),
        ));
  }
}
