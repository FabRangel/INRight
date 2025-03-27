import 'package:flutter/material.dart';

class TargetRangeWidget extends StatelessWidget {
  const TargetRangeWidget({super.key});

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
              const Icon(
                Icons
                    .medication_outlined, // Puedes cambiarlo por otro ícono si prefieres
                size: 50, // Tamaño grande
                color: Colors.black87,
              ),
              const SizedBox(width: 15), // Espaciado entre icono y texto
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sintrom",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    "4mg",
                    style: TextStyle(fontSize: 17, color: Colors.black87),
                  ),
                ],
              ),
              const SizedBox(width: 15),
              const Icon(
                Icons
                    .edit_outlined, // Puedes cambiarlo por otro ícono si prefieres
                size: 25, // Tamaño grande
                color: Colors.black87,
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Peso
              Column(
                children: [
                  const Text(
                    "Rango Objetivo",
                    style: TextStyle(fontSize: 17, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  const Text("2-3"),
                ],
              ),
              // Condiciones médicas
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Último INR",
                    style: TextStyle(fontSize: 17, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  const Text("2.8"),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
