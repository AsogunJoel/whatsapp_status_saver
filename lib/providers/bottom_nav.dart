import 'package:flutter/cupertino.dart';

class BottomNavProvider with ChangeNotifier {
  int _currentIndex = 0;
  int _whatsappCurrentIndex = 0;
  int _waBusinessCurrentIndex = 0;
  PageController controller = PageController();

  int get currentIndex {
    return _currentIndex;
  }

  formatIndex() {
    _currentIndex = 0;
    _whatsappCurrentIndex = 0;
    _waBusinessCurrentIndex = 0;
    notifyListeners();
  }

  int get waBusinessCurrentIndex {
    return _waBusinessCurrentIndex;
  }

  int get whatsappCurrentIndex {
    return _whatsappCurrentIndex;
  }

  changePageIndex(int value) {
    controller.animateToPage(value,
        duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    _currentIndex = value;
    notifyListeners();
  }

  changewhatsappPageIndex(int value) {
    controller.animateToPage(value,
        duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    _whatsappCurrentIndex = value;
    notifyListeners();
  }

  changewaBusinessPageIndex(int value) {
    controller.animateToPage(value,
        duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    _waBusinessCurrentIndex = value;
    notifyListeners();
  }
}
