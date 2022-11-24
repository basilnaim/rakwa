import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'mStack.dart';

class BottomTabNavigation {
  HashMap<int, MyStack<Widget>> tabStacks = HashMap();
  List<int> tabsStack = [];
  int currentTab = 0;
  ValueNotifier<int> onWidgetChangedListener = ValueNotifier(1);
  List<Widget> rootWidgets = [];

  BottomTabNavigation({required this.rootWidgets}) {
    tabStacks = HashMap();
    for (var i = 0; i < rootWidgets.length; i++) {
      tabStacks.putIfAbsent(i, () => MyStack<Widget>()..push(rootWidgets[i]));
    }
    currentTab = 0;
    tabsStack.add(currentTab);
  }

  switchTab(tab) {
    if (currentTab != tab) {
      currentTab = tab;
      if (currentTab == 0) {
        if (tabsStack.where((element) => element == currentTab).length > 1) {
          tabsStack.removeAt(tabsStack.lastIndexOf(currentTab));
          tabsStack.add(currentTab);
        }
        tabsStack.add(currentTab);
      } else {
        tabsStack.remove(currentTab);
        tabsStack.add(currentTab);
      }
    } else {
      tabStacks[currentTab]?.clear();
      tabStacks[currentTab]?.push(rootWidgets[currentTab]);
    }
    onWidgetChangedListener.value = Random().nextInt(100);
  }

  Future<bool> pop() {
    if (tabStacks[currentTab]!.isFirstItem) {
      tabsStack.removeLast();
      if (tabsStack.isEmpty) {
        return Future.value(true);
      } else {
        currentTab = tabsStack.last;
        onWidgetChangedListener.value = Random().nextInt(100);
      }
    } else {
      tabStacks[currentTab]!.pop();
      onWidgetChangedListener.value = Random().nextInt(100);
    }
    return Future.value(false);
  }

  pushWidget(widget) {
    tabStacks[currentTab]?.push(widget);
    onWidgetChangedListener.value = Random().nextInt(100);
  }

  replaceCurrentWidget(widget) {
    tabStacks[currentTab]?.pop();
    tabStacks[currentTab]?.push(widget);
    onWidgetChangedListener.value = Random().nextInt(100);
  }

  moveToNext() {
    if (rootWidgets.length -1 > currentTab) {
      switchTab((currentTab + 1));
      onWidgetChangedListener.value = Random().nextInt(100);
    }
  }

  Widget getCurrentWidget() {
    return tabStacks[currentTab]?.peek() ?? Container();
  }
}
