import 'package:http/http.dart' as http show Client, get;
import 'package:mobileprism/constants/application.dart';
import 'package:mobileprism/services/auth/auth_service.dart';
import 'package:mobileprism/services/rest_api/album_type.dart';
import 'package:mobileprism/services/rest_api/order_type.dart';
import 'package:mobileprism/services/rest_api/photo_format.dart';

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

  RestApiService();

  Future<String> _getPhotoprimUrl() async {
    return authService.getHostname();
  }

  Future<String> getAlbums({
    required AlbumType albumType,
    required int count,
    int? offset,
    OrderType? orderType,
  }) async {
    final response = await http.get(
      await buildAlbumURL(
        albumType: albumType,
        count: count,
        offset: offset,
        orderType: orderType,
      ),
      headers: headers,
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
      await buildMapURL(
        count: count,
        offset: offset,
        public: public,
        quality: quality,
      ),
      headers: headers,
    );
    return response.body;
  }

  Future<String> getPhoto({
    String? uid,
    String? hash,
  }) async {
    final response = await http.get(
      await buildPhotosUrl(count: 1, hash: hash, uid: uid),
      headers: headers,
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
      await buildPhotosUrl(
        count: count,
        albumUid: albumUid,
        merged: merged,
        offset: offset,
        orderType: orderType,
        month: month,
        year: year,
      ),
      headers: headers,
    );
    return response.body;
  }

  Future<Uri> buildPhotoUrl({
    required String hash,
    required PhotoFormat photoFormat,
  }) async {
    final photoPrismUrl = await _getPhotoprimUrl();
    final String format = photoFormat.toShortString();
    return Uri.parse(
      "$photoPrismUrl${photoprismApiPath}t/$hash/public/$format",
    );
  }

  Future<Uri> buildAlbumTitlePhotoUrl({
    required String uid,
    required PhotoFormat photoFormat,
  }) async {
    final photoPrismUrl = await _getPhotoprimUrl();
    final String format = photoFormat.toShortString();
    return Uri.parse(
        "$photoPrismUrl${photoprismApiPath}albums/$uid/public/$format");
  }

  Future<Uri> buildAlbumURL({
    required AlbumType albumType,
    required int count,
    int? offset,
    OrderType? orderType,
  }) async {
    final photoPrismUrl = await _getPhotoprimUrl();
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

  Future<Uri> buildMapURL({
    int? count,
    int? offset,
    bool? public,
    int? quality,
  }) async {
    final photoPrismUrl = await _getPhotoprimUrl();
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

  Future<Uri> buildPhotosUrl({
    required int count,
    String? albumUid,
    int? offset,
    bool? merged,
    OrderType? orderType,
    int? month,
    int? year,
    String? hash,
    String? uid,
  }) async {
    final photoPrismUrl = await _getPhotoprimUrl();
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
