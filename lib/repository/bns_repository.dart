import 'package:onestop_dev/globals/endpoints.dart';
import 'package:onestop_dev/models/buy_sell/buy_model.dart';
import 'package:onestop_dev/models/buy_sell/sell_model.dart';
import 'package:onestop_dev/repository/api_repository.dart';

class BnsRepository extends APIRepository {
  Future<void> deleteBnsMyAd(String id, String email) async {
    await serverDio
        .post(Endpoints.deleteBuyURL, data: {'id': id, 'email': email});
    await serverDio
        .post(Endpoints.deleteSellURL, data: {'id': id, 'email': email});
  }

  Future<List> getBuyItems() async {
    var response = await serverDio.get(Endpoints.buyURL);
    return response.data.details;
  }

  Future<List> getSellItems() async {
    var res = await serverDio.get(Endpoints.sellURL);
    return res.data.details;
  }

  Future<List<BuyModel>> getBnsMyItems(String mail, bool isSell) async {
    var res =
        await serverDio.post(Endpoints.bnsMyAdsURL, data: {'email': mail});
    var myItemsDetails = res.data;
    var sellList = (myItemsDetails["details"]["sellList"] as List)
        .map((e) => BuyModel.fromJson(e))
        .toList();
    var buyList = (myItemsDetails["details"]["buyList"] as List)
        .map((e) => BuyModel.fromJson(e))
        .toList();
    //await Future.delayed(const Duration(milliseconds: 300), () => null);
    if (isSell) {
      return sellList;
    } else {
      return buyList;
    }
  }

  Future<List<BuyModel>> getSellPage(int pageNumber) async {
    try {
      final queryParameters = {
        'page': pageNumber.toString(),
      };
      var response = await serverDio.get(Endpoints.sellPath,
          queryParameters: queryParameters);
      var json = response.data;
      List<BuyModel> sellPage = (json['details'] as List<dynamic>)
          .map((e) => BuyModel.fromJson(e))
          .toList();
      //await Future.delayed(const Duration(milliseconds: 300), () => null);
      return sellPage;
    } catch (e) {
      print('Error in getSellPage: $e');
      rethrow;
    }
  }

  Future<List<SellModel>> getBuyPage(int pageNumber) async {
    final queryParameters = {
      'page': pageNumber.toString(),
    };
    var response = await serverDio.get(Endpoints.buyPath,
        queryParameters: queryParameters);
    var json = response.data;
    List<SellModel> buyPage = (json['details'] as List<dynamic>)
        .map((e) => SellModel.fromJson(e))
        .toList();
    //await Future.delayed(const Duration(milliseconds: 300), () => null);
    return buyPage;
  }

  Future<Map<String, dynamic>> postSellData(Map<String, String> data) async {
    var res = await serverDio.post(Endpoints.sellURL, data: {
      'title': data['title'],
      'description': data['description'],
      'price': data['price'],
      'imageString': data['image'],
      'phonenumber': data['contact'],
      'email': data['email'],
      'username': data['name']
    });
    return res.data;
  }

  Future<Map<String, dynamic>> postBuyData(Map<String, String> data) async {
    var res = await serverDio.post(Endpoints.buyURL, data: {
      'title': data['title'],
      'description': data['description'],
      'price': data['total_price'],
      'imageString': data['image'],
      'phonenumber': data['contact'],
      'email': data['email'],
      'username': data['name']
    });
    return res.data;
  }
}
