import 'package:flutter/material.dart';
import 'package:inright/services/configurations/profile_config.service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileConfigProvider with ChangeNotifier {
  // Singleton pattern para la service
  final _profileService = ProfileConfigService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _currentUserId;

  double _peso = 60;
  double _altura = 165;
  String _grupoSanguineo = "A+";
  List<String> _condicionesMedicas = ["Fibrilación auricular"];
  bool _isLoading = false;

  // Getters
  double get peso => _peso;
  double get altura => _altura;
  String get grupoSanguineo => _grupoSanguineo;
  List<String> get condicionesMedicas => _condicionesMedicas;
  bool get isLoading => _isLoading;

  ProfileConfigProvider() {
    // Escuchar cambios en la autenticación
    _auth.authStateChanges().listen((User? user) {
      if (user != null && user.uid != _currentUserId) {
        _currentUserId = user.uid;
        loadProfileConfig();
      } else if (user == null) {
        _currentUserId = null;
        _resetToDefaults();
      }
    });

    // Cargar la configuración inicial si ya hay usuario autenticado
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      _currentUserId = currentUser.uid;
      loadProfileConfig();
    }
  }

  void _resetToDefaults() {
    _peso = 60;
    _altura = 165;
    _grupoSanguineo = "A+";
    _condicionesMedicas = ["Fibrilación auricular"];
    notifyListeners();
  }

  // Setters with notifications
  void setPeso(double value) {
    _peso = value;
    notifyListeners();
  }

  void setAltura(double value) {
    _altura = value;
    notifyListeners();
  }

  void setGrupoSanguineo(String value) {
    _grupoSanguineo = value;
    notifyListeners();
  }

  void addCondicionMedica(String condicion) {
    _condicionesMedicas.add(condicion);
    notifyListeners();
  }

  void removeCondicionMedica(String condicion) {
    _condicionesMedicas.remove(condicion);
    notifyListeners();
  }

  Map<String, dynamic> getAllProfileData() {
    return {
      'peso': _peso.toString(),
      'altura': _altura.toString(),
      'grupoSanguineo': _grupoSanguineo,
      'condicionesMedicas': _condicionesMedicas,
    };
  }

  Future<void> saveProfileConfig() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _profileService.saveProfileConfig(getAllProfileData());
    } catch (e) {
      print("Error guardando configuración de perfil: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadProfileConfig() async {
    if (_auth.currentUser == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final config = await _profileService.getProfileConfig();

      if (config != null) {
        _peso = double.tryParse(config['peso'] ?? "60") ?? 60;
        _altura = double.tryParse(config['altura'] ?? "165") ?? 165;
        _grupoSanguineo = config['grupoSanguineo'] ?? "A+";

        if (config['condicionesMedicas'] != null) {
          _condicionesMedicas = List<String>.from(config['condicionesMedicas']);
        }
      }
    } catch (e) {
      print("🔥 Error cargando configuración de perfil: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> forceRefresh() async {
    if (_auth.currentUser != null && _currentUserId == _auth.currentUser!.uid) {
      await loadProfileConfig();
    }
  }

  void clearProfileConfig() {
  _resetToDefaults();
}
}
