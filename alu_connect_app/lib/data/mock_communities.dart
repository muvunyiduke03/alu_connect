class Community {
  final String id;
  final String name;
  final String description;
  final int memberCount;
  final String category; 
  final List<String> announcements;
  final List<ChatMessage> messages;

  Community({
    required this.id,
    required this.name,
    required this.description,
    required this.memberCount,
    required this.category,
    required this.announcements,
    required this.messages,
  });
}

class ChatMessage {
  final String senderName;
  final String text;
  final bool isMe; 

  ChatMessage({
    required this.senderName,
    required this.text,
    required this.isMe,
  });
}

// Mock list of communities
List<Community> mockCommunities = [
  Community(
    id: 'c1',
    name: 'Tech Club ALU',
    description: 'For students passionate about software, hardware, and innovation.',
    memberCount: 142,
    category: 'Tech',
    announcements: [
      'Hackathon registration closes Friday 26/6/2026',
      'New workshop: Intro to Cybersecurity this Saturday.',
    ],
    messages: [
      ChatMessage(senderName: 'Kwame', text: 'Anyone joining the hackathon?', isMe: false),
      ChatMessage(senderName: 'You', text: 'Yes! I am looking for a teammate.', isMe: true),
    ],
  ),
  Community(
    id: 'c2',
    name: 'Entrepreneurship Society',
    description: 'Connect with founders, pitch ideas, and find co-founders for your startup.',
    memberCount: 98,
    category: 'Entrepreneurship',
    announcements: [
      'Pitch night next Thursday!\nsign up now!!',
    ],
    messages: [
      ChatMessage(senderName: 'Amina', text: 'Does anyone looking for a co-founder for a fintech idea?', isMe: false),
    ],
  ),
  Community(
    id: 'c3',
    name: 'Cohort 8',
    description: 'Official group for Cohort 8 students.',
    memberCount: 210,
    category: 'Cohort',
    announcements: [
      'Mission Monday session moved to 4PM.',
    ],
    messages: [
      ChatMessage(senderName: 'Joseph', text: 'Does anyone have notes from today\'s session?', isMe: false),
      ChatMessage(senderName: 'You', text: 'I\'ll share mine in a bit.', isMe: true),
    ],
  ),
  Community(
    id: 'c4',
    name: 'Arts Club',
    description: 'Official group for Art enthusiasts.',
    memberCount: 210,
    category: 'Cohort',
    announcements: [
      'ART EXHIBITION: Thursday 25/06/2026 there will be an art exhibition on campus.',
    ],
    messages: [],
  ),
  Community(
    id: 'c5',
    name: 'ALU Run Club',
    description: 'Official group for ALU Run Club.',
    memberCount: 210,
    category: 'Cohort',
    announcements: [
      'Sunday 13/06/2026 We will run for the Marathon.',
    ],
    messages: [],
  ),
  Community(
    id: 'c6',
    name: 'ALU Sports Community',
    description: 'Official group for ALU Sports Community.',
    memberCount: 210,
    category: 'Cohort',
    announcements: [
      'We are the best community.',
    ],
    messages: [],
  ),
  Community(
    id: 'c7',
    name: 'Music Community',
    description: 'Official group for ALU Musicians.',
    memberCount: 210,
    category: 'Cohort',
    announcements: [
      'We have Rehearsals for the band Friday 12/6/2026 in Kenya Room'
    ],
    messages: [],
  ),
  Community(
    id: 'c8',
    name: 'ALU Movie Club',
    description: 'Official group for ALU Movie Club.',
    memberCount: 210,
    category: 'Cohort',
    announcements: [
      'Saturday 13/06/2026 we will be streaming the Micheal Jackson Movie.',
    ],
    messages: [],
  ),
];