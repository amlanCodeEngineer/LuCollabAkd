import 'package:flutter/material.dart';
import '../dashboard/dashboard_screen.dart'; 

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final Color primaryPurple = const Color(0xFF673AB7);
  final Color secondaryPurple = const Color(0xFF9575CD);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('LuCollab Hub', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: primaryPurple,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          // --- UPTORE DASHBOARD BUTTON ---
          TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DashboardScreen()),
              );
            },
            icon: const Icon(Icons.account_circle, color: Colors.white, size: 24),
            label: const Text(
              'Dashboard',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            Text(
              'Welcome to LuCollab Platform 🚀',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryPurple),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // ---  (ACADEMIC RESOURCES) ---
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: InkWell(
                onTap: () {
                  // Minhaj 
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text(" PDF Resources Module Coming Soon!")),
                  );
                },
                borderRadius: BorderRadius.circular(15),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: secondaryPurple.withOpacity(0.15),
                        radius: 28,
                        child: Icon(Icons.picture_as_pdf, color: primaryPurple, size: 28),
                      ),
                      const SizedBox(width: 20),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Academic Resources',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Share and download university PDFs',
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // --- (DISCUSSION FORUM) ---
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: InkWell(
                onTap: () {
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Discussion Forum Coming Soon!")),
                  );
                },
                borderRadius: BorderRadius.circular(15),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: secondaryPurple.withOpacity(0.15),
                        radius: 28,
                        child: Icon(Icons.forum, color: primaryPurple, size: 28),
                      ),
                      const SizedBox(width: 20),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Discussion Forum',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Clear doubts and talk with batchmates',
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}