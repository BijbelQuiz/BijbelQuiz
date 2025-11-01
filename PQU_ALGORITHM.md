# Question Picking Algorithm Documentation

## TL;DR: Quick Overview

The Progressive Question Up-selection (PQU) algorithm is a sophisticated 11-phase system that:

1. **Analyzes performance** across multiple metrics (correctness, streaks, timing, session history)
2. **Dynamically adjusts** target difficulty with performance-based scaling and user preferences
3. **Applies dampening** for long sessions to prevent extreme difficulty swings
4. **Maps difficulty** from internal scale [0..2] to JSON levels [1..5] with cumulative selection
5. **Filters questions** by difficulty level while ensuring variety and preventing repetition
6. **Manages question pools** with background loading and exhaustion handling
7. **Tracks usage** with anti-repetition mechanisms (50-question recent history)
8. **Incorporates randomization** to prevent stagnation and ensure variety
9. **Integrates user feedback** for difficulty preferences ("too easy", "too hard", "good")
10. **Handles edge cases** with multiple fallback strategies for pool exhaustion
11. **Updates tracking** with comprehensive session and performance management

## Overview

The BijbelQuiz application uses an advanced Progressive Question Up-selection (PQU) algorithm that dynamically adjusts question difficulty based on comprehensive player performance metrics. This multi-phase system maintains optimal challenge levels while preventing boredom, frustration, and question repetition.

## Key Components

### Progressive Question Selector (`ProgressiveQuestionSelector`)

Located in `app/lib/services/progressive_question_selector.dart`, this service manages the comprehensive PQU algorithm with 11 distinct phases for question selection and difficulty adjustment.

## How the PQU Algorithm Works

### 1. Difficulty Management System

The algorithm uses a normalized internal difficulty scale of [0..2] which maps to the JSON difficulty levels [1..5]:

- Internal difficulty 0.0 → JSON level 1 (easiest)
- Internal difficulty 0.5 → JSON level 2 (easy)
- Internal difficulty 1.0 → JSON level 3 (medium)
- Internal difficulty 1.5 → JSON level 4 (hard)
- Internal difficulty 2.0 → JSON level 5 (hardest)

The mapping formula is: `level = 1 + (normalized_difficulty * 2).round()`

### 2. Comprehensive Question Selection Process

The `pickNextQuestion()` method implements an 11-phase algorithm:

#### Phase 1: Performance-Based Target Difficulty Calculation
- Analyzes recent performance metrics (correct/incorrect ratio)
- Applies performance thresholds:
  - High performance (>90% correct): +0.05 difficulty increase
  - Good performance (75-90% correct): +0.03 difficulty increase
  - Poor performance (<30% correct): -0.05 difficulty decrease
  - Below average performance (30-50% correct): -0.03 difficulty decrease

#### Phase 2: Session Length Dampening
- Prevents extreme difficulty swings in long sessions (>30 questions)
- Reduces adjustment magnitude as session length increases (70% dampening factor)

#### Phase 3: User Difficulty Preference Integration
- Incorporates explicit user feedback ("too hard", "too easy", "good")
- Applies preference-based adjustments:
  - "too_hard": -0.2 difficulty adjustment
  - "too_easy": +0.2 difficulty adjustment
  - "good": no change

#### Phase 4: Difficulty Range Constraints
- Ensures difficulty stays within valid bounds [0.0, 2.0]
- Applies clamping to prevent invalid values

#### Phase 5: JSON Level Mapping
- Converts normalized difficulty to discrete JSON levels [1..5]
- Uses cumulative selection strategy (users see questions from level 1 up to target level)

#### Phase 6: Question Pool Management
- Tracks correctly answered questions (prevents repetition)
- Manages shown questions for session history
- Handles pool exhaustion with 3-tier fallback strategy

#### Phase 7: Background Loading Integration
- Triggers background question loading when pool runs low
- Integrates with `QuestionLoadingService` for seamless pool expansion

#### Phase 8: Difficulty-Based Filtering
- Filters questions by difficulty level using cumulative selection
- Example: Level 3 user gets questions from levels 1, 2, and 3
- Includes fallback to higher levels if no questions available at target level

#### Phase 9: Anti-Repetition Mechanisms
- Prevents showing recently used questions (50-question history limit)
- Maintains FIFO queue for recent question tracking
- Emergency fallback: clears recent list if no eligible questions remain

#### Phase 10: Random Selection with Variety
- Randomly selects from eligible questions to ensure variety
- Uses secure random number generation for unbiased selection

#### Phase 11: Usage Tracking Updates
- Updates shown questions and recently used lists
- Maintains question history for anti-repetition logic
- Manages list size limits with automatic cleanup

### 3. Advanced Difficulty Adjustment Algorithm

The `calculateNextDifficulty()` method implements a sophisticated 5-phase adjustment system:

#### Phase 1: Immediate Performance Factors
- **Answer correctness**: Primary adjustment factor
  - Correct answer: +0.08 base difficulty increase
  - Incorrect answer: -0.10 base difficulty decrease
- **Streak bonuses**: Rewards sustained performance
  - Every 3 consecutive correct answers: +0.05 additional increase
  - Streak breaking penalty: -0.05 extra decrease
- **Speed-based adjustments**: Considers time remaining
  - Quick correct answers (>10s remaining): +0.05 bonus
  - Slow incorrect answers (<5s remaining): -0.03 penalty

#### Phase 2: Long-term Performance Analysis
- **Session performance ratio**: Overall session adjustment
  - Consistently high performance (>85% correct): +0.05 bias
  - Consistently low performance (<50% correct): -0.05 bias

#### Phase 3: Anti-Stagnation Randomization
- **Exploration factor**: Prevents difficulty stagnation
- Adds random variation: ±0.075 to encourage different difficulty levels
- Ensures algorithm continues exploring optimal difficulty ranges

#### Phase 4: User Preference Integration
- **Explicit feedback**: Incorporates user difficulty preferences
  - "too_hard": -0.2 difficulty adjustment
  - "too_easy": +0.2 difficulty adjustment
  - "good": no preference-based change

#### Phase 5: Range Validation
- **Boundary enforcement**: Ensures difficulty stays within [0.0, 2.0]
- **Context safety**: Handles disposed contexts gracefully

### 4. Question Pool Management System

#### Multi-Tier Question Tracking
- **Correctly answered questions**: Never shown again in session
- **Shown questions**: Session history for analytics
- **Recently used questions**: 50-question FIFO queue for anti-repetition

#### Exhaustion Handling Strategy
1. **Primary**: Filter by difficulty and uniqueness
2. **Secondary**: Background loading of additional questions
3. **Tertiary**: Reset session tracking if all questions exhausted
4. **Emergency**: Clear all tracking and reshuffle if critical failure

### 5. Session Management Features

#### State Management
- **Question pool reset**: For new games or language changes
- **Session reset**: Maintains pool while clearing usage tracking
- **Background loading integration**: Automatic pool expansion
- **Mounted state tracking**: Proper cleanup for widget lifecycle

#### Performance Optimizations
- **Efficient filtering**: Optimized algorithms for large question sets
- **Memory management**: Bounded tracking collections
- **Background processing**: Non-blocking pool expansion
- **Random access**: Fast question selection from filtered pools

### 6. Integration with Quiz Screen

The `QuizScreen` integrates with the PQU system through:
- **Initialization**: Sets up selector with cache service
- **Question fetching**: Calls `pickNextQuestion()` for each question
- **Performance updates**: Calls `calculateNextDifficulty()` after each answer
- **State management**: Maintains proper mounted state and callbacks

## Benefits of the Advanced PQU System

1. **Sophisticated Adaptation**: Multi-factor performance analysis
2. **User-Centric Design**: Incorporates explicit user preferences
3. **Engagement Optimization**: Maintains optimal challenge levels
4. **Progressive Reinforcement**: Cumulative difficulty exposure
5. **Variety Assurance**: Comprehensive anti-repetition mechanisms
6. **Performance Efficiency**: Optimized for low-end devices
7. **Scalability**: Handles large question pools efficiently
8. **Robustness**: Multiple fallback strategies for edge cases

#### Phase 1: Calculate Target Difficulty
- Analyzes recent performance (correct/incorrect ratio)
- Adjusts difficulty based on performance thresholds:
  - High performance (>90% correct): Increase difficulty significantly
  - Good performance (75-90% correct): Increase difficulty moderately
  - Poor performance (<30% correct): Decrease difficulty significantly
  - Below average performance (30-50% correct): Decrease difficulty moderately

#### Phase 2: Apply Dampening for Long Sessions
- Prevents extreme difficulty swings after many questions
- Reduces adjustment magnitude as session length increases (after 30+ questions)

#### Phase 3: Constrain Difficulty Range
- Ensures difficulty stays within bounds [0.0, 2.0]

#### Phase 4: Map to JSON Difficulty Levels
- Converts normalized difficulty to JSON levels [1..5]

#### Phase 5: Filter Available Questions
- Selects questions not yet used in current session
- Filters questions from level 1 up to the target difficulty level (cumulative selection)
- For example: if user is at level 3, they get questions from levels 1, 2, and 3
- This ensures that users always see easier questions as they progress
- Falls back to questions above target level if no questions available at or below
- Final fallback to any available question

#### Phase 6: Apply Anti-Repetition Filter
- Prevents showing recently used questions (within last 50 questions)
- Clears recent list if no eligible questions remain

#### Phase 7: Random Selection
- Randomly selects from eligible questions to ensure variety

#### Phase 8: Update Usage Tracking
- Adds selected question to used and recently used lists
- Maintains FIFO queue for recently used questions (limit 50)

### 3. Dynamic Difficulty Adjustment

The `calculateNextDifficulty()` method considers multiple factors:

#### Immediate Performance Factors
- **Answer correctness**: Primary factor for difficulty adjustment
  - Correct answer: +0.08 difficulty
  - Incorrect answer: -0.10 difficulty
- **Streak bonus**: Rewards sustained performance
  - Every 3 consecutive correct answers adds +0.05 difficulty
- **Speed bonus/malus**: Considers time remaining when answering
  - Quick correct answers (time > 10s): +0.05 difficulty
  - Slow incorrect answers (time < 5s): -0.03 difficulty
  - Extra penalty for breaking a streak with incorrect answer: -0.05

#### Long-term Performance Factors
- **Session performance ratio**: Adjusts based on overall session performance
  - Consistently high performance (>85% correct): +0.05 difficulty
  - Consistently low performance (<50% correct): -0.05 difficulty

#### Anti-Stagnation Randomization
- Adds small random variation to prevent getting stuck at same difficulty
- Random adjustment of ±0.075 to explore different difficulty levels

### 4. Question Pool Management

- **Used Questions Tracking**: Prevents repetition within a session
- **Recently Used Queue**: Tracks last 50 questions to avoid immediate repetition
- **Pool Exhaustion Handling**: When all questions are used, reshuffles and repopulates
- **Background Loading**: Automatically loads more questions when running low

### 5. Session Management

The algorithm provides methods for different scenarios:

- `resetQuestionPool()`: Resets for new game or language change
- `resetForNewGame()`: Resets for new game session while preserving question pool
- Session-aware difficulty management that considers total questions answered

## Usage in Quiz Screen

The `QuizScreen` uses the Progressive Question Selector in these ways:

1. **Initialization**: Sets up the selector with question cache service
2. **Question Fetching**: Calls `pickNextQuestion()` to get next question
3. **Difficulty Updates**: Calls `calculateNextDifficulty()` after each answer
4. **State Management**: Maintains mounted state and setState callbacks

## Benefits

1. **Adaptive Learning**: Adjusts difficulty to match user ability
2. **Engagement**: Maintains optimal challenge level to prevent boredom/frustration
3. **Progressive Reinforcement**: Users continue to see easier levels as they progress, reinforcing knowledge
4. **Variety**: Ensures diverse questions across all difficulty levels and prevents repetition
5. **Performance**: Optimimized to run efficiently even on low-end devices
6. **Scalability**: Works with large question pools and continuous gameplay

## Performance Optimizations

- Efficient filtering algorithms to handle large question sets
- Memory-conscious tracking of used questions
- Background loading to maintain performance
- Dampening mechanisms to prevent extreme difficulty swings