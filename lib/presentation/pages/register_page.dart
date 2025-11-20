import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trainer/design/design_tokens.dart';
import 'home_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  static const routeName = '/register';
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameCtl = TextEditingController();
  final _emailCtl = TextEditingController();
  final _passwordCtl = TextEditingController();
  final _phoneCtl = TextEditingController();
  final _bioCtl = TextEditingController();
  final _specialtiesCtl = TextEditingController();
  final _priceCtl = TextEditingController();

  bool _loading = false;
  bool _showPwd = false;
  File? _avatar;
  final _picker = ImagePicker();
  String _selectedPlan = 'starter'; // starter / pro / studio
  bool _acceptTerms = false;

  Future<void> _pickAvatar() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery, maxWidth: 1200);
    if (picked != null) {
      setState(() => _avatar = File(picked.path));
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Acepta los términos para continuar')));
      return;
    }
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _loading = false);
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (_, __, ___) => const HomePage(),
      transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
      transitionDuration: const Duration(milliseconds: 420),
    ));
  }

  Widget _planCard(String id, String title, String subtitle) {
    final selected = _selectedPlan == id;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedPlan = id),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: selected ? AppColors.primary700 : const Color(0xFFE6E9EE)),
            boxShadow: selected ? [BoxShadow(color: AppColors.primary.withOpacity(0.12), blurRadius: 12, offset: const Offset(0, 6))] : null,
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.w800, color: selected ? Colors.white : AppColors.text)),
            const SizedBox(height: 6),
            Text(subtitle, style: TextStyle(fontSize: 13, color: selected ? Colors.white70 : AppColors.muted)),
          ]),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fullNameCtl.dispose();
    _emailCtl.dispose();
    _passwordCtl.dispose();
    _phoneCtl.dispose();
    _bioCtl.dispose();
    _specialtiesCtl.dispose();
    _priceCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro - Trainer'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.accent),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: _pickAvatar,
                      child: Hero(
                        tag: 'fitlab-logo',
                        child: CircleAvatar(
                          radius: 52,
                          backgroundColor: AppColors.inputFill,
                          backgroundImage: _avatar != null ? FileImage(_avatar!) : null,
                          child: _avatar == null ? Icon(Icons.camera_alt_outlined, size: 28, color: AppColors.muted) : null,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    color: AppColors.surface,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(children: [
                          TextFormField(controller: _fullNameCtl, decoration: const InputDecoration(labelText: 'Nombre completo'), validator: (v){ if (v==null||v.isEmpty) return 'Requerido'; return null; }),
                          const SizedBox(height: 8),
                          TextFormField(controller: _emailCtl, decoration: const InputDecoration(labelText: 'Email profesional'), keyboardType: TextInputType.emailAddress, validator: (v){ if (v==null||v.isEmpty) return 'Requerido'; if(!v.contains('@')) return 'Email inválido'; return null; }),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _passwordCtl,
                            decoration: InputDecoration(
                              labelText: 'Contraseña',
                              suffixIcon: IconButton(
                                onPressed: () => setState(() => _showPwd = !_showPwd),
                                icon: Icon(_showPwd ? Icons.visibility_off : Icons.visibility),
                              ),
                            ),
                            obscureText: !_showPwd,
                            validator: (v){ if (v==null||v.length<6) return 'Mínimo 6 caracteres'; return null; },
                          ),
                          const SizedBox(height: 8),
                          TextFormField(controller: _phoneCtl, decoration: const InputDecoration(labelText: 'Teléfono (opcional)'), keyboardType: TextInputType.phone),
                          const SizedBox(height: 8),
                          TextFormField(controller: _specialtiesCtl, decoration: const InputDecoration(labelText: 'Especialidades (ej: fuerza, crossfit)')),
                          const SizedBox(height: 8),
                          TextFormField(controller: _bioCtl, decoration: const InputDecoration(labelText: 'Bio / Presentación'), maxLines: 3),
                          const SizedBox(height: 8),
                          TextFormField(controller: _priceCtl, decoration: const InputDecoration(labelText: 'Precio por sesión (opcional)', prefixText: '\$'), keyboardType: TextInputType.number),
                          const SizedBox(height: 12),

                          Align(alignment: Alignment.centerLeft, child: const Text('Selecciona un plan', style: TextStyle(fontWeight: FontWeight.w800))),
                          const SizedBox(height: 10),
                          Row(children: [
                            _planCard('starter', 'Starter', 'Hasta 10 alumnos\n\$19/mes'),
                            const SizedBox(width: 8),
                            _planCard('pro', 'Pro', 'Hasta 50 alumnos\n\$59/mes'),
                            const SizedBox(width: 8),
                            _planCard('studio', 'Studio', 'Ilimitado\n\$199/mes'),
                          ]),

                          const SizedBox(height: 14),
                          Row(children: [
                            Checkbox(value: _acceptTerms, onChanged: (v) => setState(() => _acceptTerms = v ?? false)),
                            Expanded(child: Text('Acepto los términos y la política de privacidad', style: TextStyle(color: AppColors.muted))),
                          ]),

                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _loading ? null : _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: _loading ? const SpinKitFadingCircle(color: Colors.white, size: 26) : const Text('Crear cuenta', style: TextStyle(fontWeight: FontWeight.w800)),
                            ),
                          ),

                          const SizedBox(height: 8),
                          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Volver al login')),
                        ]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}