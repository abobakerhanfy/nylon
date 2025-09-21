// import 'package:flutter/material.dart';

// class DraggableCircleInContainer extends StatefulWidget {
//   @override
//   _DraggableCircleInContainerState createState() => _DraggableCircleInContainerState();
// }

// class _DraggableCircleInContainerState extends State<DraggableCircleInContainer> {
//   double _position = 0;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onPanUpdate: (details) {
//         setState(() {
//           _position += details.delta.dx;
//           if (_position < 0) _position = 0;
//           if (_position > 80) _position = 80;
//         });
//       },
//       child: Container(
//         height: 80,
//         color: Colors.grey[200],
//         child: Stack(
//           children: [
//             Positioned(
//               left: _position,
//               top: 30,
//               child: Container(
//                 width: 40,
//                 height: 40,
//                 decoration: BoxDecoration(
//                   color: Colors.blue,
//                   shape: BoxShape.circle,
//                 ),
//                 child: Center(
//                   child: Icon(Icons.favorite, color: Colors.red),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }