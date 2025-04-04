import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:inright/features/home/presentation/widgets/medicationTime.dart';
import 'package:inright/features/home/presentation/widgets/pacientCard.dart';
import 'package:inright/features/home/presentation/widgets/rangeInr.dart';
import 'package:inright/features/home/presentation/widgets/targetRange.dart';
import 'package:inright/features/home/presentation/widgets/appBarNotifications.dart';
import 'package:inright/features/home/presentation/widgets/navbar.dart';

class Configurations extends StatefulWidget {
  const Configurations({super.key});

  @override
  _ConfigurationsState createState() => _ConfigurationsState();
}

class _ConfigurationsState extends State<Configurations> {
  int _selectedIndex = 0;

  bool _alertaInr = true;
  bool _recordatorioMed = true;
  bool _valoresCriticos = true;
  bool _push = true;
  bool _email = false;
  bool _sonido = true;
  bool _vibracion = true;
  final _minController = TextEditingController();
  final _maxController = TextEditingController();
  final _condicionController = TextEditingController();
  final _decimalRegex = RegExp(r'^\d*\.?\d*$');
  TimeOfDay _notificationTime = TimeOfDay.now();
  double _peso = 60;
  double _altura = 165;
  String _grupoSanguineo = "A+";
  List<String> _condicionesMedicas = ["Fibrilación auricular"];
  RangeValues _inrRange = const RangeValues(2.0, 3.0);
  bool _modoEdicionAnticoagulante = false;
  String _anticoagulante = "Sintróm";
  double _dosis = 4;
  final List<String> _anticoagulantesDisponibles = [
    "Sintróm",
    "Warfarina",
    "Acenocumarol",
    "Dabigatrán",
    "Apixabán",
    "Rivaroxabán",
    "Edoxabán",
  ];
  List<Map<String, dynamic>> _horariosMed = [
    {"hora": "09:00", "dosis": "4 mg", "editando": false},
    {"hora": "21:00", "dosis": "4 mg", "editando": false},
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Actualizar el estado
    });
  }

  // void _showTopSnackBar(
  //   BuildContext context,
  //   String title,
  //   String message,
  //   ContentType type,
  //   Color color,
  // ) {
  //   final overlay = Overlay.of(context);
  //   final overlayEntry = OverlayEntry(
  //     builder:
  //         (context) => Positioned(
  //           top: MediaQuery.of(context).padding.bottom + 20,
  //           left: 20,
  //           right: 20,
  //           child: Material(
  //             color: color,
  //             child: AwesomeSnackbarContent(
  //               title: title,
  //               message: message,
  //               contentType: type,
  //               inMaterialBanner: true,
  //             ),
  //           ),
  //         ),
  //   );

  //   overlay.insert(overlayEntry);

  //   Future.delayed(const Duration(seconds: 3), () {
  //     overlayEntry.remove();
  //   });
  // }

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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "María García",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Maria@gmail.com",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
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
                        const Text("Peso (kg)", style: TextStyle(fontSize: 14)),
                        const SizedBox(height: 16),
                        TextField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Peso (kg)",
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (val) {
                            setState(() {
                              _peso = double.tryParse(val) ?? _peso;
                            });
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
                            for (var condition in _condicionesMedicas)
                              Chip(
                                label: Text(
                                  condition,
                                  style: const TextStyle(color: Colors.blue),
                                ),
                                onDeleted: () {
                                  setState(
                                    () => _condicionesMedicas.remove(condition),
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
                                  setState(() {
                                    _condicionesMedicas.add(val);
                                    _condicionController.clear();
                                  });
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
                              child: Text(
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
                          onChanged: (val) {
                            setState(() {
                              _altura = double.tryParse(val) ?? _altura;
                            });
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
                          value: _grupoSanguineo,
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
                            DropdownMenuItem(value: "A+", child: Text("A+")),
                            DropdownMenuItem(value: "A-", child: Text("A-")),
                            DropdownMenuItem(value: "B+", child: Text("B+")),
                            DropdownMenuItem(value: "B-", child: Text("B-")),
                            DropdownMenuItem(value: "AB+", child: Text("AB+")),
                            DropdownMenuItem(value: "AB-", child: Text("AB-")),
                            DropdownMenuItem(value: "O+", child: Text("O+")),
                            DropdownMenuItem(value: "O-", child: Text("O-")),
                          ],
                          onChanged: (val) {
                            setState(() => _grupoSanguineo = val!);
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
                  onPressed: () {
                    final perfilData = {
                      "peso": _peso.toStringAsFixed(0),
                      "altura": _altura.toStringAsFixed(0),
                      "grupoSanguineo": _grupoSanguineo,
                      "condicionesMedicas": _condicionesMedicas,
                    };

                    _showTopSnackBar(
                      context,
                      "!Éxito!",
                      "¡Felicidades! Se guardaron los datos: $perfilData",
                      ContentType.success,
                      Colors.green,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 114, 193, 224),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
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
      case 1:
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
                        value: _anticoagulante,
                        onChanged: (val) {
                          setState(() => _anticoagulante = val!);
                        },
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
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
                            _anticoagulantesDisponibles
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
                                    "Actualizado: $_anticoagulante - ${_dosis.toStringAsFixed(2)} mg",
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
                            setState(() {
                              if (_dosis > 0.25) _dosis -= 0.25;
                            });
                          },
                        ),
                        Text(
                          "${_dosis.toStringAsFixed(2)} mg",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () {
                            setState(() {
                              _dosis += 0.25;
                            });
                          },
                        ),
                      ],
                    )
                    : Text(
                      "${_dosis.toStringAsFixed(2)} mg",
                      style: const TextStyle(fontSize: 16),
                    ),
              ],
            ),

            const SizedBox(height: 16),
            _buildCard(
              title: "Horario de medicación",
              children: [
                ..._horariosMed.asMap().entries.map((entry) {
                  int index = entry.key;
                  var horario = entry.value;

                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F6FD),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.access_time, size: 20),
                            const SizedBox(width: 12),
                            Text(
                              horario["hora"],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(horario["dosis"]),
                            const Spacer(),
                            IconButton(
                              icon: Icon(
                                horario["editando"] ? Icons.check : Icons.edit,
                                color:
                                    horario["editando"]
                                        ? Colors.green
                                        : Colors.black87,
                              ),
                              onPressed: () async {
                                if (horario["editando"]) {
                                  // Guardar y salir de modo edición
                                  setState(() {
                                    _horariosMed[index]["editando"] = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: AwesomeSnackbarContent(
                                        title: "¡Éxito!",
                                        message:
                                            "Horario guardado: ${horario["hora"]} - ${horario["dosis"]}",
                                        color: Colors.green,
                                        contentType: ContentType.success,
                                      ),
                                      backgroundColor: Colors.transparent,
                                      duration: const Duration(seconds: 2),
                                      elevation: 0,
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                } else {
                                  // Elegir nueva hora
                                  final picked = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay(
                                      hour: int.parse(
                                        horario["hora"].split(":")[0],
                                      ),
                                      minute: int.parse(
                                        horario["hora"].split(":")[1],
                                      ),
                                    ),
                                  );

                                  if (picked != null) {
                                    setState(() {
                                      _horariosMed[index]["hora"] = picked
                                          .format(context);
                                      _horariosMed[index]["editando"] = true;
                                    });
                                  }
                                }
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              color: Colors.redAccent,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      backgroundColor: Colors.white,
                                      title: const Text(
                                        "Confirmar eliminación",
                                      ),
                                      content: const Text(
                                        "¿Estás segura de que deseas eliminar este horario de medicación?",
                                      ),
                                      actions: [
                                        TextButton(
                                          child: const Text(
                                            "Cancelar",
                                            style: TextStyle(
                                              color: Colors.blueAccent,
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.of(
                                              context,
                                            ).pop(); // cerrar el diálogo
                                          },
                                        ),
                                        TextButton(
                                          child: const Text(
                                            "Eliminar",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _horariosMed.removeAt(index);
                                            });
                                            Navigator.of(
                                              context,
                                            ).pop(); // cerrar el diálogo
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: AwesomeSnackbarContent(
                                                  title: "¡Éxito!",
                                                  message:
                                                      "Horario eliminado correctamente",
                                                  contentType:
                                                      ContentType.success,
                                                  color: Colors.redAccent,
                                                  inMaterialBanner: true,
                                                ),
                                                backgroundColor:
                                                    Colors.transparent,
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                elevation: 0,
                                                duration: Duration(seconds: 2),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  );
                }).toList(),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(Icons.add, color: Colors.black87),
                    onPressed: () {
                      setState(() {
                        _horariosMed.add({
                          "hora": "08:00",
                          "dosis": "4 mg",
                          "editando": false,
                        });
                      });
                    },
                  ),
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
                      "Rango: ${_inrRange.start.toStringAsFixed(1)} - ${_inrRange.end.toStringAsFixed(1)}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    RangeSlider(
                      values: _inrRange,
                      min: 1.0,
                      max: 5.0,
                      divisions: 40,
                      labels: RangeLabels(
                        _inrRange.start.toStringAsFixed(1),
                        _inrRange.end.toStringAsFixed(1),
                      ),
                      onChanged: (RangeValues values) {
                        setState(() {
                          _inrRange = values;
                        });
                      },
                      activeColor: Colors.green,
                      inactiveColor: Colors.green.shade100,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final medicacionData = {
                  "horarios": [
                    {"hora": "09:00", "dosis": "4 mg"},
                    {"hora": "21:00", "dosis": "4 mg"},
                  ],
                  "rangoINR": {
                    "min": _inrRange.start.toStringAsFixed(1),
                    "max": _inrRange.end.toStringAsFixed(1),
                  },
                };
                _showTopSnackBar(
                  context,
                  "¡Éxito!",
                  "¡Felicidades! Se guardaron los datos de medicación: $medicacionData",
                  ContentType.success,
                  Colors.green,
                );
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
      case 2: // Notificaciones
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildCard(
                title: "Tipos de alertas",
                children: [
                  _buildSwitch(
                    "Alertas de INR",
                    "Notificaciones cuando los valores están fuera de rango",
                    _alertaInr,
                    (val) {
                      setState(() => _alertaInr = val);
                    },
                  ),
                  _buildSwitch(
                    "Recordatorios de medicación",
                    "Avisos para tomar tu medicación",
                    _recordatorioMed,
                    (val) {
                      setState(() => _recordatorioMed = val);
                    },
                  ),
                  _buildSwitch(
                    "Valores críticos",
                    "Alertas inmediatas para valores peligrosos",
                    _valoresCriticos,
                    (val) {
                      setState(() => _valoresCriticos = val);
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
                    _push,
                    (val) {
                      setState(() => _push = val);
                    },
                  ),
                  _buildSwitch(
                    "Correo electrónico",
                    "Recibe alertas por email",
                    _email,
                    (val) {
                      setState(() => _email = val);
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
                                "Seleccionada: ${_notificationTime.format(context)}",
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
                              initialTime: _notificationTime,
                            );
                            if (picked != null && picked != _notificationTime) {
                              setState(() {
                                _notificationTime = picked;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  _buildSwitch(
                    "Sonido de alerta",
                    "Activar sonido en notificaciones",
                    _sonido,
                    (val) {
                      setState(() => _sonido = val);
                    },
                  ),
                  _buildSwitch(
                    "Vibración",
                    "Activar vibración en notificaciones",
                    _vibracion,
                    (val) {
                      setState(() => _vibracion = val);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final notificacionesData = {
                    "alertaINR": _alertaInr,
                    "recordatorioMed": _recordatorioMed,
                    "valoresCriticos": _valoresCriticos,
                    "notificacionesPush": _push,
                    "correoElectronico": _email,
                    "sonido": _sonido,
                    "vibracion": _vibracion,
                    "horaNotificacion": _notificationTime.format(context),
                  };

                  _showTopSnackBar(
                    context,
                    "¡Éxito!",
                    "¡Felicidades! Se guardaron los datos de notificaciones: $notificacionesData",
                    ContentType.success,
                    Colors.green,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 114, 193, 224),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
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
