import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pondrop/l10n/l10n.dart';
import 'package:pondrop/features/styles/styles.dart';

class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({Key? key, this.automaticallyReturn = true})
      : super(key: key);

  final bool automaticallyReturn;

  @override
  _BarcodeScannerPageState createState() => _BarcodeScannerPageState();

  static Route<String> route([bool automaticallyReturn = true]) {
    return RouteTransitions.modalSlideRoute<String>(
        pageBuilder: (_) =>
            BarcodeScannerPage(automaticallyReturn: automaticallyReturn));
  }
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage>
    with SingleTickerProviderStateMixin {
  bool hasPopped = false;
  String? barcode;

  MobileScannerController controller = MobileScannerController(
    torchEnabled: false,
  );

  @override
  Widget build(BuildContext context) {
    const iconSize = 32.0;
    final l10n = context.l10n;
    final overlayHeight = MediaQuery.of(context).size.height * 0.2;
    final overlayColor = Colors.black.withOpacity(0.5);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: Text(
          l10n.barcodeScan,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Builder(
        builder: (context) {
          return Stack(
            children: [
              MobileScanner(
                controller: controller,
                fit: BoxFit.cover,
                onDetect: (barcode, args) {
                  switch (barcode.format) {
                    case BarcodeFormat.ean13:
                    case BarcodeFormat.ean8:
                      break;
                    default:
                      return;
                  }

                  if (widget.automaticallyReturn) {
                    final barcodeValue = barcode.rawValue ?? '';
                    if (!hasPopped && barcodeValue.isNotEmpty) {
                      hasPopped = true;
                      Navigator.pop(context, barcodeValue);
                    }
                  } else {
                    setState(() {
                      this.barcode = barcode.rawValue;
                    });
                  }
                },
              ),
              Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    alignment: Alignment.topCenter,
                    height: overlayHeight,
                    color: overlayColor,
                  )),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  height: overlayHeight,
                  color: overlayColor,
                  child: !widget.automaticallyReturn
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: Dims.smallBottomEdgeInsets,
                              child: Text(
                                barcode ?? 'Scanning...',
                                overflow: TextOverflow.fade,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                            Padding(
                                padding: Dims.xxLargeBottomEdgeInsets,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                        icon: Icon(
                                          Icons.check,
                                          color: barcode?.isNotEmpty == true
                                              ? Colors.green
                                              : Colors.grey,
                                        ),
                                        iconSize: iconSize,
                                        onPressed: barcode?.isNotEmpty == true
                                            ? () {
                                                if (!hasPopped) {
                                                  hasPopped = true;
                                                  Navigator.pop(
                                                      context, barcode);
                                                }
                                              }
                                            : null),
                                    const SizedBox(
                                      width: Dims.large,
                                    ),
                                    IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          color: barcode?.isNotEmpty == true
                                              ? Colors.red
                                              : Colors.grey,
                                        ),
                                        iconSize: iconSize,
                                        onPressed: barcode?.isNotEmpty == true
                                            ? () => setState(() {
                                                  barcode = null;
                                                })
                                            : null),
                                  ],
                                ))
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
