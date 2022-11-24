import 'Strings.dart';

class FrenchStrings extends Strings {
  @override
  String appName = "MyApp";

  @override
  String email = 'البريد الإلكتروني';
  @override
  String password = 'كلمة المرور';

  @override
  String validEmailText = 'الرجاء التحقق من الإيميل';
  @override
  String validePwd = 'يجب أن تكون كلمة المرور أكثر من  8 أحرف';
  @override
  String mandatoryField = 'الرجاء إكمال هذا الحقل';

  @override
  String signInButonText = 'تسجيل الدخول';

  @override
  String get errorWS => "خطأ في الإتصال بالخادم";

  @override
  // TODO: implement login
  String get login => "تسجيل الدخول";

  @override
  // TODO: implement skip
  String get skip => "تخطي";
  String get search => "البحث";

  @override
  String get topCategories => "Top categories";

  @override
  String get latestListing => "Latest Listings";

  @override
  String get seeMore => "Show more >";

  @override
  String get classified => "Classifieds";

  @override
  String get latestEvents => "Latest Events";

  @override
  // TODO: implement notregistred
  String get notregistred =>
      "You have to create an account to display the data for you, simple steps are waiting for you";
}
