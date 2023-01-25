import 'package:sizer/sizer.dart';

class UseFullMethods {
 static double sizeAble(double initalSize) {
    if (SizerUtil.deviceType == DeviceType.tablet) {
      return initalSize * 0.75;
    } else {
      return initalSize;
    }
  }
  
}
 double sizeAble(double initalSize) {
    if (SizerUtil.deviceType == DeviceType.tablet) {
      return initalSize * 0.8;
    } else {
      return initalSize;
    }
  }