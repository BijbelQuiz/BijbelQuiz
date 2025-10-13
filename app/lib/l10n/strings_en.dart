import 'package:bijbelquiz/constants/urls.dart';

class AppStrings {
  // Common
  static const String appName = 'BibleQuiz';
  static const String loading = 'Loading...';
  static const String error = 'Error';
  static const String back = 'Back';
  static const String submit = 'Submit';
  static const String cancel = 'Cancel';
  static const String ok = 'OK';
  
  // Quiz Screen
  static const String question = 'Question';
  static const String score = 'Score';
  static const String correct = 'Correct!';
  static const String incorrect = 'Incorrect';
  static const String quizComplete = 'Quiz completed!';
  static const String yourScore = 'Your score: ';
  static const String unlockBiblicalReference = 'Unlock Biblical Reference (Beta)';
  static const String biblicalReference = 'Biblical Reference';
  static const String close = 'Close';
  
  // Settings
  static const String settings = 'Settings';
  static const String sound = 'Sound';
  static const String notifications = 'Notifications';
  static const String language = 'Language';
  static const String theme = 'Theme';
  static const String darkMode = 'Dark mode';
  static const String lightMode = 'Light mode';
  static const String systemDefault = 'System default';
  
  // Lessons
  static const String lessons = 'Lessons';
  static const String continueLearning = 'Continue learning';
  
  // Store
  static const String store = 'Store';
  static const String unlockAll = 'Unlock all';
  static const String purchaseSuccessful = 'Purchase completed!';
  
  // Donation
  static const String donate = 'Support us';
  static const String donateButton = 'Donate now';
  static const String donateExplanation = 'Support the development of this app with a donation. This is needed to further develop/maintain the app.';
  
  // Guide
  static const String guide = 'Guide';
  static const String howToPlay = 'How to play';
  
  // Errors
  static const String connectionError = 'No internet connection';
  static const String connectionErrorMsg = 'Check your internet connection and try again.';
  static const String unknownError = 'An error occurred';
  static const String errorNoQuestions = 'No valid questions found';
  static const String errorLoadQuestions = 'Error loading questions';
  static const String couldNotOpenDonationPage = 'Could not open donation page';
  
  // Quiz metrics
  static const String streak = 'Streak';
  static const String best = 'Best';
  static const String time = 'Time';
  static const String screenSizeNotSupported = 'Screen size not supported';
  
  // Time up dialog
  static const String timeUp = 'Time is up!';
  static const String timeUpMessage = 'You did not answer in time. Your streak has been reset.';
  static const String notEnoughPoints = 'Not enough points';
  
  // Lesson complete screen
  static const String lessonComplete = 'Lesson completed';
  static const String percentage = 'Percentage';
  static const String bestStreak = 'Best streak';
  static const String retryLesson = 'Try again';
  static const String nextLesson = 'Next lesson';
  static const String backToLessons = 'Back to lessons';
  
  // Settings screen
  static const String display = 'Display';
  static const String chooseTheme = 'Choose your theme';
  static const String lightTheme = 'Light';
  static const String systemTheme = 'System';
  static const String darkTheme = 'Dark';
  static const String oledTheme = 'OLED';
  static const String greenTheme = 'Green';
  static const String orangeTheme = 'Orange';
  static const String tryAgain = 'Try again';
  static const String couldNotOpenStatusPage = 'Could not open status page.';
  
  // Lesson select screen
  static const String couldNotLoadLessons = 'Could not load lessons';
  static const String progress = 'Progress';
  static const String resetProgress = 'Reset progress';
  static const String resetProgressConfirmation = 'Are you sure you want to reset your progress? This cannot be undone.';
  static const String confirm = 'Confirm';
  static const String startLesson = 'Start lesson';
  static const String locked = 'Locked';
  static const String complete = 'Complete';
  static const String perfectScore = 'Perfect score!';
  static const String retry = 'Try again';
  
  // Guide screen
  static const String previous = 'Previous';
  static const String next = 'Next';
  static const String getStarted = 'Get started';
  static const String welcomeTitle = 'Welcome to BibleQuiz';
  static const String welcomeDescription = 'Discover the Bible in a fun and interactive way with challenging questions and lessons.';
  static const String howToPlayTitle = 'How do you play?';
  static const String howToPlayDescription = 'Answer questions about the Bible and earn points. The faster you answer, the more points you earn!';
  static const String notificationsTitle = 'Stay updated';
  static const String notificationsDescription = 'Receive reminders and challenges to improve your Bible knowledge.';
  static const String enableNotifications = 'Enable notifications';
  static const String notificationsEnabled = 'Notifications enabled';
  static const String continueText = 'Continue';
  static const String trackProgressTitle = 'Track Your Progress';
  static const String trackProgressDescription = 'Keep track of your scores and improve yourself over time.';
  static const String customizeExperienceTitle = 'Customize Your Experience';
  static final String customizeExperienceDescription = 'Customize your theme, game speed and sound effects in the settings. Do you have any questions or suggestions? We would love to hear from you via ${AppUrls.contactEmail}';
  static const String supportUsDescription = 'Do you find this app useful? Consider a donation to help us maintain and improve the app. Every contribution is appreciated!';
  static const String donateNow = 'Donate Now';
  
  // Activation screen
  static const String activationTitle = 'Activate your account';
  static const String activationSubtitle = 'Enter your activation code to use the app';
  static const String activationCodeHint = 'Enter your activation code';
  static const String activateButton = 'Activate';
  static const String verifyButton = 'Verify';
  static const String verifying = 'Checking...';
  static const String activationTip = 'Enter the activation code you received upon purchase.';
  static const String activationSuccess = 'Successfully activated!';
  static const String activationError = 'Invalid activation code. Please try again.';
  static const String activationErrorTitle = 'Activation failed';
  static const String activationSuccessMessage = 'Your account has been successfully activated. Enjoy the app!';
  static const String activationRequired = 'Activation required';
  static const String activationRequiredMessage = 'You must activate the app before you can use it.';
  
  // Store screen
  static const String yourStars = 'Your stars';
  static const String availableStars = 'Available stars';
  static const String powerUps = 'Power-ups';
  static const String themes = 'Themes';
  static const String availableThemes = 'Available themes';
  static const String unlockTheme = 'Unlock theme';
  static const String unlocked = 'Unlocked';
  static const String notEnoughStars = 'Not enough stars';
  static const String unlockFor = 'Unlock for';
  static const String stars = 'stars';
  static const String free = 'Free';
  static const String purchased = 'Purchased';
  static const String confirmPurchase = 'Confirm purchase';
  static const String purchaseConfirmation = 'Are you sure you want to unlock this theme for';
  static const String purchaseSuccess = 'Theme successfully unlocked!';
  static const String purchaseError = 'Not enough stars to unlock this theme.';
  static const String couldNotOpenDownloadPage = 'Could not open download page';
  
  // Power-ups
  static const String doubleStars5Questions = 'Double stars (5 questions)';
  static const String doubleStars5QuestionsDesc = 'Earn double stars for your next 5 questions';
  static const String tripleStars5Questions = 'Triple stars (5 questions)';
  static const String tripleStars5QuestionsDesc = 'Earn triple stars for your next 5 questions';
  static const String fiveTimesStars5Questions = '5x stars (5 questions)';
  static const String fiveTimesStars5QuestionsDesc = 'Earn 5x stars for your next 5 questions';
  static const String doubleStars60Seconds = 'Double stars (60 seconds)';
  static const String doubleStars60SecondsDesc = 'Earn double stars for 60 seconds';
  
  // Theme names
  static const String oledThemeName = 'OLED theme';
  static const String oledThemeDesc = 'Unlock a true black, high-contrast theme';
  static const String greenThemeName = 'Green theme';
  static const String greenThemeDesc = 'Unlock a fresh green theme';
  static const String orangeThemeName = 'Orange theme';
  static const String orangeThemeDesc = 'Unlock a vibrant orange theme';
  
  // Settings screen
  static const String supportUsTitle = 'Support us';
  static const String errorLoadingSettings = 'Error loading settings';
  static const String gameSettings = 'Game settings';
  static const String gameSpeed = 'Game speed';
  static const String chooseGameSpeed = 'Choose the speed of the game';
  static const String slow = 'Slow';
  static const String medium = 'Medium';
  static const String fast = 'Fast';
  static const String muteSoundEffects = 'Mute sound effects';
  static const String muteSoundEffectsDesc = 'Turn off all game sounds';
  static const String about = 'About';
  
  // Server status
  static const String serverStatus = 'Server status';
  static const String checkServiceStatus = 'Check the status of our services';
  static const String openStatusPage = 'Open status page';
  
  // Notifications
  static const String motivationNotifications = 'Motivation notifications (Beta)';
  static const String motivationNotificationsDesc = 'Receive daily reminders for BibleQuiz';
  
  // Actions
  static const String actions = 'Actions';
  static const String exportStats = 'Export statistics';
  static const String exportStatsDesc = 'Save your progress and scores as text';
  static const String importStats = 'Import statistics';
  static const String importStatsDesc = 'Load previously exported statistics';
  static const String resetAndLogout = 'Reset and logout';
  static const String resetAndLogoutDesc = 'Clear all data and deactivate app';
  static const String showIntroduction = 'Show introduction';
  static const String reportIssue = 'Report issue';
  static const String clearQuestionCache = 'Clear question cache';
  static const String contactUs = 'Contact us';
  static const String emailNotAvailable = 'Could not open email client';
  static const String cacheCleared = 'Question cache cleared!';
  
  // Debug/Test
  static const String testAllFeatures = 'Test All Features';
  
  // Footer
  static const String copyright = '© 2024-2025 ThomasNow Productions';
  static const String version = 'Version';
  
  // Social
  static const String social = 'Social';
  static const String comingSoon = 'Coming soon!';
  static const String socialComingSoonMessage = 'BibleQuiz social features are coming soon. Stay tuned for updates!';

  // Bible Bot
  static const String bibleBot = 'Bible Bot';
  
  // Errors
  static const String couldNotOpenEmail = 'Could not open email client';

  // Popups
  static const String followUs = 'Follow us';
  static const String followUsMessage = 'Follow us on Mastodon, Pixelfed, Kwebler, Signal, Discord and Bluesky for updates and community!';
  static const String followMastodon = 'Follow Mastodon';
  static const String followPixelfed = 'Follow Pixelfed';
  static const String followKwebler = 'Follow Kwebler';
  static const String followSignal = 'Follow Signal';
  static const String followDiscord = 'Follow Discord';
  static const String followBluesky = 'Follow Bluesky';
  static final String mastodonUrl = AppUrls.mastodonUrl;
  static final String pixelfedUrl = AppUrls.pixelfedUrl;
  static final String kweblerUrl = AppUrls.kweblerUrl;
  static final String signalUrl = AppUrls.signalUrl;
  static final String discordUrl = AppUrls.discordUrl;
  static final String blueskyUrl = AppUrls.blueskyUrl;
  
  // Satisfaction Survey
  static const String satisfactionSurvey = 'Help us improve';
  static const String satisfactionSurveyMessage = 'Take a few minutes to help us improve the app. Your feedback is important!';
  static const String satisfactionSurveyButton = 'Take survey';
  
  // Difficulty Feedback
  static const String difficultyFeedbackTitle = 'How do you like the difficulty level?';
  static const String difficultyFeedbackMessage = 'Let us know if the questions are too easy or too difficult.';
  static const String difficultyTooHard = 'Too difficult';
  static const String difficultyGood = 'Good';
  static const String difficultyTooEasy = 'Too easy';

  // Quiz Screen
  static const String skip = 'Skip';
  static const String overslaan = 'Skip';
  static const String notEnoughStarsForSkip = 'Not enough stars to skip!';

  // Settings Screen
  static const String resetAndLogoutConfirmation = 'This will remove all scores, progress, cache, settings and activation. The app will be deactivated and require a new activation code. This action cannot be undone.';

  // Guide Screen
  static const String donationError = 'An error occurred while opening the donation page';
  static const String notificationPermissionDenied = 'Notification permission denied.';
  static const String soundEffectsDescription = 'Turn all game sounds on or off';

  // Store Screen
  static const String doubleStarsActivated = 'Double Stars activated for 5 questions!';
  static const String tripleStarsActivated = 'Triple Stars activated for 5 questions!';
  static const String fiveTimesStarsActivated = '5x Stars activated for 5 questions!';
  static const String doubleStars60SecondsActivated = 'Double Stars activated for 60 seconds!';
  static const String powerupActivated = 'Power-up Activated!';
  static const String backToQuiz = 'To the quiz';
  static const String themeUnlocked = 'unlocked!';

  // Lesson Select Screen
  static const String onlyLatestUnlockedLesson = 'You can only play the most recently unlocked lesson';
  static const String starsEarned = 'stars earned';
  static const String readyForNextChallenge = 'Ready for your next challenge?';
  static const String continueLesson = 'Continue:';
  static const String freePractice = 'Free practice (random)';
  static const String lessonNumber = 'Lesson';

  // Biblical Reference Dialog
  static const String invalidBiblicalReference = 'Invalid biblical reference';
  static const String errorLoadingBiblicalText = 'Error loading biblical text';
  static const String errorLoadingWithDetails = 'Error loading:';
  static const String resumeToGame = 'Resume game';

  // Settings Screen
  static const String emailAddress = 'Email address';

  // AI Theme
  static const String aiThemeFallback = 'AI Theme';
  static const String aiThemeGenerator = 'AI Theme Generator';
  static const String aiThemeGeneratorDescription = 'Describe your desired colors and let AI create a theme for you';

  // Settings Screen - Updates
  static const String checkForUpdates = 'Check for updates';
  static const String checkForUpdatesDescription = 'Look for new app versions';
  static const String checkForUpdatesTooltip = 'Check for updates';

  // Settings Screen - Privacy
  static const String privacyPolicy = 'Privacy policy';
  static const String privacyPolicyDescription = 'Read our privacy policy';
  static const String couldNotOpenPrivacyPolicy = 'Could not open privacy policy';
  static const String openPrivacyPolicyTooltip = 'Open privacy policy';

  // Settings Screen - Privacy & Analytics
  static const String privacyAndAnalytics = 'Privacy & Analytics';
  static const String analytics = 'Analytics';
  static const String analyticsDescription = 'Help us improve the app by sending anonymous usage data';

  // Social Media
  static const String followOnSocialMedia = 'Follow on social media';
  static const String followUsOnSocialMedia = 'Follow us on social media';
  static const String mastodon = 'Mastodon';
  static const String pixelfed = 'Pixelfed';
  static const String kwebler = 'Kwebler';
  static const String discord = 'Discord';
  static const String signal = 'Signal';
  static const String bluesky = 'Bluesky';
  static const String couldNotOpenPlatform = 'Could not open {platform}';

  // Settings Provider Errors
  static const String languageMustBeNl = 'Language must be "nl" (only Dutch allowed)';
  static const String failedToSaveTheme = 'Could not save theme setting:';
  static const String failedToSaveSlowMode = 'Could not save slow mode setting:';
  static const String failedToSaveGameSpeed = 'Could not save game speed setting:';
  static const String failedToUpdateDonationStatus = 'Could not update donation status:';
  static const String failedToUpdateCheckForUpdateStatus = 'Could not update check for update status:';
  static const String failedToSaveMuteSetting = 'Could not save mute setting:';
  static const String failedToSaveGuideStatus = 'Could not save guide status:';
  static const String failedToResetGuideStatus = 'Could not reset guide status:';
  static const String failedToResetCheckForUpdateStatus = 'Could not reset check for update status:';
  static const String failedToSaveNotificationSetting = 'Could not save notification setting:';

  // Export/Import Stats
  static const String exportStatsTitle = 'Export statistics';
  static const String exportStatsMessage = 'Copy this text to save your progress:';
  static const String importStatsTitle = 'Import statistics';
  static const String importStatsMessage = 'Paste your previously exported statistics here:';
  static const String importStatsHint = 'Paste here...';
  static const String statsExportedSuccessfully = 'Statistics successfully exported!';
  static const String statsImportedSuccessfully = 'Statistics successfully imported!';
  static const String failedToExportStats = 'Could not export statistics:';
  static const String failedToImportStats = 'Could not import statistics:';
  static const String invalidOrTamperedData = 'Invalid or tampered data';
  static const String pleaseEnterValidString = 'Please enter a valid text';

  // Language options
  static const String dutch = 'Dutch';
  static const String english = 'English';
  static const String auto = 'Auto';
  static const String languageDescription = 'Choose your preferred language';
}