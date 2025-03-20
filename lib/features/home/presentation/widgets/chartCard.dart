import 'package:flutter/material.dart';

class ChartCard extends StatefulWidget {
  const ChartCard({Key? key}) : super(key: key);

  @override
  _ChartCard createState() => _ChartCard();
}

class _ChartCard extends State<ChartCard> {
  bool isLineal = true; // 🔹 Variable para manejar la pestaña activa

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📌 Título y pestañas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Mi INR",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                // 🔹 Botones de pestañas (Lineal / Barras)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      _buildTabButton(
                        "Lineal",
                        isActive: isLineal,
                        onTap: () {
                          setState(() {
                            isLineal = true;
                          });
                        },
                      ),
                      _buildTabButton(
                        "Barras",
                        isActive: !isLineal,
                        onTap: () {
                          setState(() {
                            isLineal = false;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // 📌 Gráfico simulado
            Container(
              height: 130,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  isLineal ? "Gráfico Lineal" : "Gráfico de Barras",
                  style: const TextStyle(fontSize: 9, color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 📌 Función para los botones de pestañas (Lineal / Barras)
  Widget _buildTabButton(
    String text, {
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap, // 🔹 Hacemos que el botón sea interactivo
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.bold,
            color: isActive ? Colors.blue : Colors.black54,
          ),
        ),
      ),
    );
  }
}
