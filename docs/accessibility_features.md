# Accessibility Features in BijbelQuiz App

This document outlines the accessibility features implemented in the BijbelQuiz app to make it more usable for people with disabilities.

## Implemented Accessibility Features

### 1. Screen Reader Support
- **Semantic Labels**: Added semantic labels and descriptions for all interactive elements including answer buttons, lesson tiles, and navigation components.
- **Screen Reader Hints**: Added descriptive hints for users of screen readers to understand the purpose and state of UI elements.

### 2. Color Contrast Improvements
- **Enhanced Color Contrast**: Improved color contrast ratios for answer buttons and UI elements to meet WCAG accessibility standards.
- **High Contrast Mode**: Added a high contrast theme option in settings for users with visual impairments.

### 3. Text Scaling Support
- **Dynamic Text Scaling**: Implemented support for system text scaling up to 200% throughout the app.
- **Proper Text Handling**: Ensured text elements can scale appropriately without breaking the UI layout.

### 4. Keyboard Navigation
- **Focus Management**: Improved keyboard navigation support with proper focus indicators and logical tab order.
- **Keyboard Shortcuts**: Maintained existing keyboard shortcuts for quiz answering (A, B, C, D keys).

### 5. Button Accessibility
- **Proper Tap Targets**: Ensured all interactive elements have appropriate minimum touch target sizes of 48x48 dp.
- **Visual Feedback**: Added clear visual feedback for selected and focused states.

### 6. Accessibility Settings
- **Reduce Motion**: Option to reduce or disable animations for users with motion sensitivity.
- **High Contrast Mode**: Toggle for high contrast theme to improve visibility.
- **Settings Location**: These options are available in the Settings screen under the "Accessibility" section.

## How to Use Accessibility Features

### Enabling Accessibility Options
1. Open the app and navigate to the Settings screen
2. Look for the "Accessibility" section
3. Toggle the options that best suit your needs:
   - **Reduce Motion**: Reduces animations and transitions
   - **High Contrast**: Applies a high contrast theme for better visibility

### Text Scaling
- The app automatically respects the system text scaling settings
- Users can adjust text size in their device's accessibility settings
- The app supports text scaling up to 200%

## Technical Implementation Details

### Code Changes Made
- Updated `answer_button.dart` with improved semantic labels and color contrast
- Enhanced `question_card.dart` with text scaling support
- Modified `lesson_tile.dart` with proper tap targets
- Added accessibility settings to `settings_provider.dart`
- Updated `theme_utils.dart` to support high contrast themes
- Modified `main.dart` to apply accessibility features globally

### Color Contrast Improvements
- Improved answer button colors to meet WCAG AA standards
- Enhanced visual feedback for correct/incorrect answers
- Added high contrast theme option

### Text Scaling Implementation
- Added textScaler.clamp() to all text widgets
- Ensured proper handling of large text sizes without breaking layouts
- Maintained readability with proper line heights and spacing

## Testing Considerations

The accessibility features should be tested with:
- Screen readers (TalkBack on Android, VoiceOver on iOS)
- Various text scaling settings (100% to 200%)
- Different color contrast preferences
- Keyboard navigation (where applicable)
- Assistive touch features

## Future Improvements

Potential additional accessibility features to consider:
- Voice control support
- Customizable UI themes for specific visual needs
- Haptic feedback options
- Audio descriptions for visual content