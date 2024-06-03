import 'package:comet_messenger/features/widgets/weight_bottom_sheet_widget.dart';
import 'package:get/get.dart';

class AppBottomSheetUtil {
  AppBottomSheetUtil._();

  static void weightBottomSheet({
    required void Function(String weight) onTapSave,
    required String title,
  }) {
    Get.bottomSheet(
      WeightBottomSheetWidget(
        onTapSave: (weight) => onTapSave(weight),
        title: title,
      ),
    );
  }
}
