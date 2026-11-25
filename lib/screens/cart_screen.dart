
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../models/book.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  String formatRupiah(double price) {
    final number = price.toStringAsFixed(0);
    final formatted = number.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );
    return 'Rp $formatted';
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Keranjang Belanja',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: cart.items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 85,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Keranjang masih kosong',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('Yuk, pilih buku favoritmu!'),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Jelajahi Buku'),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: cart.items.entries.map((entry) {
                      final Book book = entry.key;
                      final int quantity = entry.value;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: SizedBox(
                                  width: 70,
                                  height: 95,
                                  child: book.imageAsset != null
                                      ? Image.asset(
                                          book.imageAsset!,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) {
                                            return _placeholder();
                                          },
                                        )
                                      : book.imageUrl != null
                                          ? Image.network(
                                              book.imageUrl!,
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) {
                                                return _placeholder();
                                              },
                                            )
                                          : _placeholder(),
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      book.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),

                                    const SizedBox(height: 5),

                                    Text(
                                      formatRupiah(book.price),
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 8),

                                    Row(
                                      children: [
                                        _quantityButton(
                                          icon: Icons.remove,
                                          onPressed: () {
                                            context
                                                .read<CartProvider>()
                                                .removeItem(book);
                                          },
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                          ),
                                          child: Text(
                                            '$quantity',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),

                                        _quantityButton(
                                          icon: Icons.add,
                                          onPressed: () {
                                            context
                                                .read<CartProvider>()
                                                .addItem(book);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              IconButton(
                                tooltip: 'Hapus buku',
                                onPressed: () {
                                  context
                                      .read<CartProvider>()
                                      .removeItem(book);

                                  // Hapus seluruh jumlah buku
                                  while (context
                                      .read<CartProvider>()
                                      .items
                                      .containsKey(book)) {
                                    context
                                        .read<CartProvider>()
                                        .removeItem(book);
                                  }
                                },
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // RINGKASAN PEMBAYARAN
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(22),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 12,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total Item'),
                          Text(
                            '${cart.totalItems} Buku',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Pembayaran',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            formatRupiah(cart.totalPrice),
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: FilledButton.icon(
                          onPressed: () {
                            final total = cart.totalPrice;

                            if (total <= 0) return;

                            context.read<CartProvider>().clearCart();

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Checkout berhasil! Total: ${formatRupiah(total)}',
                                ),
                                backgroundColor: Colors.green,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          icon: const Icon(Icons.payment),
                          label: const Text(
                            'Checkout / Bayar',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: const Color(0xFFE5EDE7),
      child: const Center(
        child: Icon(
          Icons.menu_book_rounded,
          color: Color(0xFF245C46),
          size: 35,
        ),
      ),
    );
  }

  Widget _quantityButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 29,
        height: 29,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }
}
