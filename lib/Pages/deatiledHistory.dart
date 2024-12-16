import 'package:cloud_firestore/cloud_firestore.dart';


import 'package:flutter/material.dart';
import 'package:trasnport_portal/Services/dbService.dart';
import 'package:trasnport_portal/Services/loading.dart';
import 'package:trasnport_portal/Widgets/textWidget.dart';
import 'package:trasnport_portal/common/common_colors.dart';

class DetailedHistory extends StatefulWidget {
  final String docId;
  final String uid;

  const DetailedHistory({super.key, required this.docId, required this.uid});

  @override
  State<DetailedHistory> createState() => _DetailedHistoryState();
}

class _DetailedHistoryState extends State<DetailedHistory> {
  late double divHeight, divWidth;
  Map<String, dynamic>? data;
  DBService dbservice = DBService();
  List<dynamic> ticket = [];
  List<dynamic> pickupPassengersList = [];
  List<dynamic> dropPassengersList = [];
  List<dynamic> totalPassengerId = [];
  int ticketlenght = 0;

  documentDetails() async {
    DocumentSnapshot documentSnapshot = await dbservice.getDocumentDetails(
        uid: widget.uid, docId: widget.docId);

    setState(() {
      data = documentSnapshot.data() as Map<String, dynamic>;

      dynamic ticketList = data!["ticket"];
      dynamic pickupList = data!["pickupPassengersList"];
      dynamic dropList = data!["dropPassengersList"];
      ticket = ticketList != null ? ticketList : [];
      pickupPassengersList = pickupList != null ? pickupList : [];
      dropPassengersList = dropList != null ? dropList : [];
      ticketlenght = ticket.length;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    documentDetails();
  }

  bool select = true;


  @override
  Widget build(BuildContext context) {
    divHeight = MediaQuery.of(context).size.height;
    divWidth = MediaQuery.of(context).size.width;
    //final user = Provider.of<User?>(context);
    //userId = user!.uid;

    return Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          backgroundColor: white,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back)),
          centerTitle: true,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.calendar_month_sharp,
                color:blue,
                size: divHeight * 0.04,
              ),
              SizedBox(
                width: divWidth * 0.01,
              ),
              textWidget(
                  text: widget.docId,
                  fontWeight: FontWeight.w900,
                  fontsize: divHeight * 0.02,
                  fontColor: blue),
            ],
          ),
        ),
        body: data != null
            ? SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Row(
                  children: [
                    Image.asset(
                      "Assets/ticket.png",
                      height: divHeight * 0.02,
                      color: green,
                    ),
                    SizedBox(
                      width: divWidth * 0.015,
                    ),
                    textWidget(
                        text: "Tickets",
                        fontWeight: FontWeight.bold,
                        fontsize: divHeight * 0.019,
                        fontColor: black),
                    const Spacer(),
                  ],
                ),
                SizedBox(
                  height: divHeight * 0.01,
                ),
                ticketlenght > 0
                    ? ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ticketBox(ticketDetails: ticket[index]);
                  },
                  itemCount: ticket.length,
                )
                    : textWidget(
                    text: "No Tickets were raised",
                    fontWeight: FontWeight.w500,
                    fontsize: divHeight * 0.017,
                    fontColor: red),
                SizedBox(
                  height: divHeight * 0.04,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    textWidget(
                        text: "Select trip Type :  ",
                        fontWeight: FontWeight.bold,
                        fontsize: divHeight * 0.017,
                        fontColor: black),
                    SizedBox(
                      width: divWidth * 0.02,
                    ),
                    chipButton(chipName: "PickUp", selected: select),
                    SizedBox(
                      width: divWidth * 0.02,
                    ),
                    chipButton(chipName: "Drop", selected: !select),
                  ],
                ),
                SizedBox(
                  height: divHeight * 0.02,
                ),
                select
                    ? tripSpeedAndPassengersDetails(
                    passengersList: pickupPassengersList,
                    uid: widget.uid)
                    : tripSpeedAndPassengersDetails(
                    passengersList: dropPassengersList, uid: widget.uid  )
              ],
            ),
          ),
        )
            : Loading());
  }

  Card ticketBox({
    required Map ticketDetails,
  }) {
    String status = ticketDetails["status"];
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(width: 1.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textWidget(
                      text: ticketDetails["ticketName"],
                      fontWeight: FontWeight.w500,
                      fontsize: divHeight * 0.017,
                      fontColor: black),
                  textWidget(
                      text: ticketDetails["amount"],
                      fontWeight: FontWeight.w500,
                      fontsize: divHeight * 0.017,
                      fontColor: green),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textWidget(
                      text: ticketDetails["time"],
                      fontWeight: FontWeight.w500,
                      fontsize: divHeight * 0.017,
                      fontColor: black),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textWidget(
                      text: status,
                      fontWeight: FontWeight.w500,
                      fontsize: divHeight * 0.017,
                      fontColor: status == "Pending"
                          ? orange
                          : green),
                  textWidget(
                      text: ticketDetails["status"] == "Pending"
                          ? ""
                          : "Approved Time",
                      fontWeight: FontWeight.w500,
                      fontsize: divHeight * 0.017,
                      fontColor: black),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  studentIdBox({required Map passengerDetails, required bool checked

    // required int index,
  }) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                  width: 1.0, color: checked ? green : red)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              textWidget(
                  text: passengerDetails["studentName"],
                  fontWeight: FontWeight.w500,
                  fontsize: divHeight * 0.017,
                  fontColor: black),
              textWidget(
                  text: passengerDetails["studentId"],
                  fontWeight: FontWeight.w500,
                  fontsize: divHeight * 0.017,
                  fontColor: blue),
              //TextWidget(text: "1.00 pm", fontWeight: FontWeight.w500, fontsize: divHeight*0.017, fontColor: Colors.black),
              textWidget(
                  text: passengerDetails["classAndSec"],
                  fontWeight: FontWeight.w500,
                  fontsize: divHeight * 0.017,
                  fontColor: Colors.black45),
            ],
          ),
        ));
  }

  chipButton({
    required String chipName,
    required bool selected,
  }) =>
      InkWell(
        onTap: () {
          setState(() {
            select = !select;
          });
        },
        child: Chip(
            backgroundColor: selected ? blue : white,
            label: textWidget(
                text: chipName,
                fontWeight: FontWeight.w500,
                fontsize: divHeight * 0.017,
                fontColor: selected ? white : black)),
      );

  tripSpeedAndPassengersDetails(
      {required List passengersList, required String uid}) {
    int noOfPassengers = passengersList.length;
    return noOfPassengers < 1
        ? textWidget(
        text: "No trip has taken",
        fontWeight: FontWeight.w500,
        fontsize: divHeight * 0.017,
        fontColor: red)
        : Column(
      children: [


        SizedBox(
          height: divHeight * 0.02,
        ),
        Row(
          children: [
            Image.asset(
              "Assets/groups.png",
              height: divHeight * 0.02,
              color: purple,
            ),
            SizedBox(
              width: divWidth * 0.015,
            ),
            textWidget(
                text: "Passengers",
                fontWeight: FontWeight.bold,
                fontsize: divHeight * 0.019,
                fontColor: black),
            const Spacer(),
          ],
        ),
        SizedBox(
          height: divHeight * 0.01,
        ),
        StreamBuilder(
            stream: dbservice.totalPassengers(uid: uid),
            builder: (context, snapshots) {
              if (!snapshots.hasData) return Loading();
              List<DocumentSnapshot> documents = snapshots.data.docs;
              int totalPassengerCount = documents.length;
              if (totalPassengerId.isEmpty) {
                for (int i = 0; i < totalPassengerCount; i++) {
                  totalPassengerId.add(documents[i].id);
                }
              }
              return Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    textWidget(
                        text: "Present : ${noOfPassengers}",
                        fontWeight: FontWeight.w500,
                        fontsize: divHeight * 0.017,
                        fontColor: green),
                    textWidget(
                        text:
                        "Absent : ${totalPassengerCount - noOfPassengers}",
                        fontWeight: FontWeight.w500,
                        fontsize: divHeight * 0.017,
                        fontColor: red),
                  ],
                ),
                SizedBox(
                  height: divHeight * 0.01,
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> passdet =
                    documents[index].data() as Map<String, dynamic>;

                    String currentPassengerId = documents[index].id;
                    bool present = passengersList.any((dataItem) =>
                    dataItem["docId"] == currentPassengerId);

                    return studentIdBox(
                        passengerDetails: passdet, checked: present);
                  },
                  itemCount: totalPassengerCount,
                )
              ]);
            })
      ],
    );
  }
}
