// import 'package:complaint_app/widget/side_menu_tile.dart';
// import 'package:flutter/material.dart';

// class SideMenuBar extends StatefulWidget {
//   const SideMenuBar({super.key});

//   @override
//   State<SideMenuBar> createState() => _SideMenuBarState();
// }

// class _SideMenuBarState extends State<SideMenuBar> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//           child: Container(
//         width: 280,
//         height: double.infinity,
//         color: const Color(0xFF2A4320),
//         child: Column(
//           children: [
//             const infoCard(
//               name: "Showrav Das",
//               profession: "fjlkfjlfjlfkjflksjf  ghsdggsdfgsdfg" ,
//             ),
//             const Padding(
//               padding: EdgeInsets.only(left: 24, top: 32, bottom: 16),
//               child: Text("Browse", style: TextStyle(color: Colors.white70, fontSize: 25),),
//             ),
//             SideMenu()
//           ],
//         ),
//       )),
//     );
//   }
// }




// // -------------------- user information card --------------------
// class infoCard extends StatelessWidget {
//   const infoCard({
//     super.key, required this.name, required this.profession,
//   });
//   final String name, profession;

//   @override
//   Widget build(BuildContext context) {
//     return  ListTile(
//       leading: const CircleAvatar(
//         backgroundColor: Colors.white,
//         child: Icon(Icons.person, color: Colors.green,),
//       ),
//       title: Text(name, style: const TextStyle(color: Colors.white),),
//       subtitle: Text(profession, style: TextStyle(color: Colors.white),),
//     );
//   }
// }
