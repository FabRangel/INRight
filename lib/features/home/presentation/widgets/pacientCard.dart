import 'package:flutter/material.dart';

class PacientCardWidget extends StatelessWidget {
  const PacientCardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Gradient avatarGradient = LinearGradient(
      begin: Alignment(0.35, 0.35),
      end: Alignment(1.06, -0.35),
      colors: [Color(0xFF66B1C8), Color(0xFFABD2DD)],
    );

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sección superior: Avatar y nombre
          Row(
            children: [
              // Avatar
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: avatarGradient, // Gradiente de fondo
                  borderRadius: BorderRadius.circular(20), // Bordes redondeados
                ),
                child: Stack(
                  clipBehavior: Clip.none, // Permite que el ícono se desborde
                  children: [
                    // Contenedor de la imagen
                    Center(
                      child: Container(
                        width:
                            90, // Tamaño más pequeño que el contenedor principal
                        height: 90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            20,
                          ), // Bordes redondeados
                          image: const DecorationImage(
                            image: AssetImage(
                              'assets/images/persona.jpg',
                            ), // Ruta de la imagen
                            fit:
                                BoxFit.cover, // Ajustar la imagen al contenedor
                          ),
                        ),
                      ),
                    ),
                    // Ícono de cámara
                    Positioned(
                      right: -10, // Desbordamiento hacia la izquierda
                      bottom: -10, // Desbordamiento hacia abajo
                      child: Container(
                        width: 35, // Tamaño del círculo
                        height: 35,
                        decoration: BoxDecoration(
                          color: Colors.white, // Fondo blanco
                          shape: BoxShape.circle, // Forma circular
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2), // Sombra
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.camera_alt_outlined, // Ícono de cámara
                            size: 17, // Tamaño del ícono
                            color: Colors.black, // Color del ícono
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              // Nombre y correo
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "María García",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    "Maria@gmail.com",
                    style: TextStyle(fontSize: 17, color: Colors.black87),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          // Sección inferior: Peso y condiciones médicas
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Peso
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Peso",
                    style: TextStyle(fontSize: 17, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 140,
                    height: 50,
                    child: TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF8FAFF),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        suffixText: "kg", // Unidad de medida
                        suffixStyle: TextStyle(color: Colors.black87),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              // Condiciones médicas
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Condiciones médicas",
                    style: TextStyle(fontSize: 17, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 150,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Altura
          const Text(
            'Altura',
            style: TextStyle(fontSize: 17, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 140,
            height: 50,
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF8FAFF),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                suffixText: "cm", // Unidad de medida
                suffixStyle: TextStyle(color: Colors.black87),
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          const SizedBox(height: 20),
          // Grupo sanguíneo
          const Text(
            'Grupo sanguíneo',
            style: TextStyle(fontSize: 17, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 140,
            height: 50,
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF8FAFF),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.favorite_outline), // Ícono de corazón
              ),
              keyboardType: TextInputType.text,
            ),
          ),
        ],
      ),
    );
  }
}
