import 'package:flutter/cupertino.dart';


class ScreenIndexProvider extends ChangeNotifier{
  int screeIndex = 0; // Initial index of screen
  int get fetchCurrentScreenIndex{
    //  function to return the current screen Index
    return screeIndex;
  }
  void updateScreenIndex(int newIndex){
    // function to update the screenIndex
    screeIndex = newIndex;
    notifyListeners(); // This will notify every listeners that the screen index has been changed
  }
}