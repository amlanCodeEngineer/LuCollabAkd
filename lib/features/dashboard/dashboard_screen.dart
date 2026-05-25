import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../auth/login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final supabase = Supabase.instance.client;
  final Color primaryPurple = const Color(0xFF673AB7);

  Future<void> _signOut(BuildContext context) async {
    await supabase.auth.signOut();
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  // Ekhane database theke amra profiles table er data niye ashchi
  Future<Map<String, dynamic>> _fetchProfileData() async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception("User not logged in");
    
    final response = await supabase
        .from('profiles')
        .select()
        .eq('id', user.id)
        .single();
        
    return response;
  }

  @override
  Widget build(BuildContext context) {
    final user = supabase.auth.currentUser;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('LuCollab Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: primaryPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchProfileData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: primaryPurple));
          }
          
          if (snapshot.hasError) {
            return const Center(child: Text("Welcome! (Profile data not found yet)"));
          }

          final profileData = snapshot.data!;
          final String fullName = profileData['full_name'] ?? 'Unknown User';
          final String uniId = profileData['university_id'] ?? 'N/A';
          final String? avatarUrl = profileData['avatar_url'];

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- PROFILE CARD ---
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        // Uploaded Image as a Rounded Circle!
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: primaryPurple, width: 3),
                          ),
                          child: avatarUrl != null
                              ? CircleAvatar(backgroundImage: NetworkImage(avatarUrl))
                              : const Icon(Icons.person, size: 60, color: Colors.grey),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          fullName,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'ID: $uniId',
                          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          user?.email ?? '',
                          style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // You can add buttons for Minhaj and Afsana's sections here later!
                const Text(
                  'Project Modules',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                // (Cards for PDF upload and forum will go here)
              ],
            ),
          );
        },
      ),
    );
  }
}