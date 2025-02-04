import 'package:onestop_dev/globals/endpoints.dart';
import 'package:onestop_dev/models/lostfound/found_model.dart';
import 'package:onestop_dev/models/lostfound/lost_model.dart';
import 'package:onestop_kit/onestop_kit.dart';

class LnfRepository extends OneStopApi {
  LnfRepository()
      : super(
          onestopBaseUrl: Endpoints.baseUrl,
          serverBaseUrl: Endpoints.baseUrl,
          onestopSecurityKey: Endpoints.apiSecurityKey,
        );

  Future<dynamic> claimFoundItem(
      {required String name, required String email, required String id}) async {
    var res = await serverDio.post(Endpoints.claimItemURL,
        data: {"id": id, "claimerEmail": email, "claimerName": name});
    return res.data;
  }

  Future<void> deleteLnfMyAd(String id, String email) async {
    await serverDio
        .post(Endpoints.deleteLostURL, data: {'id': id, 'email': email});
    await serverDio
        .post(Endpoints.deleteFoundURL, data: {'id': id, 'email': email});
  }

  Future<List<dynamic>> getLnfMyItems(String mail, bool isLost) async {
    var res =
        await serverDio.post(Endpoints.lnfMyAdsURL, data: {'email': mail});
    var myItemsDetails = res.data;
    var foundList = (myItemsDetails["details"]["foundList"] as List)
        .map((e) => FoundModel.fromJson(e))
        .toList();
    var lostList = (myItemsDetails["details"]["lostList"] as List)
        .map((e) => LostModel.fromJson(e))
        .toList();
    //await Future.delayed(const Duration(milliseconds: 300), () => null);
    if (isLost) {
      return lostList;
    } else {
      return foundList;
    }
  }

  Future<List> getLostItems() async {
    var res = await serverDio.get(Endpoints.lostURL);
    var lostItemsDetails = res.data;
    return lostItemsDetails["details"];
  }

  Future<List<LostModel>> getLostPage(int pageNumber) async {
    final queryParameters = {
      'page': pageNumber.toString(),
    };
    var response = await serverDio.get(Endpoints.lostPath,
        queryParameters: queryParameters);
    var json = response.data;
    List<LostModel> lostPage = (json['details'] as List<dynamic>)
        .map((e) => LostModel.fromJson(e))
        .toList();
    // await Future.delayed(const Duration(milliseconds: 300), () => null);
    return lostPage;
  }

  Future<List<FoundModel>> getFoundPage(int pageNumber) async {
    final queryParameters = {
      'page': pageNumber.toString(),
    };
    var response = await serverDio.get(Endpoints.foundPath,
        queryParameters: queryParameters);
    var json = response.data;
    List<FoundModel> lostPage = (json['details'] as List<dynamic>)
        .map((e) => FoundModel.fromJson(e))
        .toList();
    //await Future.delayed(const Duration(milliseconds: 300), () => null);
    return lostPage;
  }

  Future<List> getFoundItems() async {
    var res = await serverDio.get(Endpoints.foundURL);
    var foundItemsDetails = res.data;
    return foundItemsDetails["details"];
  }

  Future<Map<String, dynamic>> postLostData(Map<String, String> data) async {
    var res = await serverDio.post(Endpoints.lostURL, data: {
      'title': data['title'],
      'description': data['description'],
      'location': data['location'],
      'imageString': data['image'],
      'phonenumber': data['contact'],
      'email': data['email'],
      'username': data['name']
    });
    return res.data;
  }

  Future<Map<String, dynamic>> postFoundData(Map<String, String> data) async {
    var res = await serverDio.post(Endpoints.foundURL, data: {
      'title': data['title'],
      'description': data['description'],
      'location': data['location'],
      'imageString': data['image'],
      'submittedat': data['submittedAt'],
      'email': data['email'],
      'username': data['name']
    });
    return res.data;
  }
}
