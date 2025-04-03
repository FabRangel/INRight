import 'package:flutter/material.dart';

class MedicationTimeWidget extends StatelessWidget {
  const MedicationTimeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Text(
                "Horario de medicación",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add, size: 25),
                color: Colors.black87,
                onPressed: () {
                  // Acción para editar
                },
              ),
            ],
          ),
          const SizedBox(height: 15),
          _buildMedicationItem(
            context: context,
            time: "09:00",
            dosage: "4mg",
            onEdit: () {
              // Acción para editar
            },
            onDelete: () {
              // Acción para eliminar
            },
          ),

          const SizedBox(height: 15),

          // Segundo horario (ejemplo)
          _buildMedicationItem(
            context: context,
            time: "14:00",
            dosage: "2mg",
            onEdit: () {
              // Acción para editar
            },
            onDelete: () {
              // Acción para eliminar
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMedicationItem({
    required BuildContext context,
    required String time,
    required String dosage,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.07,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Icono de reloj y hora
            Row(
              children: [
                const Icon(Icons.access_time),
                const SizedBox(width: 10),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            // Dosis
            Text(
              dosage,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),

            // Botones de acción
            Row(
              children: [
                // Botón de editar
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  onPressed: onEdit,
                ),

                CircleAvatar(
                  backgroundColor: Color.fromARGB(222, 214, 88, 88),
                  radius: 14,
                  child: IconButton(
                    icon: const Icon(Icons.close, size: 16),
                    color: Colors.white,
                    padding: EdgeInsets.zero,
                    onPressed: onDelete,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
