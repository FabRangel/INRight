import 'package:flutter/material.dart';

class MedicationHourConfiguration extends StatelessWidget {
  final List<Map<String, dynamic>> esquemas;
  final void Function() onAgregar;
  final void Function(int index) onEliminar;
  final void Function(int index, double nuevaDosis) onCambiarDosis;
  final void Function(int index, String dia) onToggleDia;
  final void Function(int index, String nuevaHora) onCambiarHora;

  const MedicationHourConfiguration({
    super.key,
    required this.esquemas,
    required this.onAgregar,
    required this.onEliminar,
    required this.onCambiarDosis,
    required this.onCambiarHora,
    required this.onToggleDia,
  });

  static const List<String> abreviaturas = ['D', 'L', 'M', 'X', 'J', 'V', 'S'];
  static const List<String> claves = [
    'domingo',
    'lunes',
    'martes',
    'miércoles',
    'jueves',
    'viernes',
    'sábado',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...esquemas.asMap().entries.map((entry) {
          final index = entry.key;
          final esquema = entry.value;
          return MedicationCard(
            index: index,
            esquema: esquema,
            onEliminar: onEliminar,
            onCambiarDosis: onCambiarDosis,
            onCambiarHora: onCambiarHora,
            onToggleDia: onToggleDia,
          );
        }),
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            onPressed: onAgregar,
            icon: const Icon(Icons.add, color: Colors.black87),
          ),
        ),
      ],
    );
  }
}

class MedicationCard extends StatefulWidget {
  final int index;
  final Map<String, dynamic> esquema;
  final void Function(int index) onEliminar;
  final void Function(int index, double nuevaDosis) onCambiarDosis;
  final void Function(int index, String nuevaHora) onCambiarHora;
  final void Function(int index, String dia) onToggleDia;

  const MedicationCard({
    super.key,
    required this.index,
    required this.esquema,
    required this.onEliminar,
    required this.onCambiarDosis,
    required this.onCambiarHora,
    required this.onToggleDia,
  });

  @override
  State<MedicationCard> createState() => _MedicationCardState();
}

class _MedicationCardState extends State<MedicationCard> {
  bool modoExpandido = false;

  static const List<String> abreviaturas = ['D', 'L', 'M', 'X', 'J', 'V', 'S'];
  static const List<String> claves = [
    'domingo',
    'lunes',
    'martes',
    'miércoles',
    'jueves',
    'viernes',
    'sábado',
  ];

  @override
  Widget build(BuildContext context) {
    final dosis = widget.esquema["dosis"];
    final dias = widget.esquema["dias"] as List<String>;
    final hora = widget.esquema["hora"];

    return Card(
      color: const Color.fromARGB(180, 98, 191, 228),
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          color: Color.fromARGB(255, 170, 172, 174),
          width: 1.5,
        ),
      ),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      child: InkWell(
        onTap: () => setState(() => modoExpandido = !modoExpandido),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child:
              modoExpandido
                  ? _buildEditableView(dosis, dias, hora)
                  : _buildCompactView(dosis, dias),
        ),
      ),
    );
  }

  Widget _buildCompactView(double dosis, List<String> dias) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${dosis.toStringAsFixed(2)} mg",
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            dias.map((d) => abreviaturas[claves.indexOf(d)]).join(", "),
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableView(double dosis, List<String> dias, String hora) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.remove_circle_outline,
                color: Color.fromARGB(255, 255, 255, 255),
                size: 35,
              ),
              onPressed:
                  () => widget.onCambiarDosis(
                    widget.index,
                    (dosis - 0.25).clamp(0.0, 100.0),
                  ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  "${dosis.toStringAsFixed(2)} mg",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.add_circle_outline,
                color: Color.fromARGB(255, 255, 255, 255),
                size: 35,
              ),
              onPressed:
                  () => widget.onCambiarDosis(
                    widget.index,
                    (dosis + 0.25).clamp(0.0, 100.0),
                  ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(7, (i) {
            final diaClave = claves[i];
            final activo = dias.contains(diaClave);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: GestureDetector(
                onTap: () => widget.onToggleDia(widget.index, diaClave),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: activo ? Colors.green : Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    abreviaturas[i],
                    style: TextStyle(
                      color: activo ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () async {
            final picked = await showTimePicker(
              context: context,
              initialTime: TimeOfDay(
                hour: int.parse(hora.split(":")[0]),
                minute: int.parse(hora.split(":")[1]),
              ),
            );
            if (picked != null) {
              widget.onCambiarHora(
                widget.index,
                "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}",
              );
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.access_time, size: 22, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    hora,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(
                  Icons.cancel_outlined,
                  color: Colors.red,
                  size: 30,
                ),
                onPressed: () => widget.onEliminar(widget.index),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
