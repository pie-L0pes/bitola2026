import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: App()));
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  double distancia = 0.0;
  double corrente = 0.0;

  String resultado127 = "0.00";
  String resultado220 = "0.00";

  void calcular() {
    // Fórmulas simples
    double r1 = (2 * corrente * distancia) / 294.64;
    double r2 = (2 * corrente * distancia) / 510.4;

    List<double> bitolas = [1.5, 2.5, 4, 6, 10, 16, 25, 35, 50];

    double ajustar(double valor) {
      // garante mínimo de 1.5 mm²
      if (valor < 1.5) return 1.5;
      return bitolas.firstWhere((b) => b >= valor, orElse: () => valor);
    }

    setState(() {
      resultado127 = ajustar(r1).toStringAsFixed(2);
      resultado220 = ajustar(r2).toStringAsFixed(2);
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text("Resultado"),
        content: Text(
          "A bitola recomendada para Tensão 127V é: $resultado127 \n"
        "A bitola recomendada para Tensão 220V é: $resultado220 \n"
        ),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }

  InputDecoration campo(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDE7F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A148C),
        title: const Text("Calculadora de bitola (mm²)", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Elétrica residencial - cabos de cobre:",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),

            const Text("Distância (m):"),
            const SizedBox(height: 8),
            TextField(
              keyboardType: TextInputType.number,
              decoration: campo("Digite a distância"),
              onChanged: (v) => distancia = double.tryParse(v) ?? 0,
            ),

            const SizedBox(height: 20),

            const Text("Corrente (A):"),
            const SizedBox(height: 8),
            TextField(
              keyboardType: TextInputType.number,
              decoration: campo("Digite a corrente"),
              onChanged: (v) => corrente = double.tryParse(v) ?? 0,
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: 160,
              height: 45,
              child: ElevatedButton(
                onPressed: calcular,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6A1B9A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text("Calcular", style: TextStyle(color: Colors.white),),
              ),
            ),

            const SizedBox(height: 30),

            Text(
              "A bitola recomendada para Tensão 127V é: $resultado127 mm²",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "A bitola recomendada para Tensão 220V é: $resultado220 mm²",
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}