import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trasnport_portal/Pages/deatiledHistory.dart';
import 'package:trasnport_portal/Services/dbService.dart';
import 'package:trasnport_portal/Services/loading.dart';
import 'package:trasnport_portal/Widgets/textWidget.dart';
import 'package:trasnport_portal/Widgets/textfieldWidget.dart';
import 'package:trasnport_portal/common/common_colors.dart';
import 'package:trasnport_portal/common/common_strings.dart';
class FilterHistory extends StatefulWidget {
  final String userId;
  const FilterHistory({required this.userId,super.key});

  @override
  State<FilterHistory> createState() => _FilterHistoryState();
}

class _FilterHistoryState extends State<FilterHistory> {
  bool selected = true;
  late double divHeight, divWidth;
  TextEditingController fromdate = TextEditingController();
  TextEditingController todate = TextEditingController();
  DBService dbservice = DBService();

  setDate({
    required TextEditingController control,
  }) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(3000));
    if (picked != null) {
      setState(() {
        control.text = DateFormat("dd-MM-yyyy").format(picked);
      });
    }
  }

  String? select = "Yesterday";

  @override
  Widget build(BuildContext context) {
    divHeight = MediaQuery.of(context).size.height;
    divWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: white,
      //appBar: appBarWidget(title: history, fontsize: divHeight * 0.02),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Wrap(
                spacing: divHeight * 0.01,
                children: [
                  chipButton(chipName: "Yesterday"),
                  chipButton(chipName: "Today"),
                  chipButton(chipName: "Custom"),
                  chipButton(chipName: "All")
                ],
              ),
              SizedBox(
                height: divHeight * 0.02,
              ),
              select == "Custom"
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: divWidth * 0.3,
                        child: textfieldWidget(
                            suffixIcon: const Icon(
                              Icons.calendar_month_sharp,
                            ),
                            hintText: "From",
                            control: fromdate,
                            readonly: true,
                            OnClick: () async {
                              await setDate(control: fromdate);
                            })),
                    SizedBox(width: divWidth*0.02,),
                    SizedBox(
                        width: divWidth * 0.3,
                        child: textfieldWidget(
                            suffixIcon:
                            const Icon(Icons.calendar_month_sharp),
                            hintText: "To",
                            control: todate,
                            readonly: true,
                            OnClick: () async {
                              await setDate(control: todate);
                            })),
                  ])
                  : SizedBox(),
              SizedBox(
                height: divHeight * 0.02,
              ),
              select == "All"
                  ? SizedBox(
                  height: divHeight * 0.9,
                  child: StreamBuilder(
                      stream: dbservice.showHistory(
                          uid: widget.userId, historyType: "All"),
                      builder: (context, snapshots) {
                        if (!snapshots.hasData) return Text("Loading");

                        List<DocumentSnapshot> documentSnapshots =
                            snapshots.data!.docs;

                        return ListView.builder(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return viewBox(
                                  docId: documentSnapshots[index].id,
                                  userUid: widget.userId);
                            },
                            itemCount: documentSnapshots.length);
                      }))
                  : select == "Custom"
                  ? fromdate.text.isNotEmpty && todate.text.isNotEmpty
                  ? StreamBuilder(
                  stream: dbservice.showHistory(
                      uid: widget.userId,
                      fromDateStream: fromdate.text,
                      toDateStream: todate.text),
                  builder: (context, snapshots) {
                    if (!snapshots.hasData) return Text("Loading");
                    List<DocumentSnapshot> documentSnapshots =
                        snapshots.data.docs;

                    return ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return viewBox(
                              docId: documentSnapshots[index].id,
                              userUid: widget.userId);
                        },
                        itemCount: documentSnapshots.length);
                  })
                  : Center(
                  child: textWidget(
                      text: "Please Select From date and To date",
                      fontWeight: FontWeight.w500,
                      fontsize: divHeight * 0.017,
                      fontColor: black, Spacing: null))
                  : StreamBuilder(
                  stream: dbservice.showHistoryOnlyGivenDate(
                      uid: widget.userId,
                      givenDate:
                      select == "Today" ? date : yesterdayDate),
                  builder: (context, snapshots) {
                    if (!snapshots.hasData) return Text("Loading");
                    if (snapshots.hasData != {}) {
                      Map<dynamic, dynamic> documentSnapshots =
                      snapshots.data!;
                      if (documentSnapshots.isNotEmpty) {
                        return viewBox(
                            docId: select == "Today"
                                ? date
                                : yesterdayDate,
                            userUid: widget.userId);
                      }
                    }
                    return Center(
                        child: textWidget(
                            text: "No Documents Found",
                            fontWeight: FontWeight.w500,
                            fontsize: divHeight * 0.017,
                            fontColor: black, Spacing: null));
                  }),
              SizedBox(
                height: divHeight * 0.02,
              ),
            ],
          ),
        ),
      ),
    );
  }

  viewBox({
    required String docId,
    required String userUid,
  }) {
    print(userUid);
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(width: 1.0)),
          child: ListTile(
              title: textWidget(
                  text: docId,
                  fontWeight: FontWeight.w500,
                  fontsize: divHeight * 0.017,
                  fontColor: Colors.black, Spacing: null),
              trailing: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailedHistory(
                              docId: docId,
                              uid: userUid,
                            )));
                  },
                  child: textWidget(
                    text: 'View Details',
                    fontWeight: FontWeight.w500,
                    fontsize: divHeight * 0.017,
                    fontColor: blue, Spacing: null,
                  ))),
        ));
  }

  chipButton({
    required String chipName,
  }) =>
      InkWell(
        onTap: () {
          if (select != chipName) {
            setState(() {
              select = chipName;
            });
          }
        },
        child: Chip(
            backgroundColor: select == chipName ? blue : white,
            label: textWidget(
                text: chipName,
                fontWeight: FontWeight.w500,
                fontsize: divHeight * 0.017,
                fontColor: select == chipName ? white : black, Spacing: null)),
      );
}

