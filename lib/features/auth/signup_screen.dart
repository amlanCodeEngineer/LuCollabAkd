import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _uniIdController = TextEditingController();
  bool _isLoading = false;

  XFile? _imageFile; 
  final ImagePicker _picker = ImagePicker();

  final Color primaryPurple = const Color(0xFF673AB7); 
  final Color secondaryPurple = const Color(0xFF9575CD); 

  Future<void> _pickImage() async {
    final XFile? selectedImage = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 400,
      maxHeight: 400,
      imageQuality: 85,
    );

    if (selectedImage != null) {
      setState(() {
        _imageFile = selectedImage;
      });
    }
  }

  Future<void> _signUp() async {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload a profile photo.'), backgroundColor: Colors.red),
      );
      return;
    }
    
    setState(() => _isLoading = true);
    final supabase = Supabase.instance.client;
    
    try {
      final AuthResponse res = await supabase.auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      
      final User? user = res.user;
      String? publicUrl;
      
      if (user != null) {
        final fileName = '${user.id}/${DateTime.now().millisecondsSinceEpoch}_avatar.jpg';
        
        if (kIsWeb) {
          await supabase.storage.from('avatars').uploadBinary(
                fileName,
                await _imageFile!.readAsBytes(),
                fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
              );
        } else {
          await supabase.storage.from('avatars').upload(
                fileName,
                File(_imageFile!.path),
                fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
              );
        }
           
        publicUrl = supabase.storage.from('avatars').getPublicUrl(fileName);

        await supabase.from('profiles').insert({
          'id': user.id,
          'full_name': _nameController.text.trim(),
          'university_id': _uniIdController.text.trim(),
          'avatar_url': publicUrl,
        });
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration Successful!'), backgroundColor: Colors.green),
        );
        Navigator.pop(context); 
      }
    } on AuthException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message), backgroundColor: Colors.red));
    } catch (e) {
      debugPrint("REAL ERROR: $e"); 
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _uniIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Create Account', style: TextStyle(color: primaryPurple, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: primaryPurple),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage, // Fixed onTap
                child: Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[200],
                          border: Border.all(color: secondaryPurple, width: 2),
                        ),
                        child: _imageFile != null
                            ? (kIsWeb 
                                ? CircleAvatar(backgroundImage: NetworkImage(_imageFile!.path))
                                : CircleAvatar(backgroundImage: FileImage(File(_imageFile!.path))))
                            : const Icon(Icons.person, size: 60, color: Colors.grey),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(shape: BoxShape.circle, color: primaryPurple),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text('Upload Profile Photo', style: TextStyle(fontSize: 14, color: primaryPurple, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildPurpleTextField(_nameController, Icons.person, 'Full Name'),
                  const SizedBox(height: 16),
                  _buildPurpleTextField(_uniIdController, Icons.badge, 'University ID (e.g. CSE-123)'),
                  const SizedBox(height: 16),
                  _buildPurpleTextField(_emailController, Icons.email, 'University Email'),
                  const SizedBox(height: 16),
                  _buildPurpleTextField(_passwordController, Icons.lock, 'Password', obscureText: true),
                ],
              ),
              const SizedBox(height: 30),
              _isLoading
                  ? Center(child: CircularProgressIndicator(color: primaryPurple))
                  : ElevatedButton(
                      onPressed: _signUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryPurple,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 3,
                      ),
                      child: const Text('Sign Up & Continue', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPurpleTextField(TextEditingController controller, IconData icon, String label, {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: secondaryPurple),
        enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.grey, width: 1), borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: primaryPurple, width: 2), borderRadius: BorderRadius.circular(10)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        labelStyle: TextStyle(color: primaryPurple.withOpacity(0.7)),
      ),
    );
  }
}