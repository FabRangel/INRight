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
  final _decimalRegex = RegExp(r'^\d*\.?\d*$');
  TimeOfDay _notificationTime = TimeOfDay.now();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Actualizar el estado
    });
  }

  void _showTopSnackBar(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 20,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 247, 249),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Fondo con gradiente
            Container(
              width: double.infinity,
              height: screenHeight * 0.4, // Altura del fondo
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
            ),

            // Contenido principal
            Column(
              children: [
                // AppBarNotifications
                Padding(
                  padding: EdgeInsets.only(
                    top: topPadding,
                    left: screenWidth * 0.05,
                    right: screenWidth * 0.05,
                  ),
                  child: AppBarNotifications(
                    onItemTapped: _onItemTapped, // Pasar el callback
                  ),
                ),

                // Espacio entre AppBarNotifications y el contenido dinámico
                SizedBox(height: screenHeight * 0.05),

                // Contenido dinámico
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: _buildContent(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Método para construir el contenido dinámico
  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return const PacientCardWidget();
      case 1:
        return Column(
          children: [
            const TargetRangeWidget(),
            const SizedBox(height: 20),
            const MedicationTimeWidget(),
            const SizedBox(height: 20),
            const RangeInr(),
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
                  _buildSwitch("Alertas de INR", "Notificaciones cuando los valores están fuera de rango", _alertaInr, (val) {
                    setState(() => _alertaInr = val);
                  }),
                  _buildSwitch("Recordatorios de medicación", "Avisos para tomar tu medicación", _recordatorioMed, (val) {
                    setState(() => _recordatorioMed = val);
                  }),
                  _buildSwitch("Valores críticos", "Alertas inmediatas para valores peligrosos", _valoresCriticos, (val) {
                    setState(() => _valoresCriticos = val);
                  }),
                ],
              ),
              const SizedBox(height: 16),
              _buildCard(
                title: "Método de notificación",
                children: [
                  _buildSwitch("Notificaciones push", "Alertas en tu dispositivo", _push, (val) {
                    setState(() => _push = val);
                  }),
                  _buildSwitch("Correo electrónico", "Recibe alertas por email", _email, (val) {
                    setState(() => _email = val);
                  }),
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
                              const Text("Hora de notificaciones", style: TextStyle(fontSize: 16)),
                              Text("Seleccionada: ${_notificationTime.format(context)}",
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
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
                  _buildSwitch("Sonido de alerta", "Activar sonido en notificaciones", _sonido, (val) {
                    setState(() => _sonido = val);
                  }),
                  _buildSwitch("Vibración", "Activar vibración en notificaciones", _vibracion, (val) {
                    setState(() => _vibracion = val);
                  }),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final config = {
                    "alertasINR": _alertaInr,
                    "recordatoriosMed": _recordatorioMed,
                    "valoresCriticos": _valoresCriticos,
                    "notificacionesPush": _push,
                    "correoElectronico": _email,
                    "sonido": _sonido,
                    "vibracion": _vibracion,
                    "horaNotificacion": _notificationTime.format(context),
                  };

                  print("🧾 Configuración guardada: ${config}");

                  _showTopSnackBar(context, "🎉 ¡Felicidades! Se guardaron tus configuraciones");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF78C8C9),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Guardar configuración"),
              ),
            ],
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildCard({required String title, required List<Widget> children}) {
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
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitch(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
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
}
