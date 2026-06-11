import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// CommunityMember
// ---------------------------------------------------------------------------
class CommunityMember {
  final String id;
  final String name;
  final String role; // 'Leader' | 'Moderator' | 'Member'
  final DateTime joinedDate;
  final Color avatarColor;

  const CommunityMember({
    required this.id,
    required this.name,
    required this.role,
    required this.joinedDate,
    required this.avatarColor,
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  bool get isLeader => role == 'Leader';
  bool get isModerator => role == 'Moderator';
}

// ---------------------------------------------------------------------------
// CommunityPost
// ---------------------------------------------------------------------------
class CommunityPost {
  final String id;
  final String authorId;
  final String authorName;
  final Color authorAvatarColor;
  final String content;
  final DateTime timestamp;
  int likeCount;
  bool isLiked;
  final bool isPinned;

  CommunityPost({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.authorAvatarColor,
    required this.content,
    required this.timestamp,
    this.likeCount = 0,
    this.isLiked = false,
    this.isPinned = false,
  });

  String get authorInitials {
    final parts = authorName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return authorName.isNotEmpty ? authorName[0].toUpperCase() : '?';
  }
}

// ---------------------------------------------------------------------------
// CommunityMessage
// ---------------------------------------------------------------------------
class CommunityMessage {
  final String id;
  final String senderId;
  final String senderName;
  final Color senderAvatarColor;
  final String content;
  final DateTime timestamp;
  final bool isOwn; // sent by current user

  const CommunityMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.senderAvatarColor,
    required this.content,
    required this.timestamp,
    this.isOwn = false,
  });

  String get senderInitials {
    final parts = senderName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return senderName.isNotEmpty ? senderName[0].toUpperCase() : '?';
  }
}

// ---------------------------------------------------------------------------
// Community
// ---------------------------------------------------------------------------
class Community {
  final String id;
  final String name;
  final String description;
  final String category;
  final Color color;
  final IconData icon;
  final String pinnedAnnouncement;
  final List<String> tags;
  final List<CommunityMember> members;
  final List<CommunityPost> posts;
  final List<CommunityMessage> messages;
  bool isJoined;
  int memberCount;

  Community({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.color,
    required this.icon,
    required this.pinnedAnnouncement,
    required this.tags,
    required this.members,
    required this.posts,
    required this.messages,
    this.isJoined = false,
    int? memberCount,
  }) : memberCount = memberCount ?? members.length;
}
