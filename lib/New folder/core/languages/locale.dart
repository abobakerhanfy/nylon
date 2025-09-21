import 'package:get/get.dart';

class MyLocale implements Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'ar': {
          '1': 'مرحبا بك في متجر نايلون',
          '2': 'رقم الهاتف',
          '3': 'احصل علي الرمز',
          '4': 'يمكنك الدخول للمتجر بدون تسجيل حساب',
          '5': 'التحقق من الحساب',
          '6': 'قم بالتحقق من حسابك عن طريق رمز التحقق، الذي ارسالنه إلى ',
          '7': 'إعادة ارسال الرمز',
          '8': 'تحقق الان',
          '9': 'تم التحقق من الحساب',
          '10': 'وسيتم تحويلك الي الصفحة الرئيسية',
          '11': 'ريال',
          '12': 'ابحث عن منتجك المفضل',
          '13': 'مرحبا بك في متجر نايلون',
          '14':
              'احصل علي كل مقاضيك في مكان واحد\n  باسعار اقل من اسعار الجملة ',
          '15': 'أبدا الاستمتاع',
          '16': 'الرئيسية',
          '17': 'الاقسام',
          '18': 'سلة التسوق',
          '19': 'المفضلة',
          '20': 'حسابي',
          '21': 'لا توجد أي منتجات مفضلة',
          '22': 'انشاء حساب جديد',
          '23': 'تسجيل الدخول',
          '24': 'دعوة صديق',
          '25': 'تواصل معانا',
          '26': 'اللغة',
          '27': 'المحفظة',
          '28': 'العنوان',
          '29': 'كوبون هدايا',
          '30': 'الطلبات',
          '31': 'الارجاع',
          '32': 'الرصيد',
          '33': 'عربة التسوق',
          '34': 'التحقق',
          '35': 'بيانات الدفع',
          '36': 'تاكيد الطلب',
          '37': 'تاكيد الطلب بنجاح',
          '38': 'السلة',
          '39': 'الدفع والشحن',
          '40': 'التوصيل',
          '41': 'تاكيد الطلب',
          '42': 'كوبون خصم',
          '43': 'كود الخصم',
          '44': 'تطبيق',
          '45': 'الاجمالي',
          '46': 'الإجمالي شامل الضريبة',
          '47': 'اشتري الان',
          '48': 'الاسم بالكامل',
          '49': 'البريد الالكتروني',
          '50': 'رقم الجوال',
          '51': 'العنوان',
          '52': 'المحافظة',
          '53': 'رقم البريدي',
          '54': 'الخطوة التالية',
          '55': 'تفاصيل البطاقة',
          '56': 'حفظ معلومات بطاقة الائتمان',
          '57': 'الرياض شارع عثمان ابن عفان',
          '58': 'تـم ارسـال طـلبك',
          '59': 'رقم تتبع الطلب ',
          '60':
              ' شكرا لتسوقكم معانا وسيتم متابعة الطلب من خلال الرقم وارسال حالة الطلب عن طريق الواتس اب',
          '61': 'الوصف',
          '62': 'أضافة الى السلة',
          '63': 'ترتيب',
          '64': 'التصنيف',
          '65': 'الأقسام الفرعية',
          '66': 'الكمية',
          '67': 'نايلون',
          'more_item': 'عرض المزيد',
          '69': 'سياسة الارجاع',
          '70': 'سياسة الخصوصية',
          '71': 'اتفاقية المستخدم',
          '72': 'الاصدار',
          '73': 'جميع الحقوق محفوظة',
          '74': 'رسوم الشحن',
          '75': 'رسوم الدفع عند الاستلام',
          '76': 'ضريبة القيمة المضافة',
          '77': 'الاجمالي النهائي شامل القيمة المضافة',
          '78': 'قمنا بارسال كود الي 09090229892 الرجاء ادخال الكود للمتابعة',
          '79': 'اعادة ارسال',
          '80': 'قم بالتحقق من رقم الهاتف عن طريق رمز التحقق، الذي ارسالنه إلى',
          '81': 'وسيتم تحويلك لصفحه الدفع',
          '82': 'تتبع الشحن',
          '83': 'برجاء كتابة رقم الطلب',
          '84': 'العناوين',
          '85': 'اضافة عنوان جديد',
          '86': 'البيانات الشخصية',
          '87': 'الاسم الاول ',
          '88': 'الاسم الاخير',
          '89': 'العنوان',
          '90': 'اسم الحي / اسم الشارع',
          '91': 'المدينة',
          '92': 'الرمز البريدي',
          '93': 'برجاء اختيار اسم مستعار لهذا العنوان',
          '94': 'المنزل',
          '95': 'المكتب',
          '96': 'اخري',
          '97': 'سيتم تسمية هذا العنوان ب',
          '98': 'طلباتي',
          '99': 'مكتمل',
          '100': 'رقم الطلب',
          '101': 'تاريخ الطلب',
          '102': 'تفاصيل الطلب',
          '103': 'إعادة الطلب',
          '104': 'الطلب به مشكلة',
          '105': 'العنوان والشحن',
          '106': 'الشحن حسب الوزن',
          '107': 'عادة الشحن ياخد من 3 ل 5 أياما الوقت المتوقع لتسليم الطلب ',
          '108': 'ملخص الدفع',
          '109': 'مدفوع',
          '110': 'السعر قبل الضريبة',
          '111': 'الضريبة',
          '112': 'الاجمالي بعد الضريبة والشحن',
          '113': 'الشكاوي',
          '114': 'بيانات التواصل',
          '115': 'الطلب',
          '116': 'وصف المشكلة',
          '117': 'ارسال الشكوي',
          '118': 'تم ارسال الشكوي',
          '119': 'وسيتم التواصل معاكم \n في اسرع وقت ممكن',
          '120': 'الاستبدال والارجاع',
          '121': 'إلغاء الطلب',
          '122': 'تعديل و الطلب مره اخري',
          '123': 'اضافة الرصيد',
          '124': 'الرصيد الحالي',
          '125': 'القيمة',
          '126': 'ريال سعودي',
          '127': 'اقل قيمة شحن 50 ريال',
          '128': 'وصف للمبلغ (اختياري)',
          '129': 'وصف للمبلغ',
          '130': 'كوبوناتي',
          '131': 'كود الخصم',
          '132': 'الوقت التقديري لوصول',
          '133': 'تم الطلب',
          '134': 'لقد تلقينا طلبك',
          '135': 'تم تأكيد عملية الدفع ',
          '136': 'بانتظار التأكيد',
          '137': 'تم ارسال الطلب لشركة الشحن',
          '138': 'تم طلب الشحن وسيتم التواصل معاك في اقرب وقت',
          '139': 'الطلب في الطريق اليك',
          '140': 'نحن نجهز طلبك ..',
          '141': 'جاهز للاستلام',
          '142': 'تم التسليم',
          '143': 'لا تنسى التقييم',
          '144': 'ٍسنكون سعداء جدا اذا قمت بتقييم المنتجات',
          '145': 'داخل الرياض  3 : 4 ايام \n خارج الرياض 3 : 6 ايام ',
          '146': 'قائمة الرغبات',
          '147': 'أضافة الي عربة التسوق',
          '148': "لم يتم العثور على أي منتجات..!!",
          '149': 'سلة المشتريات فارغه \n  تسوق الان',
          '150': 'حذف من السلة',
          '151': 'فشل الاتصال بالخادم',
          '152': 'لا يوجد اتصال بالإنترنت!',
          '153': 'البيانات غير متوفرة؟',
          '154': 'حدث خطأ ما. أعد المحاولة من فضلك!',
          '155': 'لم يتم العثور',
          '156': 'غير مصرح لك!',
          '157': 'رجاء تسجيل الدخول للمتابعة',
          '158': 'حدث خطأ غير معروف',
          '159': 'تم اضافة المنتج الي السلة ',
          '160': 'تم حدف المنتج من السلة',
          '161': 'الاسم الاول',
          '162': 'الاسم الاخير',
          '163': 'مطلوب',
          '164': 'الرمز البريدي للمدينة',
          '165': 'الرمز البريدي للمنطقه',
          '166': 'رجاء قم بتحديد طريقة الدفع',
          '167': 'الشحن',
          '168': 'رجاء قم بتحديد طريقة الشحن',
          '169': 'طريقة الدفع : ',
          '170': 'طريقة الشحن : ',
          '171': 'البريد الالكتروني',
          '172': 'رقم الهاتف غير صحيح',
          '173': 'البريد الإلكتروني غير صالح',
          '174': 'رجاء قم بتاكيد عنوان الشحن',
          '175': 'عنوان الشحن : ',
          '176': 'تاكيد العنوان',
          '177': 'من فضلك أرفق إيصال الدفع',
          '178': 'تفاصيل الحساب البنكي للمتجر',
          '179': 'رقم الحساب البنكي',
          '180': 'تم',
          '181': 'أكمل الطلب بـ ',
          '182': 'للحصول على شحن مجاني!',
          '183': 'مبروك  لقد حصلت على شحن مجاني',
          '184': 'عرض خاص ',
          '185': 'حسناً',
          '186': "يرجى تحميل صورة إثبات الدفع قبل إرسال الطلب.",
          '187': 'اسم الحي ',
          '188': 'اطلب بقيمة 350.0 ريال للحصول علي الشحن المجاني',
          '189': 'تهانينا لقد حصلت علي الشحن المجاني',
          '190': 'عرض المزيد...',
          '191': 'التقييمات',
          '192': 'تخفيض',
          '193': 'متاح حتي يوم ',
          '194': 'رقم طلب الشحن',
          '195': 'شحن مجاني ',
          '196': 'تم حدف المنتج من المفضلة',
          '197': 'تم اضافة المنتج الي المفضلة ',
          '198': 'عرض',
          '199': ' قطعه او اكثر واحصل علي المنتح بسعر',
          '200': 'اشتري',
          "201": "المعلومات الشخصية",
          "202": 'تقيم التطبيق',
          "203": 'تسجيل الخروج',
          "204": 'منتج',
          "205": "",
          '206': '',
          "207": "",
          "208": '',
          "209": '',
          "210": "",
          '211': 'جاري تنفيذ طلبك',
          '212': 'جاري التحديث',
          '213': 'يتم تحديث الفاتورة...',
          '214': 'برجاء ازالة هذا المنتج',
          '215': 'حذف الحساب',
          'delete_account_title': 'هل تريد حذف الحساب نهائيًا؟',
          'delete_account_cancel': 'إلغاء',
          'delete_account_confirm': 'حذف',
          'delete_account_fail': 'فشل حذف الحساب من السيرفر',
          'delete_account_no_data': 'لا توجد بيانات كافية لحذف الحساب',
          'vericfy_page_text':
              "يرجى إدخال رقم هاتفك لتأكيد الطلب وإتمام عملية الشراء.\n"
                  "إذا كنت مسجلاً من قبل، سنعرض بياناتك تلقائيًا.\n"
                  "وإذا لم يكن لديك حساب، يمكنك إنشاء حساب جديد وإضافة عنوان.",
          "code_active": "برجاء ادخال رمز التحقق ",
          "confirm_text": "تأكيد",
          "search_hint": "ابحث باستخدام كلمات رئيسية",
          "search_error": "حدث خطأ، حاول مرة أخرى",
          "search_empty": "لا توجد نتائج",
          "track_on_smsa": "تتبع على سمسا 🔗",
          "tracking_pending": "جارٍ تجهيز الشحنة وإرسالها لشركة الشحن",
          "copied": "تم النسخ",
          "order_status": "حالة الطلب",
        },
        'en': {
          '1': 'Welcome to Nylon Store',
          '2': 'phone number',
          '3': 'Get the code',
          '4': 'You can enter the store without registering an account',
          '5': 'Account verification',
          '6':
              'Verify your account using the verification code, which we sent to',
          '7': 'Resend the code',
          '8': 'Check now',
          '9': 'The account has been verified',
          '10': 'You will be transferred to Homepage',
          '11': 'SAR',
          '12': 'Find your favorite product',
          '13': 'Welcome to Nylon Store',
          '14':
              'Get all your needs in one place \n at prices lower than wholesale prices',
          '15': 'Enjoy now',
          '16': 'Home',
          '17': "Categories",
          '18': 'Cart',
          '19': 'Favorites',
          '20': 'Profile',
          '21': 'There are no favorite products',
          '22': 'register',
          '23': 'Login',
          '24': 'Invite friend',
          '25': 'Contact us',
          '26': 'Language',
          '27': 'Wallet',
          '28': 'Addresses',
          '29': 'Gift coupon',
          '30': 'Orders',
          '31': 'Returns',
          '32': 'Balance',
          '33': "Shopping cart",
          '34': 'verification',
          '35': 'Payment information',
          '36': 'Order confirmation',
          '37': 'order successfully',
          '38': 'Cart',
          '39': 'Payment and Shipping',
          '40': 'Delivery',
          '41': 'Confirm',
          '42': 'Discount coupon',
          '43': 'Discount code',
          '44': 'Send',
          '45': 'Total',
          '46': 'Total including tax',
          '47': 'Buy now',
          '48': 'full name',
          '49': 'email',
          '50': 'phone number',
          '51': 'Address',
          '52': 'city',
          '53': 'postal code',
          '54': 'next step',
          '55': 'Card details',
          '56': 'Save credit card information',
          '57': 'Riyadh, Othman Ibn Affan Street',
          '58': 'Your request has been sent',
          '59': 'Tracking number 1234 and the order was completed successfully',
          '60':
              'Thank you for shopping with us. The order will be followed up through the number and the order status will be sent via WhatsApp',
          '61': 'Description',
          '62': 'Add to cart',
          '63': 'Arrange',
          '64': 'Category',
          '65': 'Subsections',
          '66': 'Quantity',
          '67': 'NYLON',
          'more_item': 'See All',
          '69': 'Return policy',
          '70': 'privacy policy',
          '71': 'Consumer Rights',
          '72': 'Version',
          '73': 'All rights reserved',
          '74': 'Shipping fees',
          '75': 'Cash on delivery fees',
          '76': 'Value added tax',
          '77': 'The final total includes added value',
          '78':
              'We have sent a code to 09090229892. Please enter the code to continue',
          '79': 'Resend',
          '80':
              'Verify the phone number using the verification code, which we send to 20910010011',
          '81': 'You will be directed to the payment page',
          '82': 'Track Shipment',
          '83': 'Please write the order number',
          '84': 'Addresses',
          '85': 'Add new address',
          '86': 'Personal data',
          '87': 'first name',
          '88': 'Last name',
          '89': 'The Address',
          '90': 'Full address / Street name',
          '91': 'The city',
          '92': 'zip code',
          '93': 'Please choose a nickname for this address',
          '94': 'Home',
          '95': 'Office',
          '96': 'Other',
          '97': 'This address will be named',
          '98': 'My Orders',
          '99': 'complete',
          '100': 'order number',
          '101': 'order date',
          '102': 'Order Details',
          '103': 'Re-order again',
          '104': 'order has a problem',
          '105': 'Address and Shipping',
          '106': 'Shipping by weight',
          '107':
              'Shipping usually takes 3 to 5 days. Expected delivery time for the order',
          '108': 'Payment Summary',
          '109': 'Paid',
          '110': 'Price before tax',
          '111': 'Tax',
          '112': 'Total after tax and shipping',
          '113': 'Complaints',
          '114': 'Contact information',
          '115': 'Order',
          '116': 'Problem description',
          '117': 'Submit a complaint',
          '118': 'The complaint has been sent',
          '119': 'We will contact you \n  as soon as possible.',
          '120': 'Replacement and return',
          '121': 'cancel order',
          '122': 'Edit and request again',
          '123': 'Add Balance',
          '124': 'Current Balance',
          '125': 'Value',
          '126': 'Saudi Riyal',
          '127': 'Minimum shipping value 50 riyals',
          '128': 'Description of the amount (optional)',
          '129': 'Description of amount',
          '130': 'My Coupons',
          '131': 'Discount code',
          '132': 'Estimated time of arrival',
          '133': 'order done',
          '134': 'We have received your order',
          '135': 'Payment has been confirmed',
          '136': 'Waiting for confirmation',
          '137': 'The order has been sent to the shipping company',
          '138':
              'hipping has been requested and you will be contacted as soon as possible',
          '139': 'The order is on its way to you',
          '140': 'We are preparing your order..',
          '141': 'Ready for delivery',
          '142': 'Delivery done',
          '143': "Don't forget to rate",
          '144': 'We will be very happy if you rate the products',
          '145': 'Inside Riyadh 3:4 days\n Outside Riyadh 3:6 days',
          '146': 'Wish List',
          '147': 'Add to shopping cart',
          '148': 'No products found..!!',
          '149': 'Your shopping cart is empty..! \n  Shop now',
          '150': 'Remove from cart',
          '151': 'Failed to connect to server',
          '152': 'No internet connection!',
          '153': 'Data not available?',
          '154': 'Something went wrong. Please try again!',
          '155': 'Not found',
          '156': 'You are not authorized!',
          '157': 'Please log in to continue',
          '158': 'An unknown error occurred',
          '159': 'The product was added to the cart',
          '160': 'The product has been removed from the cart',
          '161': 'first name',
          '162': 'last name',
          '163': 'required',
          '164': 'city zip code',
          '165': 'area Zip Code',
          '166': 'Please select payment method',
          '167': 'shipping',
          '168': 'Please select shipping method',
          '169': 'payment method : ',
          '170': 'Shipping method : ',
          '171': 'email',
          '172': 'Invalid phone number',
          '173': 'Invalid email',
          '174': 'Please confirm your shipping address',
          '175': 'Shipping address : ',
          '176': 'Confirm address',
          '177': 'Please attach payment receipt',
          '178': 'Bank account details of the store',
          '179': 'Bank account number',
          '180': 'done',
          '181': 'Complete the order with',
          '182': 'For free shipping!',
          '183': 'Congratulations you got free shipping',
          '184': 'Special Offer',
          '185': 'Good',
          '186':
              "Please upload a proof of payment image before submitting the order.",
          '187': 'District name',
          '188': 'Order for 350.0 SAR to get free shipping',
          '189': 'Congratulations you got free shipping',
          '190': 'Show more...',
          '191': 'Ratings',
          '192': 'Discount',
          '193': 'Available until',
          '194': 'order shipping id',
          '195': 'Free Shipping',
          '196': 'The product has been removed from the favorites',
          '197': 'The product was added to the favorites',
          '198': 'Offer',
          '199': 'one or more pieces and get the product at a price',
          '200': 'Buy',
          "201": "Personal information",
          "202": 'App Rating',
          "203": 'Log out',
          "204": 'products',
          "205": "",
          '206': '',
          "207": "",
          "208": '',
          "209": '',
          "210": "",
          '211': 'Your order is being processed',
          '212': 'Updating...',
          '213': 'Invoice is being updated...',
          '214': 'Please remove this item',
          '215': 'Delete account',
          'delete_account_title':
              'Do you want to delete the account permanently?',
          'delete_account_cancel': 'Cancel',
          'delete_account_confirm': 'Delete',
          'delete_account_fail': 'Failed to delete account from server',
          'delete_account_no_data': 'No enough data to delete account',
          'vericfy_page_text':
              "Please enter your phone number to confirm the request and complete your purchase.\n"
                  "If you're already registered, we'll display your details automatically.\n"
                  "If you don't have an account, you can create a new one and add an address.",
          "code_active": "Please enter the verification code ",
          "confirm_text": "confirm",
          "search_hint": "Search using keywords",
          "search_error": "An error occurred, please try again",
          "search_empty": "No results found",
          "track_on_smsa": "Track on SMSA 🔗",
          "tracking_pending":
              "Your order is being prepared and will be handed to the courier",
          "copied": "Copied",
          "order_status": "Order Status",
        }
      };
}
