
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freelancing_database_app/controller.dart';
import 'package:freelancing_database_app/gig_detail.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddGigScreen extends StatefulWidget {
  const AddGigScreen({Key? key}) : super(key: key);

  @override
  State<AddGigScreen> createState() => _AddGigScreenState();
}

class _AddGigScreenState extends State<AddGigScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final HomeController controller = Get.put(HomeController());
  XFile? _selectedImage;

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
      }
    } catch (e) {
      log("Error picking image: $e");
    }
  }

  void _saveGig() {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final price = _priceController.text.trim();

    if (title.isNotEmpty &&
        description.isNotEmpty &&
        price.isNotEmpty &&
        _selectedImage != null) {
      controller.addGig(
        title: title,
        description: description,
        price: price,
        imagePath: _selectedImage!.path,
      );

      _titleController.clear();
      _descriptionController.clear();
      _priceController.clear();
      setState(() {
        _selectedImage = null;
      });

      Get.snackbar(
        'Success',
        'Gig added successfully!',
        snackPosition: SnackPosition.TOP,
      );
    } else {
      Get.snackbar(
        'Error',
        'Please fill all fields and select an image.',
        snackPosition: SnackPosition.TOP,
      );
    }
    HomeController.to.update(['gigs']);
    setState(() {
      HomeController.to.update(['gigs']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add New Gig',
          style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('Gig Title', 'Enter gig title', _titleController),
              SizedBox(height: 16.h),
              _buildTextField(
                'Description',
                'Enter gig description',
                _descriptionController,
                maxLines: 5,
              ),
              SizedBox(height: 16.h),
              _buildTextField(
                'Price',
                'Enter gig price',
                _priceController,
                inputType: TextInputType.number,
              ),
              SizedBox(height: 16.h),
              Text(
                'Upload Image',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.h),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150.h,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: _selectedImage == null
                      ? Center(
                          child: Icon(
                            Icons.upload_file,
                            size: 40.sp,
                            color: Colors.grey,
                          ),
                        )
                      : Image.file(
                          File(_selectedImage!.path),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              SizedBox(height: 24.h),
              Center(
                child: ElevatedButton(
                  onPressed: _saveGig,
                  style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(horizontal: 40.w, vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text('Save Gig', style: TextStyle(fontSize: 18.sp)),
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                'Your Gigs',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12.h),
              Obx(
                () => ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.gigs.length,
                  itemBuilder: (context, index) {
                    final gig = controller.gigs[index];
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => GigDetailScreen(gig: gig));
                      },
                      child: Card(
                        margin: EdgeInsets.only(bottom: 12.h),
                        child: ListTile(
                          leading: Image.file(
                            File(gig['imagePath']!),
                            width: 50.w,
                            height: 50.h,
                            fit: BoxFit.cover,
                          ),
                          title: Text(gig['title']!),
                          subtitle: Text(gig['description']!),
                          trailing: Text('\$${gig['price']}'),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String hint,
    TextEditingController controller, {
    int maxLines = 1,
    TextInputType inputType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: inputType,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            filled: true,
            fillColor: Colors.grey.shade200,
          ),
        ),
      ],
    );
  }
}
