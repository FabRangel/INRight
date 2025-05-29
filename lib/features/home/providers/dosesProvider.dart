import 'package:flutter/material.dart';
import 'package:inright/services/home/doses.service.dart';

class DosisProvider extends ChangeNotifier {
  final DosisService _dosisService = DosisService();

  bool _loading = false;
  bool get loading => _loading;

  List<Map<String, dynamic>> _dosisDatos = [];
  List<Map<String, dynamic>> get dosisDatos => _dosisDatos;

  Future<void> fetchDosis() async {
    _loading = true;
    notifyListeners();

    final data = await _dosisService.getDosesHistory();
    _dosisDatos = data;
    _loading = false;
    notifyListeners();
  }

  List<Map<String, dynamic>> get dosisReciente {
    return _dosisDatos.reversed.toList(); // más reciente al final
  }

  double get promedioMg {
    final mgList = _dosisDatos
        .where((e) => e['dosis'] != null)
        .map((e) => (e['dosis'] as num).toDouble())
        .toList();

    if (mgList.isEmpty) return 0.0;
    return mgList.reduce((a, b) => a + b) / mgList.length;
  }
}
