import 'package:flutter/material.dart';
import 'package:trainer/design/design_tokens.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('FitLab — Dashboard'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Bienvenido, Alex', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.count(
                crossAxisCount: MediaQuery.of(context).size.width > 800 ? 4 : 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _card('Alumnos', '8 activos'),
                  _card('Rutinas', '12 programadas'),
                  _card('Mensajes', '3 sin leer'),
                  _card('Facturación', 'Plan Pro'),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _card(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: [BoxShadow(color: AppColors.cardShadow.withOpacity(0.04), blurRadius: 18, offset: const Offset(0, 8))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        Text(subtitle, style: TextStyle(color: AppColors.muted)),
        const Expanded(child: SizedBox()),
        Align(alignment: Alignment.bottomRight, child: Icon(Icons.chevron_right, color: AppColors.muted)),
      ]),
    );
  }
}