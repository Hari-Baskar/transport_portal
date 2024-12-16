import 'package:cloud_firestore/cloud_firestore.dart';

class DBService {
  final firestore = FirebaseFirestore.instance;

  Stream getStudentLocation() {
    return firestore.collection("students").snapshots();
  }

  addRouteAndDroplocations({
    required String routeName,
    required String droplocationName,
    required List latlng,
  }) async {
    DocumentReference doc = firestore.collection("route").doc(routeName);
    DocumentSnapshot documentSnapshot = await doc.get();
    if (documentSnapshot.exists) {
      await doc.update({
        "droplocations": FieldValue.arrayUnion([
          {"droplocationName": droplocationName, "latlng": latlng}
        ])
      });
    } else {
      doc.set({
        "droplocations": [
          {"droplocationName": droplocationName, "latlng": latlng}
        ]
      });
    }
  }

  deleteDropLocation(
      {required String droplocationName,
      required String routeName,
      required List latlng}) async {
    await firestore.collection("route").doc(routeName).update({
      "droplocations": FieldValue.arrayRemove([
        {"droplocationName": droplocationName, "latlng": latlng}
      ])
    });
  }

  Stream routes() {
    return firestore.collection("route").snapshots();
  }

  selectedRoute({
    required String routeName,
  }) {
    return firestore.collection("route").doc(routeName).get();
  }

  getTransportDetails(){
    return firestore.collection('transport').snapshots();
  }

  Stream getDrivers(){
    return firestore.collection("driver").snapshots();
  }


  Stream getStudents({
    required String route,
}){
    return firestore.collection("students").where("pickdrop",isEqualTo: true).where("route",isEqualTo: route).snapshots();
  }

  assignStudentsToVan({
    required Map studentData,
    required String VanNo,
    required String vanId,
}) async{
    await firestore.collection("students").doc(studentData["uid"]).update({
      "assignedVechile":true,
      "assignedVanNo":VanNo,
      "vechileID":vanId,

    });
    await firestore.collection("driver").doc(vanId).collection("students").doc(studentData["studentName"]).set({
      "studentName":studentData["studentName"],
      "classAndSec":studentData["classAndSec"],
      "droplocation":studentData["droplocation"],
      "route":studentData["route"],
      "studentId":studentData["studentId"],

    });
  }

  deleteAssignedStudents({
    required Map studentData,

    required String vanId,
})async{
    await firestore.collection("students").doc(studentData["uid"]).update({
      "assignedVechile":false,
      "assignedVanNo":"",
    });
    await firestore.collection("driver").doc(vanId).collection("students").doc(studentData["studentName"]).delete();
}

assignRouteToDrivers({
    required String uid,
  required String routeName,
  required List droplocations
})async{
    return firestore.collection("driver").doc(uid).update({
  "route":routeName,
      "droplocations":droplocations
});
}



  Stream<Map<String, dynamic>> showHistoryOnlyGivenDate({
    required String uid,
    required String givenDate,
  }) {
    DocumentReference documentReference = firestore
        .collection("driver")
        .doc(uid)
        .collection("history")
        .doc(givenDate);


    return documentReference.snapshots().map((documentSnapshot) {
      if (documentSnapshot.exists) {
        return documentSnapshot.data() as Map<String, dynamic>;
      } else {
        return {}; // Return an empty map if the document doesn't exist
      }
    });
  }

  Stream showHistory({
    required String uid,
    String? historyType,
    String? fromDateStream,
    String? toDateStream,
  }) {

    if (historyType != null) {
      return firestore
          .collection("driver")
          .doc(uid)
          .collection("history")
          .snapshots();
    }


    else {
      return firestore
          .collection("driver")
          .doc(uid)
          .collection("history")
          .where(FieldPath.documentId, isGreaterThanOrEqualTo: fromDateStream)
          .where(FieldPath.documentId, isLessThanOrEqualTo: toDateStream)
          .snapshots();
    }
  }
  getDocumentDetails({
    required String uid,
    required String docId,
  }) async {
    return await firestore
        .collection("driver")
        .doc(uid)
        .collection("history")
        .doc(docId)
        .get();
  }


  Stream totalPassengers({required String uid}) {
    return firestore
        .collection("driver")
        .doc(uid)
        .collection("students")
        .snapshots();
  }


}
