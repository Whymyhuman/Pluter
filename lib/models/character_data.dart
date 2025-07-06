class CharacterData {
  static const String characterName = 'Rem';
  static const String characterSeries = 'Re:Zero - Starting Life in Another World';
  static const String characterRole = 'Maid';
  static const String characterDescription = 
      'Rem is a maid working for Margrave Roswaal L Mathers, alongside her sister Ram. '
      'She is known for her dedication, loyalty, and fierce protective nature. '
      'Despite her demon heritage, she has a gentle heart and cares deeply for those she loves.';

  static const List<String> characterTraits = [
    'Loyal',
    'Protective',
    'Hardworking',
    'Caring',
    'Dedicated',
    'Strong-willed',
  ];

  static const List<String> dailyQuotes = [
    'Good morning! I hope you have a wonderful day ahead.',
    'Remember to take care of yourself today.',
    'You\'re working so hard! Don\'t forget to rest.',
    'I believe in you! You can accomplish anything.',
    'Thank you for spending time with me today.',
    'Your smile makes my day brighter.',
    'Let\'s make today a great day together!',
    'I\'m always here if you need someone to talk to.',
    'You mean so much to me.',
    'Sweet dreams! I\'ll be here when you wake up.',
    'Every moment with you is precious to me.',
    'You make me want to be the best version of myself.',
    'I love seeing you happy!',
    'Together, we can face any challenge.',
    'Your kindness touches my heart.',
  ];

  static const List<String> affectionLevelTitles = [
    'Stranger',          // 0-9
    'Acquaintance',      // 10-24
    'Friend',            // 25-49
    'Close Friend',      // 50-99
    'Best Friend',       // 100-199
    'Trusted Companion', // 200-299
    'Beloved',           // 300-499
    'Soulmate',          // 500+
  ];

  static String getAffectionTitle(int level) {
    if (level < 10) return affectionLevelTitles[0];
    if (level < 25) return affectionLevelTitles[1];
    if (level < 50) return affectionLevelTitles[2];
    if (level < 100) return affectionLevelTitles[3];
    if (level < 200) return affectionLevelTitles[4];
    if (level < 300) return affectionLevelTitles[5];
    if (level < 500) return affectionLevelTitles[6];
    return affectionLevelTitles[7];
  }

  static String getRandomQuote() {
    final random = DateTime.now().millisecondsSinceEpoch % dailyQuotes.length;
    return dailyQuotes[random];
  }
}