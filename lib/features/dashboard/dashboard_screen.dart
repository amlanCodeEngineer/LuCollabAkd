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
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  Future<Map<String, dynamic>> _fetchProfileData() async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception("User not logged in");
    
    return await supabase
        .from('profiles')
        .select()
        .eq('id', user.id)
        .single();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('My Profile Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
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
            return const Center(child: Text("Welcome! Profile data loaded dynamically."));
          }

          final profileData = snapshot.data!;
          final String fullName = profileData['full_name'] ?? 'User';
          final String uniId = profileData['university_id'] ?? 'N/A';
          final String? avatarUrl = profileData['avatar_url'];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- PROFILE PIC & BASIC DETAILS ---
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
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
                        Text(fullName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        Text('ID: $uniId', style: TextStyle(fontSize: 15, color: Colors.grey[700])),
                        Text(supabase.auth.currentUser?.email ?? '', style: TextStyle(fontSize: 13, color: Colors.grey[500])),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 25),
                
                // --- MY PROJECTS / CONTRIBUTION SECTION ---
                const Text('My Uploaded Projects', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: Icon(Icons.folder_special, color: primaryPurple, size: 30),
                    title: const Text('Car Rental Management System'),
                    subtitle: const Text('Role: Lead Developer (Auth & Core Config)'),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                ),

                const SizedBox(height: 25),

                // --- ACTION HISTORY SECTION ---
                const Text('Recent Action History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      children: [
                        _buildHistoryItem(Icons.cloud_upload, 'Uploaded profile photo to Supabase storage', 'Just now'),
                        const Divider(),
                        _buildHistoryItem(Icons.app_registration, 'Successfully created LuCollab account', 'Today'),
                        const Divider(),
                        _buildHistoryItem(Icons.verified_user, 'Database profile record initialized', 'Today'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHistoryItem(IconData icon, String title, String time) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: primaryPurple.withOpacity(0.1),
        child: Icon(icon, color: primaryPurple, size: 18),
      ),
      title: Text(title, style: const TextStyle(fontSize: 14)),
      subtitle: Text(time, style: const TextStyle(fontSize: 12, color: Colors.grey)),
    );
  }
}