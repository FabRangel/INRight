import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inright/services/home/inr.service.dart';

final _inrService = InrService();

class AddInrForm extends StatefulWidget {
  final Map<String, dynamic>? existingData;
  const AddInrForm({Key? key, this.existingData}) : super(key: key);

  @override
  State<AddInrForm> createState() => _AddInrFormState();
}

class _AddInrFormState extends State<AddInrForm> {
  // final TextEditingController _inrController = TextEditingController();
  late final TextEditingController _inrController;
  @override
  void initState() {
    super.initState();
    _inrController = TextEditingController(
      text: widget.existingData?['value']?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _inrController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final valor = double.tryParse(_inrController.text.trim());

    if (valor != null) {
      final uid = FirebaseAuth.instance.currentUser?.uid;

      await _inrService.saveInr(valor);

      // Limpiar campo de texto
      _inrController.clear();

      // Cerrar modal y recargar desde Page2
      Navigator.of(context).pop("guardado");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor ingresa un número válido")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -3),
          ),
        ],
      ),
      height: MediaQuery.of(context).size.height * 0.5,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.2,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              'Nuevo Registro de INR',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 40, 68, 85),
              ),
            ),
          ),
          const SizedBox(height: 30),
          TextField(
            controller: _inrController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
            decoration: InputDecoration(
              labelText: 'Valor de INR',
              prefixIcon: const Icon(Icons.bloodtype),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _handleSave,
                  icon: const Icon(Icons.save),
                  label: const Text('Guardar'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    iconColor: Colors.white,
                    backgroundColor: const Color.fromARGB(255, 98, 191, 228),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
