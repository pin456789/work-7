import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../models/cold_container.dart';

class FormTab extends StatefulWidget {
  final void Function(ColdContainer) onAdd;
  const FormTab({super.key, required this.onAdd});

  @override
  State<FormTab> createState() => _FormTabState();
}

class _FormTabState extends State<FormTab>
    with AutomaticKeepAliveClientMixin {
  final _formKey = GlobalKey<FormState>();
  final _idCtrl = TextEditingController();
  final _typeCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _tempCtrl = TextEditingController();
  final _hoursCtrl = TextEditingController();

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _idCtrl.dispose();
    _typeCtrl.dispose();
    _emailCtrl.dispose();
    _tempCtrl.dispose();
    _hoursCtrl.dispose();
    super.dispose();
  }

  String? _required(String? v, String label) =>
      (v == null || v.trim().isEmpty) ? 'กรุณากรอก$label' : null;

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'กรุณากรอกอีเมลเจ้าหน้าที่ QA';
    final ok = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[A-Za-z]{2,}$').hasMatch(v.trim());
    return ok ? null : 'รูปแบบอีเมลไม่ถูกต้อง';
  }

  String? _validateTemp(String? v) {
    if (v == null || v.trim().isEmpty) return 'กรุณากรอกขีดจำกัดอุณหภูมิ';
    return double.tryParse(v.trim()) == null ? 'กรอกได้เฉพาะตัวเลข' : null;
  }

  String? _validateHours(String? v) {
    if (v == null || v.trim().isEmpty) return 'กรุณากรอกระยะเวลาขนส่งคงเหลือ';
    return int.tryParse(v.trim()) == null ? 'กรอกได้เฉพาะตัวเลข' : null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    widget.onAdd(ColdContainer(
      unitId: _idCtrl.text.trim(),
      productType: _typeCtrl.text.trim(),
      qaEmail: _emailCtrl.text.trim(),
      tempLimit: double.parse(_tempCtrl.text.trim()),
      transitHours: int.parse(_hoursCtrl.text.trim()),
    ));
    _formKey.currentState!.reset();
    for (final c in [_idCtrl, _typeCtrl, _emailCtrl, _tempCtrl, _hoursCtrl]) {
      c.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _idCtrl,
              decoration: const InputDecoration(
                labelText: 'รหัสตู้สินค้า (Container Unit ID)',
                hintText: 'เช่น COLD-TH-9941',
                prefixIcon: Icon(Icons.inventory_2),
                border: OutlineInputBorder(),
              ),
              validator: (v) => _required(v, 'รหัสตู้สินค้า'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _typeCtrl,
              decoration: const InputDecoration(
                labelText: 'ประเภทสินค้า (Product Type)',
                hintText: 'เช่น mRNA Vaccine, Plasma',
                prefixIcon: Icon(Icons.vaccines),
                border: OutlineInputBorder(),
              ),
              validator: (v) => _required(v, 'ประเภทสินค้า'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'อีเมลเจ้าหน้าที่ QA (QA Officer)',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
              validator: _validateEmail,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _tempCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true, signed: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.\-]')),
              ],
              decoration: const InputDecoration(
                labelText: 'ขีดจำกัดอุณหภูมิสูงสุด (Upper Temp Limit °C)',
                prefixIcon: Icon(Icons.thermostat),
                border: OutlineInputBorder(),
              ),
              validator: _validateTemp,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _hoursCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: 'ระยะเวลาขนส่งคงเหลือ (Remaining Transit Hours)',
                prefixIcon: Icon(Icons.schedule),
                border: OutlineInputBorder(),
              ),
              validator: _validateHours,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.save),
                label: const Text('บันทึก'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
