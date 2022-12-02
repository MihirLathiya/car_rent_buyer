import 'package:get/get.dart';

class BottomController extends GetxController {
  RxInt selectedPage = 0.obs;

  selectItem(index) {
    selectedPage.value = index;
    update();
  }
}

class LoadingController extends GetxController {
  var loading = false.obs;
  isLoading() {
    loading.value = true;
  }

  isNotLoading() {
    loading.value = false;
  }
}

class IndicatorController extends GetxController {
  RxInt indicator = 0.obs;

  selectedIndicator(index) {
    indicator.value = index;
    update();
  }
}

class DropController extends GetxController {
  var selectCatType = 'Sedan'.obs;

  selectItem(val) {
    selectCatType.value = val;
    update();
  }
}

class FuelController extends GetxController {
  var selectFuel = 'CNG'.obs;

  selectedFuel(val) {
    selectFuel.value = val;
    update();
  }
}
