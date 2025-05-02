import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../model/carwasher.dart';


class CarwasherCard extends StatelessWidget {
  final Carwasher carwasher;

  const CarwasherCard({super.key, required this.carwasher});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Color(0xfff0f5ff),
        border: Border.all(color: Color(0xff005FEE)),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Card(
        color: Color(0xfff0f5ff),
        elevation: 0.0,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        // child: ListTile(
        //   leading: Container(
        //     width: 55,
        //     height: 60,
        //     decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(60),
        //       border: Border.all(color: Color(0xff006AFA)),
        //     ),
        //     child: CircleAvatar(
        //       backgroundImage:AssetImage('assets/images/profile.jpg'),
        //     ),
        //   ),
        //   title: Text(
        //     '${carwasher.firstName} ${carwasher.lastName}',
        //     style: GoogleFonts.poppins(
        //       fontSize: 16, fontWeight: FontWeight.w600,
        //     ),
        //   ),
        //   subtitle: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       SizedBox(height: 4),
        //       Row(children: [
        //         Text('${carwasher.category} - ${carwasher.city}',
        //         style: GoogleFonts.poppins(
        //           fontSize: 14
        //         ),)
        //       ],),
        //       Text(
        //         'Experience: ${carwasher.yearsOfExperience} years',
        //         style: GoogleFonts.poppins(
        //           fontWeight: FontWeight.w500,
        //           fontSize: 12,
        //           color: Color(0xff005FEE),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        child: Card(
          color:Color(0xfff0f5ff),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),

          ),
          elevation: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(
                  'assets/images/icon.jpg',
                  width: double.infinity,
                  height: 120,
                  fit: BoxFit.fill,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${carwasher.firstName} ${carwasher.lastName}',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${carwasher.category} - ${carwasher.city}',
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Experience: ${carwasher.yearsOfExperience} years',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: Color(0xff005FEE),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
        ,
      ),
    );
  }
}
