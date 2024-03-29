import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http show Client, get, post;
import 'package:mobileprism/constants/application.dart';
import 'package:mobileprism/models/photo_prism_server.dart';
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
  final _authService = AuthService.secureStorage();
  String previewToken = "public";

  RestApiService();

  Map<String, String> getHeader() {
    return {
      "User-Agent": "$applicationName/$applicationVersion",
      "x-session-id": PhotoPrismServer().sessionToken
    };
  }

  Future<bool> hasConnection([String? hostname]) async {
    try {
      final response =
          await http.get(Uri.parse(hostname ?? PhotoPrismServer().hostname));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<Set<String>> login(
    String hostname,
    String username,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse("$hostname${photoprismApiPath}session"),
      headers: headers,
      body: jsonEncode(
        <String, String>{"username": username, "password": password},
      ),
    );

    final sessionToken = response.headers["x-session-id"].toString();
    final previewToken =
        ((jsonDecode(response.body) as Map<String, dynamic>)["config"]!
                as Map<String, dynamic>)["previewToken"]
            .toString();
    if (sessionToken == "null" || previewToken == "null") {
      log("exception");
      throw WrongCredentialsException();
    } else {
      log("fertig");
      return {sessionToken, previewToken};
    }
  }

  Future<void> refreshToken() async {
    final password = await _authService.getPassword();

    final token = await login(
      PhotoPrismServer().hostname,
      PhotoPrismServer().username,
      password,
    );
    final sessionToken = token.first;
    final previewToken = token.last;

    PhotoPrismServer().sessionToken = sessionToken;
    PhotoPrismServer().previewToken = previewToken;

    await _authService.setSessionToken(sessionToken);
    await _authService.setPreviewToken(previewToken);
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
      headers: getHeader(),
    );
    if (response.statusCode == 401) {
      await refreshToken();
      return getAlbums(albumType: albumType, count: count);
    } else {
      return response.body;
    }
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
      headers: getHeader(),
    );
    if (response.statusCode == 401) {
      await refreshToken();
      return getMap();
    } else {
      return response.body;
    }
  }

  Future<String> getPhoto({
    String? uid,
    String? hash,
  }) async {
    final response = await http.get(
      buildPhotosUrl(count: 1, hash: hash, uid: uid),
      headers: getHeader(),
    );

    if (response.statusCode == 401) {
      await refreshToken();
      return getPhoto(uid: uid, hash: hash);
    } else {
      return response.body;
    }
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
      headers: getHeader(),
    );
    if (response.statusCode == 401) {
      await refreshToken();
      return getPhotos(
        count: count,
        albumUid: albumUid,
        merged: true,
        month: month,
        offset: offset,
        orderType: orderType,
        year: year,
      );
    } else {
      return response.body;
    }
  }

  Uri buildAlbumTitlePhotoUrl({
    required String uid,
    required PhotoFormat photoFormat,
  }) {
    final String format = photoFormat.toShortString();
    return Uri.parse(
      "${PhotoPrismServer().hostname}${photoprismApiPath}albums/$uid/public/$format",
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

    return Uri.parse(
      "${PhotoPrismServer().hostname}${photoprismApiPath}albums?$query",
    );
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

    return Uri.parse(
      "${PhotoPrismServer().hostname}${photoprismApiPath}geo?$query",
    );
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
      final String filter = "year:$year+month:$month+public:true";
      query = "$query&filter=$filter";
    }
    return Uri.parse(
      "${PhotoPrismServer().hostname}${photoprismApiPath}photos?$query",
    );
  }
}
