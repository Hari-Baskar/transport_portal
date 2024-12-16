import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trasnport_portal/Pages/assignStudents.dart';
import 'package:trasnport_portal/Pages/dashboard.dart';
import 'package:trasnport_portal/Pages/fees.dart';
import 'package:trasnport_portal/Pages/setDropLocation.dart';
import 'package:trasnport_portal/Widgets/textWidget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyB-sPwCV5PAR7eGnS4iA4c_dohxm-LO9zk",
          authDomain: "driver-7f33d.firebaseapp.com",
          projectId: "driver-7f33d",
          storageBucket: "driver-7f33d.firebasestorage.app",
          messagingSenderId: "895167597712",
          appId: "1:895167597712:web:793a490df827a6190b1c15",
          measurementId: "G-NKND4E9FXP"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, home: CustomSideNavBar());
  }
}

class CustomSideNavBar extends StatefulWidget {
  @override
  _CustomSideNavBarState createState() => _CustomSideNavBarState();
}

class _CustomSideNavBarState extends State<CustomSideNavBar> {
  int _selectedIndex = 0;
  var divHeight, divWidth;

  // Define a list of page titles
  final List<String> _pageTitles = [
    'Home Page',
    'Settings Page',
    'Profile Page',
    'Help Page',
  ];

  // Function to change the selected page
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    divHeight = MediaQuery.of(context).size.height;
    divWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          SizedBox(
            width: 20,
          ),
          // Side Navigation Bar
          Card(
            elevation: 40,
            shadowColor: Colors.black,
            child: Container(
              height: divHeight * 0.98,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              width: divWidth * 0.17,
              // You can change the width of the side nav here
              // You can change the background color here
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Customizable Drawer Header
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 20, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("Assets/logo.png",
                              width:
                                  divWidth * 0.04), // Ensure correct asset path
                          Text(
                            " Vidhaan",
                            style: GoogleFonts.poppins(
                              letterSpacing: 1.0,
                              color: Color(0xFF00A0E3),
                              fontWeight: FontWeight.w800,
                              fontSize: divWidth * 0.013,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: divHeight * 0.03),
                    _buildNavItem("assets/dash.png", 'DashBoard', 0),
                    SizedBox(height: divHeight * 0.008),
                    _buildNavItem("assets/fees.png", 'Fees', 1),
                    SizedBox(height: divHeight * 0.008),
                    _buildNavItem("assets/add.png", 'Assign Students', 2),
                    SizedBox(height: divHeight * 0.008),
                    _buildNavItem("assets/location.png", 'Set DropLocation', 3),
                  ],
                ),
              ),
            ),
          ),
          // Main content area
          _selectedIndex == 1
              ? Expanded(child: Fees())
              : _selectedIndex == 2
                  ? Expanded(
                      child: Assignstudents(),
                    )
                  : _selectedIndex == 3
                      ? Expanded(child: SetDropLocation())
                      : Expanded(child: DashBoard())
        ],
      ),
    );
  }

  // Helper method to build a navigation item
  Widget _buildNavItem(String imagePath, String title, int index) {
    return Padding(
      padding: EdgeInsets.all(7),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: _selectedIndex == index ? Color(0xFF00A0E3) : Colors.white,
        ),
        child: ListTile(
          leading: Image.asset(
            imagePath,
            color: _selectedIndex == index ? Colors.white : Colors.black54,
            width: divWidth * 0.013,
          ),
          // Ensure correct asset path
          title: textWidget(
              text: title,
              fontWeight: FontWeight.bold,
              fontColor:
                  _selectedIndex == index ? Colors.white : Colors.black54,
              fontsize: divWidth * 0.01,
              Spacing: null),
          trailing: Icon(
            Icons.chevron_right,
            color: _selectedIndex == index ? Colors.white : Colors.black54,
          ),

          tileColor: _selectedIndex == index ? Color(0xFF00A0E3) : Colors.white,
          // Background color for selected item
          onTap: () => _onItemTapped(index),
        ),
      ),
    );
  }
}
