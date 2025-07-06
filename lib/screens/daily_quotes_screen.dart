import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/character_data.dart';
import '../services/user_preferences.dart';

class DailyQuotesScreen extends StatefulWidget {
  const DailyQuotesScreen({super.key});

  @override
  State<DailyQuotesScreen> createState() => _DailyQuotesScreenState();
}

class _DailyQuotesScreenState extends State<DailyQuotesScreen>
    with TickerProviderStateMixin {
  String currentQuote = '';
  bool hasInteractedToday = false;
  bool isLoading = false;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );
    _loadTodaysQuote();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _loadTodaysQuote() {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final shownToday = UserPreferences.getDailyQuoteShown();
    
    setState(() {
      hasInteractedToday = shownToday == today;
      currentQuote = CharacterData.getRandomQuote();
    });
    
    _fadeController.forward();
  }

  Future<void> _getNewQuote() async {
    if (isLoading) return;
    
    setState(() {
      isLoading = true;
    });

    await _fadeController.reverse();
    
    setState(() {
      currentQuote = CharacterData.getRandomQuote();
    });
    
    await _fadeController.forward();
    
    setState(() {
      isLoading = false;
    });

    // Give small affection bonus for getting new quotes
    await UserPreferences.incrementAffection(1);
    await UserPreferences.incrementInteractions();
  }

  Future<void> _showLove() async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    
    if (!hasInteractedToday) {
      await UserPreferences.incrementAffection(3);
      await UserPreferences.setDailyQuoteShown(today);
      await UserPreferences.incrementInteractions();
      
      setState(() {
        hasInteractedToday = true;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('💖 Rem feels loved! +3 Affection'),
            backgroundColor: Colors.pink,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } else {
      await UserPreferences.incrementAffection(1);
      await UserPreferences.incrementInteractions();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('💕 Rem appreciates your love! +1 Affection'),
            backgroundColor: Colors.pink.shade300,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userName = UserPreferences.getUserName();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Messages'),
        backgroundColor: theme.colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Greeting
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.asset(
                        'assets/images/rem_icon.png',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 30,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Hello, $userName! 💙',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Quote Card
            Expanded(
              child: Card(
                elevation: 8,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        theme.colorScheme.primaryContainer.withAlpha((0.3 * 255).round()),
                        theme.colorScheme.secondaryContainer.withAlpha((0.3 * 255).round()),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.format_quote,
                          size: 40,
                          color: theme.colorScheme.primary.withAlpha((0.7 * 255).round()),
                        ),
                        const SizedBox(height: 20),
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Text(
                            currentQuote,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontStyle: FontStyle.italic,
                              height: 1.4,
                              color: theme.colorScheme.onSurface,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          '- ${CharacterData.characterName}',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isLoading ? null : _getNewQuote,
                    icon: isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: theme.colorScheme.onPrimary,
                            ),
                          )
                        : const Icon(Icons.refresh),
                    label: const Text('New Quote'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _showLove,
                    icon: const Icon(Icons.favorite, color: Colors.pink),
                    label: Text(hasInteractedToday ? 'Show Love' : 'Daily Love'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink.shade50,
                      foregroundColor: Colors.pink.shade700,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Daily bonus indicator
            if (!hasInteractedToday)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.amber.shade300),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star,
                      size: 16,
                      color: Colors.amber.shade700,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Daily bonus available!',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.amber.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}