import 'package:bijbelquiz/constants/urls.dart';

class AppStrings {
  // Common
  static const String appName = 'BibleQuiz';
  static const String appDescription = 'Test Your Bible Knowledge';
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
  static const String quizComplete = 'Quiz Complete!';
  static const String yourScore = 'Your score: ';
  static const String unlockBiblicalReference = 'Unlock Bible Reference (Beta)';
  static const String biblicalReference = 'Bible Reference';
  static const String close = 'Close';
  
  // Settings
  static const String settings = 'Settings';
  static const String sound = 'Sound';
  static const String notifications = 'Notifications';
  static const String language = 'Language';
  static const String theme = 'Theme';
  static const String darkMode = 'Dark Mode';
  static const String lightMode = 'Light Mode';
  static const String systemDefault = 'System Default';
  
  // Lessons
  static const String lessons = 'Lessons';
  static const String continueLearning = 'Continue Learning';
  
  // Store
  static const String store = 'Store';
  static const String unlockAll = 'Unlock All';
  static const String purchaseSuccessful = 'Purchase Successful!';
  
  // Donation
  static const String donate = 'Support Us';
  static const String donateButton = 'Donate Now';
  static const String donateExplanation = 'Support the development of this app with a donation. This is needed to continue developing/maintaining the app.';
  
  // Guide
  static const String guide = 'Guide';
  static const String howToPlay = 'How to Play';
  
  // Errors
  static const String connectionError = 'No Internet Connection';
  static const String connectionErrorMsg = 'Check your internet connection and try again.';
  static const String unknownError = 'An error occurred';
  static const String errorNoQuestions = 'No valid questions found';
  static const String errorLoadQuestions = 'Error loading questions';
  static const String couldNotOpenDonationPage = 'Could not open donation page';
  static const String aiError = 'AI service error occurred';
  static const String apiError = 'API service error occurred';
  static const String storageError = 'Storage error occurred';
  static const String syncError = 'Synchronization failed';
  static const String permissionDenied = 'Permission required for this feature';
  
  // Quiz metrics
  static const String streak = 'Streak';
  static const String best = 'Best';
  static const String time = 'Time';
  static const String screenSizeNotSupported = 'Screen size not supported';
  static const String yourProgress = 'Your Progress';
  static const String dailyStreak = 'Daily Streak';
  static const String continueWith = 'Continue With';
  static const String multiplayerQuiz = 'Multiplayer Quiz';
  
  // Time up dialog
  static const String timeUp = 'Time is up!';
  static const String timeUpMessage = 'You did not answer in time. Your streak has been reset.';
  static const String notEnoughPoints = 'Not Enough Points';
  
  // Lesson complete screen
  static const String lessonComplete = 'Lesson Complete';
  static const String percentage = 'Percentage';
  static const String bestStreak = 'Best Streak';
  static const String retryLesson = 'Try Again';
  static const String nextLesson = 'Next Lesson';
  static const String backToLessons = 'Back to Lessons';
  
  // Settings screen
  static const String display = 'Display';
  static const String chooseTheme = 'Choose your theme';
  static const String lightTheme = 'Light';
  static const String systemTheme = 'System';
  static const String darkTheme = 'Dark';
  static const String oledTheme = 'OLED';
  static const String greenTheme = 'Green';
  static const String orangeTheme = 'Orange';
  static const String showNavigationLabels = 'Show Navigation Labels';
  static const String showNavigationLabelsDesc = 'Show or hide text labels below navigation icons';
  static const String colorfulMode = 'Colorful Mode';
  static const String colorfulModeDesc = 'Enable different colors for lesson cards';
  static const String hidePopup = 'Hide promotion popup';
  static const String hidePopupDesc = 'Do you only want to enable this setting if you have donated to us? We have no way to verify this, but we trust you to be honest.';
  static const String tryAgain = 'Try Again';
  static const String couldNotOpenStatusPage = 'Could not open status page.';
  static const String lessonLayout = 'Lesson Layout';
  static const String chooseLessonLayout = 'Choose how lessons are displayed';
  static const String layoutGrid = 'Grid';
  static const String layoutList = 'List';
  static const String layoutCompactGrid = 'Compact Grid';
  
  // Lesson select screen
  static const String couldNotLoadLessons = 'Could not load lessons';
  static const String progress = 'Progress';
  static const String resetProgress = 'Reset Progress';
  static const String resetProgressConfirmation = 'Are you sure you want to reset your progress? This cannot be undone.';
  static const String confirm = 'Confirm';
  static const String startLesson = 'Start Lesson';
  static const String locked = 'Locked';
  static const String complete = 'Complete';
  static const String perfectScore = 'Perfect Score!';
  static const String retry = 'Retry';
  
  // Guide screen
  static const String previous = 'Previous';
  static const String next = 'Next';
  static const String getStarted = 'Get Started';
  static const String welcomeTitle = 'Welcome to BibleQuiz';
  static const String welcomeDescription = 'Discover the Bible in a fun and interactive way with challenging questions and lessons.';
  static const String howToPlayTitle = 'How to Play?';
  static const String howToPlayDescription = 'Answer questions about the Bible and earn points. The faster you answer, the more points you earn!';
  static const String notificationsTitle = 'Stay Updated';
  static const String notificationsDescription = 'Receive reminders and challenges to improve your Bible knowledge.';
  static const String enableNotifications = 'Enable Notifications';
  static const String notificationsEnabled = 'Notifications Enabled';
  static const String continueText = 'Continue';
  static const String trackProgressTitle = 'Track Your Progress';
  static const String trackProgressDescription = 'Keep track of your scores and improve yourself over time.';
  static const String customizeExperienceTitle = 'Customize Your Experience';
  static final String customizeExperienceDescription = 'Customize your theme, game speed, and sound effects in the settings. Do you have any questions or suggestions? We would love to hear from you at ${AppUrls.contactEmail}';
  static const String supportUsDescription = 'Do you find this app useful? Consider donating to help us maintain and improve the app. Every contribution is appreciated!';
  static const String donateNow = 'Donate Now';
  
  // Activation screen
  static const String activationTitle = 'Activate your account';
  static const String activationSubtitle = 'Enter your activation code to use the app';
  static const String activationCodeHint = 'Enter your activation code';
  static const String activateButton = 'Activate';
  static const String verifyButton = 'Verify';
  static const String verifying = 'Verifying...';
  static const String activationTip = 'Enter the activation code you received with your purchase.';
  static const String activationSuccess = 'Successfully activated!';
  static const String activationError = 'Invalid activation code. Please try again.';
  static const String activationErrorTitle = 'Activation Failed';
  static const String activationSuccessMessage = 'Your account has been successfully activated. Enjoy the app!';
  static const String activationRequired = 'Activation Required';
  static const String activationRequiredMessage = 'You must activate the app before you can use it.';
  
  // Store screen
  static const String yourStars = 'Your Stars';
  static const String availableStars = 'Available Stars';
  static const String powerUps = 'Power-ups';
  static const String themes = 'Themes';
  static const String availableThemes = 'Available Themes';
  static const String unlockTheme = 'Unlock Theme';
  static const String unlocked = 'Unlocked';
  static const String notEnoughStars = 'Not Enough Stars';
  static const String unlockFor = 'Unlock for';
  static const String stars = 'stars';
  static const String free = 'Free';
  static const String purchased = 'Purchased';
  static const String confirmPurchase = 'Confirm Purchase';
  static const String purchaseConfirmation = 'Are you sure you want to unlock this theme for';
  static const String purchaseSuccess = 'Theme successfully unlocked!';
  static const String purchaseError = 'Not enough stars to unlock this theme.';
  static const String couldNotOpenDownloadPage = 'Could not open download page';
  
  // Power-ups
  static const String doubleStars5Questions = 'Double Stars (5 questions)';
  static const String doubleStars5QuestionsDesc = 'Earn double stars for your next 5 questions';
  static const String tripleStars5Questions = 'Triple Stars (5 questions)';
  static const String tripleStars5QuestionsDesc = 'Earn triple stars for your next 5 questions';
  static const String fiveTimesStars5Questions = '5x Stars (5 questions)';
  static const String fiveTimesStars5QuestionsDesc = 'Earn 5x stars for your next 5 questions';
  static const String doubleStars60Seconds = 'Double Stars (60 seconds)';
  static const String doubleStars60SecondsDesc = 'Earn double stars for 60 seconds';
  
  // Theme names
  static const String oledThemeName = 'OLED Theme';
  static const String oledThemeDesc = 'Unlock a true black, high-contrast theme';
  static const String greenThemeName = 'Green Theme';
  static const String greenThemeDesc = 'Unlock a fresh green theme';
  static const String orangeThemeName = 'Orange Theme';
  static const String orangeThemeDesc = 'Unlock a vibrant orange theme';
  
  // Settings screen
  static const String supportUsTitle = 'Support Us';
  static const String errorLoadingSettings = 'Error loading settings';
  static const String gameSettings = 'Game Settings';
  static const String gameSpeed = 'Game Speed';
  static const String chooseGameSpeed = 'Choose the speed of the game';
  static const String slow = 'Slow';
  static const String medium = 'Medium';
  static const String fast = 'Fast';
  static const String muteSoundEffects = 'Mute Sound Effects';
  static const String muteSoundEffectsDesc = 'Turn off all game sounds';
  static const String about = 'About';
  
  // Server status
  static const String serverStatus = 'Server Status';
  static const String checkServiceStatus = 'Check the status of our services';
  static const String openStatusPage = 'Open Status Page';
  
  // Notifications
  static const String motivationNotifications = 'Motivation Notifications (Beta)';
  static const String motivationNotificationsDesc = 'Receive daily reminders for BibleQuiz';
  
  // Actions
  static const String actions = 'Actions';
  static const String exportStats = 'Export Statistics';
  static const String exportStatsDesc = 'Save your progress and scores as text';
  static const String importStats = 'Import Statistics';
  static const String importStatsDesc = 'Load previously exported statistics';
  static const String resetAndLogout = 'Reset and Log Out';
  static const String resetAndLogoutDesc = 'Clear all data and deactivate app';
  static const String showIntroduction = 'Show Introduction';
  static const String reportIssue = 'Report Issue';
  static const String clearQuestionCache = 'Clear Question Cache';
  static const String contactUs = 'Contact Us';
  static const String emailNotAvailable = 'Could not open email client';
  static const String cacheCleared = 'Question cache cleared!';
  
  // Debug/Test
  static const String testAllFeatures = 'Test All Features';
  
  // Footer
  static const String copyright = '© 2024-2025 ThomasNow Productions';
  static const String version = 'Version';
  
  // Social
  static const String social = 'Social';
  static const String comingSoon = 'Coming Soon!';
  static const String socialComingSoonMessage = 'BibleQuiz social features are coming soon. Stay tuned for updates!';
  static const String manageYourBqid = 'Manage Your BQID';
  static const String manageYourBqidSubtitle = 'Manage your BQID, registered devices and more';
  static const String moreSocialFeaturesComingSoon = 'More social features coming soon';
  static const String socialFeatures = 'Social Features';
  static const String connectWithOtherUsers = 'Connect with other BibleQuiz users, share achievements and compete on the leaderboards!';
  static const String search = 'Search';
  static const String myFollowing = 'My Following';
  static const String myFollowers = 'My Followers';
  static const String messages = 'Messages';
  static const String searchUsers = 'Search Users';
  static const String searchByUsername = 'Search by username';
  static const String enterUsernameToSearch = 'Enter username to search...';
  static const String noUsersFound = 'No users found';
  static const String follow = 'Follow';
  static const String unfollow = 'Unfollow';
  static const String yourself = 'Yourself';

  // Bible Bot
  static const String bibleBot = 'Bible Bot';
  
  // Errors
  static const String couldNotOpenEmail = 'Could not open email client';
  static const String couldNotOpenUpdatePage = 'Could not open update page';
  static const String errorOpeningUpdatePage = 'Error opening update page: ';
  static const String couldNotCopyLink = 'Could not copy link';
  static const String errorCopyingLink = 'Could not copy link: ';
  static const String inviteLinkCopied = 'Invitation link copied to clipboard!';
  static const String statsLinkCopied = 'Statistics link copied to clipboard!';
  static const String copyStatsLinkToClipboard = 'Copy your statistics link to the clipboard';
  static const String importButton = 'Import';
  static const String couldNotScheduleAnyNotifications = 'Could not schedule any notifications. Check notification permissions in app settings.';
  static const String couldNotScheduleSomeNotificationsTemplate = 'Could only schedule {successCount} of {total} notifications.';
  static const String couldNotScheduleNotificationsError = 'Could not schedule notifications: ';

  // Popups
  static const String followUs = 'Follow Us';
  static const String followUsMessage = 'Follow us on Mastodon, Pixelfed, Kwebler, Signal, Discord, Bluesky and Nooki for updates and community!';
  static const String followMastodon = 'Follow Mastodon';
  static const String followPixelfed = 'Follow Pixelfed';
  static const String followKwebler = 'Follow Kwebler';
  static const String followSignal = 'Follow Signal';
  static const String followDiscord = 'Follow Discord';
  static const String followBluesky = 'Follow Bluesky';
  static const String followNooki = 'Follow Nooki';
  static final String mastodonUrl = AppUrls.mastodonUrl;
  static final String pixelfedUrl = AppUrls.pixelfedUrl;
  static final String kweblerUrl = AppUrls.kweblerUrl;
  static final String signalUrl = AppUrls.signalUrl;
  static final String discordUrl = AppUrls.discordUrl;
  static final String blueskyUrl = AppUrls.blueskyUrl;
  static final String nookiUrl = AppUrls.nookiUrl;
  
  // Satisfaction Survey
  static const String satisfactionSurvey = 'Help Us Improve';
  static const String satisfactionSurveyMessage = 'Take a few minutes to help us improve the app. Your feedback is important!';
  static const String satisfactionSurveyButton = 'Fill out survey';
  
  // Difficulty Feedback
  static const String difficultyFeedbackTitle = 'How do you find the difficulty level?';
  static const String difficultyFeedbackMessage = 'Let us know if the questions are too easy or too difficult.';
  static const String difficultyTooHard = 'Too difficult';
  static const String difficultyGood = 'Good';
  static const String difficultyTooEasy = 'Too easy';

  // Quiz Screen
  static const String skip = 'Skip';
  static const String overslaan = 'Skip';
  static const String notEnoughStarsForSkip = 'Not enough stars to skip!';

  // Settings Screen
  static const String resetAndLogoutConfirmation = 'This will remove all scores, progress, cache, settings and activation. The app will be deactivated and requires a new activation code. This action cannot be undone.';

  // Guide Screen
  static const String donationError = 'An error occurred while opening the donation page';
  static const String notificationPermissionDenied = 'Notification permission denied.';
  static const String soundEffectsDescription = 'Turn game sounds on or off';

  // Store Screen
  static const String doubleStarsActivated = 'Double Stars activated for 5 questions!';
  static const String tripleStarsActivated = 'Triple Stars activated for 5 questions!';
  static const String fiveTimesStarsActivated = '5x Stars activated for 5 questions!';
  static const String doubleStars60SecondsActivated = 'Double Stars activated for 60 seconds!';
  static const String powerupActivated = 'Power-up Activated!';
  static const String backToQuiz = 'Back to Quiz';
  static const String themeUnlocked = 'unlocked!';

  // Lesson Select Screen
  static const String onlyLatestUnlockedLesson = 'You can only play the most recently unlocked lesson';
  static const String starsEarned = 'stars earned';
  static const String readyForNextChallenge = 'Ready for your next challenge?';
  static const String continueLesson = 'Continue With:';
  static const String freePractice = 'Free Practice (random)';
  static const String lessonNumber = 'Lesson';

  // Biblical Reference Dialog
  static const String invalidBiblicalReference = 'Invalid Bible reference';
  static const String errorLoadingBiblicalText = 'Error loading Bible text';
  static const String errorLoadingWithDetails = 'Error loading:';
  static const String resumeToGame = 'Resume Game';

  // Settings Screen
  static const String emailAddress = 'Email address';

  // AI Theme
  static const String aiThemeFallback = 'AI Theme';
  static const String aiThemeGenerator = 'AI Theme Generator';
  static const String aiThemeGeneratorDescription = 'Describe your desired colors and let AI create a theme for you';

  // Settings Screen - Updates
  static const String checkForUpdates = 'Check for updates';
  static const String checkForUpdatesDescription = 'Search for new app versions';
  static const String checkForUpdatesTooltip = 'Check for updates';

  // Settings Screen - Privacy
  static const String privacyPolicy = 'Privacy Policy';
  static const String privacyPolicyDescription = 'Read our privacy policy';
  static const String couldNotOpenPrivacyPolicy = 'Could not open privacy policy';
  static const String openPrivacyPolicyTooltip = 'Open privacy policy';

  // Settings Screen - Privacy & Analytics
  static const String privacyAndAnalytics = 'Privacy & Analytics';
  static const String analytics = 'Analytics';
  static const String analyticsDescription = 'Help us improve the app by sending anonymous usage data';

  // Local API Settings
  static const String localApi = 'Local API';
  static const String enableLocalApi = 'Enable Local API';
  static const String enableLocalApiDesc = 'Allow external apps to access quiz data';
  static const String apiKey = 'API Key';
  static const String generateApiKey = 'Generate a key for API access';
  static const String apiPort = 'API Port';
  static const String apiPortDesc = 'Port for local API server';
  static const String apiStatus = 'API Status';
  static const String apiStatusDesc = 'Shows if the API server is running';
  static const String apiDisabled = 'Disabled';
  static const String apiRunning = 'Running';
  static const String apiStarting = 'Starting...';
  static const String copyApiKey = 'Copy API Key';
  static const String regenerateApiKey = 'Regenerate API Key';
  static const String regenerateApiKeyTitle = 'Regenerate API Key';
  static const String regenerateApiKeyMessage = 'This will generate a new API key and invalidate the current one. Continue?';
  static const String apiKeyCopied = 'API key copied to clipboard';
  static const String apiKeyCopyFailed = 'Could not copy API key';
  static const String generateKey = 'Generate Key';
  static const String apiKeyGenerated = 'New API key generated';

  // Social Media
  static const String followOnSocialMedia = 'Follow on social media';
  static const String followUsOnSocialMedia = 'Follow us on social media';
  static const String mastodon = 'Mastodon';
  static const String pixelfed = 'Pixelfed';
  static const String kwebler = 'Kwebler';
  static const String discord = 'Discord';
  static const String signal = 'Signal';
  static const String bluesky = 'Bluesky';
  static const String nooki = 'Nooki';
  static const String couldNotOpenPlatform = 'Could not open {platform}';
  static const String shareAppWithFriends = 'Share app with friends';
  static const String shareYourStats = 'Share your statistics';
  static const String inviteFriend = 'Invite a friend';
  static const String enterYourName = 'Enter your name';
  static const String enterFriendName = 'Enter your friend\'s name';
  static const String inviteMessage = 'Invite your friend to BibleQuiz!';
  static const String customizeInvite = 'Personalize your invitation';
  static const String sendInvite = 'Send invitation';

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
  static const String exportStatsTitle = 'Export Statistics';
  static const String exportStatsMessage = 'Copy this text to save your progress:';
  static const String importStatsTitle = 'Import Statistics';
  static const String importStatsMessage = 'Paste your previously exported statistics here:';
  static const String importStatsHint = 'Paste here...';
  static const String statsExportedSuccessfully = 'Statistics exported successfully!';
  static const String statsImportedSuccessfully = 'Statistics imported successfully!';
  static const String failedToExportStats = 'Could not export statistics:';
  static const String failedToImportStats = 'Could not import statistics:';
  static const String invalidOrTamperedData = 'Invalid or tampered data';
  static const String pleaseEnterValidString = 'Please enter a valid string';
  static const String copyCode = 'Copy Code';
  static const String codeCopied = 'Code copied to clipboard';
  
  // Sync Screen
  static const String multiDeviceSync = 'Multi-Device Sync';
  static const String enterSyncCode = 'Enter a sync code to connect to another device. Both devices must use the same code.';
  static const String syncCode = 'Sync Code';
  static const String joinSyncRoom = 'Join Sync Room';
  static const String or = 'Or';
  static const String startSyncRoom = 'Start Sync Room';
  static const String currentlySynced = 'You are currently synced. Data is shared in real-time between devices.';
  static const String yourSyncId = 'Your Sync ID:';
  static const String shareSyncId = 'Share this ID with other devices to join.';
  static const String leaveSyncRoom = 'Leave Sync Room';
  
  // Sync Error Messages
  static const String pleaseEnterSyncCode = 'Please enter a sync code';
  static const String failedToJoinSyncRoom = 'Failed to join sync room. Check the code and try again.';
  static const String errorGeneric = 'Error: ';
  static const String errorLeavingSyncRoom = 'Error leaving sync room: ';
  static const String failedToStartSyncRoom = 'Failed to start sync room. Please try again.';
  
  // Settings Screen Sync Button
  static const String multiDeviceSyncButton = 'Multi-Device Sync';
  static const String syncDataDescription = 'Sync data between devices using a code';
  
  // Sync Screen Additional Strings
  static const String syncDescription = 'Connect to another device to sync your progress and statistics.';
  static const String createSyncRoom = 'Create a new sync room';
  static const String createSyncDescription = 'Start a new sync room and share the code with others to connect.';
  
  // Sync Screen Device List Strings
  static const String connectedDevices = 'Connected Devices';
  static const String thisDevice = 'This Device';
  static const String noDevicesConnected = 'No devices connected';
  static const String removeDevice = 'Remove Device';
  static const String removeDeviceConfirmation = 'Are you sure you want to remove this device from the sync room? This device will no longer have access to the shared data.';
  static const String remove = 'Remove';
  
  // User ID Screen (rebranded from sync)
  static const String userId = 'BQID';
  static const String enterUserId = 'Enter a BQID to connect to another device';
  static const String userIdCode = 'BQID';
  static const String connectToUser = 'Connect to BQID';
  static const String createUserId = 'Create a new BQID';
  static const String createUserIdDescription = 'Create a new BQID and share the code with others to connect.';
  static const String currentlyConnectedToUser = 'You are currently connected to a BQID. Data is shared between devices.';
  static const String yourUserId = 'Your BQID:';
  static const String shareUserId = 'Share this ID with other devices to connect.';
  static const String leaveUserId = 'Remove BQID from this device';
  static const String userIdDescription = 'Connect to another device with a BQID to sync your data and statistics.';
  static const String pleaseEnterUserId = 'Please enter a BQID';
  static const String failedToConnectToUser = 'Failed to connect to the BQID. Check the ID and try again.';
  static const String failedToCreateUserId = 'Failed to create BQID. Please try again.';
  static const String userIdButton = 'BQID';
  static const String userIdDescriptionSetting = 'Create or connect to a BQID to sync your progress';
  static const String createUserIdButton = 'Create a BQID';
  static const String of = 'Or';
  static const String tapToCopyUserId = 'Tap to copy BQID';
  static const String userIdCopiedToClipboard = 'BQID copied to clipboard';

  // Following-list screen
  static const String notFollowing = "You are not following anyone yet";
  static const String joinRoomToViewFollowing = "You need to join a room to see who you are following";
  static const String searchUsersToFollow = "Search for users to start following them";

  // Followers-list screen
  static const String noFollowers = "You don't have any followers yet";
  static const String joinRoomToViewFollowers = "You need to join a room to see your followers";
  static const String shareBQIDFollowers  = "Share your BQID with others to start getting followers";

  // Messages
  static const String noActiveMessages = 'No active messages';
  static const String noActiveMessagesSubtitle = 'There are currently no messages to display';
  static const String errorLoadingMessages = 'Error loading messages';
  static const String expiresIn = 'Expires in';
  static const String expiringSoon = 'Expiring soon';
  static const String days = 'days';
  static const String hoursMessage = 'hours';
  static const String minutes = 'minutes';
  static const String lessThanAMinute = 'less than a minute';
  static const String created = 'Created';

  // BijbelQuiz Gen (Year in Review) Strings
  static const String bijbelquizGenTitle = 'BibleQuiz Year in Review';
  static const String bijbelquizGenSubtitle = 'Your year in ';
  static const String bijbelquizGenWelcomeText = 'Review your achievements today and share your BibleQuiz year!';
  static const String questionsAnswered = 'Questions answered';
  static const String bijbelquizGenQuestionsSubtitle = 'You have hopefully learned many new things.';
  static const String mistakesMade = 'Mistakes made';
  static const String bijbelquizGenMistakesSubtitle = 'Every mistake is a chance to learn and grow in your Bible knowledge!';
  static const String timeSpent = 'Time spent';
  static const String bijbelquizGenTimeSubtitle = 'You took time to deepen your Bible knowledge!';
  static const String bijbelquizGenBestStreak = 'Best streak';
  static const String bijbelquizGenStreakSubtitle = 'Your longest streak shows your consistency and dedication!';
  static const String yearInReview = 'Your year in review';
  static const String bijbelquizGenYearReviewSubtitle = 'An overview of your BibleQuiz performance in the past year!';
  static const String hours = 'hours';
  static const String correctAnswers = 'Correct answers';
  static const String accuracy = 'Accuracy';
  static const String currentStreak = 'Current streak';
  static const String thankYouForUsingBijbelQuiz = 'Thank you for using BibleQuiz!';
  static const String bijbelquizGenThankYouText = 'We hope our app has been a blessing this past year.';
  static const String bijbelquizGenDonateButton = 'Donate to us to show your continued support for our development, so we can continue to improve the app and so you can look back on another educational year next year.';
  static const String done = 'Done';
  static const String bijbelquizGenSkip = 'Skip';
  
  // Error Reporting Strings
  static const String success = 'Success';
  static const String reportSubmittedSuccessfully = 'Your report has been submitted successfully!';
  static const String reportSubmissionFailed = 'Failed to submit report. Please try again later.';
  static const String reportBug = 'Report a Bug';
  static const String reportBugDescription = 'Report a bug or issue with the app';
  static const String subject = 'Subject';
  static const String pleaseEnterSubject = 'Please enter a subject';
  static const String description = 'Description';
  static const String pleaseEnterDescription = 'Please enter a description';
  static const String emailOptional = 'Email (optional)';
  static const String reportQuestion = 'Report Question';
  static const String questionReportedSuccessfully = 'Question reported successfully';
  static const String errorReportingQuestion = 'Error reporting question';

  // Additional hardcoded strings found in codebase
  static const String apiErrorPrefix = 'API Error: ';
  static const String grid = 'Grid';
  static const String list = 'List';
  static const String compactGrid = 'Compact Grid';
  static const String useTheme = 'Use Theme';
  static const String failedToRemoveDevice = 'Failed to remove device';
  static const String errorRemovingDevice = 'Error removing device: ';
  static const String sharedStats = 'Shared Statistics';
  static const String newGame = 'New Game';
  static const String loadingMessages = 'Loading messages...';
  static const String errorLoadingUsernames = 'Error loading usernames: ';
  static const String urlCopiedToClipboard = 'URL copied to clipboard!';
  static const String tryAgainButton = 'Try Again';
  static const String checkConnection = 'Check Connection';
  static const String goToQuiz = 'Go to Quiz';
  static const String errorLoadingAnalytics = 'Error loading analytics';
  static const String bibleReferenceCopied = 'Bible reference copied: ';
  static const String bibleReferenceCopiedForSharing = 'Bible reference copied for sharing';
  static const String errorHandlingTest = 'Error Handling Test';
  static const String errorHandlingTestDescription = 'This screen demonstrates the new error handling system';
  static const String testErrorHandling = 'Test Error Handling';
  static const String testErrorDialog = 'Test Error Dialog';
  static const String retryButton = 'Retry';

  // Settings Screen - Additional hardcoded strings
  static const String searchSettings = 'Search settings...';
  static const String lessonLayoutSettings = 'Lesson Layout';
  static const String chooseLessonLayoutDesc = 'Choose how lessons are displayed';
  static const String showIntroductionDesc = 'View the app introduction and tutorial';
  static const String clearQuestionCacheDesc = 'Remove cached questions to free up storage space';
  static const String followOnSocialMediaDesc = 'Connect with us on social media platforms';
  static const String inviteFriendDesc = 'Share a personalized invite link with friends';
  static const String bugReport = 'Bug Report';
  static const String bugReportDesc = 'Report bugs and issues with the app';
}