import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pondrop/features/barcode_scanner/barcode_scanner.dart';
import 'package:pondrop/features/global/global.dart';
import 'package:pondrop/features/styles/styles.dart';
import 'package:pondrop/l10n/l10n.dart';
import 'package:tuple/tuple.dart';

class CreateProductPage extends StatefulWidget {
  const CreateProductPage({Key? key, this.name = '', this.barcode = ''})
      : super(key: key);

  static const cancelButtonKey = Key('CreateProductPage_Cancel_Btn');
  static const doneButtonKey = Key('CreateProductPage_Done_Btn');
  static const nameTextKey = Key('CreateProductPage_Name_Txt');
  static const barcodeTextKey = Key('CreateProductPage_Barcode_Txt');

  static MaterialPageRoute<Tuple2<String, String>> route(
      {String name = '', String barcode = ''}) {
    return MaterialPageRoute<Tuple2<String, String>>(
        builder: (_) => CreateProductPage(name: name, barcode: barcode));
  }

  final String name;
  final String barcode;

  @override
  State<CreateProductPage> createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {
  final _nameTextController = TextEditingController();
  final _barcodeTextController = TextEditingController();

  bool _isValid = false;

  @override
  void initState() {
    super.initState();

    _nameTextController.text = widget.name;
    _barcodeTextController.text = widget.barcode;
    updateIsValid();
  }

  @override
  void dispose() {
    _nameTextController.dispose();
    _barcodeTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final l10n = context.l10n;
      return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: Dims.smallEdgeInsets,
              child: Stack(alignment: Alignment.center, children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    key: CreateProductPage.cancelButtonKey,
                    child: Text(
                      l10n.cancel,
                      style: PondropStyles.linkTextStyle,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(const Tuple2('', ''));
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    l10n.createItem(l10n.product.toLowerCase()),
                    style: PondropStyles.popupTitleTextStyle,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                      key: CreateProductPage.doneButtonKey,
                      onPressed: _isValid
                          ? () {
                              Navigator.of(context).pop(Tuple2(
                                  _nameTextController.text,
                                  _barcodeTextController.text));
                            }
                          : null,
                      child: Text(
                        l10n.done,
                        style: PondropStyles.linkTextStyle.copyWith(
                            fontWeight: FontWeight.w500,
                            color: _isValid ? null : Colors.grey),
                      )),
                ),
              ]),
            ),
            Expanded(
                child: SingleChildScrollView(
              controller: ModalScrollController.of(context),
              child: Padding(
                  padding: Dims.smallEdgeInsets,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextField(
                        key: CreateProductPage.nameTextKey,
                        controller: _nameTextController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: l10n.itemName(l10n.product),
                          suffixIcon: null,
                        ),
                        onChanged: (value) {
                          updateIsValid();
                        },
                      ),
                      const SizedBox(
                        height: Dims.large,
                      ),
                      TextField(
                        key: CreateProductPage.barcodeTextKey,
                        controller: _barcodeTextController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(13)
                        ],
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: l10n.barcode,
                          errorText: _barcodeTextController.text.isNotEmpty &&
                                  !EanValidator.validChecksum(
                                      _barcodeTextController.text)
                              ? l10n.itemIsNotValid(l10n.barcode)
                              : null,
                          suffixIcon: IconButton(
                            tooltip: l10n.barcode,
                            focusColor: Colors.black,
                            color: Colors.black,
                            icon:
                                SvgPicture.asset('assets/barcode_scanner.svg'),
                            onPressed: () async {
                              final barcode = await Navigator.of(context)
                                  .push(BarcodeScannerPage.route());
                              if (barcode?.isNotEmpty == true) {
                                _barcodeTextController.text = barcode!;
                                updateIsValid();
                              }
                            },
                          ),
                        ),
                        onChanged: (value) {
                          updateIsValid();
                        },
                      ),
                    ],
                  )),
            )),
          ],
        ),
      );
    });
  }

  void updateIsValid() {
    setState(() {
      _isValid = _nameTextController.text.isNotEmpty &&
          EanValidator.validChecksum(_barcodeTextController.text);
    });
  }
}
