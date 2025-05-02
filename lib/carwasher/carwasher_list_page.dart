import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:practice/carwasher/widget/carwasher_card.dart';


import 'carwasher_details_page.dart';
import 'model/carwasher.dart';

class CarwasherListPage extends StatefulWidget {
  const CarwasherListPage({super.key});

  @override
  State<CarwasherListPage> createState() => _CarwasherListPageState();
}

class _CarwasherListPageState extends State<CarwasherListPage> {
  final DatabaseReference _database =
      FirebaseDatabase.instance.ref().child('Carwashers');
  List<Carwasher> _carwashers = [];
  List<Carwasher> _filteredcarwashers = [];
  bool _isLoading = true;

  // Track the selected category
  String? _selectedCategory;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchCarwashers();
  }

  Future<void> _fetchCarwashers() async {
    await _database.once().then((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      List<Carwasher> tmpCarwashers = [];
      if (snapshot.value != null) {
        Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
        values.forEach((key, value) {
          Carwasher carwasher = Carwasher.fromMap(value, key);
          tmpCarwashers.add(carwasher);
        });
      }
      setState(() {
        _carwashers = tmpCarwashers;
        _isLoading = false;
        _filteredcarwashers = tmpCarwashers;
      });
    });
  }

  // Filter lawyers based on the selected category
  void _filtercarwashersByCategory(String? category) {
    setState(() {
      _selectedCategory = category;
      if (category == null || category.isEmpty) {
        _filteredcarwashers = _carwashers; // Show all lawyers
      } else {
        // Manually filter lawyers by specific categories
        if (category == 'Full Service Wash') {
          _filteredcarwashers =
              _carwashers.where((carwasher) => carwasher.category == 'Full Service Wash').toList();
        } else if (category == 'Waterless Wash') {
          _filteredcarwashers =
              _carwashers.where((carwasher) => carwasher.category == 'Waterless Wash').toList();
        } else if (category == 'Wax and Polish') {
          _filteredcarwashers =
              _carwashers.where((carwasher) => carwasher.category == 'Wax and Polish').toList();
        } else if (category == 'Ceramic Coating') {
          _filteredcarwashers =
              _carwashers.where((carwasher) => carwasher.category == 'Ceramic Coating').toList();
        } else if (category == 'Engine Cleaning') {
          _filteredcarwashers =
              _carwashers.where((carwasher) => carwasher.category == 'Engine Cleaning').toList();
        } else {
          _filteredcarwashers = _carwashers; // Default to showing all lawyers
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 40.0), // Space before the heading
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Find your Carwasher &\nBook a Service',
              style: GoogleFonts.poppins(
                fontSize: 24,
                color: Color(0xff006AFA),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(height: 10), // Space after the heading

          // The rest of the content should be scrollable
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Find Carwasher by Category',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 16.0),

                    // Category selection section
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildCategoryCard(context, 'Full Service\nWash',
                                'assets/images/full.jpg', 'Full Service Wash'),
                            _buildCategoryCard(context, 'Waterless\nWash',
                                'assets/images/waterless.jpg', 'Waterless Wash'),
                            _buildCategoryCard(context, 'Wax and\nPolish',
                                'assets/images/wax.jpg', 'Wax and Polish'),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildCategoryCard(context, 'Ceramic\nCoating',
                                'assets/images/ceramic.jpg', 'Ceramic Coating'),
                            _buildCategoryCard(context, 'Engine\nCleaning',
                                'assets/images/engine.jpg', 'Engine Cleaning'),
                            _buildCategoryCard(context, 'See All\nCategory',
                                'assets/images/grid.png', ''),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Top Carwasher',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          'VIEW ALL',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff006AFA),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Carwasher List
                    _filteredcarwashers.isEmpty
                        ? Center(
                      child: Text(
                        'No Carwasher found for this category.',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    )
                        : Column(
                      children: _filteredcarwashers.map((carwasher) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CarwasherDetailPage(carwasher: carwasher),
                              ),
                            );
                          },
                          child: CarwasherCard(carwasher: carwasher),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildCategoryCard(BuildContext context, String title, String icon,
      String category) {
    bool isSelected = _selectedCategory == category;

    return GestureDetector(
      onTap: () {
        _filtercarwashersByCategory(category.isEmpty ? null : category);
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.28,
        decoration: BoxDecoration(
          color: isSelected ? Color(0xff006AFA) : Color(0xffFFFFFF),
          borderRadius: BorderRadius.circular(15),
          border: isSelected
              ? null
              : Border.all(color: Color(0xff006AFA), width: 2),
        ),
        child: Card(
          color: isSelected ? Color(0xff006AFA) : Color(0xfff0f5ff),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      icon,
                      width: 80,
                      height: 80,
                      fit: BoxFit.fill,
                      // color: isSelected ? Colors.white : Color(0xff006AFA),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : Color(0xff006AFA),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

