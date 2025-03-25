import 'package:flutter/material.dart';

class RangeInr extends StatefulWidget {
  const RangeInr({super.key});

  @override
  State<RangeInr> createState() => _RangeInrState();
}

class _RangeInrState extends State<RangeInr> {
  double _startValue = 2.0;
  double _endValue = 3.0;

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
              const Text(
                "Rango INR objetivo",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 25),
                color: Colors.black87,
                onPressed: () {
                  // Acción para editar
                },
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const SizedBox(height: 15),
                _buildRangeDisplay(context),
                const SizedBox(height: 15),
                _buildRangeSlider(),
                const SizedBox(height: 10),
                _buildMinMaxLabels(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRangeDisplay(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const SizedBox(width: 10),
              Text(
                "Rango actual",
                style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
              ),
            ],
          ),
          Text(
            "${_startValue.toStringAsFixed(1)} - ${_endValue.toStringAsFixed(1)}",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildRangeSlider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: RangeSlider(
        values: RangeValues(_startValue, _endValue),
        min: 1.0,
        max: 5.0,
        divisions: 8,
        labels: RangeLabels(
          _startValue.toStringAsFixed(1),
          _endValue.toStringAsFixed(1),
        ),
        onChanged: (RangeValues values) {
          setState(() {
            _startValue = values.start;
            _endValue = values.end;
          });
        },
        activeColor: Color.fromARGB(255, 74, 222, 128),
        inactiveColor: Colors.blue.shade100,
      ),
    );
  }

  Widget _buildMinMaxLabels() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("1.0", style: TextStyle(color: Colors.grey)),
          Text("5.0", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
