import 'dart:async';
import 'package:flutter/material.dart';
import 'strings_en.dart' as strings_en;
import 'strings_nl.dart' as strings_nl;

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static Map<String, dynamic> _localizedValues = {};

  Future<void> load() async {
    _localizedValues = locale.languageCode == 'nl'
        ? {
            'appName': strings_nl.AppStrings.appName,
            'appDescription': strings_nl.AppStrings.appDescription,
            'loading': strings_nl.AppStrings.loading,
            'error': strings_nl.AppStrings.error,
            'back': strings_nl.AppStrings.back,
            'submit': strings_nl.AppStrings.submit,
            'cancel': strings_nl.AppStrings.cancel,
            'ok': strings_nl.AppStrings.ok,
            'question': strings_nl.AppStrings.question,
            'score': strings_nl.AppStrings.score,
            'correct': strings_nl.AppStrings.correct,
            'incorrect': strings_nl.AppStrings.incorrect,
            'quizComplete': strings_nl.AppStrings.quizComplete,
            'yourScore': strings_nl.AppStrings.yourScore,
            'unlockBiblicalReference':
                strings_nl.AppStrings.unlockBiblicalReference,
            'biblicalReference': strings_nl.AppStrings.biblicalReference,
            'close': strings_nl.AppStrings.close,
            'settings': strings_nl.AppStrings.settings,
            'sound': strings_nl.AppStrings.sound,
            'notifications': strings_nl.AppStrings.notifications,
            'language': strings_nl.AppStrings.language,
            'theme': strings_nl.AppStrings.theme,
            'darkMode': strings_nl.AppStrings.darkMode,
            'lightMode': strings_nl.AppStrings.lightMode,
            'systemDefault': strings_nl.AppStrings.systemDefault,
            'lessons': strings_nl.AppStrings.lessons,
            'continueLearning': strings_nl.AppStrings.continueLearning,
            'store': strings_nl.AppStrings.store,
            'unlockAll': strings_nl.AppStrings.unlockAll,
            'purchaseSuccessful': strings_nl.AppStrings.purchaseSuccessful,
            'donate': strings_nl.AppStrings.donate,
            'donateButton': strings_nl.AppStrings.donateButton,
            'donateExplanation': strings_nl.AppStrings.donateExplanation,
            'guide': strings_nl.AppStrings.guide,
            'howToPlay': strings_nl.AppStrings.howToPlay,
            'connectionError': strings_nl.AppStrings.connectionError,
            'connectionErrorMsg': strings_nl.AppStrings.connectionErrorMsg,
            'unknownError': strings_nl.AppStrings.unknownError,
            'errorNoQuestions': strings_nl.AppStrings.errorNoQuestions,
            'errorLoadQuestions': strings_nl.AppStrings.errorLoadQuestions,
            'couldNotOpenDonationPage':
                strings_nl.AppStrings.couldNotOpenDonationPage,
            'aiError': strings_nl.AppStrings.aiError,
            'apiError': strings_nl.AppStrings.apiError,
            'storageError': strings_nl.AppStrings.storageError,
            'syncError': strings_nl.AppStrings.syncError,
            'permissionDenied': strings_nl.AppStrings.permissionDenied,
            'streak': strings_nl.AppStrings.streak,
            'best': strings_nl.AppStrings.best,
            'time': strings_nl.AppStrings.time,
            'screenSizeNotSupported':
                strings_nl.AppStrings.screenSizeNotSupported,
            'yourProgress': strings_nl.AppStrings.yourProgress,
            'dailyStreak': strings_nl.AppStrings.dailyStreak,
            'continueWith': strings_nl.AppStrings.continueWith,
            'multiplayerQuiz': strings_nl.AppStrings.multiplayerQuiz,
            'timeUp': strings_nl.AppStrings.timeUp,
            'timeUpMessage': strings_nl.AppStrings.timeUpMessage,
            'notEnoughPoints': strings_nl.AppStrings.notEnoughPoints,
            'lessonComplete': strings_nl.AppStrings.lessonComplete,
            'percentage': strings_nl.AppStrings.percentage,
            'bestStreak': strings_nl.AppStrings.bestStreak,
            'streakLabel': strings_nl.AppStrings.streakLabel,
            'retryLesson': strings_nl.AppStrings.retryLesson,
            'nextLesson': strings_nl.AppStrings.nextLesson,
            'backToLessons': strings_nl.AppStrings.backToLessons,
            'display': strings_nl.AppStrings.display,
            'chooseTheme': strings_nl.AppStrings.chooseTheme,
            'lightTheme': strings_nl.AppStrings.lightTheme,
            'systemTheme': strings_nl.AppStrings.systemTheme,
            'darkTheme': strings_nl.AppStrings.darkTheme,
            'oledTheme': strings_nl.AppStrings.oledTheme,
            'greenTheme': strings_nl.AppStrings.greenTheme,
            'orangeTheme': strings_nl.AppStrings.orangeTheme,
            'showNavigationLabels':
                strings_nl.AppStrings.showNavigationLabels,
            'showNavigationLabelsDesc':
                strings_nl.AppStrings.showNavigationLabelsDesc,
            'colorfulMode': strings_nl.AppStrings.colorfulMode,
            'colorfulModeDesc': strings_nl.AppStrings.colorfulModeDesc,
            'hidePopup': strings_nl.AppStrings.hidePopup,
            'hidePopupDesc': strings_nl.AppStrings.hidePopupDesc,
            'tryAgain': strings_nl.AppStrings.tryAgain,
            'couldNotOpenStatusPage':
                strings_nl.AppStrings.couldNotOpenStatusPage,
            'couldNotLoadLessons': strings_nl.AppStrings.couldNotLoadLessons,
            'progress': strings_nl.AppStrings.progress,
            'resetProgress': strings_nl.AppStrings.resetProgress,
            'resetProgressConfirmation':
                strings_nl.AppStrings.resetProgressConfirmation,
            'confirm': strings_nl.AppStrings.confirm,
            'startLesson': strings_nl.AppStrings.startLesson,
            'locked': strings_nl.AppStrings.locked,
            'complete': strings_nl.AppStrings.complete,
            'perfectScore': strings_nl.AppStrings.perfectScore,
            'retry': strings_nl.AppStrings.retry,
            'unknownUser': strings_nl.AppStrings.unknownUser,
            'lastScore': strings_nl.AppStrings.lastScore,
            'notAvailable': strings_nl.AppStrings.notAvailable,
            'previous': strings_nl.AppStrings.previous,
            'next': strings_nl.AppStrings.next,
            'getStarted': strings_nl.AppStrings.getStarted,
            'welcomeTitle': strings_nl.AppStrings.welcomeTitle,
            'welcomeDescription': strings_nl.AppStrings.welcomeDescription,
            'howToPlayTitle': strings_nl.AppStrings.howToPlayTitle,
            'howToPlayDescription':
                strings_nl.AppStrings.howToPlayDescription,
            'notificationsTitle': strings_nl.AppStrings.notificationsTitle,
            'notificationsDescription':
                strings_nl.AppStrings.notificationsDescription,
            'enableNotifications': strings_nl.AppStrings.enableNotifications,
            'notificationsEnabled':
                strings_nl.AppStrings.notificationsEnabled,
            'continueText': strings_nl.AppStrings.continueText,
            'trackProgressTitle': strings_nl.AppStrings.trackProgressTitle,
            'trackProgressDescription':
                strings_nl.AppStrings.trackProgressDescription,
            'customizeExperienceTitle':
                strings_nl.AppStrings.customizeExperienceTitle,
            'customizeExperienceDescription':
                strings_nl.AppStrings.customizeExperienceDescription,
            'supportUsDescription':
                strings_nl.AppStrings.supportUsDescription,
            'donateNow': strings_nl.AppStrings.donateNow,
            'activationTitle': strings_nl.AppStrings.activationTitle,
            'activationSubtitle': strings_nl.AppStrings.activationSubtitle,
            'activationCodeHint': strings_nl.AppStrings.activationCodeHint,
            'activateButton': strings_nl.AppStrings.activateButton,
            'verifyButton': strings_nl.AppStrings.verifyButton,
            'verifying': strings_nl.AppStrings.verifying,
            'activationTip': strings_nl.AppStrings.activationTip,
            'activationSuccess': strings_nl.AppStrings.activationSuccess,
            'activationError': strings_nl.AppStrings.activationError,
            'activationErrorTitle':
                strings_nl.AppStrings.activationErrorTitle,
            'activationSuccessMessage':
                strings_nl.AppStrings.activationSuccessMessage,
            'activationRequired': strings_nl.AppStrings.activationRequired,
            'activationRequiredMessage':
                strings_nl.AppStrings.activationRequiredMessage,
            'yourStars': strings_nl.AppStrings.yourStars,
            'availableStars': strings_nl.AppStrings.availableStars,
            'powerUps': strings_nl.AppStrings.powerUps,
            'themes': strings_nl.AppStrings.themes,
            'availableThemes': strings_nl.AppStrings.availableThemes,
            'unlockTheme': strings_nl.AppStrings.unlockTheme,
            'unlocked': strings_nl.AppStrings.unlocked,
            'notEnoughStars': strings_nl.AppStrings.notEnoughStars,
            'unlockFor': strings_nl.AppStrings.unlockFor,
            'stars': strings_nl.AppStrings.stars,
            'free': strings_nl.AppStrings.free,
            'purchased': strings_nl.AppStrings.purchased,
            'confirmPurchase': strings_nl.AppStrings.confirmPurchase,
            'purchaseConfirmation':
                strings_nl.AppStrings.purchaseConfirmation,
            'purchaseSuccess': strings_nl.AppStrings.purchaseSuccess,
            'purchaseError': strings_nl.AppStrings.purchaseError,
            'couldNotOpenDownloadPage':
                strings_nl.AppStrings.couldNotOpenDownloadPage,
            'doubleStars5Questions':
                strings_nl.AppStrings.doubleStars5Questions,
            'doubleStars5QuestionsDesc':
                strings_nl.AppStrings.doubleStars5QuestionsDesc,
            'tripleStars5Questions':
                strings_nl.AppStrings.tripleStars5Questions,
            'tripleStars5QuestionsDesc':
                strings_nl.AppStrings.tripleStars5QuestionsDesc,
            'fiveTimesStars5Questions':
                strings_nl.AppStrings.fiveTimesStars5Questions,
            'fiveTimesStars5QuestionsDesc':
                strings_nl.AppStrings.fiveTimesStars5QuestionsDesc,
            'doubleStars60Seconds':
                strings_nl.AppStrings.doubleStars60Seconds,
            'doubleStars60SecondsDesc':
                strings_nl.AppStrings.doubleStars60SecondsDesc,
            'oledThemeName': strings_nl.AppStrings.oledThemeName,
            'oledThemeDesc': strings_nl.AppStrings.oledThemeDesc,
            'greenThemeName': strings_nl.AppStrings.greenThemeName,
            'greenThemeDesc': strings_nl.AppStrings.greenThemeDesc,
            'orangeThemeName': strings_nl.AppStrings.orangeThemeName,
            'orangeThemeDesc': strings_nl.AppStrings.orangeThemeDesc,
            'supportUsTitle': strings_nl.AppStrings.supportUsTitle,
            'errorLoadingSettings':
                strings_nl.AppStrings.errorLoadingSettings,
            'gameSettings': strings_nl.AppStrings.gameSettings,
            'gameSpeed': strings_nl.AppStrings.gameSpeed,
            'chooseGameSpeed': strings_nl.AppStrings.chooseGameSpeed,
            'slow': strings_nl.AppStrings.slow,
            'medium': strings_nl.AppStrings.medium,
            'fast': strings_nl.AppStrings.fast,
            'muteSoundEffects': strings_nl.AppStrings.muteSoundEffects,
            'muteSoundEffectsDesc':
                strings_nl.AppStrings.muteSoundEffectsDesc,
            'about': strings_nl.AppStrings.about,
            'serverStatus': strings_nl.AppStrings.serverStatus,
            'checkServiceStatus': strings_nl.AppStrings.checkServiceStatus,
            'openStatusPage': strings_nl.AppStrings.openStatusPage,
            'motivationNotifications':
                strings_nl.AppStrings.motivationNotifications,
            'motivationNotificationsDesc':
                strings_nl.AppStrings.motivationNotificationsDesc,
            'actions': strings_nl.AppStrings.actions,
            'exportStats': strings_nl.AppStrings.exportStats,
            'exportStatsDesc': strings_nl.AppStrings.exportStatsDesc,
            'importStats': strings_nl.AppStrings.importStats,
            'importStatsDesc': strings_nl.AppStrings.importStatsDesc,
            'resetAndLogout': strings_nl.AppStrings.resetAndLogout,
            'resetAndLogoutDesc': strings_nl.AppStrings.resetAndLogoutDesc,
            'showIntroduction': strings_nl.AppStrings.showIntroduction,
            'reportIssue': strings_nl.AppStrings.reportIssue,
            'clearQuestionCache': strings_nl.AppStrings.clearQuestionCache,
            'contactUs': strings_nl.AppStrings.contactUs,
            'emailNotAvailable': strings_nl.AppStrings.emailNotAvailable,
            'cacheCleared': strings_nl.AppStrings.cacheCleared,
            'testAllFeatures': strings_nl.AppStrings.testAllFeatures,
            'copyright': strings_nl.AppStrings.copyright,
            'version': strings_nl.AppStrings.version,
            'social': strings_nl.AppStrings.social,
            'comingSoon': strings_nl.AppStrings.comingSoon,
            'socialComingSoonMessage':
                strings_nl.AppStrings.socialComingSoonMessage,
            'manageYourBqid': strings_nl.AppStrings.manageYourBqid,
            'manageYourBqidSubtitle':
                strings_nl.AppStrings.manageYourBqidSubtitle,
            'moreSocialFeaturesComingSoon':
                strings_nl.AppStrings.moreSocialFeaturesComingSoon,
            'socialFeatures': strings_nl.AppStrings.socialFeatures,
            'connectWithOtherUsers':
                strings_nl.AppStrings.connectWithOtherUsers,
            'search': strings_nl.AppStrings.search,
            'myFollowing': strings_nl.AppStrings.myFollowing,
            'myFollowers': strings_nl.AppStrings.myFollowers,
            'followedUsersScores': strings_nl.AppStrings.followedUsersScores,
            'searchUsers': strings_nl.AppStrings.searchUsers,
            'searchByUsername': strings_nl.AppStrings.searchByUsername,
            'enterUsernameToSearch':
                strings_nl.AppStrings.enterUsernameToSearch,
            'noUsersFound': strings_nl.AppStrings.noUsersFound,
            'follow': strings_nl.AppStrings.follow,
            'unfollow': strings_nl.AppStrings.unfollow,
            'yourself': strings_nl.AppStrings.yourself,
            'bibleBot': strings_nl.AppStrings.bibleBot,
            'couldNotOpenEmail': strings_nl.AppStrings.couldNotOpenEmail,
            'couldNotOpenUpdatePage':
                strings_nl.AppStrings.couldNotOpenUpdatePage,
            'errorOpeningUpdatePage':
                strings_nl.AppStrings.errorOpeningUpdatePage,
            'couldNotCopyLink': strings_nl.AppStrings.couldNotCopyLink,
            'errorCopyingLink': strings_nl.AppStrings.errorCopyingLink,
            'inviteLinkCopied': strings_nl.AppStrings.inviteLinkCopied,
            'statsLinkCopied': strings_nl.AppStrings.statsLinkCopied,
            'copyStatsLinkToClipboard':
                strings_nl.AppStrings.copyStatsLinkToClipboard,
            'importButton': strings_nl.AppStrings.importButton,
            'couldNotScheduleAnyNotifications':
                strings_nl.AppStrings.couldNotScheduleAnyNotifications,
            'couldNotScheduleSomeNotificationsTemplate':
                strings_nl.AppStrings
                    .couldNotScheduleSomeNotificationsTemplate,
            'couldNotScheduleNotificationsError':
                strings_nl.AppStrings.couldNotScheduleNotificationsError,
            'followUs': strings_nl.AppStrings.followUs,
            'followUsMessage': strings_nl.AppStrings.followUsMessage,
            'followMastodon': strings_nl.AppStrings.followMastodon,
            'followPixelfed': strings_nl.AppStrings.followPixelfed,
            'followKwebler': strings_nl.AppStrings.followKwebler,
            'followSignal': strings_nl.AppStrings.followSignal,
            'followDiscord': strings_nl.AppStrings.followDiscord,
            'followBluesky': strings_nl.AppStrings.followBluesky,
            'followNooki': strings_nl.AppStrings.followNooki,
            'mastodonUrl': strings_nl.AppStrings.mastodonUrl,
            'pixelfedUrl': strings_nl.AppStrings.pixelfedUrl,
            'kweblerUrl': strings_nl.AppStrings.kweblerUrl,
            'signalUrl': strings_nl.AppStrings.signalUrl,
            'discordUrl': strings_nl.AppStrings.discordUrl,
            'blueskyUrl': strings_nl.AppStrings.blueskyUrl,
            'nookiUrl': strings_nl.AppStrings.nookiUrl,
            'satisfactionSurvey': strings_nl.AppStrings.satisfactionSurvey,
            'satisfactionSurveyMessage':
                strings_nl.AppStrings.satisfactionSurveyMessage,
            'satisfactionSurveyButton':
                strings_nl.AppStrings.satisfactionSurveyButton,
            'difficultyFeedbackTitle':
                strings_nl.AppStrings.difficultyFeedbackTitle,
            'difficultyFeedbackMessage':
                strings_nl.AppStrings.difficultyFeedbackMessage,
            'difficultyTooHard': strings_nl.AppStrings.difficultyTooHard,
            'difficultyGood': strings_nl.AppStrings.difficultyGood,
            'difficultyTooEasy': strings_nl.AppStrings.difficultyTooEasy,
            'skip': strings_nl.AppStrings.skip,
            'overslaan': strings_nl.AppStrings.overslaan,
            'notEnoughStarsForSkip':
                strings_nl.AppStrings.notEnoughStarsForSkip,
            'resetAndLogoutConfirmation':
                strings_nl.AppStrings.resetAndLogoutConfirmation,
            'donationError': strings_nl.AppStrings.donationError,
            'notificationPermissionDenied':
                strings_nl.AppStrings.notificationPermissionDenied,
            'soundEffectsDescription':
                strings_nl.AppStrings.soundEffectsDescription,
            'doubleStarsActivated':
                strings_nl.AppStrings.doubleStarsActivated,
            'tripleStarsActivated':
                strings_nl.AppStrings.tripleStarsActivated,
            'fiveTimesStarsActivated':
                strings_nl.AppStrings.fiveTimesStarsActivated,
            'doubleStars60SecondsActivated':
                strings_nl.AppStrings.doubleStars60SecondsActivated,
            'powerupActivated': strings_nl.AppStrings.powerupActivated,
            'backToQuiz': strings_nl.AppStrings.backToQuiz,
            'themeUnlocked': strings_nl.AppStrings.themeUnlocked,
            'onlyLatestUnlockedLesson':
                strings_nl.AppStrings.onlyLatestUnlockedLesson,
            'starsEarned': strings_nl.AppStrings.starsEarned,
            'readyForNextChallenge':
                strings_nl.AppStrings.readyForNextChallenge,
            'continueLesson': strings_nl.AppStrings.continueLesson,
            'freePractice': strings_nl.AppStrings.freePractice,
            'lessonNumber': strings_nl.AppStrings.lessonNumber,
            'invalidBiblicalReference':
                strings_nl.AppStrings.invalidBiblicalReference,
            'errorLoadingBiblicalText':
                strings_nl.AppStrings.errorLoadingBiblicalText,
            'errorLoadingWithDetails':
                strings_nl.AppStrings.errorLoadingWithDetails,
            'resumeToGame': strings_nl.AppStrings.resumeToGame,
            'emailAddress': strings_nl.AppStrings.emailAddress,
            'aiThemeFallback': strings_nl.AppStrings.aiThemeFallback,
            'aiThemeGenerator': strings_nl.AppStrings.aiThemeGenerator,
            'aiThemeGeneratorDescription':
                strings_nl.AppStrings.aiThemeGeneratorDescription,
            'checkForUpdates': strings_nl.AppStrings.checkForUpdates,
            'checkForUpdatesDescription':
                strings_nl.AppStrings.checkForUpdatesDescription,
            'checkForUpdatesTooltip':
                strings_nl.AppStrings.checkForUpdatesTooltip,
            'privacyPolicy': strings_nl.AppStrings.privacyPolicy,
            'privacyPolicyDescription':
                strings_nl.AppStrings.privacyPolicyDescription,
            'couldNotOpenPrivacyPolicy':
                strings_nl.AppStrings.couldNotOpenPrivacyPolicy,
            'openPrivacyPolicyTooltip':
                strings_nl.AppStrings.openPrivacyPolicyTooltip,
            'privacyAndAnalytics': strings_nl.AppStrings.privacyAndAnalytics,
            'analytics': strings_nl.AppStrings.analytics,
            'analyticsDescription':
                strings_nl.AppStrings.analyticsDescription,
            'localApi': strings_nl.AppStrings.localApi,
            'enableLocalApi': strings_nl.AppStrings.enableLocalApi,
            'enableLocalApiDesc': strings_nl.AppStrings.enableLocalApiDesc,
            'apiKey': strings_nl.AppStrings.apiKey,
            'generateApiKey': strings_nl.AppStrings.generateApiKey,
            'apiPort': strings_nl.AppStrings.apiPort,
            'apiPortDesc': strings_nl.AppStrings.apiPortDesc,
            'apiStatus': strings_nl.AppStrings.apiStatus,
            'apiStatusDesc': strings_nl.AppStrings.apiStatusDesc,
            'apiDisabled': strings_nl.AppStrings.apiDisabled,
            'apiRunning': strings_nl.AppStrings.apiRunning,
            'apiStarting': strings_nl.AppStrings.apiStarting,
            'copyApiKey': strings_nl.AppStrings.copyApiKey,
            'regenerateApiKey': strings_nl.AppStrings.regenerateApiKey,
            'regenerateApiKeyTitle':
                strings_nl.AppStrings.regenerateApiKeyTitle,
            'regenerateApiKeyMessage':
                strings_nl.AppStrings.regenerateApiKeyMessage,
            'apiKeyCopied': strings_nl.AppStrings.apiKeyCopied,
            'apiKeyCopyFailed': strings_nl.AppStrings.apiKeyCopyFailed,
            'generateKey': strings_nl.AppStrings.generateKey,
            'apiKeyGenerated': strings_nl.AppStrings.apiKeyGenerated,
            'followOnSocialMedia': strings_nl.AppStrings.followOnSocialMedia,
            'followUsOnSocialMedia':
                strings_nl.AppStrings.followUsOnSocialMedia,
            'mastodon': strings_nl.AppStrings.mastodon,
            'pixelfed': strings_nl.AppStrings.pixelfed,
            'kwebler': strings_nl.AppStrings.kwebler,
            'discord': strings_nl.AppStrings.discord,
            'signal': strings_nl.AppStrings.signal,
            'bluesky': strings_nl.AppStrings.bluesky,
            'nooki': strings_nl.AppStrings.nooki,
            'couldNotOpenPlatform':
                strings_nl.AppStrings.couldNotOpenPlatform,
            'shareAppWithFriends': strings_nl.AppStrings.shareAppWithFriends,
            'shareYourStats': strings_nl.AppStrings.shareYourStats,
            'inviteFriend': strings_nl.AppStrings.inviteFriend,
            'enterYourName': strings_nl.AppStrings.enterYourName,
            'enterFriendName': strings_nl.AppStrings.enterFriendName,
            'inviteMessage': strings_nl.AppStrings.inviteMessage,
            'customizeInvite': strings_nl.AppStrings.customizeInvite,
            'sendInvite': strings_nl.AppStrings.sendInvite,
            'languageMustBeNl': strings_nl.AppStrings.languageMustBeNl,
            'failedToSaveTheme': strings_nl.AppStrings.failedToSaveTheme,
            'failedToSaveSlowMode':
                strings_nl.AppStrings.failedToSaveSlowMode,
            'failedToSaveGameSpeed':
                strings_nl.AppStrings.failedToSaveGameSpeed,
            'failedToUpdateDonationStatus':
                strings_nl.AppStrings.failedToUpdateDonationStatus,
            'failedToUpdateCheckForUpdateStatus':
                strings_nl.AppStrings.failedToUpdateCheckForUpdateStatus,
            'failedToSaveMuteSetting':
                strings_nl.AppStrings.failedToSaveMuteSetting,
            'failedToSaveGuideStatus':
                strings_nl.AppStrings.failedToSaveGuideStatus,
            'failedToResetGuideStatus':
                strings_nl.AppStrings.failedToResetGuideStatus,
            'failedToResetCheckForUpdateStatus':
                strings_nl.AppStrings.failedToResetCheckForUpdateStatus,
            'failedToSaveNotificationSetting':
                strings_nl.AppStrings.failedToSaveNotificationSetting,
            'exportStatsTitle': strings_nl.AppStrings.exportStatsTitle,
            'exportStatsMessage': strings_nl.AppStrings.exportStatsMessage,
            'importStatsTitle': strings_nl.AppStrings.importStatsTitle,
            'importStatsMessage': strings_nl.AppStrings.importStatsMessage,
            'importStatsHint': strings_nl.AppStrings.importStatsHint,
            'statsExportedSuccessfully':
                strings_nl.AppStrings.statsExportedSuccessfully,
            'statsImportedSuccessfully':
                strings_nl.AppStrings.statsImportedSuccessfully,
            'failedToExportStats': strings_nl.AppStrings.failedToExportStats,
            'failedToImportStats': strings_nl.AppStrings.failedToImportStats,
            'invalidOrTamperedData':
                strings_nl.AppStrings.invalidOrTamperedData,
            'pleaseEnterValidString':
                strings_nl.AppStrings.pleaseEnterValidString,
            'copyCode': strings_nl.AppStrings.copyCode,
            'codeCopied': strings_nl.AppStrings.codeCopied,
            'multiDeviceSync': strings_nl.AppStrings.multiDeviceSync,
            'enterSyncCode': strings_nl.AppStrings.enterSyncCode,
            'syncCode': strings_nl.AppStrings.syncCode,
            'joinSyncRoom': strings_nl.AppStrings.joinSyncRoom,
            'or': strings_nl.AppStrings.or,
            'startSyncRoom': strings_nl.AppStrings.startSyncRoom,
            'currentlySynced': strings_nl.AppStrings.currentlySynced,
            'yourSyncId': strings_nl.AppStrings.yourSyncId,
            'shareSyncId': strings_nl.AppStrings.shareSyncId,
            'leaveSyncRoom': strings_nl.AppStrings.leaveSyncRoom,
            'pleaseEnterSyncCode': strings_nl.AppStrings.pleaseEnterSyncCode,
            'failedToJoinSyncRoom':
                strings_nl.AppStrings.failedToJoinSyncRoom,
            'errorGeneric': strings_nl.AppStrings.errorGeneric,
            'errorLeavingSyncRoom':
                strings_nl.AppStrings.errorLeavingSyncRoom,
            'failedToStartSyncRoom':
                strings_nl.AppStrings.failedToStartSyncRoom,
            'multiDeviceSyncButton':
                strings_nl.AppStrings.multiDeviceSyncButton,
            'syncDataDescription': strings_nl.AppStrings.syncDataDescription,
            'syncDescription': strings_nl.AppStrings.syncDescription,
            'createSyncRoom': strings_nl.AppStrings.createSyncRoom,
            'createSyncDescription':
                strings_nl.AppStrings.createSyncDescription,
            'connectedDevices': strings_nl.AppStrings.connectedDevices,
            'thisDevice': strings_nl.AppStrings.thisDevice,
            'noDevicesConnected': strings_nl.AppStrings.noDevicesConnected,
            'removeDevice': strings_nl.AppStrings.removeDevice,
            'removeDeviceConfirmation':
                strings_nl.AppStrings.removeDeviceConfirmation,
            'remove': strings_nl.AppStrings.remove,
            'userId': strings_nl.AppStrings.userId,
            'enterUserId': strings_nl.AppStrings.enterUserId,
            'userIdCode': strings_nl.AppStrings.userIdCode,
            'connectToUser': strings_nl.AppStrings.connectToUser,
            'createUserId': strings_nl.AppStrings.createUserId,
            'createUserIdDescription':
                strings_nl.AppStrings.createUserIdDescription,
            'currentlyConnectedToUser':
                strings_nl.AppStrings.currentlyConnectedToUser,
            'yourUserId': strings_nl.AppStrings.yourUserId,
            'shareUserId': strings_nl.AppStrings.shareUserId,
            'leaveUserId': strings_nl.AppStrings.leaveUserId,
            'userIdDescription': strings_nl.AppStrings.userIdDescription,
            'pleaseEnterUserId': strings_nl.AppStrings.pleaseEnterUserId,
            'failedToConnectToUser':
                strings_nl.AppStrings.failedToConnectToUser,
            'failedToCreateUserId':
                strings_nl.AppStrings.failedToCreateUserId,
            'userIdButton': strings_nl.AppStrings.userIdButton,
            'userIdDescriptionSetting':
                strings_nl.AppStrings.userIdDescriptionSetting,
            'createUserIdButton': strings_nl.AppStrings.createUserIdButton,
            'of': strings_nl.AppStrings.of,
            'tapToCopyUserId': strings_nl.AppStrings.tapToCopyUserId,
            'userIdCopiedToClipboard':
                strings_nl.AppStrings.userIdCopiedToClipboard,
            'bijbelquizGenTitle': strings_nl.AppStrings.bijbelquizGenTitle,
            'bijbelquizGenSubtitle':
                strings_nl.AppStrings.bijbelquizGenSubtitle,
            'bijbelquizGenWelcomeText':
                strings_nl.AppStrings.bijbelquizGenWelcomeText,
            'questionsAnswered': strings_nl.AppStrings.questionsAnswered,
            'bijbelquizGenQuestionsSubtitle':
                strings_nl.AppStrings.bijbelquizGenQuestionsSubtitle,
            'mistakesMade': strings_nl.AppStrings.mistakesMade,
            'bijbelquizGenMistakesSubtitle':
                strings_nl.AppStrings.bijbelquizGenMistakesSubtitle,
            'timeSpent': strings_nl.AppStrings.timeSpent,
            'bijbelquizGenTimeSubtitle':
                strings_nl.AppStrings.bijbelquizGenTimeSubtitle,
            'bijbelquizGenBestStreak':
                strings_nl.AppStrings.bijbelquizGenBestStreak,
            'bijbelquizGenStreakSubtitle':
                strings_nl.AppStrings.bijbelquizGenStreakSubtitle,
            'yearInReview': strings_nl.AppStrings.yearInReview,
            'bijbelquizGenYearReviewSubtitle':
                strings_nl.AppStrings.bijbelquizGenYearReviewSubtitle,
            'hours': strings_nl.AppStrings.hours,
            'correctAnswers': strings_nl.AppStrings.correctAnswers,
            'accuracy': strings_nl.AppStrings.accuracy,
            'currentStreak': strings_nl.AppStrings.currentStreak,
            'thankYouForUsingBijbelQuiz':
                strings_nl.AppStrings.thankYouForUsingBijbelQuiz,
            'bijbelquizGenThankYouText':
                strings_nl.AppStrings.bijbelquizGenThankYouText,
            'bijbelquizGenDonateButton':
                strings_nl.AppStrings.bijbelquizGenDonateButton,
            'done': strings_nl.AppStrings.done,
            'bijbelquizGenSkip': strings_nl.AppStrings.bijbelquizGenSkip,
            'thankYouForSupport': strings_nl.AppStrings.thankYouForSupport,
            'thankYouForYourSupport':
                strings_nl.AppStrings.thankYouForYourSupport,
            'supportWithDonation': strings_nl.AppStrings.supportWithDonation,
            'bijbelquizGenDonationText':
                strings_nl.AppStrings.bijbelquizGenDonationText,
            'notFollowing': strings_nl.AppStrings.notFollowing,
            'joinRoomToViewFollowing':
                strings_nl.AppStrings.joinRoomToViewFollowing,
            'searchUsersToFollow': strings_nl.AppStrings.searchUsersToFollow,
            'noFollowers': strings_nl.AppStrings.noFollowers,
            'joinRoomToViewFollowers':
                strings_nl.AppStrings.joinRoomToViewFollowers,
            'shareBQIDFollowers': strings_nl.AppStrings.shareBQIDFollowers,
            'username': strings_nl.AppStrings.username,
            'enterUsername': strings_nl.AppStrings.enterUsername,
            'usernameHint': strings_nl.AppStrings.usernameHint,
            'saveUsername': strings_nl.AppStrings.saveUsername,
            'pleaseEnterUsername': strings_nl.AppStrings.pleaseEnterUsername,
            'usernameTooLong': strings_nl.AppStrings.usernameTooLong,
            'usernameAlreadyTaken':
                strings_nl.AppStrings.usernameAlreadyTaken,
            'usernameBlacklisted': strings_nl.AppStrings.usernameBlacklisted,
            'usernameSaved': strings_nl.AppStrings.usernameSaved,
            'beta': strings_nl.AppStrings.beta,
            'selectAppLanguage': strings_nl.AppStrings.selectAppLanguage,
          }
        : {
            'appName': strings_en.AppStrings.appName,
            'appDescription': strings_en.AppStrings.appDescription,
            'loading': strings_en.AppStrings.loading,
            'error': strings_en.AppStrings.error,
            'back': strings_en.AppStrings.back,
            'submit': strings_en.AppStrings.submit,
            'cancel': strings_en.AppStrings.cancel,
            'ok': strings_en.AppStrings.ok,
            'question': strings_en.AppStrings.question,
            'score': strings_en.AppStrings.score,
            'correct': strings_en.AppStrings.correct,
            'incorrect': strings_en.AppStrings.incorrect,
            'quizComplete': strings_en.AppStrings.quizComplete,
            'yourScore': strings_en.AppStrings.yourScore,
            'unlockBiblicalReference':
                strings_en.AppStrings.unlockBiblicalReference,
            'biblicalReference': strings_en.AppStrings.biblicalReference,
            'close': strings_en.AppStrings.close,
            'settings': strings_en.AppStrings.settings,
            'sound': strings_en.AppStrings.sound,
            'notifications': strings_en.AppStrings.notifications,
            'language': strings_en.AppStrings.language,
            'theme': strings_en.AppStrings.theme,
            'darkMode': strings_en.AppStrings.darkMode,
            'lightMode': strings_en.AppStrings.lightMode,
            'systemDefault': strings_en.AppStrings.systemDefault,
            'lessons': strings_en.AppStrings.lessons,
            'continueLearning': strings_en.AppStrings.continueLearning,
            'store': strings_en.AppStrings.store,
            'unlockAll': strings_en.AppStrings.unlockAll,
            'purchaseSuccessful': strings_en.AppStrings.purchaseSuccessful,
            'donate': strings_en.AppStrings.donate,
            'donateButton': strings_en.AppStrings.donateButton,
            'donateExplanation': strings_en.AppStrings.donateExplanation,
            'guide': strings_en.AppStrings.guide,
            'howToPlay': strings_en.AppStrings.howToPlay,
            'connectionError': strings_en.AppStrings.connectionError,
            'connectionErrorMsg': strings_en.AppStrings.connectionErrorMsg,
            'unknownError': strings_en.AppStrings.unknownError,
            'errorNoQuestions': strings_en.AppStrings.errorNoQuestions,
            'errorLoadQuestions': strings_en.AppStrings.errorLoadQuestions,
            'couldNotOpenDonationPage':
                strings_en.AppStrings.couldNotOpenDonationPage,
            'aiError': strings_en.AppStrings.aiError,
            'apiError': strings_en.AppStrings.apiError,
            'storageError': strings_en.AppStrings.storageError,
            'syncError': strings_en.AppStrings.syncError,
            'permissionDenied': strings_en.AppStrings.permissionDenied,
            'streak': strings_en.AppStrings.streak,
            'best': strings_en.AppStrings.best,
            'time': strings_en.AppStrings.time,
            'screenSizeNotSupported':
                strings_en.AppStrings.screenSizeNotSupported,
            'yourProgress': strings_en.AppStrings.yourProgress,
            'dailyStreak': strings_en.AppStrings.dailyStreak,
            'continueWith': strings_en.AppStrings.continueWith,
            'multiplayerQuiz': strings_en.AppStrings.multiplayerQuiz,
            'timeUp': strings_en.AppStrings.timeUp,
            'timeUpMessage': strings_en.AppStrings.timeUpMessage,
            'notEnoughPoints': strings_en.AppStrings.notEnoughPoints,
            'lessonComplete': strings_en.AppStrings.lessonComplete,
            'percentage': strings_en.AppStrings.percentage,
            'bestStreak': strings_en.AppStrings.bestStreak,
            'streakLabel': strings_en.AppStrings.streakLabel,
            'retryLesson': strings_en.AppStrings.retryLesson,
            'nextLesson': strings_en.AppStrings.nextLesson,
            'backToLessons': strings_en.AppStrings.backToLessons,
            'display': strings_en.AppStrings.display,
            'chooseTheme': strings_en.AppStrings.chooseTheme,
            'lightTheme': strings_en.AppStrings.lightTheme,
            'systemTheme': strings_en.AppStrings.systemTheme,
            'darkTheme': strings_en.AppStrings.darkTheme,
            'oledTheme': strings_en.AppStrings.oledTheme,
            'greenTheme': strings_en.AppStrings.greenTheme,
            'orangeTheme': strings_en.AppStrings.orangeTheme,
            'showNavigationLabels':
                strings_en.AppStrings.showNavigationLabels,
            'showNavigationLabelsDesc':
                strings_en.AppStrings.showNavigationLabelsDesc,
            'colorfulMode': strings_en.AppStrings.colorfulMode,
            'colorfulModeDesc': strings_en.AppStrings.colorfulModeDesc,
            'hidePopup': strings_en.AppStrings.hidePopup,
            'hidePopupDesc': strings_en.AppStrings.hidePopupDesc,
            'tryAgain': strings_en.AppStrings.tryAgain,
            'couldNotOpenStatusPage':
                strings_en.AppStrings.couldNotOpenStatusPage,
            'couldNotLoadLessons': strings_en.AppStrings.couldNotLoadLessons,
            'progress': strings_en.AppStrings.progress,
            'resetProgress': strings_en.AppStrings.resetProgress,
            'resetProgressConfirmation':
                strings_en.AppStrings.resetProgressConfirmation,
            'confirm': strings_en.AppStrings.confirm,
            'startLesson': strings_en.AppStrings.startLesson,
            'locked': strings_en.AppStrings.locked,
            'complete': strings_en.AppStrings.complete,
            'perfectScore': strings_en.AppStrings.perfectScore,
            'retry': strings_en.AppStrings.retry,
            'unknownUser': strings_en.AppStrings.unknownUser,
            'lastScore': strings_en.AppStrings.lastScore,
            'notAvailable': strings_en.AppStrings.notAvailable,
            'previous': strings_en.AppStrings.previous,
            'next': strings_en.AppStrings.next,
            'getStarted': strings_en.AppStrings.getStarted,
            'welcomeTitle': strings_en.AppStrings.welcomeTitle,
            'welcomeDescription': strings_en.AppStrings.welcomeDescription,
            'howToPlayTitle': strings_en.AppStrings.howToPlayTitle,
            'howToPlayDescription':
                strings_en.AppStrings.howToPlayDescription,
            'notificationsTitle': strings_en.AppStrings.notificationsTitle,
            'notificationsDescription':
                strings_en.AppStrings.notificationsDescription,
            'enableNotifications': strings_en.AppStrings.enableNotifications,
            'notificationsEnabled':
                strings_en.AppStrings.notificationsEnabled,
            'continueText': strings_en.AppStrings.continueText,
            'trackProgressTitle': strings_en.AppStrings.trackProgressTitle,
            'trackProgressDescription':
                strings_en.AppStrings.trackProgressDescription,
            'customizeExperienceTitle':
                strings_en.AppStrings.customizeExperienceTitle,
            'customizeExperienceDescription':
                strings_en.AppStrings.customizeExperienceDescription,
            'supportUsDescription':
                strings_en.AppStrings.supportUsDescription,
            'donateNow': strings_en.AppStrings.donateNow,
            'activationTitle': strings_en.AppStrings.activationTitle,
            'activationSubtitle': strings_en.AppStrings.activationSubtitle,
            'activationCodeHint': strings_en.AppStrings.activationCodeHint,
            'activateButton': strings_en.AppStrings.activateButton,
            'verifyButton': strings_en.AppStrings.verifyButton,
            'verifying': strings_en.AppStrings.verifying,
            'activationTip': strings_en.AppStrings.activationTip,
            'activationSuccess': strings_en.AppStrings.activationSuccess,
            'activationError': strings_en.AppStrings.activationError,
            'activationErrorTitle':
                strings_en.AppStrings.activationErrorTitle,
            'activationSuccessMessage':
                strings_en.AppStrings.activationSuccessMessage,
            'activationRequired': strings_en.AppStrings.activationRequired,
            'activationRequiredMessage':
                strings_en.AppStrings.activationRequiredMessage,
            'yourStars': strings_en.AppStrings.yourStars,
            'availableStars': strings_en.AppStrings.availableStars,
            'powerUps': strings_en.AppStrings.powerUps,
            'themes': strings_en.AppStrings.themes,
            'availableThemes': strings_en.AppStrings.availableThemes,
            'unlockTheme': strings_en.AppStrings.unlockTheme,
            'unlocked': strings_en.AppStrings.unlocked,
            'notEnoughStars': strings_en.AppStrings.notEnoughStars,
            'unlockFor': strings_en.AppStrings.unlockFor,
            'stars': strings_en.AppStrings.stars,
            'free': strings_en.AppStrings.free,
            'purchased': strings_en.AppStrings.purchased,
            'confirmPurchase': strings_en.AppStrings.confirmPurchase,
            'purchaseConfirmation':
                strings_en.AppStrings.purchaseConfirmation,
            'purchaseSuccess': strings_en.AppStrings.purchaseSuccess,
            'purchaseError': strings_en.AppStrings.purchaseError,
            'couldNotOpenDownloadPage':
                strings_en.AppStrings.couldNotOpenDownloadPage,
            'doubleStars5Questions':
                strings_en.AppStrings.doubleStars5Questions,
            'doubleStars5QuestionsDesc':
                strings_en.AppStrings.doubleStars5QuestionsDesc,
            'tripleStars5Questions':
                strings_en.AppStrings.tripleStars5Questions,
            'tripleStars5QuestionsDesc':
                strings_en.AppStrings.tripleStars5QuestionsDesc,
            'fiveTimesStars5Questions':
                strings_en.AppStrings.fiveTimesStars5Questions,
            'fiveTimesStars5QuestionsDesc':
                strings_en.AppStrings.fiveTimesStars5QuestionsDesc,
            'doubleStars60Seconds':
                strings_en.AppStrings.doubleStars60Seconds,
            'doubleStars60SecondsDesc':
                strings_en.AppStrings.doubleStars60SecondsDesc,
            'oledThemeName': strings_en.AppStrings.oledThemeName,
            'oledThemeDesc': strings_en.AppStrings.oledThemeDesc,
            'greenThemeName': strings_en.AppStrings.greenThemeName,
            'greenThemeDesc': strings_en.AppStrings.greenThemeDesc,
            'orangeThemeName': strings_en.AppStrings.orangeThemeName,
            'orangeThemeDesc': strings_en.AppStrings.orangeThemeDesc,
            'supportUsTitle': strings_en.AppStrings.supportUsTitle,
            'errorLoadingSettings':
                strings_en.AppStrings.errorLoadingSettings,
            'gameSettings': strings_en.AppStrings.gameSettings,
            'gameSpeed': strings_en.AppStrings.gameSpeed,
            'chooseGameSpeed': strings_en.AppStrings.chooseGameSpeed,
            'slow': strings_en.AppStrings.slow,
            'medium': strings_en.AppStrings.medium,
            'fast': strings_en.AppStrings.fast,
            'muteSoundEffects': strings_en.AppStrings.muteSoundEffects,
            'muteSoundEffectsDesc':
                strings_en.AppStrings.muteSoundEffectsDesc,
            'about': strings_en.AppStrings.about,
            'serverStatus': strings_en.AppStrings.serverStatus,
            'checkServiceStatus': strings_en.AppStrings.checkServiceStatus,
            'openStatusPage': strings_en.AppStrings.openStatusPage,
            'motivationNotifications':
                strings_en.AppStrings.motivationNotifications,
            'motivationNotificationsDesc':
                strings_en.AppStrings.motivationNotificationsDesc,
            'actions': strings_en.AppStrings.actions,
            'exportStats': strings_en.AppStrings.exportStats,
            'exportStatsDesc': strings_en.AppStrings.exportStatsDesc,
            'importStats': strings_en.AppStrings.importStats,
            'importStatsDesc': strings_en.AppStrings.importStatsDesc,
            'resetAndLogout': strings_en.AppStrings.resetAndLogout,
            'resetAndLogoutDesc': strings_en.AppStrings.resetAndLogoutDesc,
            'showIntroduction': strings_en.AppStrings.showIntroduction,
            'reportIssue': strings_en.AppStrings.reportIssue,
            'clearQuestionCache': strings_en.AppStrings.clearQuestionCache,
            'contactUs': strings_en.AppStrings.contactUs,
            'emailNotAvailable': strings_en.AppStrings.emailNotAvailable,
            'cacheCleared': strings_en.AppStrings.cacheCleared,
            'testAllFeatures': strings_en.AppStrings.testAllFeatures,
            'copyright': strings_en.AppStrings.copyright,
            'version': strings_en.AppStrings.version,
            'social': strings_en.AppStrings.social,
            'comingSoon': strings_en.AppStrings.comingSoon,
            'socialComingSoonMessage':
                strings_en.AppStrings.socialComingSoonMessage,
            'manageYourBqid': strings_en.AppStrings.manageYourBqid,
            'manageYourBqidSubtitle':
                strings_en.AppStrings.manageYourBqidSubtitle,
            'moreSocialFeaturesComingSoon':
                strings_en.AppStrings.moreSocialFeaturesComingSoon,
            'socialFeatures': strings_en.AppStrings.socialFeatures,
            'connectWithOtherUsers':
                strings_en.AppStrings.connectWithOtherUsers,
            'search': strings_en.AppStrings.search,
            'myFollowing': strings_en.AppStrings.myFollowing,
            'myFollowers': strings_en.AppStrings.myFollowers,
            'followedUsersScores': strings_en.AppStrings.followedUsersScores,
            'searchUsers': strings_en.AppStrings.searchUsers,
            'searchByUsername': strings_en.AppStrings.searchByUsername,
            'enterUsernameToSearch':
                strings_en.AppStrings.enterUsernameToSearch,
            'noUsersFound': strings_en.AppStrings.noUsersFound,
            'follow': strings_en.AppStrings.follow,
            'unfollow': strings_en.AppStrings.unfollow,
            'yourself': strings_en.AppStrings.yourself,
            'bibleBot': strings_en.AppStrings.bibleBot,
            'couldNotOpenEmail': strings_en.AppStrings.couldNotOpenEmail,
            'couldNotOpenUpdatePage':
                strings_en.AppStrings.couldNotOpenUpdatePage,
            'errorOpeningUpdatePage':
                strings_en.AppStrings.errorOpeningUpdatePage,
            'couldNotCopyLink': strings_en.AppStrings.couldNotCopyLink,
            'errorCopyingLink': strings_en.AppStrings.errorCopyingLink,
            'inviteLinkCopied': strings_en.AppStrings.inviteLinkCopied,
            'statsLinkCopied': strings_en.AppStrings.statsLinkCopied,
            'copyStatsLinkToClipboard':
                strings_en.AppStrings.copyStatsLinkToClipboard,
            'importButton': strings_en.AppStrings.importButton,
            'couldNotScheduleAnyNotifications':
                strings_en.AppStrings.couldNotScheduleAnyNotifications,
            'couldNotScheduleSomeNotificationsTemplate':
                strings_en.AppStrings
                    .couldNotScheduleSomeNotificationsTemplate,
            'couldNotScheduleNotificationsError':
                strings_en.AppStrings.couldNotScheduleNotificationsError,
            'followUs': strings_en.AppStrings.followUs,
            'followUsMessage': strings_en.AppStrings.followUsMessage,
            'followMastodon': strings_en.AppStrings.followMastodon,
            'followPixelfed': strings_en.AppStrings.followPixelfed,
            'followKwebler': strings_en.AppStrings.followKwebler,
            'followSignal': strings_en.AppStrings.followSignal,
            'followDiscord': strings_en.AppStrings.followDiscord,
            'followBluesky': strings_en.AppStrings.followBluesky,
            'followNooki': strings_en.AppStrings.followNooki,
            'mastodonUrl': strings_en.AppStrings.mastodonUrl,
            'pixelfedUrl': strings_en.AppStrings.pixelfedUrl,
            'kweblerUrl': strings_en.AppStrings.kweblerUrl,
            'signalUrl': strings_en.AppStrings.signalUrl,
            'discordUrl': strings_en.AppStrings.discordUrl,
            'blueskyUrl': strings_en.AppStrings.blueskyUrl,
            'nookiUrl': strings_en.AppStrings.nookiUrl,
            'satisfactionSurvey': strings_en.AppStrings.satisfactionSurvey,
            'satisfactionSurveyMessage':
                strings_en.AppStrings.satisfactionSurveyMessage,
            'satisfactionSurveyButton':
                strings_en.AppStrings.satisfactionSurveyButton,
            'difficultyFeedbackTitle':
                strings_en.AppStrings.difficultyFeedbackTitle,
            'difficultyFeedbackMessage':
                strings_en.AppStrings.difficultyFeedbackMessage,
            'difficultyTooHard': strings_en.AppStrings.difficultyTooHard,
            'difficultyGood': strings_en.AppStrings.difficultyGood,
            'difficultyTooEasy': strings_en.AppStrings.difficultyTooEasy,
            'skip': strings_en.AppStrings.skip,
            'overslaan': strings_en.AppStrings.overslaan,
            'notEnoughStarsForSkip':
                strings_en.AppStrings.notEnoughStarsForSkip,
            'resetAndLogoutConfirmation':
                strings_en.AppStrings.resetAndLogoutConfirmation,
            'donationError': strings_en.AppStrings.donationError,
            'notificationPermissionDenied':
                strings_en.AppStrings.notificationPermissionDenied,
            'soundEffectsDescription':
                strings_en.AppStrings.soundEffectsDescription,
            'doubleStarsActivated':
                strings_en.AppStrings.doubleStarsActivated,
            'tripleStarsActivated':
                strings_en.AppStrings.tripleStarsActivated,
            'fiveTimesStarsActivated':
                strings_en.AppStrings.fiveTimesStarsActivated,
            'doubleStars60SecondsActivated':
                strings_en.AppStrings.doubleStars60SecondsActivated,
            'powerupActivated': strings_en.AppStrings.powerupActivated,
            'backToQuiz': strings_en.AppStrings.backToQuiz,
            'themeUnlocked': strings_en.AppStrings.themeUnlocked,
            'onlyLatestUnlockedLesson':
                strings_en.AppStrings.onlyLatestUnlockedLesson,
            'starsEarned': strings_en.AppStrings.starsEarned,
            'readyForNextChallenge':
                strings_en.AppStrings.readyForNextChallenge,
            'continueLesson': strings_en.AppStrings.continueLesson,
            'freePractice': strings_en.AppStrings.freePractice,
            'lessonNumber': strings_en.AppStrings.lessonNumber,
            'invalidBiblicalReference':
                strings_en.AppStrings.invalidBiblicalReference,
            'errorLoadingBiblicalText':
                strings_en.AppStrings.errorLoadingBiblicalText,
            'errorLoadingWithDetails':
                strings_en.AppStrings.errorLoadingWithDetails,
            'resumeToGame': strings_en.AppStrings.resumeToGame,
            'emailAddress': strings_en.AppStrings.emailAddress,
            'aiThemeFallback': strings_en.AppStrings.aiThemeFallback,
            'aiThemeGenerator': strings_en.AppStrings.aiThemeGenerator,
            'aiThemeGeneratorDescription':
                strings_en.AppStrings.aiThemeGeneratorDescription,
            'checkForUpdates': strings_en.AppStrings.checkForUpdates,
            'checkForUpdatesDescription':
                strings_en.AppStrings.checkForUpdatesDescription,
            'checkForUpdatesTooltip':
                strings_en.AppStrings.checkForUpdatesTooltip,
            'privacyPolicy': strings_en.AppStrings.privacyPolicy,
            'privacyPolicyDescription':
                strings_en.AppStrings.privacyPolicyDescription,
            'couldNotOpenPrivacyPolicy':
                strings_en.AppStrings.couldNotOpenPrivacyPolicy,
            'openPrivacyPolicyTooltip':
                strings_en.AppStrings.openPrivacyPolicyTooltip,
            'privacyAndAnalytics': strings_en.AppStrings.privacyAndAnalytics,
            'analytics': strings_en.AppStrings.analytics,
            'analyticsDescription':
                strings_en.AppStrings.analyticsDescription,
            'localApi': strings_en.AppStrings.localApi,
            'enableLocalApi': strings_en.AppStrings.enableLocalApi,
            'enableLocalApiDesc': strings_en.AppStrings.enableLocalApiDesc,
            'apiKey': strings_en.AppStrings.apiKey,
            'generateApiKey': strings_en.AppStrings.generateApiKey,
            'apiPort': strings_en.AppStrings.apiPort,
            'apiPortDesc': strings_en.AppStrings.apiPortDesc,
            'apiStatus': strings_en.AppStrings.apiStatus,
            'apiStatusDesc': strings_en.AppStrings.apiStatusDesc,
            'apiDisabled': strings_en.AppStrings.apiDisabled,
            'apiRunning': strings_en.AppStrings.apiRunning,
            'apiStarting': strings_en.AppStrings.apiStarting,
            'copyApiKey': strings_en.AppStrings.copyApiKey,
            'regenerateApiKey': strings_en.AppStrings.regenerateApiKey,
            'regenerateApiKeyTitle':
                strings_en.AppStrings.regenerateApiKeyTitle,
            'regenerateApiKeyMessage':
                strings_en.AppStrings.regenerateApiKeyMessage,
            'apiKeyCopied': strings_en.AppStrings.apiKeyCopied,
            'apiKeyCopyFailed': strings_en.AppStrings.apiKeyCopyFailed,
            'generateKey': strings_en.AppStrings.generateKey,
            'apiKeyGenerated': strings_en.AppStrings.apiKeyGenerated,
            'followOnSocialMedia': strings_en.AppStrings.followOnSocialMedia,
            'followUsOnSocialMedia':
                strings_en.AppStrings.followUsOnSocialMedia,
            'mastodon': strings_en.AppStrings.mastodon,
            'pixelfed': strings_en.AppStrings.pixelfed,
            'kwebler': strings_en.AppStrings.kwebler,
            'discord': strings_en.AppStrings.discord,
            'signal': strings_en.AppStrings.signal,
            'bluesky': strings_en.AppStrings.bluesky,
            'nooki': strings_en.AppStrings.nooki,
            'couldNotOpenPlatform':
                strings_en.AppStrings.couldNotOpenPlatform,
            'shareAppWithFriends': strings_en.AppStrings.shareAppWithFriends,
            'shareYourStats': strings_en.AppStrings.shareYourStats,
            'inviteFriend': strings_en.AppStrings.inviteFriend,
            'enterYourName': strings_en.AppStrings.enterYourName,
            'enterFriendName': strings_en.AppStrings.enterFriendName,
            'inviteMessage': strings_en.AppStrings.inviteMessage,
            'customizeInvite': strings_en.AppStrings.customizeInvite,
            'sendInvite': strings_en.AppStrings.sendInvite,
            'languageMustBeNl': strings_en.AppStrings.languageMustBeNl,
            'failedToSaveTheme': strings_en.AppStrings.failedToSaveTheme,
            'failedToSaveSlowMode':
                strings_en.AppStrings.failedToSaveSlowMode,
            'failedToSaveGameSpeed':
                strings_en.AppStrings.failedToSaveGameSpeed,
            'failedToUpdateDonationStatus':
                strings_en.AppStrings.failedToUpdateDonationStatus,
            'failedToUpdateCheckForUpdateStatus':
                strings_en.AppStrings.failedToUpdateCheckForUpdateStatus,
            'failedToSaveMuteSetting':
                strings_en.AppStrings.failedToSaveMuteSetting,
            'failedToSaveGuideStatus':
                strings_en.AppStrings.failedToSaveGuideStatus,
            'failedToResetGuideStatus':
                strings_en.AppStrings.failedToResetGuideStatus,
            'failedToResetCheckForUpdateStatus':
                strings_en.AppStrings.failedToResetCheckForUpdateStatus,
            'failedToSaveNotificationSetting':
                strings_en.AppStrings.failedToSaveNotificationSetting,
            'exportStatsTitle': strings_en.AppStrings.exportStatsTitle,
            'exportStatsMessage': strings_en.AppStrings.exportStatsMessage,
            'importStatsTitle': strings_en.AppStrings.importStatsTitle,
            'importStatsMessage': strings_en.AppStrings.importStatsMessage,
            'importStatsHint': strings_en.AppStrings.importStatsHint,
            'statsExportedSuccessfully':
                strings_en.AppStrings.statsExportedSuccessfully,
            'statsImportedSuccessfully':
                strings_en.AppStrings.statsImportedSuccessfully,
            'failedToExportStats': strings_en.AppStrings.failedToExportStats,
            'failedToImportStats': strings_en.AppStrings.failedToImportStats,
            'invalidOrTamperedData':
                strings_en.AppStrings.invalidOrTamperedData,
            'pleaseEnterValidString':
                strings_en.AppStrings.pleaseEnterValidString,
            'copyCode': strings_en.AppStrings.copyCode,
            'codeCopied': strings_en.AppStrings.codeCopied,
            'multiDeviceSync': strings_en.AppStrings.multiDeviceSync,
            'enterSyncCode': strings_en.AppStrings.enterSyncCode,
            'syncCode': strings_en.AppStrings.syncCode,
            'joinSyncRoom': strings_en.AppStrings.joinSyncRoom,
            'or': strings_en.AppStrings.or,
            'startSyncRoom': strings_en.AppStrings.startSyncRoom,
            'currentlySynced': strings_en.AppStrings.currentlySynced,
            'yourSyncId': strings_en.AppStrings.yourSyncId,
            'shareSyncId': strings_en.AppStrings.shareSyncId,
            'leaveSyncRoom': strings_en.AppStrings.leaveSyncRoom,
            'pleaseEnterSyncCode': strings_en.AppStrings.pleaseEnterSyncCode,
            'failedToJoinSyncRoom':
                strings_en.AppStrings.failedToJoinSyncRoom,
            'errorGeneric': strings_en.AppStrings.errorGeneric,
            'errorLeavingSyncRoom':
                strings_en.AppStrings.errorLeavingSyncRoom,
            'failedToStartSyncRoom':
                strings_en.AppStrings.failedToStartSyncRoom,
            'multiDeviceSyncButton':
                strings_en.AppStrings.multiDeviceSyncButton,
            'syncDataDescription': strings_en.AppStrings.syncDataDescription,
            'syncDescription': strings_en.AppStrings.syncDescription,
            'createSyncRoom': strings_en.AppStrings.createSyncRoom,
            'createSyncDescription':
                strings_en.AppStrings.createSyncDescription,
            'connectedDevices': strings_en.AppStrings.connectedDevices,
            'thisDevice': strings_en.AppStrings.thisDevice,
            'noDevicesConnected': strings_en.AppStrings.noDevicesConnected,
            'removeDevice': strings_en.AppStrings.removeDevice,
            'removeDeviceConfirmation':
                strings_en.AppStrings.removeDeviceConfirmation,
            'remove': strings_en.AppStrings.remove,
            'userId': strings_en.AppStrings.userId,
            'enterUserId': strings_en.AppStrings.enterUserId,
            'userIdCode': strings_en.AppStrings.userIdCode,
            'connectToUser': strings_en.AppStrings.connectToUser,
            'createUserId': strings_en.AppStrings.createUserId,
            'createUserIdDescription':
                strings_en.AppStrings.createUserIdDescription,
            'currentlyConnectedToUser':
                strings_en.AppStrings.currentlyConnectedToUser,
            'yourUserId': strings_en.AppStrings.yourUserId,
            'shareUserId': strings_en.AppStrings.shareUserId,
            'leaveUserId': strings_en.AppStrings.leaveUserId,
            'userIdDescription': strings_en.AppStrings.userIdDescription,
            'pleaseEnterUserId': strings_en.AppStrings.pleaseEnterUserId,
            'failedToConnectToUser':
                strings_en.AppStrings.failedToConnectToUser,
            'failedToCreateUserId':
                strings_en.AppStrings.failedToCreateUserId,
            'userIdButton': strings_en.AppStrings.userIdButton,
            'userIdDescriptionSetting':
                strings_en.AppStrings.userIdDescriptionSetting,
            'createUserIdButton': strings_en.AppStrings.createUserIdButton,
            'of': strings_en.AppStrings.of,
            'tapToCopyUserId': strings_en.AppStrings.tapToCopyUserId,
            'userIdCopiedToClipboard':
                strings_en.AppStrings.userIdCopiedToClipboard,
            'bijbelquizGenTitle': strings_en.AppStrings.bijbelquizGenTitle,
            'bijbelquizGenSubtitle':
                strings_en.AppStrings.bijbelquizGenSubtitle,
            'bijbelquizGenWelcomeText':
                strings_en.AppStrings.bijbelquizGenWelcomeText,
            'questionsAnswered': strings_en.AppStrings.questionsAnswered,
            'bijbelquizGenQuestionsSubtitle':
                strings_en.AppStrings.bijbelquizGenQuestionsSubtitle,
            'mistakesMade': strings_en.AppStrings.mistakesMade,
            'bijbelquizGenMistakesSubtitle':
                strings_en.AppStrings.bijbelquizGenMistakesSubtitle,
            'timeSpent': strings_en.AppStrings.timeSpent,
            'bijbelquizGenTimeSubtitle':
                strings_en.AppStrings.bijbelquizGenTimeSubtitle,
            'bijbelquizGenBestStreak':
                strings_en.AppStrings.bijbelquizGenBestStreak,
            'bijbelquizGenStreakSubtitle':
                strings_en.AppStrings.bijbelquizGenStreakSubtitle,
            'yearInReview': strings_en.AppStrings.yearInReview,
            'bijbelquizGenYearReviewSubtitle':
                strings_en.AppStrings.bijbelquizGenYearReviewSubtitle,
            'hours': strings_en.AppStrings.hours,
            'correctAnswers': strings_en.AppStrings.correctAnswers,
            'accuracy': strings_en.AppStrings.accuracy,
            'currentStreak': strings_en.AppStrings.currentStreak,
            'thankYouForUsingBijbelQuiz':
                strings_en.AppStrings.thankYouForUsingBijbelQuiz,
            'bijbelquizGenThankYouText':
                strings_en.AppStrings.bijbelquizGenThankYouText,
            'bijbelquizGenDonateButton':
                strings_en.AppStrings.bijbelquizGenDonateButton,
            'done': strings_en.AppStrings.done,
            'bijbelquizGenSkip': strings_en.AppStrings.bijbelquizGenSkip,
            'thankYouForSupport': strings_en.AppStrings.thankYouForSupport,
            'thankYouForYourSupport':
                strings_en.AppStrings.thankYouForYourSupport,
            'supportWithDonation': strings_en.AppStrings.supportWithDonation,
            'bijbelquizGenDonationText':
                strings_en.AppStrings.bijbelquizGenDonationText,
            'notFollowing': strings_en.AppStrings.notFollowing,
            'joinRoomToViewFollowing':
                strings_en.AppStrings.joinRoomToViewFollowing,
            'searchUsersToFollow': strings_en.AppStrings.searchUsersToFollow,
            'noFollowers': strings_en.AppStrings.noFollowers,
            'joinRoomToViewFollowers':
                strings_en.AppStrings.joinRoomToViewFollowers,
            'shareBQIDFollowers': strings_en.AppStrings.shareBQIDFollowers,
            'username': strings_en.AppStrings.username,
            'enterUsername': strings_en.AppStrings.enterUsername,
            'usernameHint': strings_en.AppStrings.usernameHint,
            'saveUsername': strings_en.AppStrings.saveUsername,
            'pleaseEnterUsername': strings_en.AppStrings.pleaseEnterUsername,
            'usernameTooLong': strings_en.AppStrings.usernameTooLong,
            'usernameAlreadyTaken':
                strings_en.AppStrings.usernameAlreadyTaken,
            'usernameBlacklisted': strings_en.AppStrings.usernameBlacklisted,
            'usernameSaved': strings_en.AppStrings.usernameSaved,
            'beta': strings_en.AppStrings.beta,
          };
  }

  String translate(String key) {
    return _localizedValues[key] ?? key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'nl'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
