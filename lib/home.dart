
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_database_app/add_gig.dart';
import 'package:freelancing_database_app/controller.dart';
import 'package:freelancing_database_app/database_service.dart';
import 'package:freelancing_database_app/gig_detail.dart';
import 'package:get/get.dart';

class FiverrHomepage extends StatefulWidget {
  FiverrHomepage({Key? key}) : super(key: key);

  @override
  State<FiverrHomepage> createState() => _FiverrHomepageState();
}

class _FiverrHomepageState extends State<FiverrHomepage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        HomeController.to.update(['gigs']);
      });
    });
  }

  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () => setState(() {
            HomeController.to.update(['gigs']);
          }),
          child: Text(
            'Freelancing Database App',
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddGigScreen(), transition: Transition.fadeIn);
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              onChanged: (value) {
                controller.updateSearchQuery(value);
                setState(() {
                  HomeController.to.update(['gigs']);
                });
              },
              decoration: InputDecoration(
                hintText: 'Search for services...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                filled: true,
                fillColor: Colors.grey.shade200,
              ),
            ),
            SizedBox(height: 20.h),

            // Categories Section
            Text(
              'Categories',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12.h),
            SizedBox(
              height: 100.h,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  CategoryCard('Graphics & Design', Icons.brush, () {}),
                  CategoryCard('Digital Marketing', Icons.campaign, () {}),
                  CategoryCard('Writing & Translation', Icons.edit, () {}),
                  CategoryCard('Programming & Tech', Icons.code, () {}),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            // Featured Services Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Featured Services',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    await DatabaseService.deleteAllData();
                    HomeController.to.gigs.clear();
                    setState(() {});
                  },
                  icon: Icon(
                    Icons.delete_forever_sharp,
                    color: Colors.red,
                    size: 25.sp,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // Gigs Grid
            Expanded(
              child: GetBuilder<HomeController>(
                id: "gigs",
                builder: (controller) {
                  final filteredGigs = controller.filteredGigs;
                  if (filteredGigs.isEmpty) {
                    return Center(
                      child: Text(
                        "No gigs found",
                        style: TextStyle(
                          fontSize: 20.sp,
                          color: Colors.grey.shade800,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.w,
                      mainAxisSpacing: 10.h,
                      childAspectRatio: 3 / 4,
                    ),
                    itemCount: filteredGigs.length,
                    itemBuilder: (context, index) {
                      final gig = filteredGigs[index];
                      return GestureDetector(
                        onTap: () => Get.to(
                          () => GigDetailScreen(
                            gig: gig,
                          ),
                        ),
                        child: ServiceCard(
                          title: gig['title'] ?? 'No Title',
                          imagePath: gig['imagePath'] ?? '',
                          price: gig['price'] ?? '0',
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Category Card Widget
class CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const CategoryCard(this.title, this.icon, this.onTap, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 12.w),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 100.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30.sp, color: Colors.teal),
              SizedBox(height: 8.h),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Service Card Widget
class ServiceCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final String price;

  const ServiceCard({
    Key? key,
    required this.title,
    required this.imagePath,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
            child: imagePath.isEmpty
                ? Image.asset(
                    "assets/sample_service.png",
                    height: 120.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    File(imagePath),
                    height: 120.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.broken_image,
                      size: 120.h,
                      color: Colors.grey,
                    ),
                  ),
          ),
          Padding(
            padding: EdgeInsets.all(8.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '\$${price}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
