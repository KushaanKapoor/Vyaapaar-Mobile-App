import "package:cloud_firestore/cloud_firestore.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

final Firestore db = Firestore.instance;

Future<void> awardProject(projectId, bidId) async {
  try {
    final DocumentSnapshot winningBidDoc = await db
        .collection("projects")
        .document(projectId)
        .collection("bids")
        .document(bidId)
        .get();

    Map<String, dynamic> winningBidDetails = winningBidDoc.data;
    winningBidDetails["bidId"] = winningBidDoc.documentID;

    await db
        .collection("projects")
        .document(projectId)
        .updateData({"winningBid": winningBidDetails, "isAwarded": true});

    await db
        .collection("users")
        .document(winningBidDetails["bidder"])
        .collection("bids")
        .document(bidId)
        .updateData({"isAwarded": true});

    Fluttertoast.showToast(
        msg: "Project Awarded Successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black12,
        textColor: Colors.white,
        fontSize: 16.0);
  } catch (e) {
    print(e.toString());
    Fluttertoast.showToast(
        msg: "There was some problem. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black12,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
