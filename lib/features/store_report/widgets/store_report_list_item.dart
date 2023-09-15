import 'package:flutter/material.dart';
import 'package:pondrop/features/styles/styles.dart';

class StoreReportListItem extends StatelessWidget {
  const StoreReportListItem(
      {super.key,
      required this.iconData,
      required this.title,
      this.subTitle = '',
      this.photoCount = 0,
      this.hasError = false,
      this.onTap});

  final IconData iconData;

  final String title;
  final String subTitle;

  final int photoCount;

  final bool hasError;

  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          Dims.xLarge, Dims.xSmall, Dims.xLarge, Dims.small),
      child: Material(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(
              color: Color.fromARGB(153, 114, 120, 126), width: 1),
        ),
        elevation: 2,
        color: const Color.fromARGB(255, 250, 252, 255),
        child: InkWell(
            onTap: () {
              onTap?.call();
            },
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: Dims.medium),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: Dims.large),
                        child: Container(
                          padding: Dims.mediumEdgeInsets,
                          decoration: BoxDecoration(
                              color: PondropColors.primaryLightColor,
                              borderRadius: BorderRadius.circular(100)),
                          child: Icon(
                            iconData,
                            color: Colors.black,
                          ),
                        )),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                          const SizedBox(height: Dims.small),
                          Text(
                            subTitle,
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    if (photoCount > 0 && !hasError)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                            Dims.small, 0, Dims.medium, 0),
                        child: Row(
                          children: [
                            const Icon(Icons.photo_library_outlined),
                            const SizedBox(
                              width: 2,
                            ),
                            Text('$photoCount'),
                          ],
                        ),
                      ),
                    if (hasError)
                      const Padding(
                        padding: Dims.smallEdgeInsets,
                        child: Icon(
                          Icons.warning_amber_outlined,
                          color: PondropColors.warningColor,
                        ),
                      ),
                  ],
                ))),
      ),
    );
  }
}
