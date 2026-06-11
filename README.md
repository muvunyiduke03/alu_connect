# ALU Connect
A mobile application that brings all events, opportunities, hackathons, startup initiatives and communities within the ALU ecosystem together in one app. It is built by Flutter.

## Features
  - Authentication & Onboarding: Register/login restricted to @alustudent.com and @alustaff.com         email domains, with a 3-step onboarding flow.
  - Opportunity Feed: Browse and filter events, hackathons, startups, and workshops.
  - Explore: Live search across opportunities and communities.
  - RSVP & Bookmarking: Save opportunities and track them on your in-app calendar.
  - Communities & Chat: Join clubs/cohorts, view pinned announcements, and message members.
  - Squad Formation: "Looking for teammates" toggle on hackathon and startup posts.
  - Engagement Badges: Organizers can mark attendance and award badges.
  - Calendar & Profile: View upcoming RSVPs and manage your profile.

## How to run the app

1. Before running the app you have to have:
  1. Flutter SDK (3.11.5+)
  2. Android Studio For emulators.
  3. VS Code with Flutter and Dart extensions.

2. Verify if your setup is working:
   ```
   flutter doctor
   ```

3. Clone repository
   ```
   git clone https://github.com/muvunyiduke03/alu_connect.git
   cd alu_connect_app
   ```

4. Install dependencies
   ```
   flutter pub get
   ```

5. Run the app
   ```
   flutter run
   ```

### Test authentication

The app uses local in-memory storage for accounts details(emails and password). To get started:

  1. On the login screen, tap "Create an account"
  2. Register with:
     - Your ALU email (email@alustudent.com or email@alustaff.com)
     - Enter your full name and a strong password (8+ characters).

## Conclusion

This mobile application was buit collaboratively as part of a mobile development assignment.

