import 'package:flutter/material.dart';
import 'package:flutter_application_8/screens/login_screen.dart';
import '../../../models/cold_container.dart';
import 'form_tab.dart';
import 'list_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final List<ColdContainer> _items = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _addItem(ColdContainer item) {
    setState(() => _items.add(item));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('ลงทะเบียนตู้ ${item.unitId} สำเร็จ')),
    );
    _tabController.animateTo(1);
  }

  void _removeItem(ColdContainer item) {
    setState(() => _items.remove(item));
  }

  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ColdTrack'),
        actions: [
          IconButton(
            tooltip: 'ออกจากระบบ',
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.add_box), text: 'ลงทะเบียน'),
            Tab(icon: Icon(Icons.local_shipping), text: 'ระหว่างทาง'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          FormTab(onAdd: _addItem),
          ListTab(items: _items, onDelete: _removeItem, onUpdate: _refresh),
        ],
      ),
    );
  }
}
