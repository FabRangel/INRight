import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:inright/features/home/presentation/widgets/appBarNotifications.dart';
import 'package:inright/features/home/presentation/widgets/medicationHourConfiguration.dart';
import 'package:provider/provider.dart';
import 'package:inright/features/configurations/providers/medication_config_provider.dart';
import 'package:inright/features/configurations/providers/profile_config_provider.dart';
import 'package:inright/features/configurations/providers/notification_config_provider.dart';
import 'package:inright/services/configurations/medication_config.service.dart';

import 'package:inright/services/home/user.service.dart';
import 'package:inright/features/home/providers/user_provider.dart';

class Configurations extends StatefulWidget {
  const Configurations({super.key});

  @override
  _ConfigurationsState createState() => _ConfigurationsState();
}

class _ConfigurationsState extends State<Configurations> {
  int _selectedIndex = 0;
  final _condicionController = TextEditingController();
  final _decimalRegex = RegExp(r'^\d*\.?\d*$');
  bool _modoEdicionAnticoagulante = false;
  final UserService _userService = UserService();
  final _medicationConfigService = MedicationConfigService();

  String _userName = 'Usuario';
  bool _isLoading = true;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Actualizar el estado
    });
  }

  void _showTopSnackBar(
    BuildContext context,
    String title,
    String message,
    ContentType type,
    Color color,
  ) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: type,
        color: color,
        inMaterialBanner: true,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userInfo = await _userService.getUserInfo();
      if (mounted) {
        setState(() {
          _userName = userInfo['name'] as String;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _userName = 'Usuario';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 247, 249),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 191, 232, 238),
                  Color.fromARGB(255, 98, 191, 228),
                  Color.fromARGB(255, 114, 193, 224),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 16,
              bottom: 20,
              left: screenWidth * 0.05,
              right: screenWidth * 0.05,
            ),
            child: AppBarNotifications(onItemTapped: _onItemTapped),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                top: 24,
                left: screenWidth * 0.05,
                right: screenWidth * 0.05,
              ),
              child: _buildContent(),
            ),
          ),
        ],
      ),
    );
  }

  // Método para construir el contenido dinámico
  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return Consumer<ProfileConfigProvider>(
          builder: (context, profileProvider, child) {
            return Container(
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Profile section with UserProvider
                  Row(
                    children: [
                      Stack(
                        children: [
                          const CircleAvatar(
                            radius: 40,
                            backgroundImage: AssetImage(
                              "assets/images/persona.jpg",
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              padding: const EdgeInsets.all(4),
                              child: const Icon(Icons.camera_alt, size: 16),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Consumer<UserProvider>(
                          builder: (context, userProvider, child) {
                            if (userProvider.isLoading) {
                              return const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 20,
                                    width: 120,
                                    child: LinearProgressIndicator(
                                      backgroundColor: Colors.white30,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  SizedBox(
                                    height: 14,
                                    width: 150,
                                    child: LinearProgressIndicator(
                                      backgroundColor: Colors.white30,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              );
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userProvider.userName,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  userProvider.userEmail,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Peso y condiciones médicas
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Peso (kg)",
                              style: TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: "Peso (kg)",
                                border: OutlineInputBorder(),
                              ),
                              controller: TextEditingController(
                                text: profileProvider.peso.toStringAsFixed(0),
                              ),
                              onChanged: (val) {
                                profileProvider.setPeso(
                                  double.tryParse(val) ?? profileProvider.peso,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Condiciones médicas",
                              style: TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              children: [
                                for (var condition
                                    in profileProvider.condicionesMedicas)
                                  Chip(
                                    label: Text(
                                      condition,
                                      style: const TextStyle(
                                        color: Colors.blue,
                                      ),
                                    ),
                                    onDeleted: () {
                                      profileProvider.removeCondicionMedica(
                                        condition,
                                      );
                                    },
                                  ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _condicionController,
                                    decoration: const InputDecoration(
                                      hintText: "+ Añadir condición",
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 8,
                                        horizontal: 12,
                                      ),
                                      fillColor: Colors.white,
                                      filled: true,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    final val = _condicionController.text;
                                    if (val.isNotEmpty) {
                                      profileProvider.addCondicionMedica(val);
                                      _condicionController.clear();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                      255,
                                      114,
                                      193,
                                      224,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    "Añadir",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Altura y grupo sanguíneo
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Altura (cm)",
                              style: TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: "Altura (cm)",
                                border: OutlineInputBorder(),
                              ),
                              controller: TextEditingController(
                                text: profileProvider.altura.toStringAsFixed(0),
                              ),
                              onChanged: (val) {
                                profileProvider.setAltura(
                                  double.tryParse(val) ??
                                      profileProvider.altura,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Grupo sanguíneo",
                              style: TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              value: profileProvider.grupoSanguineo,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: "A+",
                                  child: Text("A+"),
                                ),
                                DropdownMenuItem(
                                  value: "A-",
                                  child: Text("A-"),
                                ),
                                DropdownMenuItem(
                                  value: "B+",
                                  child: Text("B+"),
                                ),
                                DropdownMenuItem(
                                  value: "B-",
                                  child: Text("B-"),
                                ),
                                DropdownMenuItem(
                                  value: "AB+",
                                  child: Text("AB+"),
                                ),
                                DropdownMenuItem(
                                  value: "AB-",
                                  child: Text("AB-"),
                                ),
                                DropdownMenuItem(
                                  value: "O+",
                                  child: Text("O+"),
                                ),
                                DropdownMenuItem(
                                  value: "O-",
                                  child: Text("O-"),
                                ),
                              ],
                              onChanged: (val) {
                                if (val != null) {
                                  profileProvider.setGrupoSanguineo(val);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          profileProvider.isLoading
                              ? null
                              : () async {
                                try {
                                  await profileProvider.saveProfileConfig();
                                  if (!mounted) return;

                                  _showTopSnackBar(
                                    context,
                                    "!Éxito!",
                                    "¡Felicidades! Se han guardado los datos de perfil",
                                    ContentType.success,
                                    Colors.green,
                                  );
                                } catch (e) {
                                  _showTopSnackBar(
                                    context,
                                    "Error",
                                    "No se pudieron guardar los datos: $e",
                                    ContentType.failure,
                                    Colors.red,
                                  );
                                }
                              },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          255,
                          114,
                          193,
                          224,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child:
                          profileProvider.isLoading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text(
                                "Guardar configuración",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      case 1:
        return Consumer<MedicationConfigProvider>(
          builder: (context, medicationProvider, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildCard(
                  titleWidget: Row(
                    children: [
                      Expanded(
                        child: IgnorePointer(
                          ignoring: !_modoEdicionAnticoagulante,
                          child: DropdownButtonFormField<String>(
                            value: medicationProvider.anticoagulante,
                            onChanged: (val) {
                              medicationProvider.updateAnticoagulante(val!);
                            },
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(12),
                                ),
                                borderSide: BorderSide(
                                  color:
                                      _modoEdicionAnticoagulante
                                          ? Colors.grey
                                          : Colors.grey.shade300,
                                ),
                              ),
                            ),
                            icon: const Icon(Icons.arrow_drop_down),
                            items:
                                medicationProvider.anticoagulantesDisponibles
                                    .map(
                                      (med) => DropdownMenuItem(
                                        value: med,
                                        child: Text(med),
                                      ),
                                    )
                                    .toList(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: Icon(
                          _modoEdicionAnticoagulante ? Icons.check : Icons.edit,
                          color:
                              _modoEdicionAnticoagulante
                                  ? Colors.green
                                  : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            if (_modoEdicionAnticoagulante) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: AwesomeSnackbarContent(
                                    title: "¡Éxito!",
                                    message:
                                        "Actualizado: ${medicationProvider.anticoagulante} - ${medicationProvider.dosis.toStringAsFixed(2)} mg",
                                    color: Colors.green,
                                    contentType: ContentType.success,
                                  ),
                                  backgroundColor: Colors.transparent,
                                  duration: const Duration(seconds: 2),
                                  elevation: 0,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                            _modoEdicionAnticoagulante =
                                !_modoEdicionAnticoagulante;
                          });
                        },
                      ),
                    ],
                  ),
                  children: [
                    _modoEdicionAnticoagulante
                        ? Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () {
                                medicationProvider.decrementDosis();
                              },
                            ),
                            Text(
                              "${medicationProvider.dosis.toStringAsFixed(2)} mg",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () {
                                medicationProvider.incrementDosis();
                              },
                            ),
                          ],
                        )
                        : Text(
                          "${medicationProvider.dosis.toStringAsFixed(2)} mg",
                          style: const TextStyle(fontSize: 16),
                        ),
                  ],
                ),

                const SizedBox(height: 16),
                _buildCard(
                  title: "Esquema de medicación",
                  children: [
                    MedicationHourConfiguration(
                      esquemas:
                          medicationProvider.esquemas
                              .map((e) => e.toMap())
                              .toList(),
                      onAgregar: () {
                        medicationProvider.addEsquema();
                      },
                      onEliminar: (index) {
                        medicationProvider.removeEsquema(index);
                      },
                      onCambiarDosis: (index, nuevaDosis) {
                        medicationProvider.updateEsquemaDosis(
                          index,
                          nuevaDosis,
                        );
                      },
                      onCambiarHora: (index, nuevaHora) {
                        medicationProvider.updateEsquemaHora(index, nuevaHora);
                      },
                      onToggleDia: (index, dia) {
                        medicationProvider.toggleEsquemaDia(index, dia);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildCard(
                  title: "Rango INR objetivo",
                  children: [
                    const Text("Rango actual", style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Rango: ${medicationProvider.inrRange.start.toStringAsFixed(1)} - ${medicationProvider.inrRange.end.toStringAsFixed(1)}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        RangeSlider(
                          values: medicationProvider.inrRange,
                          min: 1.0,
                          max: 5.0,
                          divisions: 40,
                          labels: RangeLabels(
                            medicationProvider.inrRange.start.toStringAsFixed(
                              1,
                            ),
                            medicationProvider.inrRange.end.toStringAsFixed(1),
                          ),
                          onChanged: (RangeValues values) {
                            medicationProvider.updateInrRange(values);
                          },
                          activeColor: Colors.green,
                          inactiveColor: Colors.green.shade100,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildCard(
                  title: "Frecuencia de pruebas INR",
                  children: [
                    const Text("Cada cuántos días te haces una prueba de INR:"),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Slider(
                            min: 3,
                            max: 30,
                            divisions: 27,
                            value: medicationProvider.frecuenciaInr.toDouble(),
                            label: "${medicationProvider.frecuenciaInr} días",
                            onChanged: (value) {
                              medicationProvider.setFrecuenciaInr(
                                value.round(),
                              );
                            },
                          ),
                        ),
                        Text("${medicationProvider.frecuenciaInr} días"),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      final medicacionData =
                          medicationProvider.getAllConfigData();
                      await _medicationConfigService.saveMedicationConfig(
                        medicacionData,
                      );

                      if (!mounted) return;
                      _showTopSnackBar(
                        context,
                        "¡Éxito!",
                        "¡Felicidades! Se guardaron los datos de medicación",
                        ContentType.success,
                        Colors.green,
                      );
                    } catch (e) {
                      _showTopSnackBar(
                        context,
                        "Error",
                        "No se pudieron guardar los datos: $e",
                        ContentType.failure,
                        Colors.red,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 114, 193, 224),
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("Guardar configuración"),
                ),
                const SizedBox(height: 90),
              ],
            );
          },
        );
      case 2: // Notificaciones
        return Consumer<NotificationConfigProvider>(
          builder: (context, notificationProvider, child) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildCard(
                    title: "Tipos de alertas",
                    children: [
                      _buildSwitch(
                        "Alertas de INR",
                        "Notificaciones cuando los valores están fuera de rango",
                        notificationProvider.alertaInr,
                        (val) {
                          notificationProvider.setAlertaInr(val);
                        },
                      ),
                      _buildSwitch(
                        "Recordatorios de medicación",
                        "Avisos para tomar tu medicación",
                        notificationProvider.recordatorioMed,
                        (val) {
                          notificationProvider.setRecordatorioMed(val);
                        },
                      ),
                      _buildSwitch(
                        "Valores críticos",
                        "Alertas inmediatas para valores peligrosos",
                        notificationProvider.valoresCriticos,
                        (val) {
                          notificationProvider.setValoresCriticos(val);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildCard(
                    title: "Método de notificación",
                    children: [
                      _buildSwitch(
                        "Notificaciones push",
                        "Alertas en tu dispositivo",
                        notificationProvider.push,
                        (val) {
                          notificationProvider.setPush(val);
                        },
                      ),
                      _buildSwitch(
                        "Correo electrónico",
                        "Recibe alertas por email",
                        notificationProvider.email,
                        (val) {
                          notificationProvider.setEmail(val);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildCard(
                    title: "Preferencias adicionales",
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Hora de notificaciones",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    "Seleccionada: ${notificationProvider.horaNotificacion}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.access_time),
                              onPressed: () async {
                                final TimeOfDay? picked = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (picked != null) {
                                  final formattedTime =
                                      "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
                                  notificationProvider.setHoraNotificacion(
                                    formattedTime,
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      _buildSwitch(
                        "Sonido de alerta",
                        "Activar sonido en notificaciones",
                        notificationProvider.sonido,
                        (val) {
                          notificationProvider.setSonido(val);
                        },
                      ),
                      _buildSwitch(
                        "Vibración",
                        "Activar vibración en notificaciones",
                        notificationProvider.vibracion,
                        (val) {
                          notificationProvider.setVibracion(val);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 36),
                  ElevatedButton(
                    onPressed:
                        notificationProvider.isLoading
                            ? null
                            : () async {
                              try {
                                await notificationProvider
                                    .saveNotificationConfig();
                                if (!mounted) return;

                                _showTopSnackBar(
                                  context,
                                  "¡Éxito!",
                                  "¡Felicidades! Se guardaron las preferencias de notificaciones",
                                  ContentType.success,
                                  Colors.green,
                                );
                              } catch (e) {
                                _showTopSnackBar(
                                  context,
                                  "Error",
                                  "No se pudieron guardar los datos: $e",
                                  ContentType.failure,
                                  Colors.red,
                                );
                              }
                            },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 114, 193, 224),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child:
                        notificationProvider.isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text(
                              "Guardar configuración",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                  ),
                ],
              ),
            );
          },
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildCard({
    String? title,
    Widget? titleWidget,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (titleWidget != null)
            titleWidget
          else if (title != null)
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitch(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
      activeColor: const Color(0xFF65B0C6),
      activeTrackColor: const Color(0xFF65B0C6).withOpacity(0.5),
    );
  }

  Widget _buildInputField(String label, String hint, {String? suffix}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F7FA),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  hint,
                  style: const TextStyle(color: Colors.black87),
                ),
              ),
              if (suffix != null)
                Text(suffix, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMedicationTimeRow(String time, String dose) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F6FD),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.access_time, size: 20),
          const SizedBox(width: 12),
          Text(time, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 12),
          Text(dose),
          const Spacer(),
          IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.close),
            color: Colors.redAccent,
          ),
        ],
      ),
    );
  }
}
