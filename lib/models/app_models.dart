class Teacher {
  final String id;
  final String name;
  final String subject;
  final String imageUrl;
  final String bio;
  final double rating;
  final int studentsCount;
  final int coursesCount;

  Teacher({
    required this.id,
    required this.name,
    required this.subject,
    required this.imageUrl,
    required this.bio,
    this.rating = 4.8,
    this.studentsCount = 1200,
    this.coursesCount = 15,
  });
}

class Course {
  final String id;
  final String title;
  final String subject;
  final String teacherName;
  final String teacherImage;
  final double price;
  final double progress; // 0.0 to 1.0
  final String imageUrl;
  final bool isEnrolled;
  final List<Lesson> lessons;

  Course({
    required this.id,
    required this.title,
    required this.subject,
    required this.teacherName,
    required this.teacherImage,
    required this.price,
    this.progress = 0.0,
    required this.imageUrl,
    this.isEnrolled = false,
    this.lessons = const [],
  });
}

class Lesson {
  final String id;
  final String title;
  final String duration;
  final bool isCompleted;
  final bool isLocked;
  final String videoUrl;

  Lesson({
    required this.id,
    required this.title,
    required this.duration,
    this.isCompleted = false,
    this.isLocked = true,
    required this.videoUrl,
  });
}

class LiveSession {
  final String id;
  final String title;
  final String teacherName;
  final String teacherImage;
  final String subject;
  final DateTime startTime;
  final int totalSeats;
  final int availableSeats;
  final double price;
  final bool isEnrolled;
  final String zoomLink;

  LiveSession({
    required this.id,
    required this.title,
    required this.teacherName,
    required this.teacherImage,
    required this.subject,
    required this.startTime,
    required this.totalSeats,
    required this.availableSeats,
    required this.price,
    this.isEnrolled = false,
    required this.zoomLink,
  });

  bool get isActive => DateTime.now().isAfter(startTime) && DateTime.now().isBefore(startTime.add(const Duration(hours: 1)));
  bool get isFull => availableSeats <= 0;
}

class Conversation {
  final String id;
  final String participantName;
  final String participantImage;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;

  Conversation({
    required this.id,
    required this.participantName,
    required this.participantImage,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
  });
}

class Message {
  final String id;
  final String senderId;
  final String text;
  final DateTime timestamp;
  final bool isMe;

  Message({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
    required this.isMe,
  });
}
