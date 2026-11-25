
import 'package:flutter/material.dart';
import '../models/book.dart';

class CartProvider extends ChangeNotifier {
  final Map<Book, int> _items = {};

  Map<Book, int> get items => Map.unmodifiable(_items);

  // Menambahkan buku ke keranjang
  void addItem(Book book) {
    if (_items.containsKey(book)) {
      _items[book] = _items[book]! + 1;
    } else {
      _items[book] = 1;
    }

    notifyListeners();
  }

  // Mengurangi jumlah atau menghapus buku
  void removeItem(Book book) {
    if (!_items.containsKey(book)) return;

    if (_items[book]! > 1) {
      _items[book] = _items[book]! - 1;
    } else {
      _items.remove(book);
    }

    notifyListeners();
  }

  // Mengosongkan seluruh keranjang
  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  // Menghitung jumlah seluruh buku
  int get totalItems {
    return _items.values.fold(0, (sum, quantity) {
      return sum + quantity;
    });
  }

  // Menghitung total pembayaran
  double get totalPrice {
    return _items.entries.fold(0.0, (sum, entry) {
      return sum + (entry.key.price * entry.value);
    });
  }
}
