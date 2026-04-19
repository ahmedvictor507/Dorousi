/// Centralized string constants for the Dourousi app.
/// All user-facing Arabic strings are kept here for easy localization.
class AppStrings {
  AppStrings._();

  // ─── App ─────────────────────────────────────────────────────────
  static const String appName = 'دروسي';
  static const String appNameEn = 'Dourousi';

  // ─── Splash / Connectivity ───────────────────────────────────────
  static const String noInternet = 'لا يوجد اتصال بالإنترنت';
  static const String noInternetDesc = 'تحقق من اتصالك بالإنترنت وحاول مرة أخرى';
  static const String retry = 'إعادة المحاولة';

  // ─── Auth ────────────────────────────────────────────────────────
  static const String login = 'تسجيل الدخول';
  static const String signup = 'إنشاء حساب';
  static const String logout = 'تسجيل الخروج';
  static const String logoutConfirm = 'هل أنت متأكد من تسجيل الخروج؟';
  static const String cancel = 'إلغاء';
  static const String confirm = 'تأكيد';
  static const String email = 'البريد الإلكتروني';
  static const String phone = 'رقم الهاتف';
  static const String phoneOrEmail = 'رقم الهاتف أو البريد الإلكتروني';
  static const String password = 'كلمة المرور';
  static const String confirmPassword = 'تأكيد كلمة المرور';
  static const String fullName = 'الاسم الكامل';
  static const String forgotPassword = 'نسيت كلمة المرور؟';
  static const String forgotPasswordTitle = 'استعادة كلمة المرور';
  static const String submit = 'إرسال';
  static const String verificationCode = 'رمز التحقق';
  static const String newPassword = 'كلمة المرور الجديدة';
  static const String createAccount = 'إنشاء حساب';
  static const String termsAccept = 'أوافق على الشروط والأحكام';
  static const String alreadyHaveAccount = 'لديك حساب بالفعل؟';
  static const String dontHaveAccount = 'ليس لديك حساب؟';
  static const String invalidCredentials = 'بيانات الدخول غير صحيحة';

  // ─── Home ────────────────────────────────────────────────────────
  static const String welcomeBack = 'أهلاً بك مجدداً';
  static const String hello = 'مرحباً';
  static const String searchHint = 'ابحث عن المعلمين أو الدروس';
  static const String liveClasses = 'الحصص المباشرة';
  static const String registeredCourses = 'الدورات المسجلة';
  static const String viewAll = 'عرض الكل';
  static const String live = 'مباشر';
  static const String joinNow = 'انضم الآن';

  // ─── Filter Chips ────────────────────────────────────────────────
  static const String all = 'الكل';
  static const String kindergarten = 'رياض أطفال';
  static const String primary = 'ابتدائي';
  static const String secondary = 'ثانوي';

  // ─── Bottom Nav ──────────────────────────────────────────────────
  static const String home = 'الرئيسية';
  static const String myCourses = 'دوراتي';
  static const String messages = 'الرسائل';
  static const String profile = 'حسابي';

  // ─── Courses ─────────────────────────────────────────────────────
  static const String courseDetails = 'تفاصيل الدورة';
  static const String buyCourse = 'شراء الدورة';
  static const String ongoingCourses = 'الدورات الجارية';
  static const String scheduledSessions = 'الحصص المجدولة';
  static const String locked = 'مقفل';
  static const String lessonCompleted = 'تم إكمال الدرس';

  // ─── Live Sessions ───────────────────────────────────────────────
  static const String sessionDetails = 'تفاصيل الحصة';
  static const String sessionNotStarted = 'لم تبدأ الحصة بعد';
  static const String sessionFull = 'الحصة ممتلئة';
  static const String sessionEnded = 'انتهت الحصة';
  static const String viewRecording = 'مشاهدة التسجيل';
  static const String seats = 'مقاعد';

  // ─── Teacher ─────────────────────────────────────────────────────
  static const String teacherProfile = 'ملف المعلم';
  static const String bookPrivate = 'حجز حصة خاصة';
  static const String availableCourses = 'الدورات المتاحة';
  static const String upcomingLives = 'الحصص القادمة';
  static const String bio = 'السيرة الذاتية';

  // ─── Booking ─────────────────────────────────────────────────────
  static const String selectSubject = 'اختر المادة';
  static const String selectDate = 'اختر التاريخ';
  static const String selectTime = 'اختر الوقت';
  static const String continueToCheckout = 'المتابعة للدفع';

  // ─── Checkout / Payment ──────────────────────────────────────────
  static const String checkout = 'الدفع';
  static const String orderSummary = 'ملخص الطلب';
  static const String promoCode = 'رمز العرض';
  static const String apply = 'تطبيق';
  static const String invalidPromo = 'رمز العرض غير صالح';
  static const String paymentMethod = 'طريقة الدفع';
  static const String cmiCard = 'بطاقة بنكية مغربية (CMI)';
  static const String creditCard = 'بطاقة ائتمان دولية';
  static const String cashPayment = 'الدفع نقداً (وفاكاش / كاش بلوس)';
  static const String totalPrice = 'المبلغ الإجمالي';
  static const String confirmPayment = 'تأكيد الدفع';
  static const String paymentSuccess = 'تمت عملية الدفع بنجاح!';
  static const String paymentFailed = 'فشلت عملية الدفع';
  static const String currency = 'د.م.'; // MAD

  // ─── Notifications ──────────────────────────────────────────────
  static const String notifications = 'الإشعارات';
  static const String noNotifications = 'لا توجد إشعارات';

  // ─── Search ──────────────────────────────────────────────────────
  static const String search = 'البحث';
  static const String noResults = 'لا توجد نتائج';

  // ─── Messages ────────────────────────────────────────────────────
  static const String typeMessage = 'اكتب رسالة...';
  static const String noMessages = 'لا توجد رسائل';

  // ─── Profile ─────────────────────────────────────────────────────
  static const String editProfile = 'تعديل الملف الشخصي';
  static const String walletBalance = 'رصيد المحفظة';
  static const String badges = 'الشارات';
  static const String settings = 'الإعدادات';
  static const String notificationSettings = 'إعدادات الإشعارات';
  static const String darkMode = 'الوضع الداكن';

  // ─── Errors ──────────────────────────────────────────────────────
  static const String errorGeneral = 'حدث خطأ ما. حاول مرة أخرى.';
  static const String fieldRequired = 'هذا الحقل مطلوب';
  static const String passwordMismatch = 'كلمات المرور غير متطابقة';
  static const String passwordTooShort = 'كلمة المرور قصيرة جداً';
}
