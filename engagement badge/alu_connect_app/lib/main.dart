import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/badges/providers/badges_providers.dart';
import 'features/badges/screens/student_badges_screen.dart';
import 'features/badges/screens/organizer_attendance_screen.dart';

/// Entry point — integrates with the team's app shell.
/// The BadgesProvider is registered here so it can be consumed
/// by both StudentBadgesScreen and OrganizerAttendanceScreen.
///
/// INTEGRATION NOTE for teammates:
///   1. Add `ChangeNotifierProvider(create: (_) => BadgesProvider())`
///      to your top-level MultiProvider list.
///   2. Navigate to StudentBadgesScreen(studentId: ..., studentName: ...)
///      from the Profile tab to show a student's earned badges.
///   3. Navigate to OrganizerAttendanceScreen(eventId: ..., eventName: ...,
///      eventType: ..., organizerName: ...) from the organizer dashboard
///      after an event to mark attendance and award badges.

void main() {
  runApp(const _BadgesDemoApp());
}

/// Standalone demo wrapper — replace with team's MultiProvider root.
class _BadgesDemoApp extends StatelessWidget {
  const _BadgesDemoApp();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BadgesProvider(),
      child: MaterialApp(
        title: 'ALU Connect — Badges Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFF5A623),
            brightness: Brightness.dark,
          ),
          scaffoldBackgroundColor: const Color(0xFF1A1F36),
          useMaterial3: true,
        ),
        home: const _BadgesDemoHome(),
      ),
    );
  }
}

/// Simple launcher to demo both screens without the full app shell.
class _BadgesDemoHome extends StatelessWidget {
  const _BadgesDemoHome();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1F36),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1F36),
        title: const Text(
          'Task 3 — Proof of Engagement Badges',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '🎖️ Badges Feature Demo',
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap a button below to preview each screen.\nIn the full app these are reached via Profile tab & Organizer Dashboard.',
              style: TextStyle(color: Color(0xFF8A91B4), fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 40),
            _DemoButton(
              emoji: '🎓',
              label: 'Student: View My Badges',
              subtitle: 'Profile tab → My Badges',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const StudentBadgesScreen(
                    studentId: 'stu_001',
                    studentName: 'Aline Umuhoza',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _DemoButton(
              emoji: '📋',
              label: 'Organizer: Mark Attendance',
              subtitle: 'Organizer Dashboard → After Event',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const OrganizerAttendanceScreen(
                    eventId: 'evt_hackathon_001',
                    eventName: 'ALU Entrepreneurship Pitch Night',
                    eventType: 'hackathon',
                    organizerName: 'David Nkurunziza',
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

class _DemoButton extends StatelessWidget {
  final String emoji;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _DemoButton({
    required this.emoji,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF2E3454),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFF8A91B4),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios,
                  color: Color(0xFFF5A623), size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
