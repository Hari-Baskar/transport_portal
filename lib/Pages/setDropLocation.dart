import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trasnport_portal/Services/dbService.dart';
import 'package:trasnport_portal/Services/loading.dart';
import 'package:trasnport_portal/Widgets/buttonWidget.dart';
import 'package:trasnport_portal/Widgets/dropdownWidget.dart';
import 'package:trasnport_portal/Widgets/textWidget.dart';
import 'package:trasnport_portal/Widgets/textfieldWidget.dart';
import 'package:trasnport_portal/common/common_colors.dart';

class SetDropLocation extends StatefulWidget {
  const SetDropLocation({super.key});

  @override
  State<SetDropLocation> createState() => _SetDropLocationState();
}

class _SetDropLocationState extends State<SetDropLocation> {


  late GoogleMapController _mapController;

  final List<Map<String,dynamic>> _dropLocations = [];
  final Set<Marker> _markers = {};

  LatLng? selectedLatLng;
  Marker? tempMarker;
  bool isAddingLocation = false;

  late double divHeight, divWidth;

  TextEditingController routeName = TextEditingController();
  bool confirmRoute = false;
  String? confirmedRouteName;
  List<String> routes = [];
  String? selectedRoute;


  Future getRouteDropLocations() async{

    DocumentSnapshot documentSnapshot=await dbService.selectedRoute(routeName: selectedRoute!);
    Map<String,dynamic> documentsdata=documentSnapshot.data() as Map<String,dynamic>;
    List data=documentsdata["droplocations"];
    int len=data.length;

    for(int i=0;i<len;i++){
      LatLng point=LatLng(data[i]["latlng"][0], data[i]["latlng"][1]);
      _markers.add(Marker(
        markerId: MarkerId(point.toString()),
        position: point,
        infoWindow:  InfoWindow(title: data[i]["droplocationName"]),
      ));
      _dropLocations.add(data[i]);
    }
    setState(() {
      confirmedRouteName = selectedRoute;
      confirmRoute = true;

    });

  }

  void _addPoint(LatLng point) {
    if (isAddingLocation) return;

    setState(() {
      selectedLatLng = point; // Store the selected point
      isAddingLocation = true; // Disable further taps

      // Add a temporary marker at the selected point

      tempMarker = Marker(
        markerId: MarkerId(point.toString()),
        position: point,
        infoWindow: const InfoWindow(title: "Unnamed Location"),
      );
      _markers.add(tempMarker!);
    });
  }

  // Widget to input name for the selected location

  void _removeLocation(int index) {
    setState(() {
      LatLng pointToRemove = LatLng(_dropLocations[index]["latlng"][0], _dropLocations[index]["latlng"][1]);
      _dropLocations.removeAt(index);
      _markers.removeWhere((marker) => marker.position == pointToRemove);
    });
  }

  DBService dbService = DBService();

  @override
  Widget build(BuildContext context) {
    divHeight = MediaQuery
        .of(context)
        .size
        .height;
    divWidth = MediaQuery
        .of(context)
        .size
        .width;
    return StreamBuilder(
        stream: dbService.routes(), builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return Loading();
      }
      QuerySnapshot querySnapshot = snapshot.data as QuerySnapshot;
      List<DocumentSnapshot> documentSnapshot = querySnapshot.docs;
      int doclen = documentSnapshot.length;
      if (doclen != 0) {
        List<String> fetchedRoutes = querySnapshot.docs.map((doc) =>
            doc.id.toString()).toSet().toList();
        routes = fetchedRoutes;
      }
      return Scaffold(
          body:
          !confirmRoute ? Center(child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: divHeight * 0.25,),
                SizedBox(
                  width: divWidth * 0.3,
                  child: textfieldWidget(hintText: "Enter the New Route Name",
                      control: routeName),),
                SizedBox(height: divHeight * 0.04,),
                InkWell(
                  onTap: () async {
                    if (routeName.text.isNotEmpty) {
                      setState(() {
                        confirmRoute = true;
                        confirmedRouteName = routeName.text;
                      });
                    }
                  },
                  child: ButtonWidget(buttonName: "Confirm Route",
                      buttonWidth: divWidth * 0.2,
                      buttonColor: green,
                      fontSize: divWidth * 0.008,
                      fontweight: FontWeight.w500,
                      fontColor: white),),
                SizedBox(height: divHeight * 0.05,),
                textWidget(text: "Or ",
                    fontsize: divWidth * 0.008,
                    fontWeight: FontWeight.w500,
                    fontColor: black,
                    Spacing: null),

                SizedBox(height: divHeight * 0.05,),
                textWidget(
                    text: "If you already created the Route please select below ",
                    fontsize: divWidth * 0.012,
                    fontWeight: FontWeight.w700,
                    fontColor: black,
                    Spacing: null),
                SizedBox(height: divHeight * 0.04,),
                SizedBox(
                    width: divWidth * 0.3,
                    child: dropDownWidget(Items: routes,
                        Onchange: (newValue) {
                          setState(() {
                            selectedRoute = newValue;
                          });
                        },
                        lableSize: divWidth * 0.008,
                        hintText: "Select Route",
                        Value: selectedRoute,
                        OnClear: () {
                          setState(() {
                            selectedRoute = null;
                          });
                        })),
                SizedBox(height: divHeight * 0.04,),
                InkWell(
                  onTap: () async {
                    if (selectedRoute != null) {
                       await getRouteDropLocations();
                    }

                  },
                  child: ButtonWidget(buttonName: "Confirm Route",
                      buttonWidth: divWidth * 0.2,
                      buttonColor: green,
                      fontSize: divWidth * 0.008,
                      fontweight: FontWeight.w500,
                      fontColor: white),)
              ]
          )) :




             Row(
              children: [
                Expanded(
                  flex: 4,
                  child: GoogleMap(
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(13.0827, 80.2707),
                      // Default starting location
                      zoom: 12,
                    ),
                    markers: _markers,
                    //polylines: _polylines,
                    onTap: (LatLng point) => _addPoint(point),
                    // Add point on map click
                    onMapCreated: (GoogleMapController controller) {
                      _mapController = controller;
                    },
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: divHeight * 0.02),
                            textWidget(
                                text: "${confirmedRouteName}  - Drop Locations ",
                                fontsize: divWidth * 0.01,
                                fontWeight: FontWeight.w700,
                                fontColor: black,
                                Spacing: null),

                            SizedBox(height: divHeight * 0.04),
                            Expanded(
                              child: ListView.builder(
                                itemCount: _dropLocations.length,
                                itemBuilder: (context, index) {
                                  String droplocationName = _dropLocations[index]["droplocationName"];
                                  return Card(
                                    child: ListTile(
                                      title: textWidget(text: droplocationName,
                                          fontsize: divWidth * 0.008,
                                          fontWeight: FontWeight.w500,
                                          fontColor: black,
                                          Spacing: null),
                                      trailing: IconButton(
                                          icon: const Icon(
                                              Icons.delete, color: Colors.red),
                                          onPressed: () {
                                            dbService.deleteDropLocation(droplocationName: droplocationName, routeName: confirmedRouteName.toString(), latlng:_dropLocations[index]["latlng"] );
                                            _removeLocation(index);
                                          }
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            if (isAddingLocation &&
                                selectedLatLng != null) _nameInputCard(
                                SelectedRoute: confirmedRouteName.toString()),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )


      );
    }
    );
  }

  Widget _nameInputCard({
    required String SelectedRoute,
  }) {
    TextEditingController locationController = TextEditingController();
    DBService dbService = DBService();
    return Card(
      color: white,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            SizedBox(height: divHeight * 0.02),
            textfieldWidget(
                hintText: "Enter Location Name", control: locationController),

            SizedBox(height: divHeight * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      _markers.remove(tempMarker);
                      selectedLatLng = null;
                      tempMarker = null;
                      isAddingLocation = false;
                    });
                  },
                  child: textWidget(text: "cancel",
                      fontsize: divWidth * 0.008,
                      fontWeight: FontWeight.bold,
                      fontColor: red,
                      Spacing: null),),
                InkWell(
                  onTap: () async {
                    if (locationController.text.isNotEmpty &&
                        selectedLatLng != null) {
                      // Add permanent marker and update state
                      List<dynamic> latlngPoints = [
                        selectedLatLng!.latitude,
                        selectedLatLng!.longitude
                      ];
                      setState(() {
                        LatLng point = selectedLatLng!;


                        // Remove the temporary marker
                        _markers.remove(tempMarker);

                        // Add a new marker with the entered name
                        _markers.add(
                          Marker(
                            markerId: MarkerId(point.toString()),
                            position: point,
                            infoWindow: InfoWindow(
                                title: locationController.text),
                          ),
                        );

                        _dropLocations.add({"droplocationName":locationController.text,"latlng":[point.latitude,point.longitude]});


                        // Update polylines
                        /*if (_routePoints.length > 1) {
                          _polylines.clear();
                          _polylines.add(
                            Polyline(
                              polylineId: const PolylineId("route"),
                              points: _routePoints,
                              color: Colors.blue,
                              width: 5,
                            ),
                          );
                        }*/

                        // Reset variables

                        selectedLatLng = null;
                        tempMarker = null;
                        isAddingLocation = false;
                      });

                      await dbService.addRouteAndDroplocations(
                          routeName: SelectedRoute,
                          droplocationName: locationController.text,
                          latlng: latlngPoints);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Please enter a valid name")),
                      );
                    }
                  },
                  child: textWidget(text: "confirm",
                      fontsize: divWidth * 0.008,
                      fontWeight: FontWeight.bold,
                      fontColor: green,
                      Spacing: null),),
              ],
            ),
          ],
        ),
      ),
    );
  }

}


/*late GoogleMapController _controller;
  final Set<Marker> _markers = {};
  final LatLng _initialPosition = const LatLng(13.0827, 80.2707);
  DBService dbService = DBService();
  late double divHeight,divWidth;

  BitmapDescriptor? selectedIcon;
  BitmapDescriptor? unSelectedIcon;
  BitmapDescriptor? dropLocationIcon;
  List selectedMarkers = []; // Track selected markers by uid
  LatLng? dropLocation; // Store the drop location
  List studentDocs=[];
  bool confirmDropLocation=false;
  @override
  void initState() {
    super.initState();
    _loadMarkerIcons();
  }
bool setDropLocationConfirmed=false;
  Future<void> _loadMarkerIcons() async {
    selectedIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      "assets/select.png",
    );
    unSelectedIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      "assets/unselect.png",
    );
    dropLocationIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      "assets/drop_location.png", // Icon for drop location
    );
    setState(() {});
  }

  void _updateMarkers(List documents) {
    final updatedMarkers = <Marker>{};

    for (var document in documents) {
      final data = document.data() as Map<String, dynamic>;
      studentDocs.add(data);
      final latitude = data['latlng'][0];
      final longitude = data['latlng'][1];
      final uid = data['uid']; // Use uid as the unique identifier

      updatedMarkers.add(
        Marker(
          markerId: MarkerId(uid), // Ensure unique MarkerId
          position: LatLng(latitude, longitude),
          infoWindow: InfoWindow(
            title: data['driverName'], // Use driverName for display
            snippet: 'Lat: $latitude, Lng: $longitude',
          ),
          icon: selectedMarkers.contains(uid)
              ? (selectedIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen))
              : (unSelectedIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)),
          onTap: () {
            setState(() {
              if (selectedMarkers.contains(uid)) {
                selectedMarkers.remove(uid); // Deselect marker

              } else {
                selectedMarkers.add(uid);


              }
            });
          },
        ),
      );
    }

    setState(() {
      _markers.clear();
      _markers.addAll(updatedMarkers);
    });
  }

  @override
  Widget build(BuildContext context) {
    divHeight=MediaQuery.of(context).size.height;
    divWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          StreamBuilder(
            stream: dbService.getStudentLocation(),
            builder: (context, snapshots) {
              if (snapshots.hasError) {
                return Center(
                  child: Text('Something went wrong: ${snapshots.error}'),
                );
              }

              if (!snapshots.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final documents = snapshots.data!.docs;

              // Update markers when data changes
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _updateMarkers(documents);
              });

              return GoogleMap(
                mapType: MapType.satellite,
                initialCameraPosition: CameraPosition(
                  target: _initialPosition,
                  zoom: 12.0,
                ),
                onMapCreated: (GoogleMapController controller) {
                  _controller = controller;
                },
                markers: _markers,
                onCameraMove: (CameraPosition position) {
                  setState(() {
                    dropLocation = position.target; // Update drop location to the center
                  });
                }
              );
            },
          ),

          // Pin at the center of the screen
          setDropLocationConfirmed? Center(
            child: Icon(
              Icons.pin_drop,
              size: 48,
              color: Colors.red,
            ),
          ):SizedBox(),

          // Confirm Drop Location button
          selectedMarkers.length>0 ? Padding(padding: EdgeInsets.all(20),child:Align(
            alignment: Alignment.centerRight,
            child: Card(

              elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),


              child:Container(

                decoration: BoxDecoration(
                  color: Colors.white
                ),


                width: divWidth*0.20,
                child:Column(children:[SizedBox(


              child: ListView.builder(
                shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: selectedMarkers.length,
                  itemBuilder: (context,index){

                    Map<String,dynamic> studentData=studentDocs.firstWhere((map) => map.containsValue(selectedMarkers[index]));
                return ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                  ),
                  title: Text(studentData["driverName"]),
                  subtitle: Text(studentData["email"]),

                );
              }),
            ),

                 !confirmDropLocation ? ElevatedButton(onPressed: (){
                    setState(() {
                      setDropLocationConfirmed=true;
                    });
                    print('Drop Location: $dropLocation');
                  }, child:Text("Set drop Location"),):TextField(
                   decoration: InputDecoration(
                     hintText: "Enter droplocation Name",
                     border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(10)
                     )
                   ),
                 ),
                  confirmDropLocation? ElevatedButton(onPressed: (){}, child: Text("Assign")):SizedBox()

          ]
            ),
              )


          ))):Container(),
         setDropLocationConfirmed ?  ElevatedButton(onPressed: (){
           setState(() {
             confirmDropLocation=true;
           });
           print('Drop Location: $dropLocation');
         }, child:Text("Confirm drop Location"),):SizedBox()
        ],
      ),
    );
  }
}
*/
