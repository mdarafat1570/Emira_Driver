import 'package:ovoride_driver/core/utils/method.dart';
import 'package:ovoride_driver/core/utils/url_container.dart';
import 'package:ovoride_driver/data/model/global/response_model/response_model.dart';
import 'package:ovoride_driver/data/services/api_client.dart';

class DashBoardRepo {
  ApiClient apiClient;
  DashBoardRepo({required this.apiClient});

  Future<ResponseModel> getData() async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.dashBoardEndPoint}";
    ResponseModel responseModel = await apiClient.request(url, Method.getMethod, null, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> onlineStatus({required String lat, required String long}) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.onlineStatus}";

    Map<String, String> params = {'lat': lat, 'long': long};

    ResponseModel responseModel = await apiClient.request(url, Method.postMethod, params, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> createBid({
    required String amount,
    required String id,
  }) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.createBid}/$id";
    Map<String, String> params = {
      'bid_amount': amount,
    };
    ResponseModel responseModel = await apiClient.request(url, Method.postMethod, params, passHeader: true);
    return responseModel;
  }

  Future<ResponseModel> cancelRide({
    required String id,
    required String reason,
  }) async {
    String url = "${UrlContainer.baseUrl}${UrlContainer.cancelBid}/$id";
    Map<String, String> params = {'cancel_reason': reason};
    ResponseModel responseModel = await apiClient.request(url, Method.getMethod, params, passHeader: true);
    return responseModel;
  }
}
