import 'package:alphalens_fend/utils/token_storage.dart';
import 'package:flutter/material.dart';


class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<String?>(
        future: TokenStorage.getToken(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 60),
                  const SizedBox(height: 16),
                  const Text('✅ LOGGED IN', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Token: ${snapshot.data!.substring(0, 30)}...', 
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            );
          }
          return const Center(child: Text('No token found'));
        },
      ),
    );
  }
}