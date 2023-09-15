class EanValidator {
  static bool validChecksum(String barcode) {
    final trimmed = barcode.replaceAll(RegExp(r'\s+'), '');
    final onlyDigits = RegExp(r'^[0-9]+$').stringMatch(trimmed);

    switch (onlyDigits?.length ?? -1) {
      case 8:
      case 13:
        break;
      default:
        return false;
    }

    final checksum = _checksum(onlyDigits!);
    final calculatedChecksum = _calculateChecksum(onlyDigits);

    return checksum == calculatedChecksum;
  }

  static int _checksum(String eanBarcode) {
    return int.parse(eanBarcode.substring(eanBarcode.length - 1));
  }

  static int _calculateChecksum(String eanBarcode) {
    final digits = eanBarcode
        .split('')
        .take(eanBarcode.length - 1)
        .map((e) => int.parse(e))
        .toList();

    var oddSum = 0;
    var evenSum = 0;

    for (var i = digits.length - 1; i >= 0; i--) {
      if ((digits.length - i) % 2 != 0) {
        oddSum += digits[i];
      } else {
        evenSum += digits[i];
      }
    }

    final checksum = (10 - (3 * oddSum + evenSum) % 10) % 10;
    return checksum;
  }
}
