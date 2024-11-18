import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class GetStoreData extends GetxController {
  static var getStore = GetStorage();

  static void storeUserData({
    required String id,
    required String name,
    required String email,
    required String phone,
    required String authToken,
  }) {
    getStore.write('access_token', authToken);
    getStore.write('id', id);
    getStore.write('name', name);
    getStore.write('phone', phone);
    getStore.write('email', email);
  }

  static void locationData({
    required double longitude,
    required double latitude,
  }) {
    getStore.write('long', longitude);
    getStore.write('lat', latitude);
  }
}
