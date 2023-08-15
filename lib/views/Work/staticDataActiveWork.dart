// import 'package:flutter/material.dart';
// import '../../model/post.dart';
// import '../../shared/constant.dart';
// import 'ActiveCargo.dart';
// import 'CargoType/Actions.dart';

// class List_Vehicles extends StatefulWidget {
//   const List_Vehicles({super.key});
//   @override
//   State<List_Vehicles> createState() => _List_VehiclesState();
// }

// class _List_VehiclesState extends State<List_Vehicles> {
//   List<ListItem> findDriver = [];
//   List<ListItem> items = [
//     ListItem(
//         driverName: 'Putin',
//         plateNumber: ' 003221',
//         Date: "09-05-2023",
//         isExpanded: false,
//         status: "start"),
//     ListItem(
//         driverName: 'Victor',
//         plateNumber: '03323',
//         Date: "08-05-2023",
//         isExpanded: false,
//         status: "start"),
//     ListItem(
//         driverName: 'John ',
//         plateNumber: '09932',
//         isExpanded: false,
//         Date: "07-05-2023",
//         status: "start"),
//   ];
//   void driversSearch(String enterKeyboard) {
//     setState(() {
//       items = findDriver;
//     });
//     if (enterKeyboard.isEmpty) {
//       findDriver = items;
//     } else {
//       final find = items.where((driver) {
//         final name = driver.driverName.toLowerCase();
//         final license = driver.plateNumber.toLowerCase();
//         final inputName = enterKeyboard.toLowerCase();
//         final inputLicense = enterKeyboard.toLowerCase();
//         return name.contains(inputName) || license.contains(inputLicense);
//       }).toList();
//       setState(() {
//         this.items = find;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     bool isPressed = true;
//     double screenHeight = MediaQuery.of(context).size.height;
//     double screenWidth = MediaQuery.of(context).size.width;
//     return Scaffold(
//       backgroundColor: kBackgroundColor,
//       appBar: AppBar(
//         toolbarHeight: 80,
//         elevation: 0,
//         leading: InkWell(
//           onTap: () {
//             Navigator.push(context,
//                 MaterialPageRoute(builder: (context) => ActiveCargo()));
//           },
//           child: const Icon(
//             Icons.arrow_back_ios,
//             color: Color.fromARGB(255, 162, 162, 162),
//           ),
//         ),
//         backgroundColor: Color.fromARGB(255, 252, 254, 250),
//         title: Container(
//           width: double.infinity,
//           margin: EdgeInsets.only(right: screenWidth * 0.12),
//           height: 40,
//           color: Color.fromARGB(255, 252, 254, 250),
//           child: Center(
//             child: TextField(
//               onChanged: driversSearch,
//               decoration: const InputDecoration(
//                 hintText: 'Driver Name or Plate No.',
//                 border: InputBorder.none,
//                 errorBorder: InputBorder.none,
//                 enabledBorder: InputBorder.none,
//                 focusedBorder: InputBorder.none,
//                 prefixIcon: Icon(Icons.search),
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: Container(
//         height: screenHeight,
//         child: Stack(
//           children: [
//             Container(
//               margin: const EdgeInsets.only(top: 30, left: 10, right: 10),
//               child: CustomScrollView(
//                 shrinkWrap: true,
//                 slivers: items.map((item) {
//                   return SliverList(
//                     delegate: SliverChildListDelegate(
//                       [
//                         Container(
//                           height: screenHeight * 0.17,
//                           child: Card(
//                             child: Container(
//                               decoration: BoxDecoration(
//                                   color: Color.fromARGB(255, 252, 254, 250),
//                                   borderRadius: BorderRadius.circular(6),
//                                   boxShadow: isPressed
//                                       ? [
//                                           BoxShadow(
//                                               color: Colors.grey.shade300
//                                                   .withOpacity(0.7),
//                                               blurRadius: 18.0,
//                                               spreadRadius: 12.0,
//                                               offset: const Offset(
//                                                 6, // Move to right 7.0 horizontally
//                                                 -10, // Move to bottom 8.0 Vertically
//                                               )),
//                                           BoxShadow(
//                                               color: Colors.grey.shade200,
//                                               blurRadius: 8.0,
//                                               spreadRadius: 6.0,
//                                               offset: const Offset(
//                                                 6, // Move to right 7.0 horizontally
//                                                 -8, // Move to bottom 8.0 Vertically
//                                               )),
//                                         ]
//                                       : null),
//                               child: ListTile(
//                                 title: Column(
//                                   children: [
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Container(
//                                           width: screenWidth * 0.3,
//                                           child: ListTile(
//                                             title: Text(
//                                               item.driverName,
//                                               style: const TextStyle(
//                                                   fontSize: 15,
//                                                   color: Colors.black87,
//                                                   fontFamily: 'Roboto',
//                                                   letterSpacing: 1,
//                                                   fontWeight: FontWeight.bold),
//                                             ),
//                                             subtitle: const Text(
//                                               "Driver",
//                                               style: TextStyle(
//                                                   fontSize: 11,
//                                                   color: Colors.black54,
//                                                   fontFamily: 'Roboto',
//                                                   letterSpacing: 1,
//                                                   fontWeight: FontWeight.bold),
//                                             ),
//                                           ),
//                                         ),
//                                         Container(
//                                           width: screenWidth * 0.3,
//                                           child: ListTile(
//                                             title: Text(
//                                               item.plateNumber,
//                                               style: const TextStyle(
//                                                   fontSize: 15,
//                                                   color: Colors.black87,
//                                                   fontFamily: 'Roboto',
//                                                   letterSpacing: 1,
//                                                   fontWeight: FontWeight.bold),
//                                             ),
//                                             subtitle: const Text(
//                                               "Plate number",
//                                               style: TextStyle(
//                                                   fontSize: 11,
//                                                   color: Colors.black54,
//                                                   fontFamily: 'Roboto',
//                                                   letterSpacing: 1,
//                                                   fontWeight: FontWeight.bold),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     InkWell(
//                                         onTap: () {
//                                           setState(() {
//                                             item.isExpanded = !item.isExpanded;
//                                           });
//                                         },
//                                         child: item.isExpanded
//                                             ? Container(
//                                                 decoration: BoxDecoration(
//                                                   color: Colors.white,
//                                                   borderRadius:
//                                                       BorderRadius.all(
//                                                           Radius.circular(10)),
//                                                   boxShadow: [
//                                                     BoxShadow(
//                                                         color: Colors
//                                                             .grey.shade200
//                                                             .withOpacity(0.7),
//                                                         blurRadius: 8.0,
//                                                         spreadRadius: 2.0,
//                                                         offset: const Offset(
//                                                           6, // Move to right 7.0 horizontally
//                                                           8, // Move to bottom 8.0 Vertically
//                                                         ))
//                                                   ],
//                                                 ),
//                                                 child: Icon(
//                                                   Icons.keyboard_arrow_up,
//                                                   color: Colors.blue.shade600,
//                                                 ))
//                                             : Container(
//                                                 decoration: BoxDecoration(
//                                                   color: Colors.white,
//                                                   borderRadius:
//                                                       BorderRadius.all(
//                                                           Radius.circular(10)),
//                                                   boxShadow: [
//                                                     BoxShadow(
//                                                         color: Colors
//                                                             .grey.shade200
//                                                             .withOpacity(0.7),
//                                                         blurRadius: 8.0,
//                                                         spreadRadius: 2.0,
//                                                         offset: const Offset(
//                                                           6, // Move to right 7.0 horizontally
//                                                           8, // Move to bottom 8.0 Vertically
//                                                         ))
//                                                   ],
//                                                 ),
//                                                 child: Icon(
//                                                   Icons.keyboard_arrow_down,
//                                                   color: Colors.blue.shade600,
//                                                 ),
//                                               ))
//                                   ],
//                                 ),
//                                 trailing: SizedBox(
//                                   width: screenWidth * 0.12,
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Container(
//                                         color: Colors.grey,
//                                         height: screenHeight * 0.05,
//                                         width: screenWidth * 0.007,
//                                       ),
//                                       Container(
//                                         child: CircleAvatar(
//                                           radius: 18,
//                                           backgroundColor: Colors.grey.shade300,
//                                           child: const Padding(
//                                             padding: EdgeInsets.all(8.0),
//                                             child: Text(
//                                               "+2",
//                                               style: TextStyle(
//                                                   fontSize: 15,
//                                                   color: Colors.red,
//                                                   fontFamily: 'Roboto',
//                                                   fontWeight: FontWeight.bold),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(3.7),
//                           child: AnimatedContainer(
//                             decoration: BoxDecoration(
//                               color: kBackgroundColor,
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(10)),
//                             ),
//                             curve: Curves.easeInOut,
//                             duration: const Duration(milliseconds: 300),
//                             height: item.isExpanded ? screenHeight * 0.4 : 0,
//                             child: item.isExpanded
//                                 ? Stack(
//                                     children: [
//                                       Center(
//                                         child: SizedBox(
//                                           height: screenHeight,
//                                           child: Container(
//                                               margin: EdgeInsets.only(top: 10),
//                                               child: Status()),
//                                         ),
//                                       ),
//                                       Align(
//                                         alignment: Alignment.bottomCenter,
//                                         child: SizedBox(
//                                           width: screenWidth,
//                                           child: ElevatedButton(
//                                             onPressed: () {
//                                               print("Button Pressed");
//                                             },
//                                             style: ElevatedButton.styleFrom(
//                                               primary: Colors.grey[300],
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                       horizontal: 15,
//                                                       vertical: 15),
//                                               textStyle: const TextStyle(
//                                                   color: Colors.white,
//                                                   fontSize: 18,
//                                                   fontStyle: FontStyle.italic),
//                                               shape: RoundedRectangleBorder(
//                                                 borderRadius:
//                                                     BorderRadius.circular(3),
//                                               ),
//                                               side: BorderSide(
//                                                   color: Colors.grey.shade400),
//                                               elevation: 1,
//                                             ),
//                                             child: Text(
//                                               "Track",
//                                               style: TextStyle(
//                                                   fontSize: 18,
//                                                   color: Colors.grey.shade600,
//                                                   fontFamily: 'Roboto',
//                                                   letterSpacing: 1,
//                                                   fontWeight: FontWeight.bold),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   )
//                                 : null,
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),
//             Positioned(
//               bottom: 20,
//               right: 25,
//               child: Container(
//                 margin: EdgeInsets.only(left: 10),
//                 alignment: Alignment.bottomCenter,
//                 child: InkWell(
//                   onTap: () {
//                     print("Share button pressed");
//                   },
//                   child: Container(
//                     decoration: const BoxDecoration(
//                       color: Colors.blue,
//                       shape: BoxShape.circle,
//                     ),
//                     child: const Padding(
//                       padding: EdgeInsets.all(15),
//                       child: Icon(
//                         Icons.share,
//                         color: Colors.white,
//                         size: 30,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
