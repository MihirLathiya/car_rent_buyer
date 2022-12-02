import 'package:get/get.dart';

class SearchController extends GetxController {
  String searchCars = '';

  onChanged(val) {
    searchCars = val;
    update();
  }
}
