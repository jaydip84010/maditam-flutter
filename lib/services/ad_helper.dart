import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3405382556879664/8436297443';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3405382556879664/8186113485';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstetialUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3405382556879664/5810134101';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3405382556879664/6472796311';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
