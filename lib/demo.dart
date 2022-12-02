// import 'package:car_buyer/custom/lib/flutter_tindercard_plus.dart';
// import 'package:flutter/material.dart';
//
// class ExampleHomePage extends StatefulWidget {
//   const ExampleHomePage({Key? key}) : super(key: key);
//
//   @override
//   State<ExampleHomePage> createState() => _ExampleHomePageState();
// }
//
// class _ExampleHomePageState extends State<ExampleHomePage>
//     with TickerProviderStateMixin {
//   List<dynamic> imageItems = [
//     "https://wallpapercave.com/fuwp/uwp2000707.jpeg",
//     "https://wallpapercave.com/fuwp/uwp2050309.jpeg",
//     "https://wallpapercave.com/fuwp/uwp1827076.jpeg",
//     "https://wallpapercave.com/fuwp/uwp2295772.jpeg",
//     "https://wallpapercave.com/fuwp/uwp2000707.jpeg",
//     "https://wallpapercave.com/fuwp/uwp2050309.jpeg",
//     "https://wallpapercave.com/fuwp/uwp1827076.jpeg",
//     "https://wallpapercave.com/fuwp/uwp2295772.jpeg",
//     "https://wallpapercave.com/fuwp/uwp2000707.jpeg",
//     "https://wallpapercave.com/fuwp/uwp2050309.jpeg",
//     "https://wallpapercave.com/fuwp/uwp1827076.jpeg",
//     "https://wallpapercave.com/fuwp/uwp2295772.jpeg",
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     CardController controller; //Use this to trigger swap.
//
//     return Scaffold(
//       body: Center(
//         child: SizedBox(
//           height: MediaQuery.of(context).size.height * 0.6,
//           child: TinderSwapCard(
//             swipeUp: true,
//             swipeDown: true,
//             orientation: AmassOrientation.bottom,
//             totalNum: imageItems.length,
//             stackNum: imageItems.length - 1,
//             swipeEdge: 4.0,
//             maxWidth: MediaQuery.of(context).size.width * 0.7,
//             maxHeight: MediaQuery.of(context).size.width * 0.6,
//             minWidth: MediaQuery.of(context).size.width * 0.6,
//             minHeight: MediaQuery.of(context).size.width * 0.58,
//             cardBuilder: (context, index) => Card(
//               child: Image.network(
//                 imageItems[index],
//                 fit: BoxFit.cover,
//               ),
//             ),
//             cardController: controller = CardController(),
//             swipeUpdateCallback: (DragUpdateDetails details, Alignment align) {
//               /// Get swiping card's alignment
//               if (align.x < 0) {
//                 //Card is LEFT swiping
//               } else if (align.x > 0) {
//                 //Card is RIGHT swiping
//               }
//             },
//             swipeCompleteCallback:
//                 (CardSwipeOrientation orientation, int index) {
//               /// Get orientation & index of swiped card!
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
