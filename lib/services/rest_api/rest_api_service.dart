import 'package:http/http.dart' as http;
import 'package:mobileprism/services/rest_api/album_type.dart';
import 'package:mobileprism/services/rest_api/order_type.dart';

const typeQueryParameter = "type";
const countQueryParameter = "count";
const offsetQueryParameter = "offset";
const orderQueryParameter = "order";
const publicQueryParameter = "public";
const qualityQueryParameter = "quality";

class RestApiService {
  final String photoPrismUrl;
  final client = http.Client();

  RestApiService(this.photoPrismUrl);

  Uri buildAlbumURL({
    required AlbumType albumType,
    required int count,
    int? offset,
    OrderType? orderType,
  }) {
    final String type = _getAlbumType(albumType);
    final String order = _getOrderType(orderType);

    final String query = Uri(
      queryParameters: {
        typeQueryParameter: type,
        countQueryParameter: count.toString(),
        offsetQueryParameter: offset?.toString() ?? "",
        orderQueryParameter: order,
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

  String _getOrderType(OrderType? orderType) {
    final String order;
    switch (orderType) {
      case OrderType.newest:
        order = "newest";
        break;
      case OrderType.place:
        order = "place";
        break;
      default:
        order = "";
        break;
    }
    return order;
  }

  String _getAlbumType(AlbumType albumType) {
    final String type;
    switch (albumType) {
      case AlbumType.calendar:
        type = "month";
        break;
      case AlbumType.album:
        type = "album";
        break;
      case AlbumType.folder:
        type = "folder";
        break;
      case AlbumType.state:
        type = "state";
        break;
      case AlbumType.moments:
        type = "moment";
        break;
    }
    return type;
  }
}
