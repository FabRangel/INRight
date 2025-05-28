import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inright/services/configurations/medication_config.service.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

class DosisHistorialItem {
  final String estado;
  final String dosis;
  final String hora;
  final String fecha;

  DosisHistorialItem({
    required this.estado,
    required this.dosis,
    required this.hora,
    required this.fecha,
  });
}

class DosisDiaria {
  final DateTime fecha;
  final double dosis;
  final String hora;
  final String diaSemana;
  bool tomada;
  String estado;
  DateTime? horaToma;

  DosisDiaria({
    required this.fecha,
    required this.dosis,
    required this.hora,
    required this.diaSemana,
    this.tomada = false,
    this.estado = 'pendiente',
    this.horaToma,
  });
}

class MedicationConfigProvider extends ChangeNotifier {
  // Valores predeterminados
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

  List<MedicationSchema> _esquemas = [
    MedicationSchema(
      dosis: 5.0,
      dias: ["lunes", "miércoles", "viernes"],
      hora: "09:00",
    ),
  ];

  final List<DosisHistorialItem> _historial = [];
  List<DosisHistorialItem> get historial => _historial;

  RangeValues _inrRange = const RangeValues(2.0, 3.0);
  String get anticoagulante => _anticoagulante;
  double get dosis => _dosis;
  List<String> get anticoagulantesDisponibles => _anticoagulantesDisponibles;
  List<MedicationSchema> get esquemas => _esquemas;
  RangeValues get inrRange => _inrRange;

  final List<DosisDiaria> _dosisGeneradas = [];
  List<DosisDiaria> get dosisGeneradas => _dosisGeneradas;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final MedicationConfigService _medicationService = MedicationConfigService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _currentUserId;

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
      notifyListeners();
    }
  }

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

  void updateInrRange(RangeValues range) {
    _inrRange = range;
    notifyListeners();
  }

  Map<String, dynamic> getAllConfigData() {
    return {
      'anticoagulante': _anticoagulante,
      'dosis': _dosis,
      'esquemas': _esquemas.map((e) => e.toMap()).toList(),
      'inrRange': {'start': _inrRange.start, 'end': _inrRange.end},
    };
  }

  void registrarDosis({
    required double dosis,
    required String hora,
    required String estado,
  }) {
    final fechaHoy = DateTime.now();
    final formato = DateFormat("d MMM", "es");
    final fechaTexto = formato.format(fechaHoy);

    _historial.insert(
      0,
      DosisHistorialItem(
        estado: estado,
        dosis: '${dosis.toStringAsFixed(1)} mg',
        hora: hora,
        fecha: fechaTexto,
      ),
    );

    notifyListeners();
  }

  void limpiarHistorial() {
    _historial.clear();
    notifyListeners();
  }

  void eliminarDosisHistorial(int index) {
    if (index >= 0 && index < _historial.length) {
      _historial.removeAt(index);
      notifyListeners();
    }
  }

  void generarDosisSegunEsquema({bool silent = false}) {
    final hoy = DateTime.now();
    _dosisGeneradas.clear();

    for (int i = 0; i < 3; i++) {
      final fecha = hoy.subtract(Duration(days: i));
      final diaNombre = _nombreDiaSemana(fecha.weekday);

      for (var esquema in _esquemas) {
        if (esquema.dias.contains(diaNombre)) {
          _dosisGeneradas.add(
            DosisDiaria(
              fecha: fecha,
              dosis: esquema.dosis,
              hora: esquema.hora,
              diaSemana: diaNombre,
            ),
          );
        }
      }
    }

    _dosisGeneradas.sort((a, b) => b.fecha.compareTo(a.fecha));
    if (!silent) notifyListeners();
  }

  String _nombreDiaSemana(int weekday) {
    const dias = [
      "lunes",
      "martes",
      "miércoles",
      "jueves",
      "viernes",
      "sábado",
      "domingo",
    ];
    return dias[weekday - 1];
  }

  void confirmarTomaDelDia() {
    final hoy = DateTime.now();

    for (var item in _dosisGeneradas) {
      if (_esMismoDia(item.fecha, hoy) && !item.tomada) {
        item.tomada = true;
        item.horaToma = DateTime.now();

        final ahora = TimeOfDay.now();
        final horaProgramada = _parseHora(item.hora);
        final minutosDiferencia = _diferenciaEnMinutos(ahora, horaProgramada);

        item.estado =
            minutosDiferencia.abs() <= 30
                ? 'ok'
                : minutosDiferencia > 30
                ? 'falta'
                : 'tarde';

        notifyListeners();
        return;
      }
    }
  }

  TimeOfDay _parseHora(String hhmm) {
    final partes = hhmm.split(':');
    return TimeOfDay(hour: int.parse(partes[0]), minute: int.parse(partes[1]));
  }

  int _diferenciaEnMinutos(TimeOfDay a, TimeOfDay b) {
    return (a.hour * 60 + a.minute) - (b.hour * 60 + b.minute);
  }

  bool _esMismoDia(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void marcarFaltas() {
    final ahora = DateTime.now();
    final hoy = DateTime(ahora.year, ahora.month, ahora.day);

    for (var dosis in dosisGeneradas) {
      final fechaDosis = DateTime(
        dosis.fecha.year,
        dosis.fecha.month,
        dosis.fecha.day,
      );

      if (!dosis.tomada && fechaDosis.isBefore(hoy)) {
        dosis.estado = 'falta'; // ¡Aquí se marca correctamente!
      } else if (!dosis.tomada && fechaDosis.isAtSameMomentAs(hoy)) {
        dosis.estado = 'pendiente';
      }
    }
    notifyListeners();
  }

  void updateEsquemas(List<MedicationSchema> esquemas) {
    _esquemas = esquemas;
    notifyListeners();
  }

  // Método para resetear a valores predeterminados
  void resetToDefaults() {
    _anticoagulante = "Sintróm";
    _dosis = 4.0;
    _esquemas = [
      MedicationSchema(
        dosis: 5.0,
        dias: ["lunes", "miércoles", "viernes"],
        hora: "09:00",
      ),
    ];
    _inrRange = const RangeValues(2.0, 3.0);

    notifyListeners();
  }

  MedicationConfigProvider() {
    // Escuchar cambios en la autenticación
    _auth.authStateChanges().listen((User? user) {
      if (user != null && user.uid != _currentUserId) {
        _currentUserId = user.uid;
        loadMedicationConfig();
      } else if (user == null) {
        _currentUserId = null;
        resetToDefaults();
      }
    });

    // Cargar la configuración inicial si ya hay usuario autenticado
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      _currentUserId = currentUser.uid;
      loadMedicationConfig();
    }
  }

  Future<void> loadMedicationConfig() async {
    if (_auth.currentUser == null) {
      return;
    }
    _isLoading = true;
    notifyListeners();

    try {
      await _medicationService.loadMedicationConfig(this);
    } catch (e) {
      print("🔥 Error cargando configuración de medicación: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveMedicationConfig() async {
    if (_auth.currentUser == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      await _medicationService.saveMedicationConfig(getAllConfigData());
    } catch (e) {
      print("Error guardando configuración de medicación: $e");
      throw e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Método para forzar la actualización de los datos
  Future<void> forceRefresh() async {
    if (_auth.currentUser != null && _currentUserId == _auth.currentUser!.uid) {
      await loadMedicationConfig();
    }
  }
}
