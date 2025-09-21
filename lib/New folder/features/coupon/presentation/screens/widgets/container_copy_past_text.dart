import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nylon/core/theme/colors_app.dart';

// ignore: must_be_immutable
class ContainerTextCpoyPast extends StatelessWidget {
  String? title;
  final String text;
  String? textTow;
  double? sizeIcon;
  ContainerTextCpoyPast(
      {super.key, required this.text, this.title, this.textTow, this.sizeIcon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...{
            Text(
              title!,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(
              height: 7,
            ),
          },
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.grey[200],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //
                Text(
                  text,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textColor1,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
                if (textTow != null) ...{
                  const SizedBox(
                    width: 5,
                  ),
                  //
                  Text(
                    textTow!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.primaryColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w900),
                  ),
                },

                const Spacer(),
                InkWell(
                    onTap: () async {
                      try {
                        if (textTow == null) {
                          Clipboard.setData(ClipboardData(text: text));
                          ClipboardData? clipboardContent =
                              await Clipboard.getData('text/plain');
                          print('${clipboardContent!.text}');
                        } else {
                          Clipboard.setData(ClipboardData(text: textTow!));
                          ClipboardData? clipboardContent =
                              await Clipboard.getData('text/plain');
                          print('${clipboardContent!.text}');
                        }
                      } catch (e) {
                        print(e.toString());
                      }
                    },
                    child: Icon(
                      Icons.copy,
                      size: sizeIcon ?? 30,
                      color: Colors.black87,
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
