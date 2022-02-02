import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;
  final int store_id;

  CartItem({
     required this.id,
    required this.title,
     required this.quantity,
    required this.price,
    required this.store_id,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(String productId, double price, String title, int store_id) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
            (existingValue) => CartItem(
          id: existingValue.id,
          title: existingValue.title,
          price: existingValue.price,
          quantity: existingValue.quantity + 1,
              store_id: existingValue.store_id   ,
        ),
      );
      print(_items);
    } else {
      _items.putIfAbsent(
        productId,
            () => CartItem(
          id: productId,
          price: price,
          title: title,
          quantity: 1,
              store_id: store_id,
        ),
      );
      print(_items);
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
            (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity - 1,
              store_id: existingCartItem.store_id,
        ),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}