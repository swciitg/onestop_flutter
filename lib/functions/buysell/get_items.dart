import 'package:onestop_dev/services/api.dart';

Future<List> getBuySellItems(mail) async {
  var list1 = await APIService.getBuyItems();
  var list2 = await APIService.getSellItems();
  var list3 = await APIService.getBnsMyItems(mail);
  return [list1, list2, list3];
}
