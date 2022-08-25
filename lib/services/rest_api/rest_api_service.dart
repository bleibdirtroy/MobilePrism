import 'dart:convert';

import 'package:http/http.dart' as http show Client, get, post;
import 'package:mobileprism/constants/application.dart';
import 'package:mobileprism/services/auth/auth_service.dart';
import 'package:mobileprism/services/rest_api/album_type.dart';
import 'package:mobileprism/services/rest_api/order_type.dart';
import 'package:mobileprism/services/rest_api/photo_format.dart';
import 'package:mobileprism/services/rest_api/rest_api_exceptions.dart';

const typeQueryParameter = "type";
const countQueryParameter = "count";
const offsetQueryParameter = "offset";
const orderQueryParameter = "order";
const publicQueryParameter = "public";
const qualityQueryParameter = "quality";
const albumQueryParameter = "album";
const mergedQueryParameter = "merged";
const filterQueryParameter = "filter";
const hashQueryParameter = "hash";
const uidQueryParameter = "uid";

const headers = {"User-Agent": "$applicationName/$applicationVersion"};

class RestApiService {
  final client = http.Client();
  final authService = AuthService.secureStorage();
  final String photoPrismUrl;
  String? token;
  String previewToken = "public";

  RestApiService(this.photoPrismUrl);

  Future<void> _getToken() async {
    token = token ?? await AuthService.secureStorage().getSessionToken();
  }

  bool _isTokenSet() {
    return token != null;
  }

  Future<Map<String, String>> _getHeader() async {
    if (!_isTokenSet()) await _getToken();
    return {
      "User-Agent": "$applicationName/$applicationVersion",
      "x-session-id": token!
    };
  }

  Future<Set<String>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse("$photoPrismUrl${photoprismApiPath}session"),
      headers: headers,
      body: jsonEncode(
        <String, String>{"username": username, "password": password},
      ),
    );
    final sessionToken = response.headers["x-session-id"].toString();
    final previewToken =
        jsonDecode(response.body)["config"]["previewToken"].toString();
    if (sessionToken == "null" || previewToken == "null") {
      throw WrongCredentialsException();
    } else {
      return {sessionToken, previewToken};
    }
  }

  Future<String> getAlbums({
    required AlbumType albumType,
    required int count,
    int? offset,
    OrderType? orderType,
  }) async {
    final response = await http.get(
      buildAlbumURL(
        albumType: albumType,
        count: count,
        offset: offset,
        orderType: orderType,
      ),
      headers: await _getHeader(),
    );
    return response.body;
  }

  Future<String> getMap({
    int? count,
    int? offset,
    bool? public,
    int? quality,
  }) async {
    final response = await http.get(
      buildMapURL(
        count: count,
        offset: offset,
        public: public,
        quality: quality,
      ),
      headers: await _getHeader(),
    );
    return response.body;
  }

  Future<String> getPhoto({
    String? uid,
    String? hash,
  }) async {
    final response = await http.get(
      buildPhotosUrl(count: 1, hash: hash, uid: uid),
      headers: await _getHeader(),
    );

    return response.body;
  }

  Future<String> getPhotos({
    required int count,
    String? albumUid,
    int? offset,
    bool? merged,
    OrderType? orderType,
    int? month,
    int? year,
  }) async {
    final response = await http.get(
      buildPhotosUrl(
        count: count,
        albumUid: albumUid,
        merged: merged,
        offset: offset,
        orderType: orderType,
        month: month,
        year: year,
      ),
      headers: await _getHeader(),
    );
    return response.body;
  }

  Uri buildAlbumTitlePhotoUrl({
    required String uid,
    required PhotoFormat photoFormat,
  }) {
    final String format = photoFormat.toShortString();
    return Uri.parse(
      "$photoPrismUrl${photoprismApiPath}albums/$uid/public/$format",
    );
  }

  Uri buildAlbumURL({
    required AlbumType albumType,
    required int count,
    int? offset,
    OrderType? orderType,
  }) {
    final String query = Uri(
      queryParameters: {
        typeQueryParameter: albumType.toShortString(),
        countQueryParameter: count.toString(),
        offsetQueryParameter: offset?.toString() ?? "",
        orderQueryParameter: orderType?.toShortString() ?? "",
      },
    ).query;

    return Uri.parse("$photoPrismUrl${photoprismApiPath}albums?$query");
  }

  Uri buildMapURL({
    int? count,
    int? offset,
    bool? public,
    int? quality,
  }) {
    final String query = Uri(
      queryParameters: {
        publicQueryParameter: public?.toString() ?? "",
        countQueryParameter: count?.toString() ?? "",
        offsetQueryParameter: offset?.toString() ?? "",
        qualityQueryParameter: quality?.toString() ?? "",
      },
    ).query;

    return Uri.parse("$photoPrismUrl${photoprismApiPath}geo?$query");
  }

  Uri buildPhotosUrl({
    required int count,
    String? albumUid,
    int? offset,
    bool? merged,
    OrderType? orderType,
    int? month,
    int? year,
    String? hash,
    String? uid,
  }) {
    String query = Uri(
      queryParameters: {
        countQueryParameter: count.toString(),
        albumQueryParameter: albumUid?.toString() ?? "",
        offsetQueryParameter: offset?.toString() ?? "",
        mergedQueryParameter: merged?.toString() ?? "",
        orderQueryParameter: orderType?.toShortString() ?? "",
        hashQueryParameter: hash ?? "",
        uidQueryParameter: uid ?? "",
      },
    ).query;

    if (month != null && year != null) {
      final String filter = "year:$year+month:$month";
      query = "$query&filter=$filter";
    }
    return Uri.parse("$photoPrismUrl${photoprismApiPath}photos?$query");
  }
}
