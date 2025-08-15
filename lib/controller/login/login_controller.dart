part of login;

class LoginController extends GetxController {
  static bool logined = false;
  var username = ''.obs;
  var password = ''.obs;
  var address = ''.obs;

  GetStorage storage = GetStorage();

  @override
  Future<void> onInit() async {
    final settingsController = Get.find<SettingsController>();
    username.value = storage.read('username') ?? "";
    password.value = storage.read('password') ?? "";
    address.value = settingsController.readAddress();

    if (address.value.isNotEmpty && !logined) {
      logined = true;
      await login(address.value);
    }
    super.onInit();
  }

  /// 进入主页面
  Future<void> toMain({required Map<String, dynamic> data}) async {
    storage.write('username', data['username']);
    storage.write('password', data['password']);
    // 使用SettingsController存储地址
    final settingsController = Get.find<SettingsController>();
    settingsController.writeAddress(data['address']);
    printInfo(info: data.toString());
    await login(data['address']);
  }

  Future<void> login(String address) async {
    ApiClient().setAddress('http://$address');
    if (await ApiClient().testAddress()) {
      // Get.snackbar('Success', 'Successfully connected to OAS server');
      Get.offAllNamed('/main');
    } else {
      Get.snackbar('Error', 'Failed to connect to OAS server');
    }
  }
}
