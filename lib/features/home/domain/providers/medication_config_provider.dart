import 'package:flutter/material.dart';

class MedicationSchema {
  double dosis;
  List<String> dias;
  String hora;

  MedicationSchema({
    required this.dosis,
    required this.dias,
    required this.hora,
  });

  Map<String, dynamic> toMap() {
    return {'dosis': dosis, 'dias': dias, 'hora': hora};
  }

  factory MedicationSchema.fromMap(Map<String, dynamic> map) {
    return MedicationSchema(
      dosis: map['dosis'] as double,
      dias: List<String>.from(map['dias']),
      hora: map['hora'] as String,
    );
  }
}

class MedicationConfigProvider extends ChangeNotifier {
  // Anticoagulante seleccionado
  String _anticoagulante = "Sintróm";
  double _dosis = 4.0;
  final List<String> _anticoagulantesDisponibles = [
    "Sintróm",
    "Warfarina",
    "Acenocumarol",
    "Dabigatrán",
    "Apixabán",
    "Rivaroxabán",
    "Edoxabán",
  ];

  // Esquemas de medicación
  List<MedicationSchema> _esquemas = [
    MedicationSchema(
      dosis: 5.0,
      dias: ["lunes", "miércoles", "viernes"],
      hora: "09:00",
    ),
  ];

  // Rango INR
  RangeValues _inrRange = const RangeValues(2.0, 3.0);

  // Getters
  String get anticoagulante => _anticoagulante;
  double get dosis => _dosis;
  List<String> get anticoagulantesDisponibles => _anticoagulantesDisponibles;
  List<MedicationSchema> get esquemas => _esquemas;
  RangeValues get inrRange => _inrRange;

  // Métodos para actualizar valores
  void updateAnticoagulante(String value) {
    _anticoagulante = value;
    notifyListeners();
  }

  void updateDosis(double value) {
    _dosis = value;
    notifyListeners();
  }

  void incrementDosis() {
    _dosis += 0.25;
    notifyListeners();
  }

  void decrementDosis() {
    if (_dosis > 0.25) {
      _dosis -= 0.25;
    }
    notifyListeners();
  }

  // Métodos para esquemas
  void addEsquema() {
    _esquemas.add(MedicationSchema(dosis: 5.0, dias: [], hora: "09:00"));
    notifyListeners();
  }

  void removeEsquema(int index) {
    if (index >= 0 && index < _esquemas.length) {
      _esquemas.removeAt(index);
      notifyListeners();
    }
  }

  void updateEsquemaDosis(int index, double nuevaDosis) {
    if (index >= 0 && index < _esquemas.length) {
      _esquemas[index].dosis = nuevaDosis;
      notifyListeners();
    }
  }

  void updateEsquemaHora(int index, String nuevaHora) {
    if (index >= 0 && index < _esquemas.length) {
      _esquemas[index].hora = nuevaHora;
      notifyListeners();
    }
  }

  void toggleEsquemaDia(int index, String dia) {
    if (index >= 0 && index < _esquemas.length) {
      final dias = _esquemas[index].dias;
      if (dias.contains(dia)) {
        dias.remove(dia);
      } else {
        dias.add(dia);
      }
      notifyListeners();
    }
  }

  // Actualizar rango INR
  void updateInrRange(RangeValues range) {
    _inrRange = range;
    notifyListeners();
  }

  // Guardar toda la configuración
  Map<String, dynamic> getAllConfigData() {
    return {
      'anticoagulante': _anticoagulante,
      'dosis': _dosis,
      'esquemas': _esquemas.map((e) => e.toMap()).toList(),
      'inrRange': {'start': _inrRange.start, 'end': _inrRange.end},
    };
  }
}
