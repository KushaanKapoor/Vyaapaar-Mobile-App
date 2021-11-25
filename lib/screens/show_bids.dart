import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vyaapaar/components/bid_card.dart';
import 'package:vyaapaar/screens/bid_detail_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

final Firestore firestoreInstance = Firestore.instance;

class ShowBids extends StatefulWidget {
  static const String id = "Bids On Your Project";

  const ShowBids({
    Key key,
    @required this.duration,
    @required this.isCollapsed,
    @required this.screenWidth,
    @required Animation<double> scaleAnimation,
    @required AnimationController controller,
    @required this.isCollaped,
    @required this.setIsCollaped,
  })  : _scaleAnimation = scaleAnimation,
        _controller = controller,
        super(key: key);

  final Duration duration;
  final bool isCollapsed;
  final double screenWidth;
  // ignore: unused_field
  final Animation<double> _scaleAnimation;
  final AnimationController _controller;
  final bool isCollaped;
  final Function setIsCollaped;

  @override
  _ShowBidsState createState() => _ShowBidsState();
}

class _ShowBidsState extends State<ShowBids> {
  Map<String, dynamic> project;
  String projectName;
  bool isLoading = true;
  List<Map<String, dynamic>> bids = List<Map<String, dynamic>>();

  void toggleSidebar() {
    if (widget.isCollapsed)
      openSidebar();
    else
      closeSidebar();
  }

  void openSidebar() {
    widget._controller.forward();
    widget.setIsCollaped(false);
  }

  void closeSidebar() {
    widget._controller.reverse();
    widget.setIsCollaped(true);
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      project = ModalRoute.of(context).settings.arguments;
      projectName = project["projectName"];
      getProjectBids(project["id"]);
    });
  }

  void getProjectBids(String projectId) async {
    isLoading = true;

    try {
      final QuerySnapshot bidsQuery = await firestoreInstance
          .collection("projects")
          .document(projectId)
          .collection("bids")
          .getDocuments();

      List<Map<String, dynamic>> bidsInterim = List<Map<String, dynamic>>();

      for (int i = 0; i < bidsQuery.documents.length; i++) {
        final Map<String, dynamic> bid = bidsQuery.documents[i].data;
        final DocumentSnapshot userDoc = await firestoreInstance
            .collection("users")
            .document(bid["bidder"])
            .get();
        bid["bidId"] = bidsQuery.documents[i].documentID;
        bid["bidderDetails"] = userDoc.data;
        bidsInterim.add(bid);
      }
      setState(() {
        isLoading = false;
        bids = bidsInterim;
      });
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(
          msg: "Check you Network Connection.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black12,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  List<BidCard> displayBids() {
    List<BidCard> bidsList = List<BidCard>();
    for (int i = 0; i < bids.length; i++) {
      bidsList.add(BidCard(
        length: 100,
        bidderName: bids[i]["bidderDetails"]["businessName"],
        bidAmount: bids[i]["bidAmount"],
        fontSize: 17,
        onPress: () {
          Navigator.pushNamed(context, BidDetailScreen.id,
              arguments: {"bidDetails": bids[i], "project": project});
        },
      ));
    }
    return bidsList;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(left: 16, right: 16, top: 25),
          decoration: BoxDecoration(
              color: Color(0xFFE8E9EB),
              borderRadius: !widget.isCollapsed
                  ? BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0),
                      bottomLeft: Radius.circular(40.0))
                  : BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0))),
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: isLoading
                    ? <Widget>[
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.3,
                        ),
                        Center(
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            height: 60.0,
                            width: 60.0,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.blueAccent),
                              value: null,
                              strokeWidth: 4.0,
                            ),
                          ),
                        ),
                      ]
                    : <Widget>[
                        SizedBox(height: 10.0),
                        Text(
                          'Project Name',
                          style: GoogleFonts.raleway(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400)),
                        ),
                        SizedBox(height: 5.0),
                        Text(projectName ?? "",
                            style: GoogleFonts.raleway(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500))),
                        SizedBox(height: 20.0),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: displayBids())
                      ],
              ),
            ),
          )),
    );
  }
}
