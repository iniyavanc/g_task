import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:g_task/features/products/data/model/product_response.dart';
import 'package:g_task/features/products/presentation/screens/create_product.dart';
import 'package:hive/hive.dart';

class ProductCrud extends ConsumerStatefulWidget {
  const ProductCrud({super.key});

  @override
  ConsumerState<ProductCrud> createState() => _ProductCrudState();
}

class _ProductCrudState extends ConsumerState<ProductCrud> {
  List<Products> products = [];

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    final box = Hive.box('products');

    final data = box.values
        .map((e) => Products.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    setState(() {
      products = data;
    });
  }

  Future<void> deleteProduct(int index) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (result == true) {
      final box = Hive.box('products');

      await box.deleteAt(index);

      loadProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Products")),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateProduct()),
          );

          loadProducts();
        },
      ),

      body: products.isEmpty
          ? Center(child: Text("No Product Found"))
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (_, index) {
                final product = products[index];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: ListTile(
                      title: Text(product.title.toString()),
                      subtitle: Text(
                        "₹${product.price} | ${product.category} | ${product.description}",
                      ),

                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CreateProduct(
                                    product: product,
                                    hiveIndex: index,
                                  ),
                                ),
                              );

                              loadProducts();
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              deleteProduct(index);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
