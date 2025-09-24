import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nylon/features/login/presentation/controller/controller_login.dart';

class AuthService extends GetxService {
// صندوق تخزين مستقل للجلسة — سريع زي السلة
  final GetStorage _box = GetStorage('auth');

  final userId = RxnString();
  final phone = RxnString();
  final verified = false.obs;
  final apiToken = RxnString();
  final tokenExpiry = Rxn<DateTime>();

  final _ready = false.obs;
  bool get ready => _ready.value;
  bool get isLoggedIn => (userId.value?.isNotEmpty ?? false) && verified.value;

  Future<AuthService> init() async {
// استرجاع من التخزين (زي ما السلة بتعمل)
    userId.value = _box.read('uid');
    phone.value = _box.read('phone');
    verified.value = _box.read('verified') ?? false;
    apiToken.value = _box.read('api_token');
    final exp = _box.read('token_exp');
    if (exp is String) tokenExpiry.value = DateTime.tryParse(exp);

    await _ensureToken();
    _ready.value = true;
    return this;
  }

  Future<void> _ensureToken() async {
    final expired = tokenExpiry.value == null ||
        tokenExpiry.value!.isBefore(DateTime.now());
    if ((apiToken.value == null || apiToken.value!.isEmpty) || expired) {
      try {
        final ctrl = Get.find<ControllerLogin>();
        await ctrl.checkAndCreateToken(); // موجودة أصلاً عندك
        final t = ctrl.apiToken; // عدّل لو اسم المتغير مختلف
        if (t != null && t.isNotEmpty) {
          apiToken.value = t;
          tokenExpiry.value = DateTime.now().add(const Duration(hours: 12));
          _box.write('api_token', t);
          _box.write('token_exp', tokenExpiry.value!.toIso8601String());
        }
      } catch (_) {}
    }
  }

  Future<void> saveSession(
      {required String uid,
      required String ph,
      required bool isVerified}) async {
    userId.value = uid;
    phone.value = ph;
    verified.value = isVerified;
    await _box.write('uid', uid);
    await _box.write('phone', ph);
    await _box.write('verified', isVerified);
  }

  Future<void> logout() async {
    await _box.erase();
    userId.value = null;
    phone.value = null;
    verified.value = false;
    apiToken.value = null;
    tokenExpiry.value = null;
  }
}
