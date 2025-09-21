import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nylon/core/services/services.dart';
import 'package:nylon/core/theme/colors_app.dart';
import 'package:nylon/core/widgets/coutm_app_bar_tow.dart';
import 'package:intl/intl.dart';
import 'package:nylon/features/shipping/presentation/controller/controller_shipping.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/date_symbol_data_local.dart';

class TrackTheShipmentDetails extends StatelessWidget {
  const TrackTheShipmentDetails({super.key});

  // مرّة واحدة لكل لغة
  static final Set<String> _initedLocales = <String>{};

  Future<void> _ensureDateLocale(String? lang) async {
    final l = (lang?.toLowerCase() == 'ar') ? 'ar' : 'en';
    if (_initedLocales.contains(l)) return;
    await initializeDateFormatting(l);
    _initedLocales.add(l);
  }

  String formatDate(String? dateString) {
    try {
      if (dateString == null || dateString.isEmpty) return '';
      String s = dateString.replaceAll('/', '-').trim();

      final candidates = <DateFormat>[
        DateFormat('dd-MM-yyyy'),
        DateFormat('dd/MM/yyyy'),
        DateFormat('yyyy-MM-dd'),
        DateFormat('yyyy/MM/dd'),
      ];

      DateTime? dt;
      for (final f in candidates) {
        try {
          dt = f.parseStrict(s);
          break;
        } catch (_) {}
      }
      dt ??= DateTime.parse(s);

      final myServices = Get.find<MyServices>();
      final lang = myServices.sharedPreferences.getString('Lang') ?? 'ar';
      return DateFormat('EEEE, d MMMM', lang).format(dt);
    } catch (e) {
      // fallback لو فشل
      return dateString ?? '';
    }
  }

  Future<String> formatDateAsync(String? dateString) async {
    try {
      final my = Get.find<MyServices>();
      final lang =
          (my.sharedPreferences.getString('Lang') ?? 'ar').toLowerCase();
      await _ensureDateLocale(lang);

      if (dateString == null || dateString.isEmpty) return '';
      String s = dateString.replaceAll('/', '-').trim();

      final fmts = <DateFormat>[
        DateFormat('yyyy-MM-dd'),
        DateFormat('dd-MM-yyyy'),
        DateFormat('dd/MM/yyyy'),
        DateFormat('yyyy/MM/dd'),
      ];
      DateTime? dt;
      for (final f in fmts) {
        try {
          dt = f.parseStrict(s);
          break;
        } catch (_) {}
      }
      dt ??= DateTime.tryParse(s) ?? DateTime.now();

      final locale = (lang == 'ar') ? 'ar' : 'en';
      return DateFormat('EEEE, d MMMM', locale).format(dt);
    } catch (e) {
      return dateString ?? '';
    }
  }

  void openLink(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  String normalizeHtml(String? html) {
    if (html == null) return '';
    String s = html;
    s = s.replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n');
    s = s.replaceAll(RegExp(r'<[^>]+>'), '');
    s = s.replaceAll('&nbsp;', ' ').replaceAll('&amp;', '&');
    return s.trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: customAppBarTow(title: ' ${'115'.tr}'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GetBuilder<ControllerShipping>(
          init: ControllerShipping(),
          builder: (controller) {
            final data = controller.trackingShippingData?.data;

            // حماية من الـ null لحد ما الداتا تيجي
            if (data == null) {
              return const Center(child: CircularProgressIndicator());
            }

            final histories = data.histories ?? const [];
            final totals = data.totals ?? const [];

            // إجمالي الطلب بأمان (من غير firstWhere كراش)
            String totalText = '';
            for (final t in totals) {
              if ((t.title ?? '') == 'الاجمالي') {
                totalText = t.text ?? '';
                break;
              }
            }

            return ListView(
              children: [
                const SizedBox(height: 20),

                // الهيدر: Row خارجي + Expanded حوالين الـ Column لتفادي unbounded
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // تاريخ إنشاء الطلب
                          // تاريخ إنشاء الطلب (مانع للّف ومتحكم في الارتفاع/السكيل)
                          FittedBox(
                            alignment: Alignment.centerLeft,
                            fit: BoxFit
                                .scaleDown, // يصغّر النص لو المساحة ضيقة بدل ما يلف سطر جديد
                            child: Text(
                              formatDate(data.dateAdded),
                              maxLines: 1,
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              textScaler: const TextScaler.linear(
                                  1.0), // يمنع تكبير النظام
                              strutStyle: const StrutStyle(
                                height: 1.2,
                                forceStrutHeight:
                                    true, // يثبت ارتفاع السطر ويقلل فرق baseline بين الأرقام والعربي
                              ),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12, // أصغر
                                    height: 1.2, // مع strut يمسك الارتفاع كويس
                                  ),
                            ),
                          ),
                          const SizedBox(
                              height: 4), // قللنا المسافة تحت التاريخ

                          // رقم الطلب + نسخ
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${'100'.tr} :',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                    ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '#${data.orderId ?? ''}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                    ),
                              ),
                              const SizedBox(width: 8),
                              InkWell(
                                onTap: () async {
                                  final v = data.orderId ?? '';
                                  await Clipboard.setData(
                                      ClipboardData(text: v));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('copied'.tr),
                                      duration:
                                          const Duration(milliseconds: 800),
                                    ),
                                  );
                                },
                                child: const Icon(
                                  Icons.copy,
                                  size: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // رقم تتبع الشحنة + نسخ (المقطع اللي طلبت تعديله)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${'194'.tr} :',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                    ),
                              ),
                              const SizedBox(width: 5),
                              if ((data.orderTrackId ?? '0') == '0')
                                Flexible(
                                  fit: FlexFit.loose, // آمن داخل Row
                                  child: Text(
                                    ' ${"tracking_pending".tr}',
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: Colors.black87,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                        ),
                                  ),
                                )
                              else ...[
                                Text(
                                  '#${data.orderTrackId!}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                      ),
                                ),
                                const SizedBox(width: 5),
                                InkWell(
                                  onTap: () async {
                                    await Clipboard.setData(ClipboardData(
                                      text: data.orderTrackId ?? '',
                                    ));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('copied'.tr),
                                        duration:
                                            const Duration(milliseconds: 800),
                                      ),
                                    );
                                  },
                                  child: const Icon(
                                    Icons.copy,
                                    size: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 8),

                          // رابط التتبع في سمسا
                          InkWell(
                            onTap: () {
                              final link = data.linkSmsa;
                              if (link != null && link.isNotEmpty) {
                                openLink(link);
                              }
                            },
                            child: Text(
                              'track_on_smsa'.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppColors.primaryColor,
                                    decoration: TextDecoration.underline,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    // الإجمالي (لو متوفّر)
                    if (totals.isNotEmpty && totalText.isNotEmpty)
                      Flexible(
                        child: Text(
                          '${'45'.tr} : $totalText',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w300,
                                  ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 20),

                // العناوين
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text(
                        '132'.tr,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        '145'.tr,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // تاريخ الحالة
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: histories.length,
                  separatorBuilder: (context, i) => const SizedBox(height: 8),
                  itemBuilder: (context, i) {
                    final h = histories[i];
                    return RowDetailsTrack(
                      title: h.status ?? '',
                      leding: h.dateAdded ?? '',
                      supTitle: normalizeHtml(h.comment),
                    );
                  },
                ),

                const SizedBox(height: 20),

                // تقييم التجربة
                Container(
                  padding: const EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width * 0.90,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.background,
                        spreadRadius: 0.5,
                        blurRadius: 7,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '143'.tr,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '144'.tr,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                      const SizedBox(height: 10),
                      const Row(
                        children: [
                          Icon(Icons.star_border_sharp,
                              size: 30, color: Colors.black54),
                          SizedBox(width: 3),
                          Icon(Icons.star_border_sharp,
                              size: 30, color: Colors.black54),
                          SizedBox(width: 3),
                          Icon(Icons.star_border_sharp,
                              size: 30, color: Colors.black54),
                          SizedBox(width: 3),
                          Icon(Icons.star_border_sharp,
                              size: 30, color: Colors.black54),
                          SizedBox(width: 3),
                          Icon(Icons.star_border_sharp,
                              size: 30, color: Colors.black54),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            );
          },
        ),
      ),
    );
  }
}

class RowDetailsTrack extends StatelessWidget {
  final String title;
  final String? supTitle;
  final String leding;

  const RowDetailsTrack({
    super.key,
    required this.title,
    this.supTitle,
    required this.leding,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check_circle, color: Colors.green[600]),
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
              ),
              const SizedBox(height: 4),
              if ((supTitle ?? '').isNotEmpty)
                Text(
                  supTitle!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.black,
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            leding,
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w300,
                ),
          ),
        ),
      ],
    );
  }
}
