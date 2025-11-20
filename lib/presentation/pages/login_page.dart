// LoginPage con foco en _narrowLayout y logo mejorado.
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:trainer/design/design_tokens.dart'; 
import 'register_page.dart';
import 'home_page.dart';

// --- Clases Principales ---

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static const routeName = '/login';
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailCtl = TextEditingController();
  final _passCtl = TextEditingController();
  bool _loading = false;
  bool _showPwd = false;
  String? _error;

  late final AnimationController _animCtrl;
  late final Animation<double> _cardAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _cardAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutBack);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _emailCtl.dispose();
    _passCtl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      setState(() {}); // fuerza mostrar errores
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });

    // simulación de llamada
    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;
    setState(() => _loading = false);

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const HomePage(),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 420),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Eliminamos el cálculo de 'isWide' ya que solo usaremos narrowLayout
    return Scaffold(
      body: Stack(
        children: [
          _BackgroundDecorations(),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500), // Max width ajustado para móvil/vertical
                  child: ScaleTransition(
                    scale: _cardAnim,
                    child: _narrowLayout(context),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Narrow layout: top logo + form (único layout ahora)
  Widget _narrowLayout(BuildContext context) {
    return Column(
      children: [
        Hero(tag: 'fitlab-logo', child: _BrandLogo(large: true)), // Usaremos 'large' para el logo principal
        const SizedBox(height: 36), // Más espacio para respirar
        _formCard(context),
      ],
    );
  }

  // Main form card
  Widget _formCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20), 
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: [BoxShadow(color: AppColors.cardShadow.withOpacity(0.06), blurRadius: 22, offset: const Offset(0, 12))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        // accent line
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 10), 
          child: Container(height: 6, width: 78, decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.14), borderRadius: BorderRadius.circular(8))),
        ),
        
        Text('Iniciar sesión', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800, fontSize: 24)), 
        const SizedBox(height: 6),
        Text('Usa tu email profesional', style: TextStyle(color: AppColors.muted, fontSize: 15)), 
        const SizedBox(height: 20), 

        Form(
          key: _formKey,
          child: Column(children: [
            // Campo Email. Usa el estilo global de inputDecorationTheme()
            TextFormField(
              controller: _emailCtl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.alternate_email_outlined)),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Ingresa tu email';
                if (!v.contains('@') || !v.contains('.')) return 'Email inválido'; 
                return null;
              },
            ),
            const SizedBox(height: 16), 
            
            // Campo Contraseña
            TextFormField(
              controller: _passCtl,
              obscureText: !_showPwd,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  onPressed: () => setState(() => _showPwd = !_showPwd),
                  icon: Icon(_showPwd ? Icons.visibility_off : Icons.visibility),
                ),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Ingresa tu contraseña';
                if (v.length < 6) return 'Mínimo 6 caracteres';
                return null;
              },
            ),

            const SizedBox(height: 20), 
            if (_error != null) Padding(padding: const EdgeInsets.only(bottom: 12.0), child: Text(_error!, style: const TextStyle(color: AppColors.danger))),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
                ),
                onPressed: _loading ? null : _submit,
                child: _loading 
                    ? const SizedBox(height: 28, width: 28, child: SpinKitFadingCircle(color: Colors.white, size: 28)) 
                    : const Text('Iniciar sesión', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
              ),
            ),
            
            const SizedBox(height: 10),
            
            Row(children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary.withOpacity(0.25)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextButton.icon(
                    onPressed: _loading ? null : () { 
                      setState(() => _loading = true);
                      Future.delayed(const Duration(milliseconds: 700), () {
                        if (!mounted) return;
                        setState(() => _loading = false);
                        Navigator.of(context).pushReplacement(PageRouteBuilder(pageBuilder: (_, __, ___) => const HomePage(), transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child), transitionDuration: const Duration(milliseconds: 360)));
                      });
                    },
                    icon: Icon(Icons.flash_on_outlined, color: AppColors.primary700),
                    label: const Text('Entrar Demo', style: TextStyle(color: AppColors.primary700)),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: 10),
              
              TextButton(
                onPressed: _loading ? null : () { 
                  Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => const RegisterPage(), transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child), transitionDuration: const Duration(milliseconds: 360)));
                }, 
                child: const Text('¿Eres trainer? Regístrate')
              ),
            ]),
            
            const SizedBox(height: 6),
            
            Align(
              alignment: Alignment.centerLeft, 
              child: TextButton(
                onPressed: _loading ? null : () { 
                  showDialog(context: context, builder: (_) => AlertDialog(title: const Text('Recuperar contraseña'), content: const Text('Se enviará un email de recuperación (simulado).'), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar')), ElevatedButton(onPressed: () { Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Correo enviado (simulado)'))); }, child: const Text('Enviar'))]));
                }, 
                child: Text('¿Olvidaste tu contraseña?', style: TextStyle(color: AppColors.muted))
              )
            ),
          ]),
        ),
      ]),
    );
  }
}

// --- Widgets de Soporte ---

// Widget de Fondo Decorativo (sin cambios)
class _BackgroundDecorations extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF6FBF9), Color(0xFFEFF7F2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -90,
            left: -60,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.10),
                borderRadius: BorderRadius.circular(140),
              ),
            ),
          ),
          Positioned(
            bottom: -110,
            right: -60,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                color: AppColors.primary700.withOpacity(0.08),
                borderRadius: BorderRadius.circular(140),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Brand logo widget: **MEJORADO**
class _BrandLogo extends StatelessWidget {
  final bool large;
  const _BrandLogo({this.large = true});

  @override
  Widget build(BuildContext context) {
    final height = large ? 48.0 : 36.0;
    final circleSize = large ? 32.0 : 24.0;
    final fontSize = large ? 24.0 : 18.0;

    return Row(
      mainAxisSize: MainAxisSize.min, 
      children: [
        // Icono Circular (simula el logo de la imagen)
        Container(
          width: circleSize, 
          height: circleSize, 
          decoration: BoxDecoration(
            color: AppColors.primary, 
            shape: BoxShape.circle, 
            boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
          ), 
          child: Center(
            child: Icon(
              Icons.directions_run, // Ejemplo de icono deportivo
              color: AppColors.surface, // Color blanco
              size: circleSize * 0.6,
            )
          )
        ),
        const SizedBox(width: 10),
        // Texto
        Text(
          'FitLab', 
          style: TextStyle(
            color: AppColors.accent, // Usamos el color de acento oscuro para el texto
            fontWeight: FontWeight.w900, 
            fontSize: fontSize, 
            height: 1, // Asegura que no haya padding vertical excesivo
          )
        ),
      ]
    );
  }
}

// Eliminamos _BrandFeatureList ya que solo usamos el layout vertical (narrow)

// Eliminamos _LoginFormInput ya que usamos el InputDecorationTheme global