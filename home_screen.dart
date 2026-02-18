import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lg_starter_kit/services/lg_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("LG Command Center"),
        actions: [
          IconButton(
            icon: const Icon(Icons.power_settings_new),
            onPressed: () {
               // Verify disconnection logic
               Provider.of<LGService>(context, listen: false).disconnect();
               Navigator.of(context).pop(); 
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 20),
            Text(
              "SYSTEM ONLINE",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Example Action
                Provider.of<LGService>(context, listen: false).reboot();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("REBOOT SYSTEM", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                 Provider.of<LGService>(context, listen: false).clear();
              },
              child: const Text("CLEAR KMLS"),
            ),
          ],
        ),
      ),
    );
  }
}
