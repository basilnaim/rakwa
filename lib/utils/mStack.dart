import 'dart:collection';

class MyStack<T> {
  final _stack = Queue<T>();

  bool elementExist(T element) {
    return _stack.any((e) => e.toString()[0] == element.toString()[0]);
  }

  void push(T element) {
    _stack.addLast(element);
  }


  T peek() => _stack.last;

  T pop() {
    final T lastElement = _stack.last;
    _stack.removeLast();
    return lastElement;
  }

  void clear() {
    _stack.clear();
  }

  bool get isEmpty => _stack.isEmpty;

  bool get isFirstItem => _stack.length == 1;

}
