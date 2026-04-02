import 'package:flutter/material.dart';
import 'package:louvor_app/widgets/modern_card.dart';
import 'repertorio_page.dart';
import 'escalas_page.dart';
import 'package:louvor_app/pages/placeholder_page.dart';
import 'musicos_page.dart';
import 'banda_management_page.dart';
import 'perfil_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Text(
                "Worship Made Easy",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    ModernCard(
                      icon: Icons.music_note,
                      title: "Repertório",
                      destination: const RepertorioPage(),
                    ),
                    ModernCard(
                      icon: Icons.groups,
                      title: "Escalas",
                      destination: const EscalasPage(),
                    ),
                    ModernCard(
                      icon: Icons.piano,
                      title: "Músicos",
                      destination: const MusicosPage(),
                    ),
                    ModernCard(
                      icon: Icons.calendar_month,
                      title: "Agenda",
                      destination: const PlaceholderPage(title: "Agenda"),
                    ),
                    ModernCard(
                      icon: Icons.admin_panel_settings,
                      title: "Banda",
                      destination: const BandaManagementPage(),
                    ),
                    ModernCard(
                      icon: Icons.person,
                      title: "Perfil",
                      destination: const PerfilPage(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}