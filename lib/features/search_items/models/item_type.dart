import 'package:pondrop/api/submissions/models/submission_template_field_dto.dart';

enum SearchItemType { category, product }

extension SubmissionFieldItemTypeX on SubmissionFieldItemType {
  SearchItemType toSearchItemType() {
    switch (this) {
      case SubmissionFieldItemType.product:
        return SearchItemType.product;
      case SubmissionFieldItemType.category:
        return SearchItemType.category;
      default:
        throw Exception('Not supported "$this"');
    }
  }
}

