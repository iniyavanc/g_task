import 'package:flutter/material.dart';
import 'package:g_task/features/products/presentation/screens/product_crud.dart';
import 'package:g_task/features/products/presentation/screens/product_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [ProductList(), ProductCrud()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Product'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Product crud'),
        ],
      ),
    );
  }
}
