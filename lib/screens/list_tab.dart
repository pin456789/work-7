import 'package:flutter/material.dart';
import '../../../models/cold_container.dart';

class ListTab extends StatelessWidget {
  final List<ColdContainer> items;
  final void Function(ColdContainer) onDelete;
  final VoidCallback onUpdate;

  const ListTab({
    super.key,
    required this.items,
    required this.onDelete,
    required this.onUpdate,
  });

  String _fmtTemp(double t) => t.toStringAsFixed(t % 1 == 0 ? 0 : 1);

  Future<void> _showEditDialog(BuildContext context, ColdContainer item) async {
    final hoursCtrl = TextEditingController(text: item.transitHours.toString());
    final routeCtrl =
        TextEditingController(text: item.route == '-' ? '' : item.route);
    final formKey = GlobalKey<FormState>();

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('แก้ไข ${item.unitId}'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: hoursCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'ชั่วโมงขนส่งคงเหลือ',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => int.tryParse((v ?? '').trim()) == null
                    ? 'กรอกเป็นตัวเลข'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: routeCtrl,
                decoration: const InputDecoration(
                  labelText: 'เส้นทางใหม่ (ถ้ามี)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('ยกเลิก')),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) Navigator.pop(ctx, true);
            },
            child: const Text('บันทึก'),
          ),
        ],
      ),
    );

    if (saved == true) {
      item.transitHours = int.parse(hoursCtrl.text.trim());
      final r = routeCtrl.text.trim();
      item.route = r.isEmpty ? '-' : r;
      onUpdate();
    }
  }

  Future<void> _showDeleteDialog(BuildContext context, ColdContainer item) async {
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('ยืนยันการดำเนินการ'),
        content: Text('เลือกผลการดำเนินการสำหรับตู้ ${item.unitId}'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('ยกเลิก')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'spoiled'),
            child: const Text('ตัดถ่ายของเสีย',
                style: TextStyle(color: Colors.red)),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, 'received'),
            child: const Text('รับเข้าคลังสำเร็จ'),
          ),
        ],
      ),
    );

    if (result == null) return;
    onDelete(item);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result == 'received'
            ? 'บันทึกตู้ ${item.unitId} ตรวจรับเข้าคลังสำเร็จ'
            : 'บันทึกตู้ ${item.unitId} ตัดถ่ายของเสีย'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(child: Text('ยังไม่มีตู้ที่อยู่ระหว่างขนส่ง'));
    }
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, i) {
        final item = items[i];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            leading: CircleAvatar(
              radius: 26,
              backgroundColor: Colors.lightBlue.shade100,
              child: Text('${_fmtTemp(item.tempLimit)}°C',
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold)),
            ),
            title: Text(item.unitId),
            subtitle: Text(
                '${item.productType}\nเหลือ ${item.transitHours} ชม. | เส้นทาง: ${item.route}'),
            isThreeLine: true,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.orange),
                  onPressed: () => _showEditDialog(context, item),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _showDeleteDialog(context, item),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
