import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/event_attendance_model.dart';
// FIX: corrected import — file is badges_providers.dart (plural)
import '../providers/badges_providers.dart';

/// OrganizerAttendanceScreen
///
/// Shown to club leaders / event organizers after an event concludes.
/// They mark which RSVPed students actually attended, then tap "Award Badges"
/// to persist verified participation records via SQLite.
///
/// INTEGRATION (team):
///   Navigator.push(context, MaterialPageRoute(builder: (_) =>
///     OrganizerAttendanceScreen(
///       eventId: event.id,
///       eventName: event.title,
///       eventType: event.type,   // 'workshop' | 'hackathon' | 'leadership' | 'community' | 'startup'
///       organizerName: currentUser.name,
///       rsvpedAttendees: event.rsvpList, // pass your actual RSVP list here
///     )));
class OrganizerAttendanceScreen extends StatefulWidget {
  final String eventId;
  final String eventName;
  final String eventType;
  final String organizerName;

  /// Optional: pass the real RSVP list from the feed/event system.
  /// Falls back to mock data when null (for standalone demo).
  final List<EventAttendee>? rsvpedAttendees;

  const OrganizerAttendanceScreen({
    super.key,
    required this.eventId,
    required this.eventName,
    required this.eventType,
    required this.organizerName,
    this.rsvpedAttendees,
  });

  @override
  State<OrganizerAttendanceScreen> createState() =>
      _OrganizerAttendanceScreenState();
}

class _OrganizerAttendanceScreenState
    extends State<OrganizerAttendanceScreen> {

  late final List<EventAttendee> _attendees;
  bool _awardsSubmitted = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Use injected RSVP list or fall back to mock data
    _attendees = widget.rsvpedAttendees ??
        [
          EventAttendee(studentId: 'stu_001', studentName: 'Aline Umuhoza',       cohort: 'Kigali 2025'),
          EventAttendee(studentId: 'stu_002', studentName: 'David Nkurunziza',    cohort: 'Kigali 2025'),
          EventAttendee(studentId: 'stu_003', studentName: 'Fatima Hassan',       cohort: 'Mauritius 2025'),
          EventAttendee(studentId: 'stu_004', studentName: 'Jean-Paul Hakizimana',cohort: 'Kigali 2024'),
          EventAttendee(studentId: 'stu_005', studentName: 'Amara Diallo',        cohort: 'Mauritius 2024'),
          EventAttendee(studentId: 'stu_006', studentName: 'Chisom Okafor',       cohort: 'Kigali 2025'),
          EventAttendee(studentId: 'stu_007', studentName: 'Lena Mwangi',         cohort: 'Mauritius 2025'),
        ];
  }

  int get _markedCount => _attendees.where((a) => a.isMarkedPresent).length;

  List<EventAttendee> get _filteredAttendees {
    if (_searchQuery.isEmpty) return _attendees;
    final q = _searchQuery.toLowerCase();
    return _attendees
        .where((a) =>
            a.studentName.toLowerCase().contains(q) ||
            a.cohort.toLowerCase().contains(q))
        .toList();
  }

  void _toggleAll(bool value) {
    setState(() {
      for (final a in _attendees) {
        a.isMarkedPresent = value;
      }
    });
  }

  Future<void> _submitAndAwardBadges() async {
    final provider = context.read<BadgesProvider>();
    final success = await provider.awardBadges(
      attendees: _attendees,
      eventId: widget.eventId,
      eventName: widget.eventName,
      eventType: widget.eventType,
      organizerName: widget.organizerName,
    );

    if (!mounted) return;

    if (success) {
      setState(() => _awardsSubmitted = true);
      _showSuccessDialog();
    } else if (provider.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.error!),
          backgroundColor: Colors.redAccent,
        ),
      );
      provider.clearError();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF2E3454),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🎉', style: TextStyle(fontSize: 52)),
            const SizedBox(height: 12),
            Text(
              '$_markedCount badge${_markedCount == 1 ? '' : 's'} awarded!',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Students will see their new badge\non their profile.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF8A91B4), fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // close dialog
                  Navigator.pop(context); // back to previous screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF5A623),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Done',
                    style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredAttendees;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1F36),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1F36),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mark Attendance',
              style: TextStyle(
                  color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700),
            ),
            Text(
              widget.eventName,
              style: const TextStyle(color: Color(0xFF8A91B4), fontSize: 11),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search attendees…',
                hintStyle: const TextStyle(color: Color(0xFF5C6289), fontSize: 14),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF5C6289), size: 20),
                filled: true,
                fillColor: const Color(0xFF2E3454),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Select all bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF2E3454),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$_markedCount / ${_attendees.length} marked present',
                  style: const TextStyle(
                      color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                ),
                TextButton(
                  onPressed: () => _toggleAll(_markedCount < _attendees.length),
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  child: Text(
                    _markedCount < _attendees.length ? 'Select all' : 'Deselect all',
                    style: const TextStyle(
                        color: Color(0xFFF5A623), fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Attendee list
          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Text(
                      'No attendees found',
                      style: TextStyle(color: Color(0xFF8A91B4)),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) {
                      final attendee = filtered[i];
                      return _AttendeeListTile(
                        attendee: attendee,
                        onTap: () => setState(
                            () => attendee.isMarkedPresent = !attendee.isMarkedPresent),
                      );
                    },
                  ),
          ),
        ],
      ),

      // Award badges CTA
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        color: const Color(0xFF1A1F36),
        child: Consumer<BadgesProvider>(
          builder: (_, provider, __) => SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed:
                  (_markedCount == 0 || _awardsSubmitted || provider.isAwarding)
                      ? null
                      : _submitAndAwardBadges,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF5A623),
                disabledBackgroundColor: const Color(0xFF2E3454),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: provider.isAwarding
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                          color: Colors.black, strokeWidth: 2.5),
                    )
                  : Text(
                      _awardsSubmitted
                          ? 'Badges Awarded ✓'
                          : 'Award Badges to $_markedCount Student${_markedCount == 1 ? '' : 's'}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 15),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Extracted tile widget for cleaner build method
class _AttendeeListTile extends StatelessWidget {
  final EventAttendee attendee;
  final VoidCallback onTap;

  const _AttendeeListTile({required this.attendee, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isPresent = attendee.isMarkedPresent;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isPresent
              ? const Color(0xFF50C878).withAlpha(25)   // replaces deprecated withOpacity
              : const Color(0xFF2E3454),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isPresent
                ? const Color(0xFF50C878).withAlpha(128)
                : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: const Color(0xFFF5A623).withAlpha(38),
              child: Text(
                attendee.studentName[0].toUpperCase(),
                style: const TextStyle(
                    color: Color(0xFFF5A623), fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    attendee.studentName,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    attendee.cohort,
                    style: const TextStyle(
                        color: Color(0xFF8A91B4), fontSize: 12),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: isPresent ? const Color(0xFF50C878) : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isPresent
                      ? const Color(0xFF50C878)
                      : const Color(0xFF8A91B4),
                  width: 2,
                ),
              ),
              child: isPresent
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}