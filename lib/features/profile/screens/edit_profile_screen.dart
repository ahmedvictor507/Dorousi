import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/app_theme.dart';
import '../../auth/providers/auth_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthProvider>();
    _nameController = TextEditingController(text: auth.userName);
    _emailController = TextEditingController(text: auth.userEmail);
    _phoneController = TextEditingController(text: auth.userPhone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.editProfile),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildAvatarPicker(),
            const SizedBox(height: 40),
            _buildTextField(AppStrings.fullName, _nameController, Icons.person_outline_rounded),
            const SizedBox(height: 20),
            _buildTextField(AppStrings.email, _emailController, Icons.email_outlined, enabled: false),
            const SizedBox(height: 20),
            _buildTextField(AppStrings.phone, _phoneController, Icons.phone_android_outlined),
            const SizedBox(height: 40),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarPicker() {
    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primaryBlue.withOpacity(0.1), width: 4),
            ),
            child: const CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=student'),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(color: AppColors.primaryBlue, shape: BoxShape.circle),
            child: const Icon(Icons.camera_enhance_rounded, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {bool enabled = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          enabled: enabled,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.primaryBlue),
            fillColor: enabled ? AppColors.inputFill : AppColors.inputFill.withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: AppColors.primaryBlue.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("تم حفظ التعديلات بنجاح")),
          );
          context.pop();
        },
        style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
        child: const Text("حفظ التغييرات", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }
}
