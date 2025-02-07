import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:suroyapp/screens/listings_screen.dart';
import 'package:suroyapp/screens/starting_page.dart';
import 'package:suroyapp/models/vehicle_info.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PriceRegistration extends StatefulWidget {
  final VehicleInformation3 vehicleInfo;

  const PriceRegistration({Key? key, required this.vehicleInfo})
      : super(key: key);

  @override
  State<PriceRegistration> createState() => _PriceRegistrationState();
}

class _PriceRegistrationState extends State<PriceRegistration> {
  TextEditingController price = TextEditingController();
  String rentPrice = "";
  double guestFee = 0;
  String strGuestFee = "";
  double totalPrice = 0;
  String strTotalPrice = "";

  @override
  Widget build(BuildContext context) {
    // Update strGuestFee and totalPrice here in the build method
    strGuestFee = guestFee.toString();
    strTotalPrice = totalPrice.toString();

    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Container(
            height: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/vectors/arrow.svg',
                  width: 25,
                  height: 25,
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      User? user = FirebaseAuth.instance.currentUser;

                      if (user != null) {
                        String userEmail = user.email ?? 'No email available';
                        String hostAge = user.phoneNumber ?? 'Invalid number';

                        DocumentReference vehicleRef = await FirebaseFirestore
                            .instance
                            .collection('vehicleListings')
                            .add({
                          'hostId': user.uid,
                          'email': userEmail,
                          'hostAge': widget.vehicleInfo.hostAge,
                          'hostMobileNumber':
                              widget.vehicleInfo.hostMobileNumber,
                          'hostName': widget.vehicleInfo.hostName,
                          'vehicleType': widget.vehicleInfo.vehicleType,
                          'vehicleModel': widget.vehicleInfo.vehicleModel,
                          'modelYear': widget.vehicleInfo.modelYear,
                          'licensePlateNum': widget.vehicleInfo.plateNumber,
                          'vehicleImage': widget.vehicleInfo.vehicleImageUrl,
                          'certificateImage': widget.vehicleInfo.certificateImageurl,
                          'numSeats': widget.vehicleInfo.numSeats,
                          'description': widget.vehicleInfo.vehicleDescription,
                          'renterAddress': widget.vehicleInfo.pickUpAddress,
                          'pricing': strTotalPrice,
                          'timestamp': FieldValue.serverTimestamp(),
                          'isAvailable': false,
                          'bookingStatus': "Available",
                        });

                        Fluttertoast.showToast(
                          msg: "Application submitted. Check your email for confirmation!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                        );
                        print("Registration Successful!");
                      }
                    } catch (error) {
                      Fluttertoast.showToast(
                        msg: "Error registering vehicle. Please try again!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                      );

                      print("Invalid account details ${error.toString()}");
                    }
                    FinalVehicleInfo finalVehicleInfo = FinalVehicleInfo(
                      isAvailable: false,
                      rentPrice: rentPrice,
                      bookingStatus: "Available",
                      vehicleDescription: widget.vehicleInfo.vehicleDescription,
                      pickUpAddress: widget.vehicleInfo.pickUpAddress,
                      vehicleType: widget.vehicleInfo.vehicleType,
                      vehicleModel: widget.vehicleInfo.vehicleModel,
                      hostName: widget.vehicleInfo.hostName,
                      numSeats: widget.vehicleInfo.numSeats,
                      modelYear: widget.vehicleInfo.modelYear,
                      plateNumber: widget.vehicleInfo.plateNumber,
                      vehicleImageUrl: widget.vehicleInfo.vehicleImageUrl,
                      certificateImageUrl: widget.vehicleInfo.certificateImageurl,
                      hostAge: widget.vehicleInfo.hostAge,
                      hostMobileNumber: widget.vehicleInfo.hostMobileNumber,
                      email: widget.vehicleInfo.email,
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Listings(),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xfff004aad),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 50,
                    width: 100,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "NEXT",
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              20, MediaQuery.of(context).size.height * 0, 20, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "SET THE PRICE FOR YOUR VEHICLE!",
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "This will be the base price before incurred additional charges and fees",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
              ),
              SizedBox(height: 110),
              TextField(
                textAlign: TextAlign.center,
                controller: price,
                keyboardType: TextInputType.numberWithOptions(
                  signed: false,
                  decimal: false,
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: price.text.isEmpty ? "₱0" : null,
                  labelStyle: TextStyle(fontSize: 45, color: Colors.black),
                  border: InputBorder.none, // Remove the border
                ),
                textAlignVertical: TextAlignVertical.center,
                style: GoogleFonts.poppins(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                ), // Set the font size
                onChanged: (value) {
                  // Format the input with a peso sign
                  double numericPrice = double.tryParse(value) ?? 0;
                  guestFee = (numericPrice * 0.05).toDouble();
                  totalPrice = (numericPrice + guestFee).toDouble();
                  price.text = 'P' + '$value';
                  // Rebuild the widget to update the label text visibility
                  setState(() {
                    rentPrice = value;
                  });
                },
              ),
              Container(
                height: 120,
                decoration: BoxDecoration(
                  border: Border.all(width: 3.0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Base Price",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "P" + "$rentPrice",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Guest Fee",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "P" + "$strGuestFee",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Divider(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Price before taxes",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "P" + "$strTotalPrice",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    strGuestFee = "0";
    strTotalPrice = "0";
  }

  @override
  void dispose() {
    price.dispose();
    super.dispose();
  }
}
