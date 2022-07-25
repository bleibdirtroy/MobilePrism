import 'package:http/http.dart' as http show Client, get;
import 'package:mobileprism/constants/application.dart';
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
const headers = {"User-Agent": "$applicationName/$applicationVersion"};

class RestApiService {
  final String photoPrismUrl;
  final client = http.Client();

  RestApiService(this.photoPrismUrl);

  Uri buildPhotoUrl({
    required String hash,
    required PhotoFormat photoFormat,
  }) {
    final String format = photoFormat.toShortString();

    return Uri.parse("${photoPrismUrl}t/$hash/public/$format");
  }

  Uri buildAlbumTitlePhotoUrl({
    required String uid,
    required PhotoFormat photoFormat,
  }) {
    final String format = photoFormat.toShortString();
    return Uri.parse("${photoPrismUrl}albums/$uid/public/$format");
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
      buildMapURL(
        count: count,
        offset: offset,
        public: public,
        quality: quality,
      ),
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
  }) async {
    final response = await http.get(
      buildPhotosUrl(
        count: count,
        albumUid: albumUid,
        merged: merged,
        offset: offset,
        orderType: orderType,
      ),
      headers: headers,
    );
    return response.body;
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

    return Uri.parse("${photoPrismUrl}albums?$query");
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

    return Uri.parse("${photoPrismUrl}geo?$query");
  }

  Uri buildPhotosUrl({
    required int count,
    String? albumUid,
    int? offset,
    bool? merged,
    OrderType? orderType,
  }) {
    final String query = Uri(
      queryParameters: {
        countQueryParameter: count.toString(),
        albumQueryParameter: albumUid?.toString() ?? "",
        offsetQueryParameter: offset?.toString() ?? "",
        mergedQueryParameter: merged?.toString() ?? "",
        orderQueryParameter: orderType?.toShortString() ?? "",
      },
    ).query;

    return Uri.parse("${photoPrismUrl}photos?$query");
  }
}

extension ParseToString on Enum {
  String toShortString() {
    return toString().split('.').last;
  }
}
