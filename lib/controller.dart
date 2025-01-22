import 'package:freelancing_database_app/database_service.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();

  // Reactive state
  final RxList<Map<String, dynamic>> gigs = <Map<String, dynamic>>[].obs;
  final RxString searchQuery = ''.obs;

  // Computed property for filtered gigs
  List<Map<String, dynamic>> get filteredGigs {
    if (searchQuery.value.isEmpty) return gigs;
    return gigs
        .where((gig) => gig['title']
            .toLowerCase()
            .contains(searchQuery.value.toLowerCase()))
        .toList();
  }

  // Update search query
  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  // Load gigs from database
  Future<void> loadGigs() async {
    try {
      final db = await DatabaseService().database;
      final result = await db.query('gigs');
      gigs.assignAll(result);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load gigs: $e');
    }
  }

  // Add a new gig
  Future<void> addGig({
    required String title,
    required String description,
    required String price,
    required String imagePath,
  }) async {
    try {
      final db = await DatabaseService().database;
      final newGig = {
        'title': title,
        'description': description,
        'price': price,
        'imagePath': imagePath,
      };
      final id = await db.insert('gigs', newGig);
      gigs.add({...newGig, 'id': id});
    } catch (e) {
      Get.snackbar('Error', 'Failed to add gig: $e');
    }
  }

  // Delete a gig
  Future<void> deleteGig(int id) async {
    try {
      final db = await DatabaseService().database;

      gigs.removeAt(id);

      await db.delete('gigs', where: 'id = ?', whereArgs: [id]);
      gigs.removeWhere((gig) => gig['id'] == id);
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete gig: $e');
    }
  }

  //

  @override
  void onInit() {
    super.onInit();
    loadGigs();
  }
}
