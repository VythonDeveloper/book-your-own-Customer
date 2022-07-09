import 'package:book_your_own/BookingUI/booking_ui.dart';
import 'package:book_your_own/Booking_History/booking_history.dart';
import 'package:book_your_own/Rewards/rewards.dart';
import 'package:book_your_own/constants.dart';
import 'package:book_your_own/register.dart';
import 'package:book_your_own/track_trip.dart';
import 'package:book_your_own/webView_ui.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:page_route_transition/page_route_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardUI extends StatefulWidget {
  const DashboardUI({Key? key}) : super(key: key);

  @override
  State<DashboardUI> createState() => _DashboardUIState();
}

class _DashboardUIState extends State<DashboardUI> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final trackingId = TextEditingController();
  String trkErrorMsg = '';
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final dateFormat = new DateFormat('MMMM d, yyyy HH:mm');
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    trackingId.dispose();
  }

  _fetchSpecificRideDetails() {
    FocusScope.of(context).unfocus();
    FirebaseFirestore.instance
        .collection('rideRequest')
        .doc(trackingId.text)
        .get()
        .then((value) {
      PageRouteTransition.push(
          context,
          TrackTripUi(
            rideDetails: value.data(),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
                image: DecorationImage(
                  image: const AssetImage(
                    'lib/assets/images/deliveryBack.jpg',
                  ),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(0.6),
                    BlendMode.lighten,
                  ),
                ),
              ),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Book',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'Your Own',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () => _scaffoldKey.currentState?.openDrawer(),
                          child: Image.asset(
                            './lib/assets/images/menu.png',
                            height: 30,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    Text(
                      'Track Your Package',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        fontSize: 30,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Flexible(
                            child: TextField(
                              controller: trackingId,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Enter tracking id',
                                hintStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (trackingId.text.isEmpty) {
                                  trkErrorMsg = "Please enter your tracking id";
                                }
                              });
                              _fetchSpecificRideDetails();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                'Track',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      trkErrorMsg,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color.fromARGB(255, 177, 31, 20),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            GestureDetector(
              onTap: () {
                PageRouteTransition.push(context, RewardsUi());
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 230, 230, 230),
                      blurRadius: 25.0,
                      spreadRadius: 25,
                      offset: Offset(
                        20,
                        20,
                      ),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      './lib/assets/images/gift.png',
                      height: 35,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Rewards for you",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Spacer(),
                    Icon(
                      Icons.arrow_circle_right_rounded,
                      size: 25,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            const Center(
              child: Text(
                'What are you looking for?',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  fontSize: 25,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Center(
              child: Text(
                'Here are our best features',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.grey,
                  fontSize: 17,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                PageRouteTransition.effect = TransitionEffect.rightToLeft;
                PageRouteTransition.push(context, const VehicleBookingUi());
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding:
                    const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: const AssetImage(
                      'lib/assets/images/bookbanner.jpg',
                    ),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.white.withOpacity(0.6),
                      BlendMode.lighten,
                    ),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Text(
                          'Book Your Own',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 25,
                          ),
                        ),
                        Text(
                          'Vehicle',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(
                      "Recent Bookings",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: OutlinedButton(
                      onPressed: () {
                        PageRouteTransition.push(context, BookingHistoryUi())
                            .then((value) => setState(() {}));
                      },
                      child: Text("See all"),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Column(
                children: [
                  FutureBuilder<dynamic>(
                    future: FirebaseFirestore.instance
                        .collection('rideRequest')
                        .where('customerId',
                            isEqualTo: Constants.customerDetails['id'])
                        .orderBy('tripStartTime', descending: true)
                        .limit(3)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            DocumentSnapshot ds = snapshot.data.docs[index];
                            return historyCard(ds);
                          },
                        );
                      } else {
                        return const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("No booking..."),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Column(
                  children: [
                    Center(
                      child: Image.asset(
                        './lib/assets/images/icon.png',
                        height: 180,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Profile",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              Constants.customerDetails['fullname'],
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              Constants.customerDetails['mobile'],
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Terms and Privacy",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          PageRouteTransition.effect = TransitionEffect.fade;
                          PageRouteTransition.push(
                            context,
                            WebViewUI(
                                url: "https://aryagold.co.in/terms-conditions"),
                          );
                        },
                        leading: Icon(Icons.gavel),
                        title: Text("Terms & Conditions"),
                        subtitle: Text(
                          "Read terms & conditions",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Icon(Icons.arrow_forward_ios_rounded),
                        // tileColor: Colors.blueGrey[100],
                        iconColor: Colors.blueGrey[800],
                      ),
                      ListTile(
                        onTap: () {
                          PageRouteTransition.effect = TransitionEffect.fade;
                          PageRouteTransition.push(
                            context,
                            WebViewUI(
                                url: "https://aryagold.co.in/privacy-policy"),
                          );
                        },
                        leading: Icon(Icons.privacy_tip),
                        title: Text("Privacy Policy"),
                        subtitle: Text(
                          "Read privacy policy",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Icon(Icons.arrow_forward_ios_rounded),
                        // tileColor: Colors.blueGrey[100],
                        iconColor: Colors.blueGrey[800],
                      ),
                      ListTile(
                        onTap: () {
                          PageRouteTransition.effect = TransitionEffect.fade;
                          PageRouteTransition.push(
                            context,
                            WebViewUI(
                                url: "https://aryagold.co.in/refund-policy"),
                          );
                        },
                        leading: Icon(Icons.privacy_tip),
                        title: Text("Return, Refund, & Cancellation Policy"),
                        subtitle: Text(
                          "Read Return, Refund, & Cancellation Policy",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Icon(Icons.arrow_forward_ios_rounded),
                        // tileColor: Colors.blueGrey[100],
                        iconColor: Colors.blueGrey[800],
                      ),
                      const SizedBox(height: 20),
                      MaterialButton(
                        onPressed: () async {
                          final pref = await _prefs;
                          Constants.customerDetails = {};
                          pref.setString("mobile", "");
                          pref.setString("password", "");
                          Navigator.popUntil(context, (route) => false);
                          PageRouteTransition.push(context, const RegisterUi());
                        },
                        elevation: 0,
                        color: Colors.red[900],
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: const Center(
                            child: Text(
                              'Logout',
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget historyCard(var tripDetails) {
    return GestureDetector(
      onTap: () {
        PageRouteTransition.push(context, TrackTripUi(rideDetails: tripDetails))
            .then((value) => setState(() {}));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.grey,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Trk. Id " + tripDetails['id'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade700,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'lib/assets/icons/homeMarker.svg',
                              color: Colors.white,
                              height: 15,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              'Source',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        tripDetails['pickAddress'],
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.red.shade700,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'lib/assets/icons/destination.svg',
                              color: Colors.white,
                              height: 15,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            const Text(
                              'Destination',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        tripDetails['dropAddress'],
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        'Status: ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Constants.statusColor[tripDetails['status']],
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          tripDetails['status'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Scheduled on",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text(dateFormat.format(
                          DateTime.fromMillisecondsSinceEpoch(
                              tripDetails['tripStartTime']))),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
