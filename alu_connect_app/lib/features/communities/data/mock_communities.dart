import 'package:flutter/material.dart';
import '../models/community_model.dart';

// ---------------------------------------------------------------------------
// Shared avatar colours
// ---------------------------------------------------------------------------
const _c1 = Color(0xFFE53935);
const _c2 = Color(0xFF8E24AA);
const _c3 = Color(0xFF1E88E5);
const _c4 = Color(0xFF43A047);
const _c5 = Color(0xFFFF8F00);
const _c6 = Color(0xFF00ACC1);
const _c7 = Color(0xFFAD1457);
const _c8 = Color(0xFF3949AB);

// ---------------------------------------------------------------------------
// 1. ALU Debate Society
// ---------------------------------------------------------------------------
final _debateMebers = [
  CommunityMember(id: 'm1', name: 'Kwame Asante', role: 'Leader', joinedDate: DateTime(2025, 9, 1), avatarColor: _c8),
  CommunityMember(id: 'm2', name: 'Fatima Al-Hassan', role: 'Moderator', joinedDate: DateTime(2025, 9, 5), avatarColor: _c2),
  CommunityMember(id: 'm3', name: 'Chidi Okonkwo', role: 'Member', joinedDate: DateTime(2025, 9, 10), avatarColor: _c4),
  CommunityMember(id: 'm4', name: 'Amara Diallo', role: 'Member', joinedDate: DateTime(2025, 10, 2), avatarColor: _c5),
  CommunityMember(id: 'm5', name: 'Sipho Dlamini', role: 'Member', joinedDate: DateTime(2025, 10, 15), avatarColor: _c6),
  CommunityMember(id: 'm6', name: 'Nadia Moussaoui', role: 'Member', joinedDate: DateTime(2025, 11, 1), avatarColor: _c7),
  CommunityMember(id: 'm7', name: 'Emeka Eze', role: 'Member', joinedDate: DateTime(2026, 1, 8), avatarColor: _c3),
  CommunityMember(id: 'm8', name: 'Zara Mbeki', role: 'Member', joinedDate: DateTime(2026, 2, 14), avatarColor: _c1),
];

final _debatePosts = [
  CommunityPost(id: 'dp1', authorId: 'm1', authorName: 'Kwame Asante', authorAvatarColor: _c8,
    content: '🏆 Huge congratulations to Fatima and Chidi for winning the inter-cohort debate on AI ethics! They absolutely crushed it. S2026 represent!',
    timestamp: DateTime.now().subtract(const Duration(hours: 2)), likeCount: 24, isPinned: false),
  CommunityPost(id: 'dp2', authorId: 'm2', authorName: 'Fatima Al-Hassan', authorAvatarColor: _c2,
    content: 'Reminder: Our next session is THIS Saturday at 10am in Room 204. Topic: "Should African governments regulate social media?" Come prepared with 3 arguments for both sides.',
    timestamp: DateTime.now().subtract(const Duration(hours: 8)), likeCount: 15),
  CommunityPost(id: 'dp3', authorId: 'm3', authorName: 'Chidi Okonkwo', authorAvatarColor: _c4,
    content: 'Pro tip from a 2nd-year: record yourself practicing. You\'ll catch filler words and weak transitions you never notice in the moment. Changed my debate game completely.',
    timestamp: DateTime.now().subtract(const Duration(days: 1)), likeCount: 31),
  CommunityPost(id: 'dp4', authorId: 'm5', authorName: 'Sipho Dlamini', authorAvatarColor: _c6,
    content: 'Anyone interested in joining the Africa Universities Debate Championship in October? Applications open next week. DM me for the link!',
    timestamp: DateTime.now().subtract(const Duration(days: 2)), likeCount: 18),
];

final _debateMessages = [
  CommunityMessage(id: 'dm1', senderId: 'm1', senderName: 'Kwame Asante', senderAvatarColor: _c8, content: 'Welcome to the Debate Society chat! 🎙️', timestamp: DateTime.now().subtract(const Duration(days: 5))),
  CommunityMessage(id: 'dm2', senderId: 'm4', senderName: 'Amara Diallo', senderAvatarColor: _c5, content: 'Thanks for having me! So excited to be here.', timestamp: DateTime.now().subtract(const Duration(days: 4, hours: 22))),
  CommunityMessage(id: 'dm3', senderId: 'm2', senderName: 'Fatima Al-Hassan', senderAvatarColor: _c2, content: 'Can we vote on Saturday\'s motion? I have two options ready.', timestamp: DateTime.now().subtract(const Duration(days: 3))),
  CommunityMessage(id: 'dm4', senderId: 'm3', senderName: 'Chidi Okonkwo', senderAvatarColor: _c4, content: 'Option 1 sounds stronger for practice. More nuance to explore.', timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 18))),
  CommunityMessage(id: 'dm5', senderId: 'm5', senderName: 'Sipho Dlamini', senderAvatarColor: _c6, content: '+1 for Option 1. Let\'s do it!', timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 17))),
  CommunityMessage(id: 'dm6', senderId: 'm7', senderName: 'Emeka Eze', senderAvatarColor: _c3, content: 'Who\'s bringing snacks this time 😂', timestamp: DateTime.now().subtract(const Duration(hours: 12))),
  CommunityMessage(id: 'dm7', senderId: 'm8', senderName: 'Zara Mbeki', senderAvatarColor: _c1, content: 'I\'ve got it covered 🍕', timestamp: DateTime.now().subtract(const Duration(hours: 11, minutes: 30))),
  CommunityMessage(id: 'dm8', senderId: 'm1', senderName: 'Kwame Asante', senderAvatarColor: _c8, content: 'See everyone Saturday! Don\'t forget to prepare 🔥', timestamp: DateTime.now().subtract(const Duration(hours: 1))),
];

// ---------------------------------------------------------------------------
// 2. Entrepreneurship Club
// ---------------------------------------------------------------------------
final _entrepreneurMembers = [
  CommunityMember(id: 'e1', name: 'Aisha Mensah', role: 'Leader', joinedDate: DateTime(2025, 8, 20), avatarColor: _c5),
  CommunityMember(id: 'e2', name: 'Kofi Boateng', role: 'Moderator', joinedDate: DateTime(2025, 8, 25), avatarColor: _c3),
  CommunityMember(id: 'e3', name: 'Yemi Adeyemi', role: 'Member', joinedDate: DateTime(2025, 9, 3), avatarColor: _c1),
  CommunityMember(id: 'e4', name: 'Lena Kirabo', role: 'Member', joinedDate: DateTime(2025, 9, 15), avatarColor: _c4),
  CommunityMember(id: 'e5', name: 'Rafi Nkrumah', role: 'Member', joinedDate: DateTime(2025, 10, 5), avatarColor: _c2),
  CommunityMember(id: 'e6', name: 'Sadie Osei', role: 'Member', joinedDate: DateTime(2025, 11, 10), avatarColor: _c6),
  CommunityMember(id: 'e7', name: 'Marcus Tutu', role: 'Member', joinedDate: DateTime(2026, 1, 20), avatarColor: _c7),
  CommunityMember(id: 'e8', name: 'Nia Nakagawa', role: 'Member', joinedDate: DateTime(2026, 2, 5), avatarColor: _c8),
  CommunityMember(id: 'e9', name: 'Felix Oduya', role: 'Member', joinedDate: DateTime(2026, 3, 1), avatarColor: _c1),
  CommunityMember(id: 'e10', name: 'Grace Wanjiku', role: 'Member', joinedDate: DateTime(2026, 3, 18), avatarColor: _c4),
];

final _entrepreneurPosts = [
  CommunityPost(id: 'ep1', authorId: 'e1', authorName: 'Aisha Mensah', authorAvatarColor: _c5,
    content: '🚀 We just got accepted into the ALU Ventures pre-accelerator! Our fintech idea is officially a real thing. Thank you all for the early feedback sessions — you helped shape this.',
    timestamp: DateTime.now().subtract(const Duration(hours: 3)), likeCount: 47),
  CommunityPost(id: 'ep2', authorId: 'e2', authorName: 'Kofi Boateng', authorAvatarColor: _c3,
    content: 'Reading group this week: "The Lean Startup" chapters 7–9. Summary doc in the shared drive. Let\'s discuss at Thursday\'s session!',
    timestamp: DateTime.now().subtract(const Duration(hours: 10)), likeCount: 22),
  CommunityPost(id: 'ep3', authorId: 'e4', authorName: 'Lena Kirabo', authorAvatarColor: _c4,
    content: 'Does anyone have experience with M-Pesa API integration? Working on a payment module for my MVP and getting stuck on sandbox auth.',
    timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 5)), likeCount: 9),
  CommunityPost(id: 'ep4', authorId: 'e7', authorName: 'Marcus Tutu', authorAvatarColor: _c7,
    content: 'Sharing this incredible deck from the Techstars Africa founder — best breakdown of PMF I\'ve seen. Will post the link in chat.',
    timestamp: DateTime.now().subtract(const Duration(days: 2)), likeCount: 34),
];

final _entrepreneurMessages = [
  CommunityMessage(id: 'em1', senderId: 'e1', senderName: 'Aisha Mensah', senderAvatarColor: _c5, content: 'Welcome to the E-Club family! 🦁 Big ideas only.', timestamp: DateTime.now().subtract(const Duration(days: 6))),
  CommunityMessage(id: 'em2', senderId: 'e3', senderName: 'Yemi Adeyemi', senderAvatarColor: _c1, content: 'Anyone pitching at the startup fair next month?', timestamp: DateTime.now().subtract(const Duration(days: 4))),
  CommunityMessage(id: 'em3', senderId: 'e5', senderName: 'Rafi Nkrumah', senderAvatarColor: _c2, content: 'I\'m in! Need a co-founder for the design side though 🎨', timestamp: DateTime.now().subtract(const Duration(days: 3, hours: 20))),
  CommunityMessage(id: 'em4', senderId: 'e4', senderName: 'Lena Kirabo', senderAvatarColor: _c4, content: 'I do Figma! DM me your idea Rafi.', timestamp: DateTime.now().subtract(const Duration(days: 3, hours: 19))),
  CommunityMessage(id: 'em5', senderId: 'e2', senderName: 'Kofi Boateng', senderAvatarColor: _c3, content: 'Thursday office hours are OPEN. Bring your pitch decks for feedback 💡', timestamp: DateTime.now().subtract(const Duration(hours: 14))),
  CommunityMessage(id: 'em6', senderId: 'e9', senderName: 'Felix Oduya', senderAvatarColor: _c1, content: 'Can\'t make Thursday — will the session be recorded?', timestamp: DateTime.now().subtract(const Duration(hours: 6))),
  CommunityMessage(id: 'em7', senderId: 'e1', senderName: 'Aisha Mensah', senderAvatarColor: _c5, content: 'Yes! Zoom link will be shared 30 mins before.', timestamp: DateTime.now().subtract(const Duration(hours: 5, minutes: 45))),
];

// ---------------------------------------------------------------------------
// 3. Tech & Innovation Hub
// ---------------------------------------------------------------------------
final _techMembers = [
  CommunityMember(id: 't1', name: 'Dara Abimbola', role: 'Leader', joinedDate: DateTime(2025, 8, 15), avatarColor: _c3),
  CommunityMember(id: 't2', name: 'Sami Osei-Bonsu', role: 'Moderator', joinedDate: DateTime(2025, 8, 22), avatarColor: _c8),
  CommunityMember(id: 't3', name: 'Precious Olu', role: 'Member', joinedDate: DateTime(2025, 9, 8), avatarColor: _c6),
  CommunityMember(id: 't4', name: 'Ahmed Farah', role: 'Member', joinedDate: DateTime(2025, 9, 20), avatarColor: _c5),
  CommunityMember(id: 't5', name: 'Lila Munyaradzi', role: 'Member', joinedDate: DateTime(2025, 10, 10), avatarColor: _c2),
  CommunityMember(id: 't6', name: 'Chris Acheampong', role: 'Member', joinedDate: DateTime(2025, 11, 5), avatarColor: _c4),
  CommunityMember(id: 't7', name: 'Amina Sesay', role: 'Member', joinedDate: DateTime(2026, 1, 12), avatarColor: _c7),
  CommunityMember(id: 't8', name: 'Tunde Adebisi', role: 'Member', joinedDate: DateTime(2026, 2, 28), avatarColor: _c1),
  CommunityMember(id: 't9', name: 'Joy Ekwueme', role: 'Member', joinedDate: DateTime(2026, 3, 10), avatarColor: _c4),
  CommunityMember(id: 't10', name: 'Kwesi Asare', role: 'Member', joinedDate: DateTime(2026, 3, 25), avatarColor: _c6),
  CommunityMember(id: 't11', name: 'Miriam Nyagah', role: 'Member', joinedDate: DateTime(2026, 4, 2), avatarColor: _c2),
  CommunityMember(id: 't12', name: 'Daniel Obi', role: 'Member', joinedDate: DateTime(2026, 4, 18), avatarColor: _c3),
];

final _techPosts = [
  CommunityPost(id: 'tp1', authorId: 't1', authorName: 'Dara Abimbola', authorAvatarColor: _c3,
    content: '🛠️ Open-source Friday is back! This week we\'re contributing to an ALU-built open source tool. Fork the repo, pick an issue, and let\'s ship something together. Links in chat.',
    timestamp: DateTime.now().subtract(const Duration(hours: 1)), likeCount: 38),
  CommunityPost(id: 'tp2', authorId: 't4', authorName: 'Ahmed Farah', authorAvatarColor: _c5,
    content: 'Just finished the CS50 AI track — honestly life-changing. Highly recommend for anyone getting into machine learning. Happy to answer questions!',
    timestamp: DateTime.now().subtract(const Duration(hours: 9)), likeCount: 26),
  CommunityPost(id: 'tp3', authorId: 't2', authorName: 'Sami Osei-Bonsu', authorAvatarColor: _c8,
    content: 'Flutter vs React Native — let\'s settle this. Drop your take below 👇 (I\'m team Flutter but I can be convinced 😄)',
    timestamp: DateTime.now().subtract(const Duration(days: 1)), likeCount: 51),
  CommunityPost(id: 'tp4', authorId: 't6', authorName: 'Chris Acheampong', authorAvatarColor: _c4,
    content: 'Resource drop 📚 — curated list of free AWS certs prep material. Perfect for the long weekend. Check the pinned announcement for context.',
    timestamp: DateTime.now().subtract(const Duration(days: 3)), likeCount: 42),
];

final _techMessages = [
  CommunityMessage(id: 'tm1', senderId: 't1', senderName: 'Dara Abimbola', senderAvatarColor: _c3, content: '👾 Welcome to the hub! Build first, ask questions later.', timestamp: DateTime.now().subtract(const Duration(days: 7))),
  CommunityMessage(id: 'tm2', senderId: 't3', senderName: 'Precious Olu', senderAvatarColor: _c6, content: 'Can someone explain REST vs GraphQL simply? I keep forgetting.', timestamp: DateTime.now().subtract(const Duration(days: 5))),
  CommunityMessage(id: 'tm3', senderId: 't2', senderName: 'Sami Osei-Bonsu', senderAvatarColor: _c8, content: 'REST = fixed endpoints. GraphQL = ask exactly for what you need. Think of REST as a set menu vs GraphQL as à la carte 🍽️', timestamp: DateTime.now().subtract(const Duration(days: 4, hours: 22))),
  CommunityMessage(id: 'tm4', senderId: 't5', senderName: 'Lila Munyaradzi', senderAvatarColor: _c2, content: 'That analogy is PERFECT 😭', timestamp: DateTime.now().subtract(const Duration(days: 4, hours: 21))),
  CommunityMessage(id: 'tm5', senderId: 't7', senderName: 'Amina Sesay', senderAvatarColor: _c7, content: 'Hackathon team formation — who\'s looking for a mobile dev?', timestamp: DateTime.now().subtract(const Duration(hours: 20))),
  CommunityMessage(id: 'tm6', senderId: 't9', senderName: 'Joy Ekwueme', senderAvatarColor: _c4, content: 'Me! I do backend (Node/Python). DM me!', timestamp: DateTime.now().subtract(const Duration(hours: 19, minutes: 45))),
  CommunityMessage(id: 'tm7', senderId: 't4', senderName: 'Ahmed Farah', senderAvatarColor: _c5, content: 'Open source Friday hype! I already picked an issue 🔥', timestamp: DateTime.now().subtract(const Duration(hours: 2))),
];

// ---------------------------------------------------------------------------
// 4. Women in Leadership
// ---------------------------------------------------------------------------
final _womenMembers = [
  CommunityMember(id: 'w1', name: 'Amara Owusu', role: 'Leader', joinedDate: DateTime(2025, 9, 1), avatarColor: _c7),
  CommunityMember(id: 'w2', name: 'Chisom Nwosu', role: 'Moderator', joinedDate: DateTime(2025, 9, 8), avatarColor: _c2),
  CommunityMember(id: 'w3', name: 'Isatou Jallow', role: 'Member', joinedDate: DateTime(2025, 9, 20), avatarColor: _c5),
  CommunityMember(id: 'w4', name: 'Zoe Mwangi', role: 'Member', joinedDate: DateTime(2025, 10, 1), avatarColor: _c4),
  CommunityMember(id: 'w5', name: 'Hana Tadesse', role: 'Member', joinedDate: DateTime(2025, 10, 18), avatarColor: _c1),
  CommunityMember(id: 'w6', name: 'Naledi Dube', role: 'Member', joinedDate: DateTime(2025, 11, 5), avatarColor: _c6),
  CommunityMember(id: 'w7', name: 'Efua Ansah', role: 'Member', joinedDate: DateTime(2026, 1, 15), avatarColor: _c3),
  CommunityMember(id: 'w8', name: 'Rukayat Lawal', role: 'Member', joinedDate: DateTime(2026, 2, 22), avatarColor: _c8),
];

final _womenPosts = [
  CommunityPost(id: 'wp1', authorId: 'w1', authorName: 'Amara Owusu', authorAvatarColor: _c7,
    content: '✨ Our mentorship match results are out! Check your email for your mentor\'s contact. First session should be within the next 2 weeks. So proud of this cohort!',
    timestamp: DateTime.now().subtract(const Duration(hours: 4)), likeCount: 53),
  CommunityPost(id: 'wp2', authorId: 'w3', authorName: 'Isatou Jallow', authorAvatarColor: _c5,
    content: 'Book club pick for July: "Lean In" by Sheryl Sandberg. I know it\'s controversial — that\'s exactly why we should read and discuss it critically.',
    timestamp: DateTime.now().subtract(const Duration(hours: 16)), likeCount: 29),
  CommunityPost(id: 'wp3', authorId: 'w2', authorName: 'Chisom Nwosu', authorAvatarColor: _c2,
    content: 'Just landed a summer internship at a top VC firm! If anyone wants to learn about the application process, I\'m happy to do a 30-min chat. Just sign up in the sheet below.',
    timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 8)), likeCount: 67),
];

final _womenMessages = [
  CommunityMessage(id: 'wm1', senderId: 'w1', senderName: 'Amara Owusu', senderAvatarColor: _c7, content: 'This space is for lifting each other up. All voices welcome 💜', timestamp: DateTime.now().subtract(const Duration(days: 6))),
  CommunityMessage(id: 'wm2', senderId: 'w4', senderName: 'Zoe Mwangi', senderAvatarColor: _c4, content: 'Has anyone done the consulting track at ALU? Thinking of switching.', timestamp: DateTime.now().subtract(const Duration(days: 3))),
  CommunityMessage(id: 'wm3', senderId: 'w2', senderName: 'Chisom Nwosu', senderAvatarColor: _c2, content: 'I did! Happy to talk through it. Very intense but so worth it.', timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 23))),
  CommunityMessage(id: 'wm4', senderId: 'w6', senderName: 'Naledi Dube', senderAvatarColor: _c6, content: 'Career fair next week — anyone prepping their elevator pitch?', timestamp: DateTime.now().subtract(const Duration(hours: 8))),
  CommunityMessage(id: 'wm5', senderId: 'w5', senderName: 'Hana Tadesse', senderAvatarColor: _c1, content: 'We should do a mock pitch session tomorrow evening!', timestamp: DateTime.now().subtract(const Duration(hours: 7, minutes: 30))),
  CommunityMessage(id: 'wm6', senderId: 'w1', senderName: 'Amara Owusu', senderAvatarColor: _c7, content: 'GREAT idea. 7pm in the student lounge — I\'ll bring the flip chart 📋', timestamp: DateTime.now().subtract(const Duration(hours: 7))),
];

// ---------------------------------------------------------------------------
// 5. Creative Arts Collective
// ---------------------------------------------------------------------------
final _artsMembers = [
  CommunityMember(id: 'a1', name: 'Tolu Fashola', role: 'Leader', joinedDate: DateTime(2025, 9, 2), avatarColor: _c1),
  CommunityMember(id: 'a2', name: 'Karim Diop', role: 'Moderator', joinedDate: DateTime(2025, 9, 12), avatarColor: _c5),
  CommunityMember(id: 'a3', name: 'Yemi Kalu', role: 'Member', joinedDate: DateTime(2025, 10, 5), avatarColor: _c4),
  CommunityMember(id: 'a4', name: 'Sasha Ngozi', role: 'Member', joinedDate: DateTime(2025, 10, 28), avatarColor: _c2),
  CommunityMember(id: 'a5', name: 'Ibrahim Traore', role: 'Member', joinedDate: DateTime(2025, 11, 15), avatarColor: _c3),
  CommunityMember(id: 'a6', name: 'Mia Coetzee', role: 'Member', joinedDate: DateTime(2026, 1, 25), avatarColor: _c6),
];

final _artsPosts = [
  CommunityPost(id: 'ap1', authorId: 'a1', authorName: 'Tolu Fashola', authorAvatarColor: _c1,
    content: '🎨 ALU End-of-Semester Arts Show submissions are OPEN! Theme: "Africa Reimagined." All mediums welcome — digital, painting, photography, spoken word, film. Submit by June 30.',
    timestamp: DateTime.now().subtract(const Duration(hours: 6)), likeCount: 44),
  CommunityPost(id: 'ap2', authorId: 'a3', authorName: 'Yemi Kalu', authorAvatarColor: _c4,
    content: 'Sharing my latest portrait series "The Entrepreneurs of Kigali." 6 months of work finally done. Feedback welcome — brutal honesty preferred.',
    timestamp: DateTime.now().subtract(const Duration(hours: 20)), likeCount: 37),
  CommunityPost(id: 'ap3', authorId: 'a2', authorName: 'Karim Diop', authorAvatarColor: _c5,
    content: 'Skill swap opportunity! I teach photography composition in exchange for someone teaching me video editing (Premiere or Final Cut). Any takers?',
    timestamp: DateTime.now().subtract(const Duration(days: 2)), likeCount: 19),
];

final _artsMessages = [
  CommunityMessage(id: 'am1', senderId: 'a1', senderName: 'Tolu Fashola', senderAvatarColor: _c1, content: 'Creativity is our superpower 🎭 Welcome everyone!', timestamp: DateTime.now().subtract(const Duration(days: 5))),
  CommunityMessage(id: 'am2', senderId: 'a4', senderName: 'Sasha Ngozi', senderAvatarColor: _c2, content: 'Who\'s going to the Kigali arts market this weekend?', timestamp: DateTime.now().subtract(const Duration(days: 2))),
  CommunityMessage(id: 'am3', senderId: 'a6', senderName: 'Mia Coetzee', senderAvatarColor: _c6, content: 'Me! Let\'s meet up there and do a little photo walk 📸', timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 23))),
  CommunityMessage(id: 'am4', senderId: 'a5', senderName: 'Ibrahim Traore', senderAvatarColor: _c3, content: 'Count me in! I need inspiration for my Arts Show piece.', timestamp: DateTime.now().subtract(const Duration(hours: 10))),
];

// ---------------------------------------------------------------------------
// 6. Climate Action Network
// ---------------------------------------------------------------------------
final _climateMembers = [
  CommunityMember(id: 'cl1', name: 'Adaeze Obi', role: 'Leader', joinedDate: DateTime(2025, 9, 5), avatarColor: _c4),
  CommunityMember(id: 'cl2', name: 'Samuel Kipchoge', role: 'Moderator', joinedDate: DateTime(2025, 9, 15), avatarColor: _c6),
  CommunityMember(id: 'cl3', name: 'Fatou Diallo', role: 'Member', joinedDate: DateTime(2025, 10, 1), avatarColor: _c5),
  CommunityMember(id: 'cl4', name: 'Neo Molefe', role: 'Member', joinedDate: DateTime(2025, 10, 20), avatarColor: _c3),
  CommunityMember(id: 'cl5', name: 'Anna Mwenda', role: 'Member', joinedDate: DateTime(2025, 11, 8), avatarColor: _c2),
  CommunityMember(id: 'cl6', name: 'Bayo Alabi', role: 'Member', joinedDate: DateTime(2026, 2, 3), avatarColor: _c8),
  CommunityMember(id: 'cl7', name: 'Ritu Sharma', role: 'Member', joinedDate: DateTime(2026, 3, 12), avatarColor: _c7),
];

final _climatePosts = [
  CommunityPost(id: 'clp1', authorId: 'cl1', authorName: 'Adaeze Obi', authorAvatarColor: _c4,
    content: '🌿 Campus clean-up drive this Sunday 8am! We\'ll be doing the green spaces near the tech hub. Gloves and bags provided. Bring a friend — let\'s show ALU cares.',
    timestamp: DateTime.now().subtract(const Duration(hours: 5)), likeCount: 33),
  CommunityPost(id: 'clp2', authorId: 'cl3', authorName: 'Fatou Diallo', authorAvatarColor: _c5,
    content: 'Submitted our proposal for the UN Youth Climate Fellowship! 12 of us applied as a group. Results in August — fingers crossed 🤞',
    timestamp: DateTime.now().subtract(const Duration(days: 1)), likeCount: 58),
  CommunityPost(id: 'clp3', authorId: 'cl2', authorName: 'Samuel Kipchoge', authorAvatarColor: _c6,
    content: 'Data point: ALU\'s solar panels saved 14 tonnes of CO2 this semester alone. Let\'s push for 20 next semester with better energy habits on campus.',
    timestamp: DateTime.now().subtract(const Duration(days: 3)), likeCount: 45),
];

final _climateMessages = [
  CommunityMessage(id: 'clm1', senderId: 'cl1', senderName: 'Adaeze Obi', senderAvatarColor: _c4, content: '🌍 Small actions, big impact. Let\'s go!', timestamp: DateTime.now().subtract(const Duration(days: 7))),
  CommunityMessage(id: 'clm2', senderId: 'cl4', senderName: 'Neo Molefe', senderAvatarColor: _c3, content: 'Should we propose a plastic-free policy for the cafeteria?', timestamp: DateTime.now().subtract(const Duration(days: 4))),
  CommunityMessage(id: 'clm3', senderId: 'cl1', senderName: 'Adaeze Obi', senderAvatarColor: _c4, content: 'Already drafted a proposal! Reviewing with the Student Council next week.', timestamp: DateTime.now().subtract(const Duration(days: 3, hours: 22))),
  CommunityMessage(id: 'clm4', senderId: 'cl7', senderName: 'Ritu Sharma', senderAvatarColor: _c7, content: 'Yasss! I\'ll gather signature support from my cohort.', timestamp: DateTime.now().subtract(const Duration(hours: 18))),
];

// ---------------------------------------------------------------------------
// 7. ALU Sports Council
// ---------------------------------------------------------------------------
final _sportsMembers = [
  CommunityMember(id: 's1', name: 'Femi Adesanya', role: 'Leader', joinedDate: DateTime(2025, 8, 28), avatarColor: _c1),
  CommunityMember(id: 's2', name: 'Awa Coulibaly', role: 'Moderator', joinedDate: DateTime(2025, 9, 5), avatarColor: _c3),
  CommunityMember(id: 's3', name: 'Chibuike Nze', role: 'Member', joinedDate: DateTime(2025, 9, 18), avatarColor: _c5),
  CommunityMember(id: 's4', name: 'Sifiso Dlamini', role: 'Member', joinedDate: DateTime(2025, 10, 8), avatarColor: _c4),
  CommunityMember(id: 's5', name: 'Leila Kone', role: 'Member', joinedDate: DateTime(2025, 10, 25), avatarColor: _c2),
  CommunityMember(id: 's6', name: 'Emile Habimana', role: 'Member', joinedDate: DateTime(2025, 11, 12), avatarColor: _c6),
  CommunityMember(id: 's7', name: 'Titi Olawale', role: 'Member', joinedDate: DateTime(2026, 1, 5), avatarColor: _c7),
  CommunityMember(id: 's8', name: 'Patrick Gahigi', role: 'Member', joinedDate: DateTime(2026, 2, 10), avatarColor: _c8),
];

final _sportsPosts = [
  CommunityPost(id: 'sp1', authorId: 's1', authorName: 'Femi Adesanya', authorAvatarColor: _c1,
    content: '⚽ Inter-cohort football tournament brackets are LIVE! S2024 vs S2026 in the opener — Saturday at 3pm. Main field. Come support your cohort!',
    timestamp: DateTime.now().subtract(const Duration(hours: 2)), likeCount: 62),
  CommunityPost(id: 'sp2', authorId: 's3', authorName: 'Chibuike Nze', authorAvatarColor: _c5,
    content: 'Morning run crew! 5:30am every Tuesday and Thursday from the main gate. All paces welcome — we go together, we finish together. Who\'s joining?',
    timestamp: DateTime.now().subtract(const Duration(hours: 14)), likeCount: 28),
  CommunityPost(id: 'sp3', authorId: 's2', authorName: 'Awa Coulibaly', authorAvatarColor: _c3,
    content: 'Basketball court bookings are now online! No more queueing at the front desk. Link in the pinned announcement.',
    timestamp: DateTime.now().subtract(const Duration(days: 2)), likeCount: 41),
];

final _sportsMessages = [
  CommunityMessage(id: 'ssm1', senderId: 's1', senderName: 'Femi Adesanya', senderAvatarColor: _c1, content: '🏆 No excuses. Just results. Let\'s get active!', timestamp: DateTime.now().subtract(const Duration(days: 5))),
  CommunityMessage(id: 'ssm2', senderId: 's5', senderName: 'Leila Kone', senderAvatarColor: _c2, content: 'Gym is packed at 6pm these days. Anyone know quieter hours?', timestamp: DateTime.now().subtract(const Duration(days: 3))),
  CommunityMessage(id: 'ssm3', senderId: 's4', senderName: 'Sifiso Dlamini', senderAvatarColor: _c4, content: 'Try 8am or after 9pm! Much better.', timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 22))),
  CommunityMessage(id: 'ssm4', senderId: 's7', senderName: 'Titi Olawale', senderAvatarColor: _c7, content: 'Football tournament hype is real 🔥 S2024 won\'t know what hit them', timestamp: DateTime.now().subtract(const Duration(hours: 5))),
  CommunityMessage(id: 'ssm5', senderId: 's3', senderName: 'Chibuike Nze', senderAvatarColor: _c5, content: 'Bold words from someone who missed last practice 😂', timestamp: DateTime.now().subtract(const Duration(hours: 4, minutes: 45))),
];

// ---------------------------------------------------------------------------
// 8. Data Science Guild
// ---------------------------------------------------------------------------
final _dataMembers = [
  CommunityMember(id: 'd1', name: 'Nkechi Eze', role: 'Leader', joinedDate: DateTime(2025, 9, 3), avatarColor: _c6),
  CommunityMember(id: 'd2', name: 'Omar Sow', role: 'Moderator', joinedDate: DateTime(2025, 9, 10), avatarColor: _c3),
  CommunityMember(id: 'd3', name: 'Yvonne Asantewaa', role: 'Member', joinedDate: DateTime(2025, 9, 25), avatarColor: _c5),
  CommunityMember(id: 'd4', name: 'Kolade Idowu', role: 'Member', joinedDate: DateTime(2025, 10, 12), avatarColor: _c8),
  CommunityMember(id: 'd5', name: 'Blessing Eze', role: 'Member', joinedDate: DateTime(2025, 11, 3), avatarColor: _c1),
  CommunityMember(id: 'd6', name: 'Habib Moussav', role: 'Member', joinedDate: DateTime(2026, 1, 17), avatarColor: _c4),
  CommunityMember(id: 'd7', name: 'Priya Nkusi', role: 'Member', joinedDate: DateTime(2026, 2, 8), avatarColor: _c2),
  CommunityMember(id: 'd8', name: 'Leo Tshisekedi', role: 'Member', joinedDate: DateTime(2026, 3, 5), avatarColor: _c7),
  CommunityMember(id: 'd9', name: 'Abena Appiah', role: 'Member', joinedDate: DateTime(2026, 4, 1), avatarColor: _c4),
];

final _dataPosts = [
  CommunityPost(id: 'dap1', authorId: 'd1', authorName: 'Nkechi Eze', authorAvatarColor: _c6,
    content: '📊 Kaggle competition alert! We\'re entering as a team — topic is healthcare access in sub-Saharan Africa. Perfect alignment with ALU\'s mission. Sign up in the shared doc.',
    timestamp: DateTime.now().subtract(const Duration(hours: 3)), likeCount: 39),
  CommunityPost(id: 'dap2', authorId: 'd3', authorName: 'Yvonne Asantewaa', authorAvatarColor: _c5,
    content: 'Built a dashboard tracking job postings for data roles across African cities. Nairobi leads with 47% of listings. Lagos second at 29%. Kigali growing fast at 11%! Exciting data.',
    timestamp: DateTime.now().subtract(const Duration(hours: 11)), likeCount: 55),
  CommunityPost(id: 'dap3', authorId: 'd2', authorName: 'Omar Sow', authorAvatarColor: _c3,
    content: 'Weekly challenge: clean this messy real-world dataset and produce 3 actionable insights. Winner gets a shoutout (and bragging rights). Dataset link in chat 🧹',
    timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 4)), likeCount: 27),
  CommunityPost(id: 'dap4', authorId: 'd5', authorName: 'Blessing Eze', authorAvatarColor: _c1,
    content: 'SQL vs Python for data wrangling — hot take: SQL will take you further faster if you\'re just starting out. Fight me in the comments.',
    timestamp: DateTime.now().subtract(const Duration(days: 2)), likeCount: 33),
];

final _dataMessages = [
  CommunityMessage(id: 'dam1', senderId: 'd1', senderName: 'Nkechi Eze', senderAvatarColor: _c6, content: '📈 Data tells stories. We learn the language. Welcome!', timestamp: DateTime.now().subtract(const Duration(days: 6))),
  CommunityMessage(id: 'dam2', senderId: 'd4', senderName: 'Kolade Idowu', senderAvatarColor: _c8, content: 'Best free resource to learn Pandas? Starting from scratch.', timestamp: DateTime.now().subtract(const Duration(days: 4))),
  CommunityMessage(id: 'dam3', senderId: 'd2', senderName: 'Omar Sow', senderAvatarColor: _c3, content: 'Kaggle Learn — free, hands-on, no fluff. Start there.', timestamp: DateTime.now().subtract(const Duration(days: 3, hours: 23))),
  CommunityMessage(id: 'dam4', senderId: 'd7', senderName: 'Priya Nkusi', senderAvatarColor: _c2, content: 'Also check "Python for Data Analysis" by Wes McKinney. It\'s the pandas bible.', timestamp: DateTime.now().subtract(const Duration(days: 3, hours: 22))),
  CommunityMessage(id: 'dam5', senderId: 'd9', senderName: 'Abena Appiah', senderAvatarColor: _c4, content: 'Who else is doing the Kaggle competition? Need a Python expert on our team!', timestamp: DateTime.now().subtract(const Duration(hours: 9))),
  CommunityMessage(id: 'dam6', senderId: 'd6', senderName: 'Habib Moussav', senderAvatarColor: _c4, content: 'I\'m in. DM me your idea and let\'s chat.', timestamp: DateTime.now().subtract(const Duration(hours: 8, minutes: 30))),
];

// ---------------------------------------------------------------------------
// Master list
// ---------------------------------------------------------------------------
final List<Community> mockCommunities = [
  Community(
    id: 'c1',
    name: 'ALU Debate Society',
    description: 'Sharpen your arguments and develop critical thinking through competitive debate. We cover topics from African politics to global tech ethics.',
    category: 'Academic',
    color: const Color(0xFF3949AB),
    icon: Icons.record_voice_over_rounded,
    pinnedAnnouncement: '📌 Upcoming: Inter-University Debate Championship — Kigali, July 20. Applications to represent ALU close June 25. DM Kwame to apply.',
    tags: ['Critical Thinking', 'Public Speaking', 'Policy'],
    members: _debateMebers,
    posts: _debatePosts,
    messages: _debateMessages,
  ),
  Community(
    id: 'c2',
    name: 'Entrepreneurship Club',
    description: 'From idea to MVP — the E-Club supports founders at every stage. Pitch sessions, investor access, peer feedback, and co-founder matching.',
    category: 'Startup',
    color: const Color(0xFFE65100),
    icon: Icons.rocket_launch_rounded,
    pinnedAnnouncement: '📌 Pre-Accelerator applications close July 1! Submit your 1-page executive summary to aisha@alu.edu. Cohort limited to 8 teams.',
    tags: ['Entrepreneurship', 'Startups', 'Funding'],
    members: _entrepreneurMembers,
    posts: _entrepreneurPosts,
    messages: _entrepreneurMessages,
    isJoined: true,
  ),
  Community(
    id: 'c3',
    name: 'Tech & Innovation Hub',
    description: 'Your home for builders, hackers, and makers. Open-source contributions, hackathon squads, study groups, and weekly tech talks.',
    category: 'Technology',
    color: const Color(0xFF1565C0),
    icon: Icons.code_rounded,
    pinnedAnnouncement: '📌 Open Source Friday is every week! Contribute to alu-connect-os on GitHub. First-time contributors get a special badge 🏅',
    tags: ['Software', 'Open Source', 'Hackathons'],
    members: _techMembers,
    posts: _techPosts,
    messages: _techMessages,
    isJoined: true,
  ),
  Community(
    id: 'c4',
    name: 'Women in Leadership',
    description: 'A safe, empowering space for women at ALU to connect, grow, and lead. Mentorship circles, skill workshops, and leadership opportunities.',
    category: 'Leadership',
    color: const Color(0xFF6A1B9A),
    icon: Icons.star_rounded,
    pinnedAnnouncement: '📌 Mentorship Programme is now open! 15 senior student mentors available. Fill the interest form before June 20 to be matched.',
    tags: ['Mentorship', 'Leadership', 'Networking'],
    members: _womenMembers,
    posts: _womenPosts,
    messages: _womenMessages,
  ),
  Community(
    id: 'c5',
    name: 'Creative Arts Collective',
    description: 'A creative sanctuary for artists, writers, photographers, filmmakers, and musicians. Exhibitions, skill swaps, and collaborative projects.',
    category: 'Arts & Culture',
    color: const Color(0xFFC2185B),
    icon: Icons.palette_rounded,
    pinnedAnnouncement: '📌 End-of-Semester Arts Show: "Africa Reimagined." All mediums welcome. Submit your work to tolu@alu.edu by June 30.',
    tags: ['Art', 'Photography', 'Music', 'Film'],
    members: _artsMembers,
    posts: _artsPosts,
    messages: _artsMessages,
  ),
  Community(
    id: 'c6',
    name: 'Climate Action Network',
    description: 'Students committed to environmental sustainability on campus and beyond. Policy advocacy, climate research, and direct action projects.',
    category: 'Social Impact',
    color: const Color(0xFF2E7D32),
    icon: Icons.eco_rounded,
    pinnedAnnouncement: '📌 Campus Clean-Up Drive this Sunday at 8am — meet at the main gate. UN Youth Climate Fellowship applications now open for ALU students.',
    tags: ['Sustainability', 'Climate', 'Advocacy'],
    members: _climateMembers,
    posts: _climatePosts,
    messages: _climateMessages,
  ),
  Community(
    id: 'c7',
    name: 'ALU Sports Council',
    description: 'Organising inter-cohort competitions, fitness challenges, and wellness events. Football, basketball, track, and more.',
    category: 'Sports & Wellness',
    color: const Color(0xFFD92B2B),
    icon: Icons.sports_soccer_rounded,
    pinnedAnnouncement: '📌 Inter-Cohort Football Tournament kicks off Saturday at 3pm — Main Field. Basketball court booking is now online (link in chat).',
    tags: ['Football', 'Basketball', 'Fitness', 'Wellness'],
    members: _sportsMembers,
    posts: _sportsPosts,
    messages: _sportsMessages,
  ),
  Community(
    id: 'c8',
    name: 'Data Science Guild',
    description: 'Turning data into decisions. Kaggle competitions, real-world projects with African datasets, weekly challenges, and career prep.',
    category: 'Technology',
    color: const Color(0xFF00695C),
    icon: Icons.bar_chart_rounded,
    pinnedAnnouncement: '📌 Kaggle Team Registration closes June 22! Topic: Healthcare access in sub-Saharan Africa. Join as individual or team of up to 4.',
    tags: ['Data Science', 'Machine Learning', 'Analytics'],
    members: _dataMembers,
    posts: _dataPosts,
    messages: _dataMessages,
  ),
];
