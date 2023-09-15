import 'dart:async';
import 'dart:convert';

import 'package:cancellation_token_http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:pondrop/api/common/common.dart';
import 'package:pondrop/extensions/extensions.dart';
import 'package:pondrop/api/submissions/models/models.dart';

class SubmissionApi {
  SubmissionApi({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  static const String _baseUrl =
      'template-submission-service.ashyocean-bde16918.australiaeast.azurecontainerapps.io';

  final http.Client _httpClient;
  final Map<String, List<SubmissionTemplateDto>> _localTemplates = {};

  Future<List<SubmissionTemplateDto>> fetchTemplates(
      String accessToken, bool useCachedResult) async {
    if (_localTemplates.isNotEmpty && useCachedResult) {
      if (_localTemplates.containsKey(accessToken)) {
        return _localTemplates[accessToken]!;
      } else {
        _localTemplates.clear();
      }
    }

    final headers = _getCommonHeaders(accessToken);

    final response = await _httpClient.get(
        Uri.https(_baseUrl, '/SubmissionTemplate/active',
            {'offset': '0', 'limit': '-1'}),
        headers: headers);

    response.ensureSuccessStatusCode();

    final submissionTemplates = PaginationDto.fromJson(
        json.decode(response.body),
        (json) => SubmissionTemplateDto.fromJson(json)).items;

    if (submissionTemplates.isNotEmpty) {
      submissionTemplates.sort((t1, t2) => t1.title.compareTo(t2.title));
      _localTemplates[accessToken] = submissionTemplates;
    }

    return submissionTemplates;
  }

  Future<List<CategoryCampaignDto>> fetchCategoryCampaigns(
      String accessToken, List<String> storeIds) async {
    final headers = _getCommonHeaders(accessToken);

    final response = await _httpClient.post(
        Uri.https(_baseUrl, '/Campaign/category'),
        headers: headers,
        body: jsonEncode({'storeIds': storeIds}));

    response.ensureSuccessStatusCode();

    Iterable l = json.decode(response.body);
    final campaigns = List<CategoryCampaignDto>.from(
        l.map((i) => CategoryCampaignDto.fromJson(i)));

    return campaigns;
  }

  Future<List<ProductCampaignDto>> fetchProductCampaigns(
      String accessToken, List<String> storeIds) async {
    final headers = _getCommonHeaders(accessToken);

    final response = await _httpClient.post(
        Uri.https(_baseUrl, '/Campaign/product'),
        headers: headers,
        body: jsonEncode({'storeIds': storeIds}));

    response.ensureSuccessStatusCode();

    Iterable l = json.decode(response.body);
    final campaigns = List<ProductCampaignDto>.from(
        l.map((i) => ProductCampaignDto.fromJson(i)));

    return campaigns;
  }

  Future<StoreVisitDto> startStoreVisit(
      String accessToken, String storeId, LatLng? location) async {
    final json = jsonEncode({
      'storeId': storeId,
      'latitude': location?.latitude ?? 0,
      'longitude': location?.longitude ?? 0,
    });

    final headers = _getCommonHeaders(accessToken);

    final response = await _httpClient.post(
        Uri.https(_baseUrl, '/StoreVisit/create'),
        headers: headers,
        body: json);

    response.ensureSuccessStatusCode();

    final storeVisit = StoreVisitDto.fromJson(jsonDecode(response.body));
    return storeVisit;
  }

  Future<StoreVisitDto> endStoreVisit(
      String accessToken, String visitId, LatLng? location) async {
    final json = jsonEncode({
      'id': visitId,
      'shopModeStatus': 'Completed',
      'latitude': location?.latitude ?? 0,
      'longitude': location?.longitude ?? 0,
    });

    final headers = _getCommonHeaders(accessToken);

    final response = await _httpClient.put(
        Uri.https(_baseUrl, '/StoreVisit/update'),
        headers: headers,
        body: json);

    response.ensureSuccessStatusCode();

    final storeVisit = StoreVisitDto.fromJson(jsonDecode(response.body));
    return storeVisit;
  }

  Future<void> submitResult(
      String accessToken, SubmissionResultDto result) async {
    final json = jsonEncode(result);

    final headers = _getCommonHeaders(accessToken);

    final ct = http.TimeoutCancellationToken(const Duration(seconds: 10));

    final response = await _httpClient.post(
        Uri.https(_baseUrl, '/Submission/create'),
        headers: headers,
        body: json,
        cancellationToken: ct);

    response.ensureSuccessStatusCode();
  }

  Map<String, String> _getCommonHeaders(String accessToken) {
    return {
      'Content-type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
  }
}
