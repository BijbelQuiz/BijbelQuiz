import 'package:bijbelquiz/constants/urls.dart';

class AppStrings {
  // Common
  static const String appName = 'BijbelQuiz';
  static const String appDescription = 'Test je Bijbelkennis';
  static const String loading = 'Laden...';
  static const String error = 'Fout';
  static const String back = 'Terug';
  static const String submit = 'Indienen';
  static const String cancel = 'Annuleren';
  static const String ok = 'OK';

  // Quiz Screen
  static const String question = 'Vraag';
  static const String score = 'Score';
  static const String correct = 'Correct!';
  static const String incorrect = 'Niet correct';
  static const String quizComplete = 'Quiz voltooid!';
  static const String yourScore = 'Jouw score: ';
  static const String unlockBiblicalReference =
      'Ontgrendel Bijbelverwijzing (Béta)';
  static const String biblicalReference = 'Bijbelverwijzing';
  static const String close = 'Sluiten';

  // Settings
  static const String settings = 'Instellingen';
  static const String sound = 'Geluid';
  static const String notifications = 'Meldingen';
  static const String language = 'Taal';
  static const String theme = 'Thema';
  static const String darkMode = 'Donkere modus';
  static const String lightMode = 'Lichte modus';
  static const String systemDefault = 'Systeemstandaard';

  // Lessons
  static const String lessons = 'Lessen';
  static const String continueLearning = 'Verder leren';

  // Store
  static const String store = 'Winkel';
  static const String unlockAll = 'Alles ontgrendelen';
  static const String purchaseSuccessful = 'Aankoop voltooid!';

  // Donation
  static const String donate = 'Ondersteun ons';
  static const String donateButton = 'Doneer nu';
  static const String donateExplanation =
      'Steun de ontwikkeling van deze app met een donatie. Dit is nodig om de app verder te ontwikkelen/onderhouden.';

  // Guide
  static const String guide = 'Handleiding';
  static const String howToPlay = 'Hoe te spelen';

  // Errors
  static const String connectionError = 'Geen internetverbinding';
  static const String connectionErrorMsg =
      'Controleer je internetverbinding en probeer het opnieuw.';
  static const String unknownError = 'Er is een fout opgetreden';
  static const String errorNoQuestions = 'Geen geldige vragen gevonden';
  static const String errorLoadQuestions = 'Fout bij het laden van de vragen';
  static const String couldNotOpenDonationPage =
      'Kon de donatiepagina niet openen';
  static const String aiError = 'AI-service fout opgetreden';
  static const String apiError = 'API-service fout opgetreden';
  static const String storageError = 'Opslagfout opgetreden';
  static const String syncError = 'Synchronisatie mislukt';
  static const String permissionDenied =
      'Toestemming vereist voor deze functie';

  // Quiz metrics
  static const String streak = 'Reeks';
  static const String best = 'Beste';
  static const String time = 'Tijd';
  static const String screenSizeNotSupported = 'Schermgrootte niet ondersteund';
  static const String yourProgress = 'Jouw voortgang';
  static const String dailyStreak = 'Dagelijkse reeks';
  static const String continueWith = 'Ga verder';
  static const String multiplayerQuiz = 'Multiplayer Quiz';

  // Time up dialog
  static const String timeUp = 'Tijd is om!';
  static const String timeUpMessage =
      'Je hebt niet op tijd geantwoord. Je reeks is gereset.';
  static const String notEnoughPoints = 'Onvoldoende punten';

  // Lesson complete screen
  static const String lessonComplete = 'Les voltooid';
  static const String percentage = 'Percentage';
  static const String bestStreak = 'Beste reeks';
  static const String streakLabel = ' reeks';
  static const String retryLesson = 'Opnieuw proberen';
  static const String nextLesson = 'Volgende les';
  static const String backToLessons = 'Terug naar lessen';

  // Settings screen
  static const String display = 'Weergave';
  static const String chooseTheme = 'Kies je thema';
  static const String lightTheme = 'Licht';
  static const String systemTheme = 'Systeem';
  static const String darkTheme = 'Donker';
  static const String oledTheme = 'OLED';
  static const String greenTheme = 'Groen';
  static const String orangeTheme = 'Oranje';
  static const String showNavigationLabels = 'Toon navigatielabels';
  static const String showNavigationLabelsDesc =
      'Toon of verberg tekstlabels onder de navigatie-iconen';
  static const String colorfulMode = 'Kleurrijke modus';
  static const String colorfulModeDesc =
      'Zet verschillende kleuren aan voor leskaarten';
  static const String hidePopup = 'Verberg promotie pop-up';
  static const String hidePopupDesc =
      'Wil je deze instelling alleen aanzetten als u aan ons heeft gedoneerd? We hebben geen manier om het te verifieren, maar we vertrouwen erop dat je eerlijk bent.';
  static const String tryAgain = 'Opnieuw proberen';
  static const String couldNotOpenStatusPage =
      'Kon de statuspagina niet openen.';

  // Lesson select screen
  static const String couldNotLoadLessons = 'Kon lessen niet laden';
  static const String progress = 'Voortgang';
  static const String resetProgress = 'Voortgang resetten';
  static const String resetProgressConfirmation =
      'Weet je zeker dat je je voortgang wilt resetten? Dit kan niet ongedaan worden gemaakt.';
  static const String confirm = 'Bevestigen';
  static const String startLesson = 'Start les';
  static const String locked = 'Vergrendeld';
  static const String complete = 'Voltooid';
  static const String perfectScore = 'Perfecte score!';
  static const String retry = 'Opnieuw proberen';
  static const String unknownUser = 'Onbekende Gebruiker';
  static const String lastScore = 'Laatste score:';
  static const String notAvailable = 'Onbekend';

  // Guide screen
  static const String previous = 'Vorige';
  static const String next = 'Volgende';
  static const String getStarted = 'Aan de slag';
  static const String welcomeTitle = 'Welkom bij BijbelQuiz';
  static const String welcomeDescription =
      'Ontdek de Bijbel op een leuke en interactieve manier met uitdagende vragen en lessen.';
  static const String howToPlayTitle = 'Hoe speel je?';
  static const String howToPlayDescription =
      'Beantwoord vragen over de Bijbel en verdien punten. Hoe sneller je antwoordt, hoe meer punten je verdient!';
  static const String notificationsTitle = 'Blijf op de hoogte';
  static const String notificationsDescription =
      'Ontvang herinneringen en uitdagingen om je Bijbelkennis te verbeteren.';
  static const String enableNotifications = 'Meldingen inschakelen';
  static const String notificationsEnabled = 'Meldingen ingeschakeld';
  static const String continueText = 'Doorgaan';
  static const String trackProgressTitle = 'Volg Je Voortgang';
  static const String trackProgressDescription =
      'Houd je scores bij en verbeter jezelf in de loop van de tijd.';
  static const String customizeExperienceTitle = 'Pas Je Ervaring Aan';
  static final String customizeExperienceDescription =
      'Pas je thema, speelsnelheid en de geluidseffecten aan in de instellingen. Heeft u nog vragen of suggesties? We horen graag van je via ${AppUrls.contactEmail}';
  static const String supportUsDescription =
      'Vind je deze app nuttig? Overweeg dan een donatie om ons te helpen de app te onderhouden en te verbeteren. Elke bijdrage wordt gewaardeerd!';
  static const String donateNow = 'Doneer Nu';

  // Activation screen
  static const String activationTitle = 'Activeer je account';
  static const String activationSubtitle =
      'Voer je activatiecode in om de app te gebruiken';
  static const String activationCodeHint = 'Voer je activatiecode in';
  static const String activateButton = 'Activeren';
  static const String verifyButton = 'Verifiëren';
  static const String verifying = 'Controleren...';
  static const String activationTip =
      'Voer de activatiecode in die je hebt ontvangen bij aankoop.';
  static const String activationSuccess = 'Succesvol geactiveerd!';
  static const String activationError =
      'Ongeldige activatiecode. Probeer het opnieuw.';
  static const String activationErrorTitle = 'Activatie mislukt';
  static const String activationSuccessMessage =
      'Je account is succesvol geactiveerd. Veel plezier met de app!';
  static const String activationRequired = 'Activatie vereist';
  static const String activationRequiredMessage =
      'Je moet de app activeren voordat je deze kunt gebruiken.';

  // Store screen
  static const String yourStars = 'Jouw sterren';
  static const String availableStars = 'Beschikbare sterren';
  static const String powerUps = 'Power-ups';
  static const String themes = 'Thema\'s';
  static const String availableThemes = 'Beschikbare thema\'s';
  static const String unlockTheme = 'Ontgrendel thema';
  static const String unlocked = 'Ontgrendeld';
  static const String notEnoughStars = 'Niet genoeg sterren';
  static const String unlockFor = 'Ontgrendel voor';
  static const String stars = 'sterren';
  static const String free = 'Gratis';
  static const String purchased = 'Aangekocht';
  static const String confirmPurchase = 'Bevestig aankoop';
  static const String purchaseConfirmation =
      'Weet je zeker dat je dit thema wilt ontgrendelen voor';
  static const String purchaseSuccess = 'Thema succesvol ontgrendeld!';
  static const String purchaseError =
      'Niet genoeg sterren om dit thema te ontgrendelen.';
  static const String couldNotOpenDownloadPage =
      'Kon de downloadpagina niet openen';

  // Power-ups
  static const String doubleStars5Questions = 'Dubbele sterren (5 vragen)';
  static const String doubleStars5QuestionsDesc =
      'Verdien dubbele sterren voor je volgende 5 vragen';
  static const String tripleStars5Questions = 'Driedubbele sterren (5 vragen)';
  static const String tripleStars5QuestionsDesc =
      'Verdien driedubbele sterren voor je volgende 5 vragen';
  static const String fiveTimesStars5Questions = '5x sterren (5 vragen)';
  static const String fiveTimesStars5QuestionsDesc =
      'Verdien 5x sterren voor je volgende 5 vragen';
  static const String doubleStars60Seconds = 'Dubbele sterren (60 seconden)';
  static const String doubleStars60SecondsDesc =
      'Verdien dubbele sterren gedurende 60 seconden';

  // Theme names
  static const String oledThemeName = 'OLED thema';
  static const String oledThemeDesc =
      'Ontgrendel een echt zwart, hoog-contrast thema';
  static const String greenThemeName = 'Groen thema';
  static const String greenThemeDesc = 'Ontgrendel een fris groen thema';
  static const String orangeThemeName = 'Oranje thema';
  static const String orangeThemeDesc = 'Ontgrendel een levendig oranje thema';

  // Settings screen
  static const String supportUsTitle = 'Ondersteun ons';
  static const String errorLoadingSettings =
      'Fout bij het laden van instellingen';
  static const String gameSettings = 'Spelinstellingen';
  static const String gameSpeed = 'Spelsnelheid';
  static const String chooseGameSpeed = 'Kies de snelheid van het spel';
  static const String slow = 'Langzaam';
  static const String medium = 'Gemiddeld';
  static const String fast = 'Snel';
  static const String muteSoundEffects = 'Geluidseffecten dempen';
  static const String muteSoundEffectsDesc = 'Schakel alle spelgeluiden uit';
  static const String about = 'Over';

  // Server status
  static const String serverStatus = 'Serverstatus';
  static const String checkServiceStatus =
      'Controleer de status van onze services';
  static const String openStatusPage = 'Open statuspagina';

  // Notifications
  static const String motivationNotifications = 'Motivatie-meldingen (Béta)';
  static const String motivationNotificationsDesc =
      'Ontvang dagelijkse herinneringen voor BijbelQuiz';

  // Actions
  static const String actions = 'Acties';
  static const String exportStats = 'Statistieken exporteren';
  static const String exportStatsDesc =
      'Sla je voortgang en scores op als tekst';
  static const String importStats = 'Statistieken importeren';
  static const String importStatsDesc =
      'Laad eerder geëxporteerde statistieken';
  static const String resetAndLogout = 'Resetten en uitloggen';
  static const String resetAndLogoutDesc =
      'Alle gegevens wissen en app deactiveren';
  static const String showIntroduction = 'Introductie tonen';
  static const String reportIssue = 'Probleem melden';
  static const String clearQuestionCache = 'Vragencache wissen';
  static const String contactUs = 'Neem contact op';
  static const String emailNotAvailable = 'Kon e-mailclient niet openen';
  static const String cacheCleared = 'Vragencache gewist!';

  // Debug/Test
  static const String testAllFeatures = 'Test Alle Functies';

  // Footer
  static const String copyright = '© 2024-2025 ThomasNow Productions';
  static const String version = 'Versie';

  // Social
  static const String social = 'Sociaal';
  static const String comingSoon = 'Binnenkort beschikbaar!';
  static const String socialComingSoonMessage =
      'De sociale functies van BijbelQuiz zijn binnenkort beschikbaar. Blijf op de hoogte voor updates!';
  static const String manageYourBqid = 'Beheer je BQID';
  static const String manageYourBqidSubtitle =
      'Beheer je BQID, geregistreerde apparaten en meer';
  static const String moreSocialFeaturesComingSoon =
      'Meer sociale functies binnenkort beschikbaar';
  static const String socialFeatures = 'Sociale Functies';
  static const String connectWithOtherUsers =
      'Verbind met andere BijbelQuiz-gebruikers, deel prestaties en strijd op de scoreborden!';
  static const String search = 'Zoeken';
  static const String myFollowing = 'Volgend';
  static const String myFollowers = 'Volgers';
  static const String messages = 'Berichten';
  static const String followedUsersScores = 'Scores van Gevolgde Gebruikers';
  static const String searchUsers = 'Zoek Gebruikers';
  static const String searchByUsername = 'Zoek op gebruikersnaam';
  static const String enterUsernameToSearch =
      'Voer gebruikersnaam in om te zoeken...';
  static const String noUsersFound = 'Geen gebruikers gevonden';
  static const String follow = 'Volgen';
  static const String unfollow = 'Ontvolgen';
  static const String yourself = 'Zelf';

  // Bible Bot
  static const String bibleBot = 'Bijbel Bot';

  // Errors
  static const String couldNotOpenEmail = 'Kon e-mailclient niet openen';
  static const String couldNotOpenUpdatePage = 'Kon update pagina niet openen';
  static const String errorOpeningUpdatePage =
      'Fout bij openen update pagina: ';
  static const String couldNotCopyLink = 'Kon link niet kopiëren';
  static const String errorCopyingLink = 'Kon link niet kopiëren: ';
  static const String inviteLinkCopied =
      'Uitnodigingslink gekopieerd naar klembord!';
  static const String statsLinkCopied =
      'Statistieken link gekopieerd naar klembord!';
  static const String copyStatsLinkToClipboard =
      'Kopieer je statistieken link naar het klembord';
  static const String importButton = 'Importeren';
  static const String couldNotScheduleAnyNotifications =
      'Kon geen enkele melding plannen. Controleer de toestemmingen voor meldingen in de app-instellingen.';
  static const String couldNotScheduleSomeNotificationsTemplate =
      'Kon slechts {successCount} van de {total} meldingen plannen.';
  static const String couldNotScheduleNotificationsError =
      'Kon meldingen niet plannen: ';

  // Popups
  static const String followUs = 'Volg ons';
  static const String followUsMessage =
      'Volg ons op Mastodon, Pixelfed, Kwebler, Signal, Discord, Bluesky en Nooki voor updates en community!';
  static const String followMastodon = 'Volg Mastodon';
  static const String followPixelfed = 'Volg Pixelfed';
  static const String followKwebler = 'Volg Kwebler';
  static const String followSignal = 'Volg Signal';
  static const String followDiscord = 'Volg Discord';
  static const String followBluesky = 'Volg Bluesky';
  static const String followNooki = 'Volg Nooki';
  static final String mastodonUrl = AppUrls.mastodonUrl;
  static final String pixelfedUrl = AppUrls.pixelfedUrl;
  static final String kweblerUrl = AppUrls.kweblerUrl;
  static final String signalUrl = AppUrls.signalUrl;
  static final String discordUrl = AppUrls.discordUrl;
  static final String blueskyUrl = AppUrls.blueskyUrl;
  static final String nookiUrl = AppUrls.nookiUrl;

  // Satisfaction Survey
  static const String satisfactionSurvey = 'Help ons te verbeteren';
  static const String satisfactionSurveyMessage =
      'Neem een paar minuten om ons te helpen de app te verbeteren. Uw feedback is belangrijk!';
  static const String satisfactionSurveyButton = 'Vul enquête in';

  // Difficulty Feedback
  static const String difficultyFeedbackTitle =
      'Hoe bevalt de moeilijkheidsgraad?';
  static const String difficultyFeedbackMessage =
      'Laat ons weten of de vragen te makkelijk of te moeilijk zijn.';
  static const String difficultyTooHard = 'Te moeilijk';
  static const String difficultyGood = 'Goed';
  static const String difficultyTooEasy = 'Te makkelijk';

  // Quiz Screen
  static const String skip = 'Skip';
  static const String overslaan = 'Overslaan';
  static const String notEnoughStarsForSkip =
      'Niet genoeg sterren om over te slaan!';

  // Settings Screen
  static const String resetAndLogoutConfirmation =
      'Dit verwijdert alle scores, voortgang, cache, instellingen en activatie. De app wordt gedeactiveerd en vereist een nieuwe activatiecode. Deze actie kan niet ongedaan worden gemaakt.';

  // Guide Screen
  static const String donationError =
      'Er is een fout opgetreden bij het openen van de donatiepagina';
  static const String notificationPermissionDenied =
      'Meldingstoestemming geweigerd.';
  static const String soundEffectsDescription =
      'Schakel alle spelgeluiden in of uit';

  // Store Screen
  static const String doubleStarsActivated =
      'Dubbele Sterren geactiveerd voor 5 vragen!';
  static const String tripleStarsActivated =
      'Driedubbele Sterren geactiveerd voor 5 vragen!';
  static const String fiveTimesStarsActivated =
      '5x Sterren geactiveerd voor 5 vragen!';
  static const String doubleStars60SecondsActivated =
      'Dubbele Sterren geactiveerd voor 60 seconden!';
  static const String powerupActivated = 'Power-up Geactiveerd!';
  static const String backToQuiz = 'Naar de quiz';
  static const String themeUnlocked = 'ontgrendeld!';

  // Lesson Select Screen
  static const String onlyLatestUnlockedLesson =
      'Je kunt alleen de meest recente ontgrendelde les spelen';
  static const String starsEarned = 'sterren verdiend';
  static const String readyForNextChallenge =
      'Klaar voor je volgende uitdaging?';
  static const String continueLesson = 'Ga verder:';
  static const String freePractice = 'Vrij oefenen (random)';
  static const String lessonNumber = 'Les';

  // Biblical Reference Dialog
  static const String invalidBiblicalReference = 'Ongeldige bijbelverwijzing';
  static const String errorLoadingBiblicalText =
      'Fout bij het laden van de bijbeltekst';
  static const String errorLoadingWithDetails = 'Fout bij het laden:';
  static const String resumeToGame = 'Hervat spel';

  // Settings Screen
  static const String emailAddress = 'E-mailadres';

  // AI Theme
  static const String aiThemeFallback = 'AI Thema';
  static const String aiThemeGenerator = 'AI Thema Generator';
  static const String aiThemeGeneratorDescription =
      'Beschrijf je gewenste kleuren en laat AI een thema voor je maken';

  // Settings Screen - Updates
  static const String checkForUpdates = 'Controleer op updates';
  static const String checkForUpdatesDescription =
      'Zoek naar nieuwe app-versies';
  static const String checkForUpdatesTooltip = 'Controleer op updates';

  // Settings Screen - Privacy
  static const String privacyPolicy = 'Privacybeleid';
  static const String privacyPolicyDescription = 'Lees ons privacybeleid';
  static const String couldNotOpenPrivacyPolicy =
      'Kon privacybeleid niet openen';
  static const String openPrivacyPolicyTooltip = 'Open privacybeleid';

  // Settings Screen - Privacy & Analytics
  static const String privacyAndAnalytics = 'Privacy & Analytics';
  static const String analytics = 'Analytics';
  static const String analyticsDescription =
      'Help ons de app te verbeteren door anonieme gebruiksgegevens te verzenden';

  // Local API Settings
  static const String localApi = 'Lokale API';
  static const String enableLocalApi = 'Lokale API inschakelen';
  static const String enableLocalApiDesc =
      'Sta externe apps toe om quizgegevens te benaderen';
  static const String apiKey = 'API-sleutel';
  static const String generateApiKey = 'Genereer een sleutel voor API-toegang';
  static const String apiPort = 'API-poort';
  static const String apiPortDesc = 'Poort voor lokale API-server';
  static const String apiStatus = 'API-status';
  static const String apiStatusDesc = 'Toont of de API-server draait';
  static const String apiDisabled = 'Uitgeschakeld';
  static const String apiRunning = 'Draait';
  static const String apiStarting = 'Starten...';
  static const String copyApiKey = 'API-sleutel kopiëren';
  static const String regenerateApiKey = 'API-sleutel opnieuw genereren';
  static const String regenerateApiKeyTitle = 'API-sleutel opnieuw genereren';
  static const String regenerateApiKeyMessage =
      'Dit genereert een nieuwe API-sleutel en maakt de huidige ongeldig. Doorgaan?';
  static const String apiKeyCopied = 'API-sleutel gekopieerd naar klembord';
  static const String apiKeyCopyFailed = 'Kon API-sleutel niet kopiëren';
  static const String generateKey = 'Genereer sleutel';
  static const String apiKeyGenerated = 'Nieuwe API-sleutel gegenereerd';

  // Social Media
  static const String followOnSocialMedia = 'Volg op social media';
  static const String followUsOnSocialMedia = 'Volg ons op social media';
  static const String mastodon = 'Mastodon';
  static const String pixelfed = 'Pixelfed';
  static const String kwebler = 'Kwebler';
  static const String discord = 'Discord';
  static const String signal = 'Signal';
  static const String bluesky = 'Bluesky';
  static const String nooki = 'Nooki';
  static const String couldNotOpenPlatform = 'Kon {platform} niet openen';
  static const String shareAppWithFriends = 'Deel app met vrienden';
  static const String shareYourStats = 'Deel je statistieken';
  static const String inviteFriend = 'Nodig een vriend uit';
  static const String enterYourName = 'Voer je naam in';
  static const String enterFriendName = 'Voer de naam van je vriend in';
  static const String inviteMessage = 'Nodig je vriend uit voor de BijbelQuiz!';
  static const String customizeInvite = 'Personaliseer je uitnodiging';
  static const String sendInvite = 'Verzend uitnodiging';

  // Settings Provider Errors
  static const String languageMustBeNl =
      'Taal moet "nl" zijn (alleen Nederlands toegestaan)';
  static const String failedToSaveTheme = 'Kon thema-instelling niet opslaan:';
  static const String failedToSaveSlowMode =
      'Kon langzame modus-instelling niet opslaan:';
  static const String failedToSaveGameSpeed =
      'Kon spelsnelheid-instelling niet opslaan:';
  static const String failedToUpdateDonationStatus =
      'Kon donatiestatus niet bijwerken:';
  static const String failedToUpdateCheckForUpdateStatus =
      'Kon update-controle status niet bijwerken:';
  static const String failedToSaveMuteSetting =
      'Kon demp-instelling niet opslaan:';
  static const String failedToSaveGuideStatus = 'Kon gidsstatus niet opslaan:';
  static const String failedToResetGuideStatus =
      'Kon gidsstatus niet resetten:';
  static const String failedToResetCheckForUpdateStatus =
      'Kon update-controle status niet resetten:';
  static const String failedToSaveNotificationSetting =
      'Kon meldingsinstelling niet opslaan:';

  // Export/Import Stats
  static const String exportStatsTitle = 'Statistieken exporteren';
  static const String exportStatsMessage =
      'Kopieer deze tekst om je voortgang op te slaan:';
  static const String importStatsTitle = 'Statistieken importeren';
  static const String importStatsMessage =
      'Plak je eerder geëxporteerde statistieken hier:';
  static const String importStatsHint = 'Plak hier...';
  static const String statsExportedSuccessfully =
      'Statistieken succesvol geëxporteerd!';
  static const String statsImportedSuccessfully =
      'Statistieken succesvol geïmporteerd!';
  static const String failedToExportStats = 'Kon statistieken niet exporteren:';
  static const String failedToImportStats = 'Kon statistieken niet importeren:';
  static const String invalidOrTamperedData =
      'Ongeldige of gemanipuleerde gegevens';
  static const String pleaseEnterValidString = 'Voer een geldige tekst in';
  static const String copyCode = 'Code kopiëren';
  static const String codeCopied = 'Code gekopieerd naar klembord';

  // Sync Screen
  static const String multiDeviceSync = 'Multi-Apparaat Sync';
  static const String enterSyncCode =
      'Voer een sync code in om verbinding te maken met een ander apparaat. Beide apparaten moeten dezelfde code gebruiken.';
  static const String syncCode = 'Sync Code';
  static const String joinSyncRoom = 'Sync Ruimte Toetreden';
  static const String or = 'Of';
  static const String startSyncRoom = 'Sync Ruimte Starten';
  static const String currentlySynced =
      'Je bent momenteel gesynced. Gegevens worden in realtime gedeeld tussen apparaten.';
  static const String yourSyncId = 'Jouw Sync ID:';
  static const String shareSyncId =
      'Deel deze ID met andere apparaten om toe te treden.';
  static const String leaveSyncRoom = 'Sync Ruimte Verlaten';

  // Sync Error Messages
  static const String pleaseEnterSyncCode = 'Voer een sync code in';
  static const String failedToJoinSyncRoom =
      'Kon niet toetreden tot sync ruimte. Controleer de code en probeer opnieuw.';
  static const String errorGeneric = 'Fout: ';
  static const String errorLeavingSyncRoom = 'Fout bij verlaten sync ruimte: ';
  static const String failedToStartSyncRoom =
      'Kon sync ruimte niet starten. Probeer opnieuw.';

  // Settings Screen Sync Button
  static const String multiDeviceSyncButton = 'Multi-Apparaat Sync';
  static const String syncDataDescription =
      'Sync data tussen apparaten met behulp van een code';

  // Sync Screen Additional Strings
  static const String syncDescription =
      'Verbind met een ander apparaat om je voortgang en statistieken te synchroniseren.';
  static const String createSyncRoom = 'Maak een nieuwe sync-ruimte';
  static const String createSyncDescription =
      'Start een nieuwe sync-ruimte en deel de code met anderen om verbinding te maken.';

  // Sync Screen Device List Strings
  static const String connectedDevices = 'Verbonden Apparaten';
  static const String thisDevice = 'Dit Apparaat';
  static const String noDevicesConnected = 'Geen apparaten verbonden';
  static const String removeDevice = 'Apparaat Verwijderen';
  static const String removeDeviceConfirmation =
      'Weet je zeker dat je dit apparaat wilt verwijderen uit de sync-ruimte? Dit apparaat zal niet langer toegang hebben tot de gedeelde data.';
  static const String remove = 'Verwijderen';

  // User ID Screen (rebranded from sync)
  static const String userId = 'BQID';
  static const String enterUserId =
      'Voer een BQID in om verbinding te maken met een ander apparaat';
  static const String userIdCode = 'BQID';
  static const String connectToUser = 'Verbdinden met BQID';
  static const String createUserId = 'Maak een nieuwe BQID';
  static const String createUserIdDescription =
      'Maak een nieuwe BQID en deel de code met anderen om verbinding te maken.';
  static const String currentlyConnectedToUser =
      'Je bent momenteel verbonden met een BQID. Gegevens worden gedeeld tussen apparaten.';
  static const String yourUserId = 'Jouw BQID:';
  static const String shareUserId =
      'Deel dit ID met andere apparaten om verbinding te maken.';
  static const String leaveUserId = 'Verwijder BQID van dit apparaat';
  static const String userIdDescription =
      'Verbind met een ander apparaat met een BQID om je data en statistieken te sychroniseren.';
  static const String pleaseEnterUserId = 'Voer een BQID in';
  static const String failedToConnectToUser =
      'Kon niet verbinden met de BQID. Controleer het ID en probeer opnieuw.';
  static const String failedToCreateUserId =
      'Kon BQID niet maken. Probeer opnieuw.';
  static const String userIdButton = 'BQID';
  static const String userIdDescriptionSetting =
      'Maak of verbind met een BQID om je voortgang te synchroniseren';
  static const String createUserIdButton = 'Maak een BQID';
  static const String of = 'Of';
  static const String tapToCopyUserId = 'Tik om BQID te kopiëren';
  static const String userIdCopiedToClipboard = 'BQID gekopieerd naar klembord';

  // BijbelQuiz Gen (Year in Review) Strings
  static const String bijbelquizGenTitle = 'BijbelQuiz Gen';
  static const String bijbelquizGenSubtitle = 'Jouw jaar in ';
  static const String bijbelquizGenWelcomeText =
      'Bekijk je prestaties van vandaag en deel jouw BijbelQuiz-jaar!';
  static const String questionsAnswered = 'Vragen beantwoord';
  static const String bijbelquizGenQuestionsSubtitle =
      'Je hebt hopelijk veel nieuwe dingen geleerd.';
  static const String mistakesMade = 'Fouten gemaakt';
  static const String bijbelquizGenMistakesSubtitle =
      'Elke fout is een kans om te leren en groeien in je Bijbelkennis!';
  static const String timeSpent = 'Tijd besteed';
  static const String bijbelquizGenTimeSubtitle =
      'Je hebt tijd genomen om je Bijbelkennis te verdiepen!';
  static const String bijbelquizGenBestStreak = 'Beste reeks';
  static const String bijbelquizGenStreakSubtitle =
      'Je langste reeks toont je consistentie en toewijding!';
  static const String yearInReview = 'Jouw jaar in review';
  static const String bijbelquizGenYearReviewSubtitle =
      'Een overzicht van je BijbelQuiz prestaties in het afgelopen jaar!';
  static const String hours = 'Uren';
  static const String correctAnswers = 'Correcte antwoorden';
  static const String accuracy = 'Nauwkeurigheid';
  static const String currentStreak = 'Huidige reeks';
  static const String thankYouForUsingBijbelQuiz =
      'Bedankt voor het gebruik van BijbelQuiz!';
  static const String bijbelquizGenThankYouText =
      'We hopen dat onze app het afgelopen jaar tot Zegen mocht zijn. Bedankt voor je steun en betrokkenheid!';
  static const String bijbelquizGenDonateButton = 'Doneer';
  static const String done = 'Klaar';
  static const String bijbelquizGenSkip = 'Overslaan';
  static const String thankYouForSupport = 'Bedankt voor je steun!';
  static const String thankYouForYourSupport =
      'We waarderen dat je BijbelQuiz gebruikt en deelneemt aan onze gemeenschap.';
  static const String supportWithDonation = 'Ondersteun ons met een donatie';
  static const String bijbelquizGenDonationText =
      'Je donatie helpt ons BijbelQuiz te onderhouden en te verbeteren voor jouw, en anderen.';

  // Following-list screen
  static const String notFollowing = "Je volgt op dit moment niemand";
  static const String joinRoomToViewFollowing =
      "Je moet een ruimte toetreden om te zien wij jij volgt";
  static const String searchUsersToFollow =
      "Zoek naar gebruikers om ze te volgen";

  // Followers-list screen
  static const String noFollowers = "Je hebt op dit moment geen volgers";
  static const String joinRoomToViewFollowers =
      "Je moet een ruimte toetreden om je volgers te zien";
  static const String shareBQIDFollowers =
      "Deel jouw BQID met anderen om volgers te krijgen";

  // Messages
  static const String noActiveMessages = 'Geen actieve berichten';
  static const String noActiveMessagesSubtitle =
      'Er zijn momenteel geen berichten om weer te geven';
  static const String errorLoadingMessages = 'Fout bij laden van berichten';
  static const String expiresIn = 'Verloopt over';
  static const String expiringSoon = 'Verloopt binnenkort';
  static const String days = 'dagen';
  static const String noExpirationDate = 'Geen vervaldatum';
  static const String hoursMessage = 'uren'; // Rename to avoid conflict
  static const String minutes = 'minuten';
  static const String lessThanAMinute = 'minder dan een minuut';
  static const String created = 'Aangemaakt';

  // Username
  static const String username = 'Gebruikersnaam';
  static const String enterUsername = 'Voer gebruikersnaam in';
  static const String usernameHint = 'Bijv. Jan2025';
  static const String saveUsername = 'Bewaar gebruikersnaam';
  static const String pleaseEnterUsername = 'Voer een gebruikersnaam in';
  static const String usernameTooLong =
      'Gebruikersnaam mag maximaal 30 tekens bevatten';
  static const String usernameAlreadyTaken = 'Gebruikersnaam is al in gebruik';
  static const String usernameBlacklisted =
      'Deze gebruikersnaam is niet toegestaan';
  static const String usernameSaved = 'Gebruikersnaam opgeslagen!';

  // Beta
  static const String beta = 'Bèta';

  // Share functionality
  static const String shareStatsTitle = 'Deel je statistieken';
  static const String shareYourBijbelQuizStats =
      'Deel je BijbelQuiz statistieken';
  static const String correctAnswersShare = 'Correcte antwoorden';
  static const String currentStreakShare = 'Huidige reeks';
  static const String bestStreakShare = 'Beste reeks';
  static const String mistakesShare = 'Fouten';
  static const String accuracyShare = 'Accuraatheid';
  static const String timeSpentShare = 'Tijd besteed';
  static const String shareResults = 'Deel je resultaten';
  static const String copyLink = 'Kopieer link';

  // Error Reporting Strings
  static const String success = 'Succes';
  static const String reportSubmittedSuccessfully =
      'Je melding is succesvol verstuurd!';
  static const String reportSubmissionFailed =
      'Melding kon niet worden verstuurd. Probeer het later opnieuw.';
  static const String reportBug = 'Meld een bug';
  static const String reportBugDescription =
      'Meld een bug of probleem met de app';
  static const String subject = 'Onderwerp';
  static const String pleaseEnterSubject = 'Voer een onderwerp in';
  static const String description = 'Beschrijving';
  static const String pleaseEnterDescription = 'Voer een beschrijving in';
  static const String emailOptional = 'E-mail (optioneel)';
  static const String reportQuestion = 'Meld Vraag';
  static const String questionReportedSuccessfully = 'Vraag succesvol gemeld';
  static const String errorReportingQuestion = 'Fout bij melden van vraag';

  // Additional hardcoded strings found in codebase
  static const String apiErrorPrefix = 'API Fout: ';
  static const String grid = 'Grid';
  static const String list = 'Lijst';
  static const String compactGrid = 'Compacte grid';
  static const String useTheme = 'Gebruik Thema';
  static const String failedToRemoveDevice = 'Kon apparaat niet verwijderen';
  static const String errorRemovingDevice = 'Fout bij verwijderen apparaat: ';
  static const String sharedStats = 'Gedeelde Statistieken';
  static const String newGame = 'Nieuw spel';
  static const String loadingMessages = 'Berichten laden...';
  static const String errorLoadingUsernames =
      'Fout bij laden gebruikersnamen: ';
  static const String urlCopiedToClipboard = 'URL gekopieerd naar klembord!';
  static const String tryAgainButton = 'Probeer Opnieuw';
  static const String checkConnection = 'Controleer Verbinding';
  static const String goToQuiz = 'Naar de Quiz';
  static const String errorLoadingAnalytics = 'Fout bij laden analytics';
  static const String bibleReferenceCopied = 'Bijbelverwijzing gekopieerd: ';
  static const String bibleReferenceCopiedForSharing =
      'Bijbelverwijzing gekopieerd voor delen';
  static const String errorHandlingTest = 'Foutafhandeling Test';
  static const String errorHandlingTestDescription =
      'Dit scherm demonstreert het nieuwe foutafhandelingssysteem';
  static const String testErrorHandling = 'Test Foutafhandeling';
  static const String testErrorDialog = 'Test Foutdialoog';
  static const String retryButton = 'Opnieuw Proberen';

  // Settings Screen - Additional hardcoded strings
  static const String searchSettings = 'Zoek instellingen...';
  static const String lessonLayoutSettings = 'Leslay-out';
  static const String chooseLessonLayoutDesc =
      'Kies hoe lessen worden weergegeven';
  static const String showIntroductionDesc =
      'Bekijk de app-introductie en tutorial';
  static const String clearQuestionCacheDesc =
      'Verwijder gecachte vragen om opslagruimte vrij te maken';
  static const String followOnSocialMediaDesc =
      'Verbind met ons op social media platforms';
  static const String inviteFriendDesc =
      'Deel een gepersonaliseerde uitnodigingslink met vrienden';
  static const String bugReport = 'Bug Rapport';
  static const String bugReportDesc = 'Rapporteer bugs en problemen met de app';

  // Automatic Bug Reporting
  static const String automaticBugReports = 'Automatisch problemen melden';
  static const String automaticBugReportsDesc =
      'Automatisch bug rapporten verzenden wanneer er fouten optreden (aanbevolen)';
}
