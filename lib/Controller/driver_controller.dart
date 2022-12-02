import 'package:get/get.dart';

class DriverController extends GetxController {
  var driver = 0.obs;
  withDriver(index) {
    driver.value = index;
  }
}

class TransmissionController extends GetxController {
  var type = 0.obs;
  withWhat(index) {
    type.value = index;
  }
}
