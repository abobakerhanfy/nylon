// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:nylon/features/home/presentation/screens/widgets/search_widget.dart';

// class SearchAndNotification extends StatelessWidget {
//   const SearchAndNotification({super.key});

//   @override
//   Widget build(BuildContext context) {
//   return   Row(
//       children: [
//         const Expanded(child: SearchWidget()),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 8),
//           child: InkWell(
//             onTap: () {
//               showDialog(
//                 context: context,
//                 builder: (context) {
//                   return AlertDialog(
//                     backgroundColor: Theme.of(context).scaffoldBackgroundColor
,
//                     title: SizedBox(
//                       width: MediaQuery.of(context).size.width,
//                       child: const FortuneWheelPage(),
//                     ),
//                   );
//                 },
//               );
//             },
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: SvgPicture.asset('images/Notification.svg'),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
