import 'package:flutter/material.dart';
import 'package:inright/services/home/inr_service.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class AddInrValuePage extends StatefulWidget {
  const AddInrValuePage({Key? key}) : super(key: key);

  @override
  _AddInrValuePageState createState() => _AddInrValuePageState();
}

class _AddInrValuePageState extends State<AddInrValuePage> {
  final TextEditingController _inrController = TextEditingController();
  final InrService _inrService = InrService();
  bool _isLoading = false;
  Map<String, double> _inrRange = {'min': 2.0, 'max': 3.5};

  @override
  void initState() {
    super.initState();
    _loadInrRange();
  }

  Future<void> _loadInrRange() async {
    try {
      final range = await _inrService.getCurrentInrRange();
      setState(() {
        _inrRange = range;
      });
    } catch (e) {
      // En caso de error, mantener los valores predeterminados
      debugPrint('Error al cargar el rango de INR: $e');
    }
  }

  void _showSnackBar(String title, String message, ContentType type) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: type,
        inMaterialBanner: true,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  Future<void> _saveInrValue() async {
    if (_inrController.text.isEmpty) {
      _showSnackBar(
        'Datos incompletos',
        'Por favor ingresa un valor de INR',
        ContentType.warning,
      );
      return;
    }

    try {
      final inrValue = double.parse(_inrController.text);

      if (inrValue <= 0 || inrValue > 10) {
        _showSnackBar(
          'Valor inválido',
          'El valor de INR debe estar entre 0.1 y 10.0',
          ContentType.warning,
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      // Guardar el valor y verificar rango en un solo paso
      await _inrService.saveInrValue(context, inrValue);

      setState(() {
        _isLoading = false;
      });

      _showSnackBar(
        '¡Guardado con éxito!',
        'Tu valor de INR ha sido registrado correctamente',
        ContentType.success,
      );

      // Si el valor está fuera de rango, no necesitamos mostrar otro mensaje
      // ya que la notificación se enviará automáticamente si las alertas están activadas

      _inrController.clear();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      _showSnackBar(
        'Error',
        'No se pudo guardar el valor: $e',
        ContentType.failure,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo valor de INR')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Tu rango objetivo de INR: ${_inrRange['min']?.toStringAsFixed(1)} - ${_inrRange['max']?.toStringAsFixed(1)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _inrController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Valor de INR',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveInrValue,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 114, 193, 224),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child:
                  _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                        'Guardar',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
