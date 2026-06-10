import 'package:flutter/material.dart';
import '../models/opportunity_model.dart';
import '../constants/app_colors.dart';

final List<OpportunityModel> mockOpportunities = [
  // Events
  OpportunityModel(
    id: 'opp1',
    title: 'Web3 & Blockchain Bootcamp',
    description:
        'A comprehensive 3-day bootcamp covering blockchain fundamentals, smart contracts, and dApp development. Learn from industry experts and build your first decentralized application.',
    date: DateTime(2026, 6, 15),
    time: '10:00 AM',
    location: 'ALU Tech Hub',
    type: OpportunityType.event,
    category: 'Tech & Software',
    organizer: OrganizerInfo(
      name: 'Tech Innovation Club',
      id: 'org1',
      avatar: '',
    ),
    tagColor: Color(0xFF1565C0),
    rsvpCount: 45,
    isFeatured: true,
  ),
  
  OpportunityModel(
    id: 'opp2',
    title: 'AI & Machine Learning Summit',
    description:
        'Explore the latest advances in artificial intelligence and machine learning. Network with AI researchers, data scientists, and tech leaders from across Africa.',
    date: DateTime(2026, 6, 20),
    time: '9:00 AM',
    location: 'Innovation Auditorium',
    type: OpportunityType.event,
    category: 'Tech & Software',
    organizer: OrganizerInfo(
      name: 'AI Research Lab',
      id: 'org2',
      avatar: '',
    ),
    tagColor: Color(0xFF7B2D8B),
    rsvpCount: 67,
    isFeatured: true,
  ),

  OpportunityModel(
    id: 'opp3',
    title: 'Digital Marketing Masterclass',
    description:
        'Learn modern digital marketing strategies from industry leaders. Topics include SEO, social media marketing, content strategy, and analytics.',
    date: DateTime(2026, 6, 25),
    time: '2:00 PM',
    location: 'Room 301',
    type: OpportunityType.event,
    category: 'Business & Marketing',
    organizer: OrganizerInfo(
      name: 'Marketing Club',
      id: 'org3',
      avatar: '',
    ),
    tagColor: Color(0xFFE07B39),
    rsvpCount: 38,
  ),

  OpportunityModel(
    id: 'opp4',
    title: 'Leadership & Personal Development Workshop',
    description:
        'Develop essential leadership skills including emotional intelligence, decision-making, and team management. Interactive sessions with case studies and group exercises.',
    date: DateTime(2026, 7, 2),
    time: '11:00 AM',
    location: 'Conference Room A',
    type: OpportunityType.event,
    category: 'Leadership',
    organizer: OrganizerInfo(
      name: 'Student Leadership Council',
      id: 'org4',
      avatar: '',
    ),
    tagColor: Color(0xFF2E7D32),
    rsvpCount: 52,
  ),

  OpportunityModel(
    id: 'opp5',
    title: 'Social Impact & Sustainability Forum',
    description:
        'Join innovators and social entrepreneurs discussing solutions to Africa\'s most pressing challenges. Focus on sustainable development and community impact.',
    date: DateTime(2026, 7, 8),
    time: '3:00 PM',
    location: 'Main Hall',
    type: OpportunityType.event,
    category: 'Social Impact',
    organizer: OrganizerInfo(
      name: 'Impact Initiative',
      id: 'org5',
      avatar: '',
    ),
    tagColor: Color(0xFF00695C),
    rsvpCount: 41,
  ),

  // Hackathons
  OpportunityModel(
    id: 'opp6',
    title: 'ALU Hackathon 2026: Build for Africa',
    description:
        'A 48-hour hackathon where teams compete to build innovative solutions addressing real challenges in African communities. Prizes: \$10,000 + mentorship from tech leaders.',
    date: DateTime(2026, 7, 15),
    time: '8:00 AM',
    location: 'Tech Campus - All Spaces',
    type: OpportunityType.hackathon,
    category: 'Hackathon',
    organizer: OrganizerInfo(
      name: 'ALU Developer Community',
      id: 'org6',
      avatar: '',
    ),
    tagColor: AppColors.red,
    rsvpCount: 120,
    isFeatured: true,
  ),

  OpportunityModel(
    id: 'opp7',
    title: 'Mobile App Development Hackathon',
    description:
        'Create the next killer mobile app! 36-hour hackathon focused on iOS and Android development. Categories: Social, Health, Education, Commerce.',
    date: DateTime(2026, 7, 22),
    time: '10:00 AM',
    location: 'Mobile Lab',
    type: OpportunityType.hackathon,
    category: 'Hackathon',
    organizer: OrganizerInfo(
      name: 'Mobile Developers Guild',
      id: 'org7',
      avatar: '',
    ),
    tagColor: Color(0xFF1565C0),
    rsvpCount: 89,
  ),

  OpportunityModel(
    id: 'opp8',
    title: 'Climate Tech Hackathon',
    description:
        'Build technology solutions to combat climate change. 48-hour hackathon with focus on renewable energy, carbon tracking, and environmental monitoring.',
    date: DateTime(2026, 8, 5),
    time: '9:00 AM',
    location: 'Sustainability Center',
    type: OpportunityType.hackathon,
    category: 'Hackathon',
    organizer: OrganizerInfo(
      name: 'Green Tech Initiative',
      id: 'org8',
      avatar: '',
    ),
    tagColor: Color(0xFF2E7D32),
    rsvpCount: 76,
  ),

  // Startups
  OpportunityModel(
    id: 'opp9',
    title: 'ALU Startup Pitch Competition',
    description:
        'Showcase your startup idea to investors and win funding! Startups pitch their business ideas in 3 minutes. Winners receive seed funding and mentorship.',
    date: DateTime(2026, 8, 12),
    time: '2:00 PM',
    location: 'Auditorium',
    type: OpportunityType.startup,
    category: 'Startup',
    organizer: OrganizerInfo(
      name: 'Entrepreneurship Hub',
      id: 'org9',
      avatar: '',
    ),
    tagColor: Color(0xFFAD1457),
    rsvpCount: 95,
    isFeatured: true,
  ),

  OpportunityModel(
    id: 'opp10',
    title: 'Pre-Accelerator Program: 8 Weeks to Launch',
    description:
        'Intense 8-week program to develop your startup from idea to MVP. Learn product development, fundraising, marketing, and business fundamentals from experienced entrepreneurs.',
    date: DateTime(2026, 8, 19),
    time: '10:00 AM',
    location: 'Startup Incubator',
    type: OpportunityType.startup,
    category: 'Startup',
    organizer: OrganizerInfo(
      name: 'ALU Ventures',
      id: 'org10',
      avatar: '',
    ),
    tagColor: Color(0xFF1565C0),
    rsvpCount: 34,
  ),

  OpportunityModel(
    id: 'opp11',
    title: 'Women in Tech: Funding & Mentorship',
    description:
        'Exclusive program for women founders and entrepreneurs. Connect with female investors, VCs, and mentors. Learn fundraising strategies and build your investor network.',
    date: DateTime(2026, 8, 26),
    time: '11:00 AM',
    location: 'Innovation Hub',
    type: OpportunityType.startup,
    category: 'Startup',
    organizer: OrganizerInfo(
      name: 'Women in Tech Africa',
      id: 'org11',
      avatar: '',
    ),
    tagColor: Color(0xFFE07B39),
    rsvpCount: 62,
  ),

  OpportunityModel(
    id: 'opp12',
    title: 'B2B SaaS Mastermind Series',
    description:
        'Monthly gathering for B2B SaaS founders and operators. Share challenges, learn growth strategies, and network with fellow SaaS entrepreneurs in Africa.',
    date: DateTime(2026, 9, 2),
    time: '4:00 PM',
    location: 'Meeting Room B',
    type: OpportunityType.startup,
    category: 'Startup',
    organizer: OrganizerInfo(
      name: 'SaaS Community Africa',
      id: 'org12',
      avatar: '',
    ),
    tagColor: AppColors.navyBlue,
    rsvpCount: 28,
  ),
];
