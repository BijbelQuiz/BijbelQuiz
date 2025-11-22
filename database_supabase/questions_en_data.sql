-- SQL INSERT statements for en questions table
-- Generated from questions-en.json
-- Generated on: 1763806680.095157

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000001', 'How many books does the New Testament have?', '27', ARRAY['26','66','39'], 3, 'mc', '{}', NULL)
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000002', 'What did Hannah name her child?', 'Samuel', ARRAY['Saul','Samson','Gideon'], 1, 'mc', '{}', '1 Samuel 1:20')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000003', 'Who was responsible for the massacre of children in Bethlehem shortly after Jesus''s birth?', 'Herod', ARRAY['Pilate','The High Priest','Quirinius'], 1, 'mc', ARRAY['Matthew'], 'Matthew 1')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000004', 'Jesus healed Peter''s mother-in-law. What was wrong with her?', 'Fever', ARRAY['Paralysis','Blind in one eye','Bleeding'], 4, 'mc', '{}', 'Mark 1')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000005', 'What promise do the meek receive from the Lord Jesus in the Beatitudes?', 'They shall inherit the earth', ARRAY['For them is the kingdom of heaven','They shall be called children of God','They shall see God'], 3, 'mc', ARRAY['Matthew'], 'Matthew 5:5')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000006', 'What promise follows the Beatitude ''blessed are the pure in heart''?', 'they shall see God', ARRAY['For them is the kingdom of heaven','They shall be called children of God','They shall inherit the earth'], 3, 'mc', '{}', 'Matthew 5:8')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000007', 'Which prophet was not allowed to marry by the Lord?', 'Jeremiah', ARRAY['Isaiah','Ezekiel','Hosea'], 5, 'mc', ARRAY['Jeremiah'], 'Jeremiah 16:2')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000008', 'Which prophet was commanded to marry by the Lord?', 'Hosea', ARRAY['Isaiah','Jeremiah','Ezekiel'], 5, 'mc', ARRAY['Hosea'], 'Hosea 1:2')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000009', 'Which prophet and his children were a symbol for Israel?', 'Isaiah', ARRAY['Jeremiah','Ezekiel','Hosea'], 5, 'mc', ARRAY['Isaiah'], NULL)
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000010', 'Which prophet lost his wife during his time as a prophet?', 'Ezekiel', ARRAY['Isaiah','Jeremiah','Hosea'], 5, 'mc', ARRAY['Ezekiel'], 'Ezekiel 24:16-24')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000011', 'On the 1st day God created...', 'the light', ARRAY['man','plants','fish'], 1, 'fitb', ARRAY['Genesis'], 'Genesis 1:4')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000012', 'On the 2nd day there was separation between...', 'sea and sky', ARRAY['sea and land','light and darkness','light and land'], 1, 'fitb', ARRAY['Genesis'], 'Genesis 1:6-8')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000013', 'God rested on the...', '7th day', ARRAY['1st day','5th day','6th day'], 1, 'fitb', ARRAY['Genesis'], 'Genesis 2:2')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000014', 'Where was the tree of the knowledge of good and evil?', 'In the garden of Eden', ARRAY['In the garden of Aden','Just outside the garden of Eden','In Shinar'], 1, 'mc', ARRAY['Genesis'], 'Genesis 2 and 3')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000015', 'Who was murdered by Cain?', 'Abel', ARRAY['His mother','His father','Esau'], 1, 'mc', ARRAY['Genesis'], NULL)
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000016', 'How old was Methuselah when he died?', '969', ARRAY['996','966','669'], 1, 'mc', ARRAY['Genesis'], 'Genesis 5:27')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000017', 'How long did Noah stay in the ark with his family?', 'Just over a year', ARRAY['40 days','7 months','1.5 years'], 3, 'mc', ARRAY['Genesis'], 'Genesis 8')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000018', 'The top of the tower of Babel was meant to reach into ...', 'the heavens', ARRAY['the clouds','great height','an invisible height'], 1, 'fitb', ARRAY['Genesis'], 'Genesis 11:4')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000019', 'What does the word ''Babel'' mean?', 'Confusion', ARRAY['Great city','Great tower','Destruction'], 3, 'mc', ARRAY['Genesis'], 'Genesis 11')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000020', 'Where was Abram born?', 'Ur of the Chaldeans', ARRAY['Canaan','Egypt','Shinar'], 1, 'mc', ARRAY['Genesis'], 'Genesis 11:26')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000021', 'What was the name of Abram''s father?', 'Terah', ARRAY['Lot','Isaac','Noah'], 3, 'mc', ARRAY['Genesis'], 'Genesis 11:26')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000022', 'Why did Abram go to Canaan?', 'God asked him to', ARRAY['There was plenty of work','Family already lived there','There was enough to eat'], 1, 'mc', ARRAY['Genesis'], 'Genesis 12')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000023', 'Who was Abram''s wife?', 'Sarai', ARRAY['Rebekah','Rachel','Zilpah'], 1, 'mc', ARRAY['Genesis'], 'Genesis 11')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000024', 'Why did Abram and Sarai go to Egypt?', 'There was a famine in Canaan', ARRAY['There was much money to earn','They went to visit relatives','It was a command from the Lord'], 1, 'mc', ARRAY['Genesis'], 'Genesis 12:10')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000025', 'Abram and Lot return to Canaan. Where does Lot live?', 'In the Jordan region', ARRAY['On the coast','In the mountains','In Sodom'], 3, 'mc', ARRAY['Genesis'], 'Genesis 19')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000026', 'Sarai remains barren. Who becomes Abram''s second wife?', 'Hagar', ARRAY['Rachel','Zilpah','Bilhah'], 1, 'mc', ARRAY['Genesis'], 'Genesis 16:3')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000027', 'Abram and Hagar have a son, his name is...', 'Ishmael', ARRAY['Lot','Isaac','Jacob'], 1, 'fitb', ARRAY['Genesis'], 'Genesis 16:11')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000028', 'What did Lot''s wife do?', 'She looked back while leaving Sodom', ARRAY['She warned her husband Lot','She stayed in Sodom','She did what God asked her to do'], 1, 'mc', ARRAY['Genesis'], 'Genesis 19:26')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000029', 'Abraham and Sarah finally have a son. How old was Abraham then?', '100', ARRAY['80','90','120'], 3, 'mc', ARRAY['Genesis'], 'Genesis 21:5')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000030', 'Where should Abraham sacrifice Isaac?', 'On Mount Moriah', ARRAY['On Mount Sinai','On Mount Carmel','On Mount Horeb'], 3, 'mc', ARRAY['Genesis'], 'Genesis 22:2')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000031', 'Who does Isaac marry?', 'Rebekah', ARRAY['Rachel','Bilhah','Sarah'], 1, 'mc', ARRAY['Genesis'], 'Genesis 24:67')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000032', 'Who succeeds Moses?', 'Joshua', ARRAY['Aaron','Caleb','Elijah'], 1, 'mc', ARRAY['Joshua'], 'Joshua 1:1')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000033', 'Where did Moses strike the rock?', 'at Meribah', ARRAY['at Edom','at Mara','at Elim'], 3, 'mc', ARRAY['Exodus'], 'Exodus 17:7')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000034', 'After ... much of Canaan is conquered', '7 years', ARRAY['4 years','6 years','9 years'], 5, 'fitb', ARRAY['Joshua'], 'Joshua')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000035', 'After Joshua''s death...', 'there is no leader anymore', ARRAY['his son succeeds him','Judah succeeds him','Eleazar succeeds him'], 3, 'fitb', ARRAY['Joshua'], 'Joshua 24')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000036', 'What was Israel''s first task after Joshua''s death?', 'Fight against the remaining Canaanites', ARRAY['Finding a new leader','The people got a period of rest','Finding water sources'], 3, 'mc', ARRAY['Judges'], 'Judges 1:1')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000037', 'After a long period following Joshua''s death comes...', 'a judge', ARRAY['a king','an emperor','a prophet'], 3, 'fitb', ARRAY['Judges'], 'Judges 3:9')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000038', 'Who was the first judge?', 'Othniel', ARRAY['Ehud','Samgar','Barak'], 2, 'mc', ARRAY['Genesis'], 'Judges 3:9')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000039', 'Under the leadership of the first judge...', 'people serve God again', ARRAY['people serve the idols again','the enemy is driven away','the people become rebellious again'], 3, 'fitb', ARRAY['Judges'], 'Judges 3: 9, 10')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000040', 'Who are the most well-known judges?', 'Gideon, Samson and Samuel', ARRAY['Saul, David and Solomon','Jephthah, Deborah and Barak','Othniel, Ehud and Samgar'], 1, 'mc', ARRAY['Judges'], 'Judges')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000041', 'With how many men did Gideon drive away a large army of Midianites?', '300 men', ARRAY['1000 men','100 men','500 men'], 3, 'mc', ARRAY['Judges'], 'Judges 7:6')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000042', 'Who was the last judge?', 'Samuel', ARRAY['Eli','Samson','Jephthah'], 1, 'mc', ARRAY['Judges'], '1 Samuel')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000043', 'Which answer does not belong. Samson may NOT ... ', 'not marry', ARRAY['not drink wine or beer','not cut his hair','not touch dead bodies'], 1, 'fitb', ARRAY['Judges'], 'Judges 13')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000044', 'Deborah defeated the ... ', 'Canaanites', ARRAY['Midianites','Ammonites','Philistines'], 5, 'fitb', ARRAY['Judges'], 'Judges 4')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000045', 'Several judges are mentioned as heroes of faith in the Epistle to the Hebrews. Which judge is NOT mentioned in it?', 'Deborah', ARRAY['Gideon','Samson','Samuel'], 3, 'mc', '{}', 'Hebrews 11')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000046', 'Who leads the people after Samuel?', 'King Saul', ARRAY['King David','High Priest Eli','Judge Samson'], 1, 'mc', '{}', '1 Samuel 10:1')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000047', 'Who was the first king of Israel?', 'Saul', ARRAY['David','Solomon','Herod'], 1, 'mc', '{}', '1 Samuel 10:1')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000048', 'Saul is anointed by Samuel ... ', 'anointed', ARRAY['crowned','consecrated','baptized'], 1, 'fitb', ARRAY['1 Samuel'], '1 Samuel 10:1')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000049', 'But I hate him, because he prophesies nothing good about me, but evil. Who said that?', 'Ahab', ARRAY['Micaiah','Jezebel','Baasha'], 5, 'mc', ARRAY['1 Kings'], '1 Kings 22:8')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000050', 'In which time period does the story of Ruth take place?', 'Time of Judges', ARRAY['Time of Kings','Exile','Time of Prophets'], 3, 'mc', ARRAY['Genesis','Ruth'], NULL)
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000051', 'From which place did Elimelech and Naomi come?', 'Bethlehem', ARRAY['Jerusalem','Cana','Moab'], 3, 'mc', ARRAY['Ruth'], 'Ruth 1:1')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000052', 'What were the names of the women whom Naomi''s sons married?', 'Orpah and Ruth', ARRAY['Orpah and Rebekah','Ruth and Rachel','Ruth and Rebekah'], 1, 'mc', ARRAY['Ruth'], 'Ruth 1:4')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000053', 'How did Naomi want to be called?', 'Mara', ARRAY['Martha','Mary','Miriam'], 1, 'mc', ARRAY['Ruth'], 'Ruth 1:20')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000054', 'Why was Boaz kind to Ruth?', 'Ruth''s devotion to Naomi touched him', ARRAY['He was in love with Ruth','Because he was related to Naomi','God asked this of him'], 3, 'mc', ARRAY['Ruth'], 'Ruth 2:11')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000055', 'What is a kinsman-redeemer?', 'A close relative who has the duty to help another family member', ARRAY['A close relative','A close relative who has much money','A close relative who lives in the same place'], 1, 'mc', '{}', 'Ruth 3:9')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000056', 'What did Boaz give as proof of his redemption?', 'His sandal', ARRAY['A clay tablet','His ring','His coat'], 3, 'mc', ARRAY['Ruth'], 'Ruth 4:7')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000057', 'What is the name of Boaz and Ruth''s son?', 'Obed', ARRAY['Judah','Machlon','Chilion'], 1, 'mc', ARRAY['Ruth'], 'Ruth 4:17')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000058', 'Of whom did Obed become father?', 'Jesse', ARRAY['Isaac','Ishmael','Issachar'], 1, 'mc', ARRAY['Ruth'], 'Ruth 4:17')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000059', 'Of whom did Jesse become father?', 'Of King David', ARRAY['Of King Solomon','Of King Saul','Of King Abijah'], 1, 'mc', '{}', '1 Samuel 17:12')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000060', 'How many wives did Elkanah have?', 'Two', ARRAY['One','Three','Four'], 1, 'mc', ARRAY['Genesis'], '1 Samuel 1:2')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000061', 'What did the old priest think when Hannah prayed in the temple?', 'That she was drunk', ARRAY['That she was praying earnestly','That she was sad','That she was tired'], 1, 'mc', '{}', '1 Samuel 1:14')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000062', 'What did Hannah name her son?', 'Samuel', ARRAY['Samson','Gideon','Judah'], 1, 'mc', ARRAY['Genesis'], '1 Samuel 1:20')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000063', 'What does Samuel mean?', 'Asked of God', ARRAY['Man of God','Comforter','God gives'], 3, 'mc', ARRAY['1 Samuel','2 Samuel'], '1 Samuel 1:17')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000064', 'Where did Hannah bring Samuel?', 'To Eli', ARRAY['To Jerusalem','To Elijah','To the temple in Jerusalem'], 3, 'mc', ARRAY['1 Samuel'], '1 Samuel 1: 25')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000065', 'What did Hannah NOT bring with her when she brought Samuel to Eli?', '2 measures of barley', ARRAY['3 bulls','an ephah of flour','a flask of wine'], 5, 'mc', ARRAY['1 Samuel'], '1 Samuel 1:24')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000066', 'Who thought that Samuel called him?', 'Eli', ARRAY['Hophni','Phinehas','the Lord'], 1, 'mc', ARRAY['1 Samuel'], '1 Samuel 3')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000067', 'Which position did Samuel NOT hold in his life?', 'King', ARRAY['Prophet','Priest','Judge'], 1, 'mc', '{}', '1 Samuel')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000068', 'How is the holy city called in Ezekiel 48?', 'The Lord is there', ARRAY['Zion','Jerusalem','City of God'], 5, 'mc', ARRAY['Ezekiel'], 'Ezekiel 48:35')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000069', 'Which psalm is often called the Shepherd''s Psalm?', 'Psalm 23', ARRAY['Psalm 1','Psalm 25','Psalm 42'], 1, 'mc', ARRAY['Psalms'], 'Psalm 23')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000070', 'What do you call a male sheep?', 'A ram', ARRAY['A buck','A lamb','An ewe'], 1, 'mc', ARRAY['Genesis'], 'Genesis 22')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000071', 'On which instrument did David often play?', 'Harp', ARRAY['Harp','Flute','Cymbal'], 3, 'mc', ARRAY['1 Samuel'], '1 and 2 Samuel')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000072', 'Who wrote the biblical book of Proverbs?', 'Solomon', ARRAY['David','Asaph','Jehoshaphat'], 1, 'mc', ARRAY['Proverbs'], 'Proverbs')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000073', 'What is the beginning of wisdom?', 'The fear of the Lord', ARRAY['The knowledge of the Lord','The instruction of the Lord','The thoughtfulness of the Lord'], 3, 'mc', ARRAY['Proverbs'], 'Proverbs 1:7')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000074', 'What is God to those who walk uprightly?', 'A Shield', ARRAY['A Fortress','A Refuge','A High Tower'], 5, 'mc', ARRAY['Proverbs'], 'Proverbs 2:7')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000075', 'With what must one honor the Lord', 'With possessions', ARRAY['With prayer','With wisdom','With sincerity'], 5, 'mc', ARRAY['Proverbs'], 'Proverbs 3:9')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000076', 'What is more precious than rubies?', 'Wisdom', ARRAY['Love','Virtue','Knowledge'], 5, 'mc', ARRAY['Proverbs'], 'Proverbs 3: 13-15')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000077', 'Who must be saved?', 'Those in danger of death', ARRAY['Those who waver','Those who wander','Those who live godlessly'], 5, 'mc', ARRAY['Proverbs'], 'Proverbs 24:11')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000078', 'Wisdom is like ... ?', 'a beautiful crown on the head', ARRAY['a golden necklace around the neck','an ornament of knowledge','a band of insight'], 3, 'fitb', ARRAY['Proverbs'], 'Proverbs 4:9')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000079', 'From where must our foot remain distant?', 'From evil', ARRAY['From the path of the wicked','From uneven paths','From paths of death'], 5, 'mc', ARRAY['Proverbs'], 'Proverbs 4:14')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000080', 'How many things are an abomination to the Lord?', 'Seven', ARRAY['Five','Six','Three'], 5, 'mc', ARRAY['Proverbs'], 'Proverbs 6:16')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000081', 'What covers love?', 'All transgressions', ARRAY['All greed','All unkindness','All hatred'], 5, 'mc', ARRAY['Proverbs'], 'Proverbs 10:12')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000082', 'What is in the house of a righteous man?', 'A great treasure', ARRAY['Love and faithfulness','Understanding','Knowledge'], 5, 'mc', ARRAY['Proverbs'], 'Proverbs 15:6')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000083', 'Who will fall into a pit?', 'He who digs a pit', ARRAY['Who shoots burning arrows','Who is wise in his own eyes','Who honors a fool'], 3, 'mc', ARRAY['Proverbs'], 'Proverbs 26:27')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000084', 'When does one find mercy?', 'When one confesses and forsakes sins', ARRAY['When one is a man of understanding','When one loves in secret','When one does not harden his heart'], 3, 'mc', ARRAY['Proverbs'], 'Proverbs 28:13')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000085', 'Where did Jesus grow up?', 'Nazareth', ARRAY['Jerusalem','Bethlehem','Capernaum'], 1, 'mc', ARRAY['Matthew'], 'Matthew 2:23')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000086', 'How many days was Jesus tempted by the devil:', '40 days', ARRAY['3 days','10 days','7 weeks'], 1, 'mc', '{}', 'Mark 1:13')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000087', 'On what should one build their life''s house?', 'Rock', ARRAY['Sand','A mountain','Clay ground'], 1, 'mc', '{}', 'Matthew 7:25')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000088', 'Of whom did Jesus say: I have not found such great faith even in Israel?', 'The centurion', ARRAY['Peter','The leper','The blind man'], 1, 'mc', ARRAY['Matthew'], 'Matthew 8:10')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000089', 'Where was Matthew when Jesus called him?', 'In the tax office', ARRAY['On the temple grounds','In a tree','In front of his house'], 3, 'mc', ARRAY['Matthew'], 'Matthew 9:9')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000090', 'How big must our faith be according to Jesus?', 'Like a mustard seed', ARRAY['Like a mountain','Like a rock','Like a cedar of Lebanon'], 1, 'mc', ARRAY['Matthew'], 'Matthew 17:20')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000091', 'How many times must we forgive each other?', '70 x 7 times', ARRAY['7 times','3 times','always'], 1, 'mc', '{}', 'Matthew 18:22')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000092', 'Who cried out: Lord, Son of David, have mercy on us', '2 blind men', ARRAY['10 lepers','the children','the lame'], 1, 'mc', '{}', 'Matthew 20:30')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000093', 'Which tree was cursed by Jesus?', 'The fig tree', ARRAY['The olive tree','The cedar','The date palm'], 3, 'mc', '{}', 'Mark 11:21')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000094', 'Who wrote the book of Revelation?', 'John', ARRAY['Paul','Peter','Matthew'], 1, 'mc', ARRAY['Revelation'], 'Revelation 1:1')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000095', 'To how many churches did John write a letter?', '7', ARRAY['6','8','5'], 1, 'mc', ARRAY['Revelation'], 'Revelation')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000096', 'What was John told to write to Ephesus?', 'You have left your first love', ARRAY['Be faithful unto death','I have given you an open door','And I will give you each according to your works'], 5, 'mc', ARRAY['Ephesians'], 'Revelation 2:4')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000097', 'What will Jesus give the church in Smyrna if they remain faithful?', 'The crown of life', ARRAY['A white stone','A new name','Hidden manna'], 5, 'mc', ARRAY['Revelation'], 'Revelation 2:10')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000098', 'To which teaching did they in Pergamum cling?', 'The teaching of Balaam', ARRAY['The teaching of the Pharisees','There is no resurrection','The teaching of Paul'], 5, 'mc', ARRAY['Revelation'], 'Revelation 2:14')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000099', 'What woman did they allow in Thyatira?', 'Jezebel', ARRAY['the wife of Herod','The wife of Potiphar','Salome'], 5, 'mc', ARRAY['Revelation'], 'Revelation 2: 20-23')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000100', 'For what will Jesus keep the church of Philadelphia?', 'The hour of trial', ARRAY['From poverty','From diseases','From spiritual decline'], 5, 'mc', ARRAY['Revelation'], 'Revelation 3:10')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000101', 'Why will Jesus spew Laodicea out of His mouth?', 'Because they are lukewarm', ARRAY['Because they are hot','Because they are cold','Because they are hard'], 3, 'mc', ARRAY['Revelation'], 'Revelation 3: 15, 16')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000102', 'What was around God''s throne in Revelation?', 'A rainbow', ARRAY['A light','Golden rays','A cloud'], 5, 'mc', ARRAY['Revelation'], 'Revelation 4:3')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000103', 'And around the throne were thrones; and on the thrones I saw ... elders sitting, clothed in white robes, and they had golden crowns on their heads. ', '24', ARRAY['7','7 x 7','3'], 3, 'fitb', ARRAY['Revelation'], 'Revelation 4:4')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000104', 'What did the great multitude that no one could count have in their hands?', 'Palm branches', ARRAY['Torches','Trumpets','Bowls of incense'], 5, 'mc', ARRAY['Revelation'], 'Revelation 7:9')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000105', 'What does God do with the people who come out of the great tribulation?', 'God will wipe away every tear from their eyes', ARRAY['God will give them a new name','God will seal their foreheads','God will dwell among them'], 3, 'mc', ARRAY['Revelation'], 'Revelation 21:4')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000106', 'What happened when the third angel sounded?', 'A great star, blazing like a torch, fell from the sky', ARRAY['The smoke of incense with the prayers of the saints ascended','There became hail and fire mixed with blood','Something like a great mountain, burning with fire, was thrown into the sea'], 5, 'mc', ARRAY['Revelation'], 'Revelation 8:10')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000107', 'What is the name of the angel of the bottomless pit in Revelation?', 'Abaddon', ARRAY['Lucifer','The dragon','The beast'], 5, 'mc', ARRAY['Revelation'], 'Revelation 9:11')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000108', 'What was John told to eat in Revelation?', 'A little book', ARRAY['A honey cake','Bread','Figs'], 5, 'mc', ARRAY['Revelation'], 'Revelation 10:9')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000109', 'How many witnesses will prophesy for 1260 days?', '2', ARRAY['3','7','12'], 5, 'mc', ARRAY['Revelation'], 'Revelation 11: 3-12')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000110', 'And the woman fled to the ... , where she had a place prepared by God', 'wilderness', ARRAY['temple','mountains','city'], 3, 'fitb', ARRAY['Revelation'], 'Revelation 12:6')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000111', 'How many bowls of wrath are there?', 'Seven', ARRAY['Three','Five','Four'], 5, 'mc', ARRAY['Revelation'], 'Revelation 16')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000112', 'Which city comes down from heaven?', 'The new Jerusalem', ARRAY['The city of God','The city with many dwellings','That city which has foundations'], 1, 'mc', ARRAY['Revelation'], 'Revelation 21: 1-4')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000113', 'What do the Spirit and the Bride say?', 'Come', ARRAY['Amen','Hallelujah','I am the Alpha and the Omega'], 1, 'mc', ARRAY['Revelation'], 'Revelation 22:17')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000114', 'How many letters are there from Paul to the Corinthians?', 'Two', ARRAY['One','Three','Four'], 1, 'mc', ARRAY['1 Corinthians','2 Corinthians'], ' 1 and 2 Corinthians')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000115', 'How many people did Jesus raise from the dead?', 'Three', ARRAY['Two','One','Four'], 3, 'mc', '{}', 'Gospels')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000116', 'For approximately how many years did Jesus preach?', 'Three', ARRAY['Two','One','Four'], 1, 'mc', '{}', 'In the Gospels')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000117', 'In which city did they drive Jesus out of town, to the edge of the mountain, to throw Him into the abyss?', 'Nazareth', ARRAY['Jerusalem','Bethlehem','Samaria'], 1, 'mc', '{}', 'Luke 4:29')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000118', 'In which city was Bartimaeus sitting by the gate begging?', 'Jericho', ARRAY['Jerusalem','Samaria','Capernaum'], 3, 'mc', '{}', 'Mark 10:46')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000119', 'To whom was it asked: Do you also understand what you are reading?', 'The Ethiopian eunuch', ARRAY['Philip','Peter','Saul'], 1, 'mc', ARRAY['Acts'], 'Acts 8:30')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000120', 'Which island did Paul and Barnabas visit on their first missionary journey?', 'Cyprus', ARRAY['Crete','Malta','Sicily'], 3, 'mc', ARRAY['Acts'], 'Acts 13:4')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000121', 'Which king became severely ill, a terminal illness?', 'Hezekiah', ARRAY['Ahaz','Manasseh','Jehudah'], 1, 'mc', '{}', 'Hezekiah 20:1')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000122', 'After fleeing from Queen Jezebel, where did Elijah flee to the cave? Which one?', 'The cave on Mount Horeb', ARRAY['The cave of Machpelah','The cave of Adullam','The caves of Zephaniah'], 3, 'mc', ARRAY['1 Kings'], '1 Kings 19')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000123', 'What did the Israelites NOT take with them from the Egyptians when they left Egypt?', 'Food', ARRAY['Gold','Silver','Clothing'], 3, 'mc', ARRAY['Exodus'], 'Exodus 3:22')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000124', 'How long was Paul imprisoned in Caesarea during the time of Felix and Festus?', '2 years', ARRAY['1.5 years','2.5 years','3 years'], 3, 'mc', ARRAY['Acts'], 'Acts')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000125', 'Which deacon was stoned in Jerusalem?', 'Stephen', ARRAY['Philip','Timon','Nicholas'], 1, 'mc', ARRAY['Acts'], 'Acts 7: 54 - 60')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000126', 'Which son wanted to push David from the throne?', 'Absalom', ARRAY['Joab','Amnon','Adonijah'], 1, 'mc', ARRAY['2 Samuel'], '2 Samuel 15')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000127', 'Who were the first to visit Jesus after His birth?', 'The shepherds', ARRAY['The wise men','King Herod','Zacharias and Elizabeth'], 1, 'mc', '{}', 'Luke 2: 8-20')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000128', '10 lepers were healed by Jesus. Who came back to thank Him?', 'A Samaritan', ARRAY['An Israelite','A Jew','A Tax Collector'], 1, 'mc', '{}', 'Luke 17:11-19')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

-- Total questions processed: 128