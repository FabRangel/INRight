import 'package:flutter/material.dart';
import 'package:inright/services/home/inr.service.dart';

enum ModoInr { semanal, mensual }

class InrProvider extends ChangeNotifier {
  final InrService _inrService = InrService();
  List<double> get inrValores => _inrValores;
  List<double> _inrValores = [];

  bool _loading = false;
  bool get loading => _loading;

  List<Map<String, dynamic>> _inrDatos = [];
  List<Map<String, dynamic>> get inrDatos => _inrDatos;

  Future<void> fetchInr() async {
  _loading = true;
  notifyListeners();

  final data = await _inrService.getInrHistory();

  // 🛠 Añadir el campo 'tipo': 'inr' a cada entrada
  _inrDatos = data.map((e) => {
    ...e,
    'tipo': 'inr',
    'valor': e['value'],
    'fecha': e['date'],
    'hora': e['time'],
  }).toList();

  _inrValores = _inrDatos
      .where((e) => e['valor'] != null)
      .map((e) => (e['valor'] as num).toDouble())
      .toList();

  _loading = false;
  notifyListeners();
}

  ModoInr _modo = ModoInr.semanal;
  ModoInr get modo => _modo;

  void setModo(ModoInr nuevoModo) {
    _modo = nuevoModo;
    notifyListeners();
  }

  // Filtra los datos según el modo
  List<Map<String, dynamic>> get inrFiltrado {
    final cantidad = _modo == ModoInr.semanal ? 7 : 31;

    return _inrDatos.take(cantidad).toList().reversed.toList(); // SIN padding
  }

  double get promedio {
    final datos = inrFiltrado.where((e) => e['value'] != null).toList();
    if (datos.isEmpty) return 0.0;

    final valores = datos.map((e) => (e['value'] as num).toDouble());
    return valores.reduce((a, b) => a + b) / valores.length;
  }
}
