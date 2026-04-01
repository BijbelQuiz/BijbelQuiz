-- SQL INSERT statements for en questions table
-- Generated from questions-en.json
-- Generated on: 1766828313.435703

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

INSERT INTO questions_en (id, question, correct_answer, incorrect_answers, difficulty, type, categories, biblical_reference)
VALUES ('000129', 'Who was king when Daniel was thrown into the lion''s den?', 'Darius', ARRAY['Nebuchadnezzar','Belshazzar','Cyrus'], 3, 'mc', ARRAY['Daniel'], 'Daniel 6')
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
VALUES ('000130', 'Peter''s mother-in-law was healed of fever. In which place was this?', 'Capernaum', ARRAY['Cana','Nain','Jericho'], 3, 'mc', '{}', 'Matthew 8:14')
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
VALUES ('000131', 'The inhabitants of the Ten-Tribe Kingdom were taken to ...', 'Assyria', ARRAY['Babylon','Persia','Egypt'], 3, 'fitb', ARRAY['2 Kings'], '2 Kings 17:6')
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
VALUES ('000132', 'From which 2 tribes did the Two-Tribe Kingdom consist?', 'Judah and Benjamin', ARRAY['Levi and Judah','Joseph and Benjamin','Judah and Levi'], 3, 'mc', ARRAY['1 Kings'], '1 Kings 12:21')
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
VALUES ('000133', '3 names are for the same lake/sea. Which one doesn''t belong?', 'The Dead Sea', ARRAY['Sea of Galilee','Sea of Gennesaret','Sea of Tiberias'], 1, 'mc', '{}', NULL)
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
VALUES ('000134', 'A new apostle was chosen instead of Judas. Who was that?', 'Matthias', ARRAY['Justus','Philip','Nathanael'], 3, 'mc', ARRAY['Acts'], 'Acts 1:26')
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
VALUES ('000135', 'What do we think of at Easter?', 'The resurrection of Jesus', ARRAY['The birth of Jesus','The death of Jesus','The ascension of Jesus'], 1, 'mc', '{}', 'Mark 16')
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
VALUES ('000136', 'Daniel received a Babylonian name. Which one?', 'Belteshazzar', ARRAY['Belshazzar','Shadrach','Meshach'], 1, 'mc', ARRAY['Daniel'], 'Daniel 1:7')
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
VALUES ('000137', 'The blind man had to wash in ... to become seeing.', 'the pool of Siloam', ARRAY['the pool of Bethesda','the Jordan','the pool of cleansing'], 3, 'fitb', ARRAY['John'], 'John 9: 1-7')
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
VALUES ('000138', 'In the battle against Egypt, king ... of Judah fell.', 'Josiah', ARRAY['Amon','Manasseh','Ahaz'], 5, 'fitb', ARRAY['2 Chronicles'], '2 Chronicles 35: 20-24')
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
VALUES ('000139', 'Where did the first Christian church arise?', 'Jerusalem', ARRAY['Antioch','Philippi','Corinth'], 3, 'mc', ARRAY['Acts'], 'Acts 2:40-41')
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
VALUES ('000140', 'Who were the third and fourth disciples of Jesus?', 'John and James', ARRAY['Simon and Andrew','Simon and James','John and Andrew'], 5, 'mc', '{}', 'Mark 1: 16-20')
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
VALUES ('000141', 'Elijah, Ahab and the people went to offer on Mount ...', 'Carmel', ARRAY['Horeb','Sinai','Tabor'], 3, 'fitb', ARRAY['1 Kings'], '1 Kings 18: 20 -40')
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
VALUES ('000142', 'What is the last word in the Bible?', 'Amen', ARRAY['Come','Thanks be to God','Blessing'], 1, 'mc', ARRAY['Revelation'], 'Revelation 22:21')
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
VALUES ('000143', 'Who heard a Great Voice from Heaven say: ''Behold, the tabernacle of God is with the people and He will dwell with them''?', 'John', ARRAY['Peter','James','Jesus Himself'], 5, 'mc', ARRAY['Revelation'], 'Revelation 21:3')
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
VALUES ('000144', 'What is the Rider on the white horse called in Revelation?', 'Faithful and True', ARRAY['Savior','Christ Jesus','Firm and certain'], 5, 'mc', ARRAY['Revelation'], 'Revelation 19:11')
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
VALUES ('000145', 'Complete the sentence: Woe, woe, the great city ... , the strong city', 'Babylon', ARRAY['Jericho','Jerusalem','Nineveh'], 5, 'fitb', ARRAY['Revelation'], 'Revelation 18:10')
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
VALUES ('000146', 'How often was the trumpet blown in Revelation?', '7 times', ARRAY['7 times 70 times','70 times','700 times'], 5, 'mc', ARRAY['Revelation'], 'Revelation 8, 9, 10, 11')
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
VALUES ('000147', 'How many seals are opened in Revelation?', '7', ARRAY['8','6','3'], 5, 'mc', ARRAY['Revelation'], 'Revelation 6, 7, 8')
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
VALUES ('000148', 'Who alone could open the book with the 7 seals?', 'The Lamb', ARRAY['The Rock','The beast with 7 eyes','No one'], 5, 'mc', ARRAY['Revelation'], 'Revelation 5')
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
VALUES ('000149', 'What was in the Letter of Christ to Sardis?', 'You have a name that you live, and you are dead', ARRAY['Woe to you','The rules that church had to follow','To you is Eternal Life'], 5, 'mc', ARRAY['Revelation'], 'Revelation 3:1')
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
VALUES ('000150', 'Where did John write the biblical book of Revelation?', 'On the island of Patmos', ARRAY['In prison','John didn''t write Revelation','In the wilderness'], 1, 'mc', ARRAY['Revelation'], 'Revelation 1:9')
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
VALUES ('000151', 'What did Jude warn against in his biblical book?', 'Against false teachers', ARRAY['Against the devil','Against sin','Against the world'], 3, 'mc', ARRAY['Jude'], 'Jude 1')
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
VALUES ('000152', 'To whom did John write his letter, 3 John?', 'Gaius', ARRAY['The church of Laodicea','To no one specific','To Diotrephes'], 5, 'mc', ARRAY['3 John'], '3 John 1:1')
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
VALUES ('000153', 'From which place did John write his letter, 2 John?', 'From Ephesus', ARRAY['From Corinth','From Asia Minor','That is unknown'], 3, 'mc', ARRAY['John'], '2 John')
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
VALUES ('000154', 'Which prophet told King Hezekiah that he had to die?', 'Isaiah', ARRAY['Jeremiah','Micah','Amos'], 3, 'mc', ARRAY['Isaiah'], 'Isaiah 38:1')
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
VALUES ('000155', 'From whom did Peter cut off the ear?', 'Malchus', ARRAY['Matthew','Maltus','Caiaphas'], 1, 'mc', ARRAY['John'], 'John 18:10')
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
VALUES ('000156', 'What did the Macedonian man ask in Paul''s dream?', '''Come over to Macedonia and help us''', ARRAY['''Come over and help us''','''Come and see''','''Come over to Macedonia and preach the gospel'''], 3, 'mc', ARRAY['Acts'], 'Acts 16:9')
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
VALUES ('000157', 'Which punishment did the prophet Elijah announce to King Ahab?', 'There shall be no dew or rain', ARRAY['There shall be no more rain','Famine will come','Many people will die'], 3, 'mc', ARRAY['1 Kings'], '1 Kings 17:1')
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
VALUES ('000158', 'Who was the father of Samuel?', 'Elkanah', ARRAY['Elihu','Elam','Jeroboam'], 1, 'mc', ARRAY['1 Samuel'], '1 Samuel 1:1')
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
VALUES ('000159', 'In which city did Paul speak about the unknown God?', 'In Athens', ARRAY['In Corinth','In Philippi','In Thyatira'], 3, 'mc', ARRAY['Acts','Romans'], 'Acts 17:23')
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
VALUES ('000160', 'Who went along on Paul and Barnabas''s first missionary journey?', 'John Mark', ARRAY['Mark','John','Peter'], 3, 'mc', ARRAY['Acts'], 'Acts 13')
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
VALUES ('000161', 'Who were the sons of Zebedee?', 'James and John', ARRAY['John and Andrew','Andrew and Peter','James and Peter'], 3, 'mc', '{}', 'Mark 1: 19 , 20')
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
VALUES ('000162', 'In which place was David proclaimed king?', 'Hebron', ARRAY['Jerusalem','Judah','Gilead'], 3, 'mc', ARRAY['2 Kings'], '2 Kings 2:4')
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
VALUES ('000163', 'Who said: ''You almost persuade me to become a Christian''?', 'King Agrippa', ARRAY['Silas','Governor Felix','King David'], 1, 'mc', ARRAY['Acts'], 'Acts 26:28')
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
VALUES ('000164', 'During the wilderness journey the water was bitter at ...', 'Mara', ARRAY['Elim','Rephidim','Kadesh Barnea'], 1, 'fitb', '{}', 'Exodus 15:23')
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
VALUES ('000165', 'Which idolatry did King Jeroboam introduce?', 'The service of the golden calves', ARRAY['The service of Baal','The service of Ashtoreth','The service of the stars'], 3, 'mc', ARRAY['1 Kings'], '1 Kings 12: 25-33')
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
VALUES ('000166', 'How many missionary journeys did Paul make?', '3', ARRAY['2','4','5'], 1, 'mc', ARRAY['Acts'], 'Acts')
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
VALUES ('000167', 'On which mountain was the Ascension of Jesus?', 'Mount of Olives', ARRAY['Horeb','Moriah','Nebo'], 1, 'mc', ARRAY['Acts'], 'Acts 1: 9-12')
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
VALUES ('000168', 'Where did Jesus''s mother live?', 'Nazareth', ARRAY['Bethlehem','Jerusalem','That is unknown'], 1, 'mc', ARRAY['Luke'], 'Luke 1:26')
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
VALUES ('000169', 'How many days are there between Ascension and Pentecost?', '10', ARRAY['40','3','12'], 1, 'mc', ARRAY['Pentecost','Ascension'], 'Acts 1 and 2')
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
VALUES ('000170', 'Who was the first Christian to die for his faith?', 'Stephen', ARRAY['Peter','James','Philip'], 1, 'mc', ARRAY['Acts'], 'Acts 7: 54-60')
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
VALUES ('000171', 'Blessed is the man who does not ... in the counsel of the wicked', 'walk', ARRAY['walk','stand','go'], 1, 'fitb', ARRAY['Psalms'], 'Psalms 1:1')
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
VALUES ('000172', 'What was the name of Aaron''s wife?', 'Elisheba', ARRAY['Zipporah','Jehosheba','Elizabeth'], 5, 'mc', ARRAY['Exodus'], 'Exodus 6:22')
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
VALUES ('000173', 'How did the people react when the law was read aloud by Ezra?', 'They wept', ARRAY['They rejoiced','They left the city','They rebelled'], 5, 'mc', ARRAY['Nehemiah'], 'Nehemiah 8:9')
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
VALUES ('000174', 'What was Nehemiah''s function at the court of the king of Persia?', 'Cupbearer', ARRAY['Head of the guards','Herald','Bookkeeper'], 4, 'mc', ARRAY['Nehemiah'], 'Nehemiah 1:11')
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
VALUES ('000175', 'What was Ezra''s main task when he came to Jerusalem?', 'Teach the people in the Law of the Lord', ARRAY['Rebuild the city','Restore the walls','Cleanse the temple'], 5, 'mc', ARRAY['Ezra'], 'Ezra 7:10')
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
VALUES ('000176', 'What happened to King Uzziah when he wanted to perform the priestly office?', 'He got leprosy', ARRAY['He was blessed','He became king over all tribes','He was expelled from Jerusalem'], 5, 'mc', ARRAY['2 Chronicles'], '2 Chronicles 26: 16-21')
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
VALUES ('000177', 'What did Solomon do after he completed the temple?', 'He prayed', ARRAY['He left Jerusalem','He destroyed the high places','He hid the ark'], 4, 'mc', ARRAY['1 Kings'], '1 Kings 8: 22, 23')
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
VALUES ('000178', 'Who brought the ark of God to Jerusalem, after it had first failed?', 'David', ARRAY['Moses','Saul','Joab'], 3, 'mc', '{}', '2 Samuel 6: 12-15')
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
VALUES ('000179', 'What did Elisha do to make the bitter water of Jericho healthy?', 'He threw salt into the spring', ARRAY['He prayed to God','He struck the water with his cloak','He commanded the water to stand still'], 4, 'mc', ARRAY['2 Kings'], '2 Kings 2:21')
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
VALUES ('000180', 'What happened at the dedication of the temple that Solomon built?', 'The cloud filled the house of the Lord', ARRAY['Fire came from heaven','The ark disappeared','The priests went into the sanctuary'], 4, 'mc', ARRAY['1 Kings'], '1 Kings 8: 10, 11')
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
VALUES ('000181', 'What did David do when he heard of the death of Absalom?', 'He wept and mourned', ARRAY['He celebrated','He fled','He stoned himself'], 2, 'mc', ARRAY['2 Samuel'], '2 Samuel 18:33')
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
VALUES ('000182', 'With how many men did Gideon defeat the army of Midian?', '300', ARRAY['30','1000','3000'], 2, 'mc', ARRAY['Judges'], 'Judges 7:6')
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
VALUES ('000183', 'Who was the only female judge of Israel?', 'Deborah', ARRAY['Hannah','Ruth','Jael'], 1, 'mc', ARRAY['Judges'], 'Judges 4:4-5')
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
VALUES ('000184', 'What did Joshua say to the people in his farewell speech?', 'But as for me and my house, we will serve the Lord', ARRAY['Leave this land, for it is unclean','Seek for yourself another god this day','Let us return to Egypt'], 2, 'mc', ARRAY['Joshua'], 'Joshua 24:15')
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
VALUES ('000185', 'What did Moses have to do to get water from the rock at Meribah?', 'Strike the rock with his staff', ARRAY['Speak to the rock','Pray to the Lord','Sprinkle the rock with blood'], 3, 'mc', ARRAY['Genesis','Exodus'], 'Exodus 17:1-7')
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
VALUES ('000186', 'What did the priest have to do with the blood of the guilt offering?', 'Put it on the horns of the altar', ARRAY['Put it on the ark','Put it on the west side of the sanctuary of the holy ones','Mix it with incense'], 3, 'mc', ARRAY['Exodus'], 'Exodus 29:12')
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
VALUES ('000187', 'What did God say to Moses from the burning bush?', 'I am the God of your fathers', ARRAY['Go to Nineveh','You are chosen above all nations','I am your God'], 4, 'mc', ARRAY['Genesis','Exodus'], 'Exodus 3:6')
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
VALUES ('000188', 'What did Noah build first after the flood?', 'An altar', ARRAY['A city','A ship','A tower'], 1, 'mc', ARRAY['Genesis'], 'Genesis 8:20')
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
VALUES ('000189', 'What did God say to the serpent after the fall of Adam and Eve?', '"Cursed are you above all livestock"', ARRAY['"You shall return to dust"','"You shall leave your wife"','"I will be gracious to you"'], 2, 'mc', ARRAY['Genesis'], 'Genesis 3:14')
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
VALUES ('000190', 'What was the name of the disciple Matthew first?', 'Levi', ARRAY['Simon','Mark','Lazarus'], 1, 'mc', ARRAY['Matthew'], 'Mark 9:9')
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
VALUES ('000191', 'With whom did Mary, the mother of the Lord Jesus, live after Jesus'' death?', 'With John', ARRAY['With Martha','With Peter','With her sister'], 2, 'mc', ARRAY['John'], 'John 19: 26, 27')
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
VALUES ('000192', 'Where was the Lord Jesus led by the Spirit after his baptism in the Jordan?', 'Into the wilderness', ARRAY['To Galilee','To Capernaum','To his disciples'], 2, 'mc', ARRAY['Matthew'], 'Matthew 4 : 1-3')
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
VALUES ('000193', 'How does the Sermon on the Mount begin in Matthew 5?', 'With the Beatitudes', ARRAY['With the Lord''s Prayer','With the parables of the seed','With the commandment of love'], 3, 'mc', ARRAY['Matthew'], 'Matthew 5: 1-12')
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
VALUES ('000194', 'What is the first miracle of Jesus, mentioned in the biblical book of Mark?', 'Casting out an unclean spirit', ARRAY['Turning water into wine','Peter walks on the water','Jesus calms the storm'], 4, 'mc', ARRAY['Matthew','Mark','Luke'], 'Mark 1:21-28')
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
VALUES ('000195', 'Who is first mentioned in Matthew in the genealogy of Jesus?', 'Abraham', ARRAY['Jacob','Adam','Moses'], 3, 'mc', ARRAY['Matthew'], 'Matthew 1:1')
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
VALUES ('000196', 'What was the first message that Jesus preached in Mark 1?', 'Repent and believe the Gospel', ARRAY['Love one another','Go into the whole world','Watch and pray'], 4, 'mc', '{}', 'Mark 1:15')
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
VALUES ('000197', 'To whom is the Gospel of Luke addressed?', 'Theophilus', ARRAY['Timothy','Titus','Silas'], 2, 'mc', ARRAY['Luke'], 'Luke 1:3')
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
VALUES ('000198', 'Who saw Jesus first after His resurrection?', 'The Emmaus travelers', ARRAY['Peter','Mary Magdalene','John'], 2, 'mc', ARRAY['Luke'], 'Luke 24:15')
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
VALUES ('000199', 'Where does the biblical book of Luke end?', 'At the ascension of Jesus', ARRAY['At the crucifixion','At Pentecost in Jerusalem','At the announcement of the second coming'], 3, 'mc', '{}', 'Luke 24: 50-53')
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
VALUES ('000200', 'With what words does John 1 begin?', 'In the beginning was the Word', ARRAY['In the beginning God created','And it came to pass','This is the book of generations'], 2, 'mc', '{}', 'John 1: 1')
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
VALUES ('000201', 'Who was the woman at the well?', 'A Samaritan woman', ARRAY['A Jewess','A Roman woman','A Philistine woman'], 1, 'mc', ARRAY['John'], 'John 4:7')
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
VALUES ('000202', 'Who took the place of Judas as apostle?', 'Matthias', ARRAY['Barnabas','Paul','Silas'], 3, 'mc', ARRAY['Acts'], 'Acts 1: 15-26')
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
VALUES ('000203', 'What did Peter do after Pentecost?', 'He preached', ARRAY['He was silent','He prayed in silence','He fled'], 1, 'mc', ARRAY['Acts'], 'Acts 2:14-41')
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
VALUES ('000204', 'Who converted on the road to Damascus?', 'Saul', ARRAY['Peter','Barnabas','Timothy'], 1, 'mc', ARRAY['Acts'], 'Acts 9: 1-6')
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
VALUES ('000205', 'How does the book of Acts end?', 'With Paul''s stay in Rome', ARRAY['With Paul''s death','With the destruction of Jerusalem','With Pentecost'], 4, 'mc', ARRAY['Acts'], 'Acts 28')
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
VALUES ('000206', 'How does Paul describe himself in Romans 1:1?', 'A servant of Jesus Christ', ARRAY['A prophet of Jesus Christ','A servant of men','An apostle of John'], 2, 'mc', ARRAY['Romans'], 'Romans 1:1')
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
VALUES ('000207', 'Who are the true children of Abraham?', 'Those who are of faith', ARRAY['Those who are of the Spirit','Those born in Israel','Those who are of the flesh'], 2, 'mc', ARRAY['Romans'], 'Romans 4:16')
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
VALUES ('000208', 'What does Paul say that we must do with our bodies?', 'Present them as a living, holy and pleasing sacrifice to God', ARRAY['Subject them to the law','Use them for good works','Offer them as sacrifices'], 4, 'mc', ARRAY['Romans'], 'Romans 12: 1')
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
VALUES ('000209', 'What is the summary of the law?', 'Love', ARRAY['Faith','Obedience','Hope'], 1, 'mc', ARRAY['Romans'], 'Romans 13: 8-14')
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
VALUES ('000210', 'What is the problem in the church at Corinth?', 'Strife and division', ARRAY['Persecution','Lack of faith','Lack of love'], 4, 'mc', ARRAY['1 Corinthians'], '1 Corinthians 1:10-13')
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
VALUES ('000211', 'What is the body of a believer?', 'A temple of the Holy Spirit', ARRAY['Dust of the earth','A sinful vessel','A temporary tent'], 2, 'mc', ARRAY['1 Corinthians'], '1 Corinthians 6 and 20')
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
VALUES ('000212', 'How many letters did Paul write to the Corinthians that have been preserved?', 'Two', ARRAY['One','Three','Four'], 1, 'mc', ARRAY['1 Corinthians'], NULL)
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
VALUES ('000213', 'What does Paul say about weakness?', 'My power is made perfect in weakness', ARRAY['Weakness is a sin','Avoid weakness at all times','Faith overcomes weakness'], 2, 'mc', ARRAY['2 Corinthians'], '2 Corinthians 12:9')
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
VALUES ('000214', 'What is the ministry that God has given to us?', 'Ministry of reconciliation', ARRAY['Ministry of judgment','Ministry of grace','Ministry of the commandments'], 2, 'mc', ARRAY['2 Corinthians'], '2 Corinthians 5:18')
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
VALUES ('000215', 'What surprises Paul?', 'That they quickly turn to another gospel', ARRAY['That the Galatians are devout','That they fast much','That they pray much'], 3, 'mc', '{}', 'Galatians 1:6')
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
VALUES ('000216', 'What does Paul say about the law?', 'It is a tutor to Christ', ARRAY['It justifies','It leads away from sins','It is fulfilled in Christ'], 4, 'mc', ARRAY['Galatians'], 'Galatians 3:24')
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
VALUES ('000217', 'Through what are we made righteous?', 'Through faith, by grace', ARRAY['Through the works of the law','Through keeping the law','Through prayer and fasting'], 2, 'mc', ARRAY['Galatians'], 'Galatians 2:16')
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
VALUES ('000218', 'What must children do?', 'Be obedient to their parents', ARRAY['Be silent','Work','Pray'], 1, 'mc', '{}', 'Ephesians 6:1-3')
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
VALUES ('000219', 'What is life for Paul?', 'Christ', ARRAY['Suffering','Struggle','Hope'], 2, 'mc', ARRAY['Philippians'], 'Philippians 1:21')
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
VALUES ('000220', 'Who is mentioned as Paul''s brother and fellow worker?', 'Epaphroditus', ARRAY['Barnabas','Silas','Timothy'], 4, 'mc', ARRAY['Philippians'], 'Philippians 2:25')
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
VALUES ('000221', 'Who wrote the letter to the Colossians?', 'Paul', ARRAY['Colossians','Silas','Timotheus'], 1, 'mc', ARRAY['Colossians'], 'Colossians 1:1-2')
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
VALUES ('000222', 'Who wrote the letter to the Thessalonians?', 'Paul, Silvanus and Timothy', ARRAY['Paul','Paul and Timothy','Paul and Barnabas'], 5, 'mc', '{}', '1 Thessalonians 1:1')
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
VALUES ('000223', 'What did Christ do that it was done?', 'The angel of the Lord', ARRAY['Moses','The angel of the Lord','The Holy Spirit'], 3, 'mc', ARRAY['Colossians'], 'Colossians 1:15')
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
VALUES ('000224', 'What happens to the dead in Christ at His coming?', 'They shall rise first', ARRAY['They shall be judged','They return with Jesus','They shall rise last'], 2, 'mc', '{}', '1 Thessalonians 4:16')
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
VALUES ('000225', 'What must happen first before the day of the Lord comes?', 'The falling away from the faith and the revealing of the man of sin', ARRAY['The coming','The resurrection from the dead','The oppression'], 3, 'mc', '{}', '2 Thessalonians 2')
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
VALUES ('000226', 'How is the "man of sin" also called?', 'The son of perdition', ARRAY['The antichrist','The dragon','The ruler of darkness'], 3, 'mc', '{}', '2 Thessalonians 2:3')
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
VALUES ('000227', 'What is Paul''s blessing at the end of Thessalonians?', 'The grace of our Lord Jesus Christ be with you all. Amen.', ARRAY['Grace and peace be with you all. Amen.','The love of God and the fellowship of the Holy Spirit be with you all, Amen.','The peace of God be with you all. Amen.'], 4, 'mc', '{}', '2 Thessalonians 3:18')
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
VALUES ('000228', 'What does Paul say about women in the worship service?', 'That they should be in silence', ARRAY['That they should prophesy','That they should teach the people','That they should preach to the people'], 3, 'mc', '{}', '1 Timothy 2:11')
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
VALUES ('000229', 'What is God not?', 'A spirit of fear', ARRAY['A consuming fire','A God of judgment','A God of strife'], 4, 'mc', '{}', '2 Timothy 1:7')
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
VALUES ('000230', 'Which parable does Paul use for the life of a believer?', 'Soldier, athlete, farmer', ARRAY['Prophet, priest, king','Redemption, pilgrimage, traveler','Fisherman, farmer, soldier'], 5, 'mc', ARRAY['2 Timothy'], '2 Timothy 2')
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
VALUES ('000231', 'Who has Paul left, having loved the present world?', 'Demas', ARRAY['Timothy'], 4, 'mc', ARRAY['Romans'], '2 Timothy 4:10')
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
VALUES ('000232', 'What did Titus have to do on Crete?', 'Appoint elders in every city', ARRAY['Convince the Romans','Appoint deacons in every city','Establish a church'], 4, 'mc', ARRAY['Titus'], 'Titus 1:5')
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
VALUES ('000233', 'What does Paul say about the saving grace of God?', 'It has appeared to all men', ARRAY['It has come to Israel','It has come for the chosen ones','It teaches us to know Christ through the law'], 5, 'mc', ARRAY['Titus'], 'Titus 2:11')
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
VALUES ('000234', 'Who was Onesimus?', 'A runaway slave', ARRAY['A Roman soldier','An elder','A deacon'], 3, 'mc', ARRAY['Philemon'], 'Philemon 1:16')
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
VALUES ('000235', 'Who was Melchizedek?', 'A priest without genealogy', ARRAY['A priest from the line of David','A descendant of Abraham','A descendant of Moses'], 3, 'mc', ARRAY['Hebrews'], 'Hebrews 7:3')
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
VALUES ('000236', 'Who are mentioned in Hebrews 11 as examples of faith?', 'Noah, Abraham, Moses', ARRAY['David, Elijah, Isaiah','John, Peter, Andrew','Paul, Timothy, Titus'], 2, 'mc', ARRAY['Hebrews'], 'Hebrews 11')
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
VALUES ('000237', 'What is the origin of reconciliation?', 'Self-will', ARRAY['The devil','The self-will','The world'], 2, 'mc', ARRAY['James'], 'James 1:14')
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
VALUES ('000238', 'Who must pray for the sick?', 'The elders of the church', ARRAY['The deacons of the church','The preachers of the church','The believing physicians from the church'], 3, 'mc', ARRAY['James'], 'James 5:14-15')
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
VALUES ('000239', 'God created the heaven and earth in six days', 'Not true', ARRAY['True'], 1, 'tf', ARRAY['Genesis'], 'Genesis 2:2')
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
VALUES ('000240', 'Cain killed his brother Abel', 'Not true', ARRAY['True'], 1, 'tf', ARRAY['Genesis'], 'Genesis 4:8')
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
VALUES ('000241', 'Aaron was the father of Moses', 'Not true', ARRAY['True'], 1, 'tf', '{}', 'Exodus 6:19')
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
VALUES ('000242', 'The law of the jubilee year is set out in Leviticus', 'True', ARRAY['Not true'], 3, 'tf', ARRAY['Leviticus'], 'Leviticus 25: 8-55')
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
VALUES ('000243', 'Leviticus is primarily addressed to the tribe of Judah', 'Not true', ARRAY['True'], 4, 'tf', ARRAY['Leviticus'], 'Leviticus')
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
VALUES ('000244', 'Balaam''s donkey spoke to him', 'True', ARRAY['Not true'], 1, 'tf', ARRAY['Numbers'], 'Numbers 22:28')
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
VALUES ('000245', 'Deuteronomy means "restoration of the law"', 'True', ARRAY['Not true'], 4, 'tf', ARRAY['Deuteronomy'], 'Deuteronomy')
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
VALUES ('000246', 'Deuteronomy describes Moses'' last speech', 'True', ARRAY['Not true'], 3, 'tf', ARRAY['Deuteronomy'], 'Deuteronomy 32 and 33')
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
VALUES ('000247', 'Joshua was the nephew of Nun', 'Not true', ARRAY['True'], 2, 'tf', ARRAY['Joshua'], 'Joshua 1:1')
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
VALUES ('000248', 'The sun stood still during a battle under Joshua''s leadership', 'True', ARRAY['Not true'], 3, 'tf', ARRAY['Joshua'], 'Joshua 10:12-14')
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
VALUES ('000249', 'The book Joshua ends with the death of Moses', 'Not true', ARRAY['True'], 3, 'tf', ARRAY['Joshua'], 'Joshua 24')
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
VALUES ('000250', 'The book Judges ends with the words: ''In those days there was no king in Israel, everyone did what was right in his eyes''', 'True', ARRAY['Not true'], 4, 'tf', ARRAY['Judges'], 'Judges 21')
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
VALUES ('000251', 'Samson was a judge in Israel', 'True', ARRAY['Not true'], 3, 'tf', ARRAY['Judges'], 'Judges 13')
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
VALUES ('000252', 'Ruth became the grandmother of King Solomon', 'Not true', ARRAY['True'], 3, 'tf', ARRAY['Ruth'], 'Ruth 4')
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
VALUES ('000253', 'Samuel was raised in the holiness in Jerusalem', 'Not true', ARRAY['True'], 3, 'tf', ARRAY['1 Samuel'], '1 Samuel 1:3')
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
VALUES ('000254', 'Saul was the first king of Israel', 'Not true', ARRAY['True'], 2, 'tf', ARRAY['Genesis'], '1 Samuel 10:1')
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
VALUES ('000255', 'Uzzah died when he touched the ark of God', 'Not true', ARRAY['True'], 3, 'tf', ARRAY['Exodus'], '2 Samuel 6:6, 7')
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
VALUES ('000256', 'Absalom, David''s son, rose in rebellion against David', 'True', ARRAY['Not true'], 1, 'tf', ARRAY['2 Samuel'], '2 Samuel 13 - 18')
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
VALUES ('000257', 'Elijah slaughtered the Baal priests on Mount Carmel', 'True', ARRAY['Not true'], 2, 'tf', ARRAY['Genesis'], '1 Kings 18')
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
VALUES ('000258', 'After Solomon the kingdom remained intact', 'Not true', ARRAY['True'], 3, 'tf', ARRAY['1 Kings'], '1 Kings 12')
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
VALUES ('000259', 'Elisha received a double portion of Elijah''s spirit', 'True', ARRAY['Not true'], 4, 'tf', ARRAY['Revelation'], '2 Kings 2:9, 10')
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
VALUES ('000260', 'David brought the ark to Jerusalem', 'Not true', ARRAY['True'], 3, 'tf', '{}', '1 Chronicles 15')
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
VALUES ('000261', 'David built the temple in Jerusalem', 'Not true', ARRAY['True'], 2, 'tf', ARRAY['2 Chronicles'], '2 Chronicles 2:1')
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
VALUES ('000262', 'Josiah found the book of the law in the temple', 'Not true', ARRAY['True'], 4, 'tf', ARRAY['1 Chronicles'], '2 Chronicles 34')
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
VALUES ('000263', 'Cyrus was the king of the Medes', 'Not true', ARRAY['True'], 3, 'tf', ARRAY['Daniel'], 'Ezra 1:1')
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
VALUES ('000264', 'Ezra led the first group of exiles back to Jerusalem', 'Not true', ARRAY['True'], 5, 'tf', ARRAY['Ezra'], 'Ezra 2:1, 2')
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
VALUES ('000265', 'Ezra was a priest and scribe', 'Not true', ARRAY['True'], 4, 'tf', ARRAY['Ezra'], 'Ezra 7:6, 11')
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
VALUES ('000266', 'The temple was rebuilt during the time of Ezra', 'Not true', ARRAY['True'], 4, 'tf', ARRAY['Ezra'], 'Ezra 5 and 6')
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
VALUES ('000267', 'The rebuilding of the temple was never completed', 'Not true', ARRAY['True'], 2, 'tf', ARRAY['Ezra'], 'Ezra 4: 1-5')
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
VALUES ('000268', 'Nehemiah was cupbearer to the court of the king of Babylon', 'Not true', ARRAY['True'], 4, 'tf', ARRAY['Nehemiah'], 'Nehemiah 1:11')
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
VALUES ('000269', 'Nehemiah led the rebuilding of the walls of Jerusalem', 'Not true', ARRAY['True'], 3, 'tf', ARRAY['Nehemiah'], 'Nehemiah 2 and 18')
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
VALUES ('000270', 'Mordecai was the father of Esther', 'Not true', ARRAY['True'], 1, 'tf', ARRAY['Esther'], 'Esther 2:7')
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
VALUES ('000271', 'The book Esther never mentions the name of God', 'True', ARRAY['Not true'], 1, 'tf', ARRAY['Esther'], 'Esther 1')
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
VALUES ('000272', 'Job was a rich man from the land of Uz', 'Not true', ARRAY['True'], 3, 'tf', ARRAY['Job'], 'Job 1:1')
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
VALUES ('000273', 'The wife of Job said: ''Bless God and die''', 'Not true', ARRAY['True'], 2, 'tf', ARRAY['Job'], 'Job 2:9')
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
VALUES ('000274', 'The Psalms contain both praises and complaints', 'True', ARRAY['Not true'], 1, 'tf', ARRAY['Psalms'], 'Psalms')
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
VALUES ('000275', 'David was the writer of the Biblical book Psalms', 'Not true', ARRAY['True'], 2, 'tf', ARRAY['Psalms'], 'Psalms')
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
VALUES ('000276', 'Solomon is the most important writer of the Biblical book Proverbs', 'Not true', ARRAY['True'], 2, 'tf', ARRAY['Proverbs'], 'Proverbs 1:1')
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
VALUES ('000277', 'Wickedness does the monkey tricks', 'Not true', ARRAY['True'], 3, 'tf', ARRAY['Proverbs'], 'Proverbs')
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
VALUES ('000278', 'Prophet is addressed to Solomon', 'Not true', ARRAY['True'], 3, 'tf', ARRAY['Proverbs'], 'Proverbs 1:1 and 12')
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
VALUES ('000279', 'False teachers are deceiving', 'Not true', ARRAY['True'], 3, 'tf', ARRAY['Proverbs'], 'Proverbs')
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
VALUES ('000280', 'The king has made a chariot of wood from Jerusalem', 'Not true', ARRAY['True'], 2, 'tf', ARRAY['Haggai'], 'Haggai 3:9')
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
VALUES ('000281', 'Draw me, we will leave you', 'Not true', ARRAY['True'], 1, 'tf', ARRAY['Haggai'], 'Haggai 1:4')
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
VALUES ('000282', 'Isaiah prophesied about the coming of the Messiah', 'Not true', ARRAY['True'], 1, 'tf', ARRAY['Isaiah'], 'Isaiah 7, 9, 11, 53')
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
VALUES ('000283', 'The Bible Isaiah has 66 chapters', 'Not true', ARRAY['True'], 3, 'tf', ARRAY['Isaiah'], 'Isaiah 66')
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
VALUES ('000284', 'Jeremiah wrote a book to the exiles in Babylon', 'Not true', ARRAY['True'], 3, 'tf', ARRAY['Jeremiah'], 'Jeremiah 29:1')
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
VALUES ('000285', 'Jeremiah says: Ah, LORD GOD, behold, I cannot speak', 'Not true', ARRAY['True'], 4, 'tf', ARRAY['Jeremiah'], 'Jeremiah 1:6')
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
VALUES ('000286', 'Lamentations was written after the destruction of Jerusalem', 'Not true', ARRAY['True'], 5, 'tf', ARRAY['Lamentations'], 'Lamentations 1')
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
VALUES ('000287', 'In Lamentations comes no single hope for you', 'Not true', ARRAY['True'], 3, 'tf', ARRAY['Lamentations'], 'Lamentations 3: 21-23')
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
VALUES ('000288', 'Ezekiel prophesied in Babylon, went from Jerusalem', 'Not true', ARRAY['True'], 3, 'tf', ARRAY['Ezekiel'], 'Ezekiel 1:1-3')
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
VALUES ('000289', 'Ezekiel ends with: and I was already there', 'Not true', ARRAY['True'], 5, 'tf', ARRAY['Ezekiel'], 'Ezekiel 48:35')
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
VALUES ('000290', 'Daniel worked at the court of former kings in Babylon', 'Not true', ARRAY['True'], 2, 'tf', ARRAY['Daniel'], 'Daniel')
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
VALUES ('000291', 'King Nebuchadnezzar made a statue of gold, the height was 60 cubits', 'Not true', ARRAY['True'], 3, 'tf', ARRAY['Daniel'], 'Daniel 3:1')
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
VALUES ('000292', 'Hosea called the people to return to the Lord', 'Not true', ARRAY['True'], 2, 'tf', ARRAY['Hosea'], 'Hosea 6:1')
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
VALUES ('000293', 'Hosea preached only about love and forgiveness', 'Not true', ARRAY['True'], 3, 'tf', ARRAY['Hosea'], 'Hosea')
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
VALUES ('000294', 'Joel describes a plague as judgment', 'Not true', ARRAY['True'], 5, 'tf', ARRAY['Joel'], 'Joel 1')
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
VALUES ('000295', 'Egypt and Edom will be saved, despite that they have turned against God', 'Not true', ARRAY['True'], 4, 'tf', ARRAY['Joel'], 'Joel 3:19')
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
VALUES ('000296', 'Amos was a shepherd from Tekoa', 'Not true', ARRAY['True'], 2, 'tf', ARRAY['Amos'], 'Amos 1:1')
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
VALUES ('000297', 'Amos saw in a vision a basket of summer fruit', 'Not true', ARRAY['True'], 3, 'tf', ARRAY['Amos'], 'Amos 8:1')
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
VALUES ('000298', 'Obadiah is the shortest Bible book from the Old Testament', 'Not true', ARRAY['True'], 3, 'tf', ARRAY['Obadiah'], 'Obadiah 1')
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
VALUES ('000299', 'Obadiah''s prophecy is directed against Israel', 'Not true', ARRAY['True'], 4, 'tf', ARRAY['Obadiah'], 'Obadiah 1:1')
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
VALUES ('000300', 'Jonah was happy with God''s compassion for Nineveh', 'Not true', ARRAY['True'], 3, 'tf', ARRAY['Jonah'], 'Jonah 4')
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
VALUES ('000301', 'Jonah was swallowed by God to go to Nineveh', 'Not true', ARRAY['True'], 1, 'tf', ARRAY['Jonah'], 'Jonah 1:2')
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
VALUES ('000302', 'Micah foretold the birthplace of the Messiah', 'Not true', ARRAY['True'], 3, 'tf', ARRAY['Micah'], 'Micah 5:1')
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
VALUES ('000303', 'Micah lived in the time of King Ahab', 'Not true', ARRAY['True'], 4, 'tf', ARRAY['Micah'], 'Micah 1:1')
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
VALUES ('000304', 'Nahum prophesied against the city Nineveh', 'Not true', ARRAY['True'], 3, 'tf', ARRAY['Nahum'], 'Nahum 1, 2, 3')
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
VALUES ('000305', 'In Nahum it says: four your times, O Jerusalem, pay your vows', 'Not true', ARRAY['True'], 5, 'tf', ARRAY['Nahum'], 'Nahum')
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
VALUES ('000306', 'Habakkuk says: "the righteous shall live by his faith"', 'Not true', ARRAY['True'], 4, 'tf', ARRAY['Habakkuk'], 'Habakkuk 2:4')
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
VALUES ('000307', 'Habakkuk is shaken by God because of his doubts', 'Not true', ARRAY['True'], 4, 'tf', ARRAY['Habakkuk'], 'Habakkuk')
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
VALUES ('000308', 'Zephaniah prophesied about the overthrow of Jerusalem', 'Not true', ARRAY['True'], 5, 'tf', ARRAY['Zephaniah'], 'Zephaniah 1')
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
VALUES ('000309', 'In Zephaniah comes no single hope for you', 'Not true', ARRAY['True'], 3, 'tf', ARRAY['Zephaniah'], 'Zephaniah 3: 21-23')
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
VALUES ('000310', 'Ezekiel prophesied in Babylon, went from Jerusalem', 'Not true', ARRAY['True'], 3, 'tf', ARRAY['Ezekiel'], 'Ezekiel 1:1-3')
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
VALUES ('000311', 'Ezekiel ends with: and I was already there', 'Not true', ARRAY['True'], 5, 'tf', ARRAY['Ezekiel'], 'Ezekiel 48:35')
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
VALUES ('000312', 'Daniel worked at the court of former kings in Babylon', 'Not true', ARRAY['True'], 2, 'tf', ARRAY['Daniel'], 'Daniel')
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
VALUES ('000313', 'King Nebuchadnezzar made a statue of gold, the height was 60 cubits', 'Not true', ARRAY['True'], 3, 'tf', ARRAY['Daniel'], 'Daniel 3:1')
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
VALUES ('000314', 'Hosea called the people to return to the Lord', 'Not true', ARRAY['True'], 2, 'tf', ARRAY['Hosea'], 'Hosea 6:1')
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
VALUES ('000315', 'Hosea preached only about love and forgiveness', 'Not true', ARRAY['True'], 3, 'tf', ARRAY['Hosea'], 'Hosea')
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
VALUES ('000316', 'Joel describes a plague as judgment', 'Not true', ARRAY['True'], 5, 'tf', ARRAY['Joel'], 'Joel 1')
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
VALUES ('000317', 'Egypt and Edom will be saved, despite that they have turned against God', 'Not true', ARRAY['True'], 4, 'tf', ARRAY['Joel'], 'Joel 3:19')
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
VALUES ('000318', 'Amos was a shepherd from Tekoa', 'Not true', ARRAY['True'], 2, 'tf', ARRAY['Amos'], 'Amos 1:1')
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
VALUES ('000319', 'Amos saw in a vision a basket of summer fruit', 'Not true', ARRAY['True'], 3, 'tf', ARRAY['Amos'], 'Amos 8:1')
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
VALUES ('000320', 'Obadiah is the shortest Bible book from the Old Testament', 'Not true', ARRAY['True'], 3, 'tf', ARRAY['Obadiah'], 'Obadiah 1')
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
VALUES ('000321', 'Obadiah''s prophecy is directed against Israel', 'Not true', ARRAY['True'], 4, 'tf', ARRAY['Obadiah'], 'Obadiah 1:1')
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
VALUES ('000322', 'Jonah was happy with God''s compassion for Nineveh', 'Not true', ARRAY['True'], 3, 'tf', ARRAY['Jonah'], 'Jonah 4')
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
VALUES ('000323', 'Jonah was swallowed by God to go to Nineveh', 'Not true', ARRAY['True'], 1, 'tf', ARRAY['Jonah'], 'Jonah 1:2')
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
VALUES ('000324', 'Micah foretold the birthplace of the Messiah', 'Not true', ARRAY['True'], 3, 'tf', ARRAY['Micah'], 'Micah 5:1')
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
VALUES ('000325', 'Micah lived in the time of King Ahab', 'Not true', ARRAY['True'], 4, 'tf', ARRAY['Micah'], 'Micah 1:1')
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
VALUES ('000326', 'Nahum prophesied against the city Nineveh', 'Not true', ARRAY['True'], 3, 'tf', ARRAY['Nahum'], 'Nahum 1, 2, 3')
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
VALUES ('000327', 'In Nahum it says: four your times, O Jerusalem, pay your vows', 'Not true', ARRAY['True'], 5, 'tf', ARRAY['Nahum'], 'Nahum')
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
VALUES ('000328', 'Habakkuk says: "the righteous shall live by his faith"', 'Not true', ARRAY['True'], 4, 'tf', ARRAY['Habakkuk'], 'Habakkuk 2:4')
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
VALUES ('000329', 'Habakkuk is shaken by God because of his doubts', 'Not true', ARRAY['True'], 4, 'tf', ARRAY['Habakkuk'], 'Habakkuk')
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
VALUES ('000330', 'Zephaniah prophesied about the overthrow of Jerusalem', 'Not true', ARRAY['True'], 5, 'tf', ARRAY['Zephaniah'], 'Zephaniah 1')
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
VALUES ('000331', 'Zephaniah was written after the destruction of Jerusalem', 'Not true', ARRAY['True'], 5, 'tf', ARRAY['Zephaniah'], 'Zephaniah 1')
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
VALUES ('000332', 'Ezekiel prophesied in Babylon, went from Jerusalem', 'Not true', ARRAY['True'], 3, 'tf', ARRAY['Ezekiel'], 'Ezekiel 1:1-3')
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
VALUES ('000333', 'Ezekiel ends with: and I was already there', 'Not true', ARRAY['True'], 5, 'tf', ARRAY['Ezekiel'], 'Ezekiel 48:35')
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
VALUES ('000334', 'Daniel worked at the court of former kings in Babylon', 'Not true', ARRAY['True'], 2, 'tf', ARRAY['Daniel'], 'Daniel')
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
VALUES ('000335', 'King Nebuchadnezzar made a statue of gold, the height was 60 cubits', 'Not true', ARRAY['True'], 3, 'tf', ARRAY['Daniel'], 'Daniel 3:1')
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
VALUES ('000336', 'Paul mentions the fruits of the Spirit in Galatians', 'True', ARRAY['Not true'], 2, 'tf', ARRAY['Galatians'], 'Galatians 5:22')
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
VALUES ('000337', 'In Christ there is difference between Jew and Greek, Paul writes in Galatians', 'Not true', ARRAY['True'], 2, 'tf', ARRAY['Galatians'], 'Galatians 3:28')
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
VALUES ('000338', 'In Ephesians the spiritual armor is described', 'True', ARRAY['Not true'], 3, 'tf', ARRAY['Ephesians'], 'Ephesians 6: 10-20')
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
VALUES ('000339', 'Paul wrote the biblical book Ephesians during his first missionary journey', 'Not true', ARRAY['True'], 3, 'tf', ARRAY['Ephesians','Acts'], 'Ephesians 3:1')
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
VALUES ('000340', 'Philippians is addressed to the Christians in Philippi', 'True', ARRAY['Not true'], 4, 'tf', ARRAY['Philippians'], 'Philippians')
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
VALUES ('000341', 'In Philippians it says "For to me to live is Christ, and to die is gain"', 'True', ARRAY['Not true'], 2, 'tf', ARRAY['Philippians'], 'Philippians 1:21')
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
VALUES ('000342', 'In Colossians the fruits of the Spirit are described', 'Not true', ARRAY['True'], 2, 'tf', '{}', 'Colossians')
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
VALUES ('000343', 'Paul knew the Christians of Colossae personally', 'Not true', ARRAY['True'], 4, 'tf', ARRAY['Colossians'], 'Colossians 1')
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
VALUES ('000344', '1 Thessalonians is probably Paul''s oldest letter', 'True', ARRAY['Not true'], 4, 'tf', '{}', '1 Thessalonians')
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
VALUES ('000345', 'In Thessalonians Paul calls to holy walk and brotherly love', 'True', ARRAY['Not true'], 3, 'tf', ARRAY['1 Thessalonians'], '1 Thessalonians 4')
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
VALUES ('000346', 'In 2 Thessalonians Paul calls to steadfastness', 'True', ARRAY['Not true'], 3, 'tf', '{}', '2 Thessalonians 2: 13-17')
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
VALUES ('000347', '2 Thessalonians is mainly a repetition of the first letter', 'Not true', ARRAY['True'], 3, 'tf', '{}', '2 Thessalonians')
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
VALUES ('000348', 'Paul writes in 1 Timothy about the office of elders and deacons', 'True', ARRAY['Not true'], 3, 'tf', ARRAY['1 Timothy'], '1 Timothy 3')
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
VALUES ('000349', 'Timothy was a pastor in Rome', 'Not true', ARRAY['True'], 4, 'tf', ARRAY['1 Timothy'], '1 Timothy')
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
VALUES ('000350', 'Paul writes in 1 Timothy about the role of women in the church', 'True', ARRAY['Not true'], 3, 'tf', ARRAY['1 Timothy'], '1 Timothy')
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
VALUES ('000351', 'In 2 Timothy Paul mentions "All Scripture is God-breathed"', 'True', ARRAY['Not true'], 4, 'tf', '{}', '2 Timothy 3:16')
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
VALUES ('000352', 'In 2 Timothy Paul expects that he will go on a journey soon', 'Not true', ARRAY['True'], 4, 'tf', ARRAY['1 Timothy','2 Timothy'], '2 Timothy')
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
VALUES ('000353', 'Titus was left by Paul on the island of Cyprus', 'Not true', ARRAY['True'], 4, 'tf', ARRAY['Philemon'], 'Titus 1:5')
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
VALUES ('000354', 'Titus contains instructions for appointing elders', 'True', ARRAY['Not true'], 3, 'tf', ARRAY['Philemon','Titus'], 'Titus 1: 5-9')
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
VALUES ('000355', 'When ... saw that she was not bearing children for Jacob, she envied ... her sister.', 'Rachel', ARRAY['Leah','Bilhah','Zilpah'], 1, 'fitb', ARRAY['Genesis'], 'Genesis 30:1')
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
VALUES ('000356', 'And Adam lived ... years and begot a son in his own likeness, in his own image, and named his name Seth', '130', ARRAY['90','110','140'], 4, 'fitb', ARRAY['Genesis'], 'Genesis 5:3')
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
VALUES ('000357', 'So all the days of Enoch were ... years', '365', ARRAY['969','300','782'], 4, 'fitb', ARRAY['Genesis'], 'Genesis 5:23')
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
VALUES ('000358', 'But Noah found ... in the eyes of the Lord', 'grace', ARRAY['mercy','forgiveness','goodness'], 1, 'fitb', ARRAY['Genesis'], 'Genesis 6:8')
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
VALUES ('000359', 'And the Lord said: Shall I hide from ... what I do?', 'Abraham', ARRAY['Adam','Noah','Lot'], 3, 'fitb', ARRAY['Genesis'], 'Genesis 18:17')
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
VALUES ('000360', 'Moses led the people out of ...', 'Egypt', ARRAY['Babylon','Canaan','Assyria'], 1, 'fitb', ARRAY['Exodus'], 'Exodus 12')
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
VALUES ('000361', 'The law was given on the mountain ...', 'Sinai', ARRAY['Horeb','Nebo','Moria'], 1, 'fitb', ARRAY['Exodus'], 'Exodus 19 and 20')
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
VALUES ('000362', 'And they shall make Me a ... that I may dwell in their midst', 'sanctuary', ARRAY['tent','tabernacle','temple'], 4, 'fitb', ARRAY['John'], 'Exodus 25:8')
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
VALUES ('000363', 'His snuffers and his ... shall be pure gold', 'snuff dishes', ARRAY['lamps','knops','tongs'], 3, 'fitb', ARRAY['Exodus'], 'Exodus 25:38')
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
VALUES ('000364', 'Then he (Moses) said: Show me Your ...', 'glory', ARRAY['goodness','grace','greatness'], 2, 'fitb', ARRAY['Exodus'], 'Exodus 33:18')
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
VALUES ('000365', 'Break them in pieces and pour oil on it: it is a ...', 'grain offering', ARRAY['burnt offering','fire offering','thanksgiving offering'], 4, 'fitb', ARRAY['Psalms'], 'Leviticus 2:6')
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
VALUES ('000366', 'It is a ... ; he has certainly made himself guilty to the Lord', 'guilt offering', ARRAY['burnt offering','thanksgiving offering','peace offering'], 3, 'fitb', ARRAY['Job'], 'Leviticus 5:19')
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
VALUES ('000367', 'And the priest shall light it on the altar as burnt offering to the Lord; it is a ...', 'guilt offering', ARRAY['sin offering','burnt offering','thanksgiving offering'], 3, 'fitb', ARRAY['Leviticus'], 'Leviticus 7:5')
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
VALUES ('000368', 'When Moses heard that, it was ... in his eyes', 'good', ARRAY['evil','right','beautiful'], 4, 'fitb', ARRAY['Exodus'], 'Leviticus 10:20')
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
VALUES ('000369', 'Also the ... of that oil shall pour it on the priest''s left hand', 'priest', ARRAY['prophet','man','survivor'], 3, 'fitb', ARRAY['Leviticus'], 'Leviticus 14:26')
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
VALUES ('000370', 'The book of Numbers begins with a census of the ...', 'Israelites', ARRAY['priests','Levites','foreigners'], 2, 'fitb', ARRAY['Numbers'], 'Numbers 1')
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
VALUES ('000371', 'Moses then spoke to the children of Israel, that they should keep the ...', 'Passover', ARRAY['commandment','feast of tabernacles','faith'], 2, 'fitb', ARRAY['Exodus','Deuteronomy'], 'Numbers 9:4')
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
VALUES ('000372', 'Of the tribe of Judah ..., the son of Jephunneh', 'Caleb', ARRAY['Simeon','Issachar','Benjamin'], 3, 'fitb', ARRAY['Genesis'], 'Numbers 13:6')
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
VALUES ('000373', 'And ... did it; as the Lord commanded him, so he did', 'Moses', ARRAY['Aaron','Levi','Edom'], 2, 'fitb', ARRAY['Exodus'], 'Numbers 17:11')
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
VALUES ('000374', 'But the children of ... did not die', 'Korah', ARRAY['Dathan','Abiram','Eliab'], 2, 'fitb', ARRAY['Exodus'], 'Numbers 26:11')
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
VALUES ('000375', 'Moses spoke to the people before they entered the promised land ...', 'entered', ARRAY['left','conquered','forgot'], 2, 'fitb', ARRAY['Exodus','Deuteronomy'], 'Deuteronomy 1')
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
VALUES ('000376', 'Moses died on the mountain ...', 'Nebo', ARRAY['Sinai','Horeb','Hor'], 1, 'fitb', ARRAY['Exodus','Deuteronomy'], 'Deuteronomy 34:5')
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
VALUES ('000377', 'Therefore the Lord has said to me: You shall not cross this ...', 'Jordan', ARRAY['Land','River','Mountain'], 3, 'fitb', ARRAY['Jeremiah'], 'Deuteronomy 3:27')
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
VALUES ('000378', 'A ... you shall not muzzle, when he is thirsty', 'ox', ARRAY['bull','ram','bear'], 2, 'fitb', ARRAY['Proverbs'], 'Deuteronomy 25:4')
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
VALUES ('000379', 'For you shall do what ... is in the eyes of the Lord', 'right', ARRAY['good','evil','just'], 3, 'fitb', ARRAY['Deuteronomy'], 'Deuteronomy 12:28')
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
VALUES ('000380', 'Then Joshua commanded the ... of the people, saying:', 'officers', ARRAY['leaders','heads','sons'], 3, 'fitb', ARRAY['Joshua'], 'Joshua')
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
VALUES ('000381', 'And He said: No, but I am the ... of the host of the Lord', 'Commander', ARRAY['King','Priest','Prophet'], 3, 'fitb', ARRAY['Exodus'], 'Joshua 5')
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
VALUES ('000382', 'Then Joshua built an altar to the Lord, the God of Israel, on the mountain ...', 'Ebal', ARRAY['Horeb','Sinai','Hermon'], 3, 'fitb', ARRAY['Joshua'], 'Joshua 8:30')
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
VALUES ('000383', 'But the king of ... they captured alive, and they brought him to Joshua', 'Ai', ARRAY['Lebanon','Perez','Gibeon'], 3, 'fitb', ARRAY['Joshua'], 'Joshua 8:23')
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
VALUES ('000384', 'Those five kings were found, hidden in the cave at ...', 'Makkedah', ARRAY['Adullam','Machpelah','the prophets'], 3, 'fitb', ARRAY['1 Samuel'], 'Joshua 10:16')
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
VALUES ('000385', 'The first judge of Israel was ...', 'Othniel', ARRAY['Ehud','Shamgar','Gideon'], 2, 'fitb', ARRAY['Judges'], 'Judges 3')
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
VALUES ('000386', '... now, a woman who was a prophetess, the wife of Lappidoth', 'Deborah', ARRAY['Rebekah','Jael','Priscilla'], 1, 'fitb', ARRAY['1 Samuel'], 'Judges 4:4')
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
VALUES ('000387', 'Gideon asked for a sign from God with a ...', 'fleece of wool', ARRAY['dream','vision','voice'], 1, 'fitb', ARRAY['Judges'], 'Judges 6:37')
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
VALUES ('000388', 'Then the trees said to the vine: Come you, be ... over us', 'king', ARRAY['ruler','prince','chief'], 3, 'fitb', ARRAY['Ecclesiastes'], 'Judges 9:12')
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
VALUES ('000389', 'And ... vowed a vow to the Lord', 'Jephthah', ARRAY['Jair','Gideon','Ephraim'], 1, 'fitb', ARRAY['Genesis'], 'Judges 11')
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
VALUES ('000390', 'And ..., the husband of Naomi died', 'Elimelech', ARRAY['Mahlon','Chilion','Boaz'], 2, 'fitb', ARRAY['Genesis','Ruth'], 'Ruth 1:3')
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
VALUES ('000391', 'Call me not Naomi, call me ...', 'Mara', ARRAY['Orpah','Ruth','Rachel'], 1, 'fitb', ARRAY['Ruth'], 'Ruth 1:20')
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
VALUES ('000392', 'Naomi now had a kinsman of her husband, a man, mighty in ...', 'wealth', ARRAY['name','spirit','goodness'], 2, 'fitb', ARRAY['Ruth'], 'Ruth 2:1')
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
VALUES ('000393', 'The Lord will reward your ..., and your reward will be full from the Lord', 'deed', ARRAY['wage','goodness','faith'], 2, 'fitb', ARRAY['Ruth'], 'Ruth 2:12')
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
VALUES ('000394', 'When she now rose ...', 'to read', ARRAY['to go','to work','to comfort her'], 3, 'fitb', ARRAY['Revelation'], 'Ruth')
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
VALUES ('000395', 'And she said to her: All what you ... , I will do', 'say to me', ARRAY['command me','threaten me','speak to me'], 3, 'fitb', ARRAY['Ruth'], 'Ruth')
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
VALUES ('000396', 'Elkanah went annually to sacrifice in ...', 'Shiloh', ARRAY['Jerusalem','the temple','the tabernacle'], 2, 'fitb', ARRAY['1 Samuel'], '1 Samuel 1:3')
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
VALUES ('000397', 'But when a man sins against the Lord, who will ...', 'pray for him', ARRAY['be able to exist','still seek','then find'], 2, 'fitb', '{}', '1 Samuel 2:25')
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
VALUES ('000398', 'And I will raise up for Myself a ... priest, who will do as is in My heart and in My soul shall be', 'faithful', ARRAY['man','prophet','son'], 2, 'fitb', ARRAY['Isaiah'], '1 Samuel 2:35')
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
VALUES ('000399', 'Saul became jealous of David because he ...', 'received more praise', ARRAY['had more wealth','had more friends','possessed more land'], 2, 'fitb', ARRAY['1 Samuel','2 Samuel'], '1 Samuel 18')
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
VALUES ('000400', 'David became king over Israel in the city ...', 'Hebron', ARRAY['Jerusalem','Bethlehem','Jericho'], 3, 'fitb', ARRAY['1 Samuel','2 Samuel'], '2 Samuel 2')
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
VALUES ('000401', 'David brought the ark of God to ...', 'Jerusalem', ARRAY['Bethel','Hebron','Gilgal'], 2, 'mc', ARRAY['1 Samuel','2 Samuel'], '2 Samuel 6')
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
VALUES ('000402', 'The Lord sent the prophet ... to David', 'Nathan', ARRAY['Elijah','Elisha','Isaiah'], 1, 'mc', ARRAY['1 Samuel'], '2 Samuel 12:1')
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
VALUES ('000403', 'Absalom fled to ...', 'Geshur', ARRAY['Jerusalem','Rabbah','Ziklag'], 4, 'fitb', ARRAY['2 Samuel'], '2 Samuel 13:38')
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
VALUES ('000404', 'Which woman said: Keep the king?', 'the Tekoite', ARRAY['the Ammonitess','the Hittite','the Israelitess'], 5, 'fitb', ARRAY['1 Kings'], '2 Samuel')
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
VALUES ('000405', 'Who wanted to become king when David was old?', 'Adonijah', ARRAY['Solomon','Joab','Absalom'], 3, 'fitb', ARRAY['1 Samuel','2 Samuel'], '1 Kings 1')
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
VALUES ('000406', 'Grant me ... , the priest', 'Zadok', ARRAY['Nathan','Benaiah','Joiada'], 3, 'fitb', ARRAY['Exodus'], '1 Kings 1:32')
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
VALUES ('000407', 'and they have made him ride on ... of the king', 'the mule', ARRAY['the donkey','the chariot','the horse'], 3, 'fitb', ARRAY['Matthew','Christ'], '1 Kings 1')
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
VALUES ('000408', 'I go in the way of all the earth; so you are strong and become ...', 'a man', ARRAY['brave','a watchman','God-fearing'], 4, 'fitb', ARRAY['Deuteronomy'], '1 Kings 2:2')
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
VALUES ('000409', 'Apply your ... so that you do not let her gray hair descend with peace into the grave', 'wisdom', ARRAY['word','understanding','wealth'], 3, 'fitb', ARRAY['Ecclesiastes'], '1 Kings 2:6')
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
VALUES ('000410', 'The king of Israel in time of Elisha was ...', 'Joram', ARRAY['Ahab','Solomon','David'], 4, 'fitb', ARRAY['1 Kings','2 Kings'], '2 Kings 3')
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
VALUES ('000411', 'He then said to the young men: ... him to his mother', 'bring', ARRAY['carry','lead','give'], 3, 'fitb', '{}', '2 Kings 4:27')
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
VALUES ('000412', 'When Elisha then returned to ..., there was famine in that land', 'Gilgal', ARRAY['Shunem','Baal-shalisha','Syria'], 3, 'fitb', ARRAY['1 Kings'], '2 Kings 4:38')
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
VALUES ('000413', 'His ... and ..., the rivers of Damascus, are better than all waters of Israel', 'Abana, Pharpar', ARRAY['Euphrates, Tigris','Pison, Gihon','Jordan, Nile'], 5, 'fitb', ARRAY['2 Kings'], '2 Kings 5:12')
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
VALUES ('000414', 'that the iron fell in the water, and he cried and said: Ah, my lord; for it was ...', 'heavy', ARRAY['fallen','broken','rusty'], 3, 'fitb', ARRAY['2 Kings'], '2 Kings 6:5')
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
VALUES ('000415', '1 Chronicles begins with a list of ...', 'generations', ARRAY['kings','prophets','priests'], 3, 'fitb', ARRAY['1 Chronicles'], '1 Chronicles 1')
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
VALUES ('000416', 'and his mother had called him ..., saying: For I bore him with pain', 'Jabez', ARRAY['Perez','Hezron','Etam'], 1, 'fitb', ARRAY['Genesis'], '1 Chronicles 4:9')
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
VALUES ('000417', 'And in days of Saul they fought against the ... ; who fell by their hand', 'Hagarites', ARRAY['Gadites','Reubenites','Hivites'], 5, 'fitb', ARRAY['1 Samuel'], '1 Chronicles 5:10')
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
VALUES ('000418', 'Aaron now and his sons burned offerings on the altar of ... and on the incense altar', 'burnt offerings', ARRAY['grain offerings','sin offerings','thanksgiving offerings'], 3, 'fitb', ARRAY['Exodus'], '1 Chronicles 6:49')
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
VALUES ('000419', 'So Saul and his ... died', 'three', ARRAY['two','four','five'], 4, 'fitb', ARRAY['1 Samuel'], '1 Chronicles 10:13')
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
VALUES ('000420', 'Solomon built a temple in Jerusalem on the mountain ...', 'Moria', ARRAY['Sinai','Carmel','Zion'], 3, 'fitb', ARRAY['1 Kings','2 Chronicles'], '2 Chronicles 3:1')
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
VALUES ('000421', 'The king who restored the temple was ...', 'Josiah', ARRAY['David','Solomon','Ahaz'], 3, 'fitb', ARRAY['1 Chronicles','2 Chronicles'], '2 Chronicles 34')
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
VALUES ('000422', 'and he called the name of judge ... and of the left Boaz', 'Jachin', ARRAY['Joachin','Jacob','Jehozadak'], 2, 'fitb', ARRAY['Ruth'], '2 Chronicles 3:17')
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
VALUES ('000423', 'And they brought for Solomon ... from Egypt and from all those lands', 'horses', ARRAY['gold','silver','camels'], 3, 'fitb', ARRAY['1 Kings'], '2 Chronicles 1:17')
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
VALUES ('000424', 'And Solomon reigned in Jerusalem over all Israel ... years', '40', ARRAY['30','34','45'], 1, 'fitb', ARRAY['1 Kings'], '2 Chronicles')
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
VALUES ('000425', 'The return of the exiles began under king ...', 'Cyrus', ARRAY['Darius','Nebuchadnezzar','Xerxes'], 2, 'fitb', ARRAY['Ezra'], 'Ezra')
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
VALUES ('000426', 'Ezra led the return of the Israelites to ...', 'Jerusalem', ARRAY['Egypt','Babylon','Moab'], 2, 'fitb', ARRAY['Ezra'], 'Ezra')
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
VALUES ('000427', 'And they set up the Levites from ... years old and above to take oversight over work of Lord''s house', '18', ARRAY['20','22','25'], 3, 'fitb', ARRAY['Exodus'], 'Ezra 3:8')
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
VALUES ('000428', 'The letter which you have fitted for us, is ... for me to read', 'profitable', ARRAY['unprofitable','good','readable'], 3, 'fitb', ARRAY['Philemon'], 'Ezra 4:18')
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
VALUES ('000429', 'Now when I fast at the river ...', 'Ahava', ARRAY['Tigris','Euphrates','Pison'], 5, 'fitb', ARRAY['Ezra'], 'Ezra 8:21')
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
VALUES ('000430', 'I now was ... of the king', 'cupbearer', ARRAY['baker','priest','prophet'], 2, 'fitb', '{}', 'Nehemiah 1:11')
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
VALUES ('000431', 'The walls of Jerusalem were rebuilt in ... days', '52', ARRAY['42','30','70'], 1, 'fitb', ARRAY['Ezra','Nehemiah'], 'Nehemiah 6:15')
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
VALUES ('000432', 'Nehemiah was concerned over the ... of the people', 'sins', ARRAY['wealth','diseases','gave'], 2, 'fitb', ARRAY['Nehemiah','Ezra'], 'Nehemiah 1: 6,7')
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
VALUES ('000433', 'Remember me, my God, for good, all that I have ... to this people', 'done for', ARRAY['done to You','done to them','done to these'], 3, 'fitb', ARRAY['Psalms'], 'Nehemiah 5:19')
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
VALUES ('000434', 'Come and let us gather together in the valleys, in the valley ...', 'Ono', ARRAY['Ela','Kison','Hinnom'], 5, 'fitb', ARRAY['Psalms'], 'Nehemiah 6:2')
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
VALUES ('000435', 'Esther was ..., beautiful and lovely in form', 'white', ARRAY['black','yellow','red'], 3, 'fitb', ARRAY['Exodus'], 'Esther 1:1')
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
VALUES ('000436', 'In the twelfth month, which is the month ..., in the tenth year of his reign', 'Tebeth', ARRAY['Nisan','Sivan','Adar'], 4, 'fitb', ARRAY['1 Kings'], 'Esther 2:16')
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
VALUES ('000437', 'Then Esther called ..., one of the king''s chamberlains', 'Hatach', ARRAY['Haman','Heber','Hanan'], 4, 'fitb', ARRAY['Esther'], 'Esther 4:5')
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
VALUES ('000438', 'With the Jews there was light and joy and ...', 'gladness', ARRAY['honor','praise','happiness'], 3, 'fitb', '{}', 'Esther 8:16')
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
VALUES ('000439', 'Among the Jews were light and gladness and ...', 'glory', ARRAY['honor','praise','happiness'], 3, 'fitb', '{}', 'Esther 8:16')
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
VALUES ('000440', 'And to him were born ... sons and three daughters', '7', ARRAY['5','8','3'], 2, 'fitb', ARRAY['Genesis'], 'Job 1:2')
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
VALUES ('000441', 'In all this Job did not sin, and charged God with nothing ...', 'unrighteous', ARRAY['wrong','evil','good'], 2, 'fitb', ARRAY['Job'], 'Job 1:22')
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
VALUES ('000442', 'For He gives pain and He ...; He wounds and His hands heal', 'binds', ARRAY['heals','creates','helps'], 3, 'fitb', ARRAY['Isaiah','Christ','Psalm'], 'Job 5:18')
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
VALUES ('000443', 'Teach me, and I will ... and will give me understanding in which I erred', 'keep silent', ARRAY['preach','go','walk'], 4, 'fitb', ARRAY['Psalms'], 'Job 6:24')
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
VALUES ('000444', 'Then answered ..., the Shuhite, and said:', 'Bildad', ARRAY['Eliphaz','Zophar','Elihu'], 5, 'fitb', ARRAY['1 Samuel'], 'Job 25:1')
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
VALUES ('000445', 'Serves the Lord with ..., and pleases Him with thanksgiving', 'fear', ARRAY['joy','gladness','honor'], 3, 'fitb', ARRAY['Psalms'], 'Psalms 2:11')
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
VALUES ('000446', 'I lay down and slept; I was ashamed, for the Lord ... me', 'sustained', ARRAY['helped','redeemed','honored'], 3, 'fitb', ARRAY['Psalms'], 'Psalms 3:6')
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
VALUES ('000447', 'The Lord has heard my ...; the Lord will accept my prayer', 'crying', ARRAY['prayer','song','praise'], 3, 'fitb', ARRAY['Psalms'], 'Psalms 6:10')
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
VALUES ('000448', 'O Lord, our Lord, how ... is Your Name in all the earth', 'glorious', ARRAY['big','heavenly','lovely'], 2, 'fitb', ARRAY['Psalms'], 'Psalms 8:10')
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
VALUES ('000449', 'Therefore I will praise You, O Lord, among the heathen, and I will ... Your name', 'sing psalms to', ARRAY['love','bless','praise'], 2, 'fitb', ARRAY['Psalms'], 'Psalms 18:50')
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
VALUES ('000450', 'The fear of the Lord is the beginning of ...', 'wisdom', ARRAY['wisdom','joy','blessedness'], 2, 'fitb', ARRAY['Psalms','Proverbs','Ecclesiastes','Haggai'], 'Proverbs 1:7')
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
VALUES ('000451', 'Do you seek her as silver and consume her like ...', 'hidden treasures', ARRAY['wealth','possessions','gold'], 3, 'fitb', ARRAY['Proverbs'], 'Proverbs 2:4')
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
VALUES ('000452', 'Trust in the Lord with your whole heart, and lean not on your ...', 'understanding', ARRAY['heart','wealth','knowledge'], 2, 'fitb', ARRAY['Psalms','Proverbs'], 'Proverbs 3:5')
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
VALUES ('000453', 'I will instruct you in the path of ...; I will make my eyes on your ways', 'wisdom', ARRAY['good','straight','level'], 3, 'fitb', ARRAY['Proverbs'], 'Proverbs 4:11')
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
VALUES ('000454', 'Commit your ... to the Lord, and your thoughts will be established', 'works', ARRAY['way','thoughts','eyes'], 3, 'fitb', ARRAY['Psalms'], 'Proverbs 16:3')
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
VALUES ('000455', 'All has a ... time', 'destined time', ARRAY['fixed','good','set time'], 2, 'fitb', ARRAY['Ecclesiastes'], 'Ecclesiastes 3:1')
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
VALUES ('000456', 'The book of Ecclesiastes is written to ...', 'Solomon', ARRAY['David','Moses','Isaiah'], 1, 'fitb', ARRAY['Ecclesiastes'], 'Ecclesiastes 1:1')
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
VALUES ('000457', 'And it has neither seen ... nor known it; it has more rest than he', 'sun', ARRAY['moon','stars','waters'], 3, 'fitb', ARRAY['Ecclesiastes'], 'Ecclesiastes 6:5')
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
VALUES ('000458', 'and who breaks a ... through will be caught by him', 'hedge', ARRAY['lizard','mouse','weasel'], 2, 'fitb', ARRAY['Proverbs'], 'Proverbs 10:8')
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
VALUES ('000459', 'and much reading is wearing out of ...', 'flesh', ARRAY['understanding','eyes','vision'], 2, 'fitb', ARRAY['Proverbs'], 'Proverbs 12:12')
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
VALUES ('000460', 'Draw me, we will ...', 'open up', ARRAY['find','approach','seek'], 2, 'fitb', ARRAY['Haggai'], 'Haggai 1:4')
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
VALUES ('000461', 'The bars of our houses are ...', 'cedars', ARRAY['oaks','from olive wood','from acacia wood'], 3, 'fitb', ARRAY['Psalms','Proverbs'], 'Haggai 1:17')
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
VALUES ('000462', 'For behold, the ... is past', 'winter', ARRAY['summer','spring','autumn'], 1, 'fitb', '{}', 'Haggai 2:11')
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
VALUES ('000463', 'When I knew it, I set My soul on the ... of My people', 'violent', ARRAY['gentle','loving','restless'], 3, 'fitb', ARRAY['Isaiah'], 'Haggai 6:12')
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
VALUES ('000464', 'Solomon had a daughter in ...', 'Baal-Hamon', ARRAY['Hamon','Baal-Gad','Jeroboam-Baal'], 5, 'fitb', ARRAY['1 Kings','2 Chronicles'], 'Haggai 8:11')
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
VALUES ('000465', 'The ... will be gathered again, even to the God of heaven', 'Jacob''s', ARRAY['Isaiah''s','Abraham''s','David''s'], 4, 'fitb', ARRAY['Isaiah'], 'Isaiah 10:21')
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
VALUES ('000466', 'The ... and the ... shall come together', 'cow, bear', ARRAY['lion','wolf','sheep'], 3, 'fitb', ARRAY['Genesis'], 'Isaiah 11:7')
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
VALUES ('000467', 'Praising the Lord, for He has done ... things', 'glorious', ARRAY['good','Godly'], 3, 'fitb', ARRAY['Psalms'], 'Isaiah 12:5')
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
VALUES ('000468', 'and the prophet Isaiah, the son of ..., came to him', 'Amoz', ARRAY['Hezekiah','Ahab','Judah'], 3, 'fitb', ARRAY['Isaiah'], 'Isaiah 38:1')
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
VALUES ('000469', 'O Zion, you who ... of good news', 'bring forth', ARRAY['hear','proclaim','publish'], 3, 'fitb', ARRAY['Psalms'], 'Isaiah 40:9')
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
VALUES ('000470', 'And I said: Ah, Lord God, behold, I cannot speak, for I am ...', 'young', ARRAY['old','experienced','ashamed'], 3, 'fitb', ARRAY['Isaiah'], 'Jeremiah 1:6')
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
VALUES ('000471', 'for I am with you, to ... to the Lord', 'plead', ARRAY['help','support','listen'], 3, 'fitb', '{}', 'Jeremiah 1:8')
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
VALUES ('000472', 'He will bring to them a ... who will be strong for them', 'wind', ARRAY['storm','rain','overflow'], 3, 'fitb', '{}', 'Jeremiah 4:12')
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
VALUES ('000473', 'See, you trust on ... which do no good', 'false words', ARRAY['gold','thoughts','teachers'], 4, 'fitb', ARRAY['Isaiah'], 'Jeremiah 7:8')
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
VALUES ('000474', 'You set my ... to the days of sorrows', 'remembrance', ARRAY['fear','despair','grief'], 3, 'fitb', ARRAY['Psalms'], 'Jeremiah 17:17')
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
VALUES ('000475', 'My soul is weary of ... and bows down within me', 'life', ARRAY['living','grief','distress'], 3, 'fitb', ARRAY['Psalms'], 'Klaagliederen 3:20')
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
VALUES ('000476', 'Is it ... of the Lord, that we have not been destroyed?', 'kindnesses', ARRAY['goodnesses','righteousnesses','mercies'], 3, 'fitb', ARRAY['Romans'], 'Klaagliederen 3:22')
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
VALUES ('000477', 'They are all ... tomorrow, Your love is great', 'new', ARRAY['goodness','faith','loving'], 3, 'fitb', ARRAY['Psalms'], 'Klaagliederen 3:23')
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
VALUES ('000478', 'For he plots and deceives people children not ...', 'from heart', ARRAY['with lust','with malice','in eternity'], 3, 'fitb', ARRAY['Job'], 'Klaagliederen 3:33')
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
VALUES ('000479', 'You have already seen ..., all their thoughts against me', 'all', ARRAY['their evil','their sins','their plotting'], 4, 'fitb', ARRAY['Jeremiah'], 'Klaagliederen 3:60')
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
VALUES ('000480', 'And when I opened my mouth, and He gave me that role to ...', 'eat', ARRAY['listen','observe','see'], 3, 'fitb', ARRAY['Revelation'], 'Ezekiel 3:2')
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
VALUES ('000481', 'Men, set your face against the ...', 'Israel''s mountains', ARRAY['Cherubim','around Jerusalem','Zions'], 3, 'fitb', ARRAY['Ezekiel'], 'Ezekiel 6:2')
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
VALUES ('000482', 'And He said to me: Man, go now and walk in ...', 'wilderness', ARRAY['earth','mountains','river'], 3, 'fitb', ARRAY['Ezekiel'], 'Ezekiel 8:8')
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
VALUES ('000483', 'And the inhabited places shall be ...', 'ruins', ARRAY['destroyed','abandoned','overthrown'], 3, 'fitb', ARRAY['Isaiah'], 'Ezekiel 12:20')
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
VALUES ('000484', 'But Noah, Daniel and ... were in the middle of it themselves', 'Job', ARRAY['Amos','Jonah','David'], 4, 'fitb', ARRAY['Daniel'], 'Ezekiel 14:20')
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
VALUES ('000485', 'and that men subdued them in the speech of the ...', 'Chaldeans', ARRAY['Babylonians','Persians','Egyptians'], 2, 'fitb', ARRAY['Exodus'], 'Daniel 1:4')
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
VALUES ('000486', 'and Daniel named him ...', 'Belteshazzar', ARRAY['Shadrach','Meshach','Abed-nego'], 1, 'fitb', ARRAY['Daniel'], 'Daniel 1:7')
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
VALUES ('000487', 'Yet be patient, ..., your kingdom is divided', '10 days', ARRAY['6 days','7 days','14 days'], 2, 'fitb', ARRAY['Genesis'], 'Daniel 1:12')
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
VALUES ('000488', 'Then Daniel entered until ..., of the king who had set up the wise men of Babylon to bring us to eat and drink', 'Arioch', ARRAY['Melzar','Shadrach','Ari-el'], 2, 'fitb', ARRAY['Daniel'], 'Daniel 2:24')
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
VALUES ('000489', '... , your kingdom is divided', 'Medes', ARRAY['Persians','Greeks','Tekei'], 2, 'fitb', ARRAY['1 Kings','2 Samuel'], 'Daniel 5:28')
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
VALUES ('000490', 'and in the days of ..., son of Joash, king of Israel', 'Jeroboam', ARRAY['Jotham','Ahaz','Hezekiah'], 5, 'fitb', ARRAY['1 Kings','2 Kings','1 Chronicles','2 Chronicles'], 'Hosea 1:1')
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
VALUES ('000491', 'Is not his name ...; for you have not been My people', 'Lo-Ruhamah', ARRAY['Lo-Ruchamah','Lizreel','Gomer'], 5, 'fitb', ARRAY['Jeremiah'], 'Hosea 1:9')
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
VALUES ('000492', 'Ephraim is ..., let him go and become a ...', 'godless', ARRAY['brother','priest','prophet'], 3, 'fitb', ARRAY['Genesis'], 'Hosea 4:17')
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
VALUES ('000493', 'Come and let us ... to the Lord', 'return', ARRAY['repent','observe','pray'], 3, 'fitb', ARRAY['Psalms'], 'Hosea 6:1')
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
VALUES ('000494', 'Who is ...? Who understands these things', 'wise', ARRAY['understanding','right','insightful'], 3, 'fitb', ARRAY['John'], 'Hosea 14:10')
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
VALUES ('000495', 'The word of the Lord that has gone forth to ...', 'Joel', ARRAY['Pethuel','Jeremiah','Jonah'], 4, 'fitb', ARRAY['Numbers'], 'Joel 1:1')
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
VALUES ('000496', 'Consecrate the ... to Zion', 'Sion', ARRAY['Jerusalem','Bethlehem','Jericho'], 1, 'fitb', ARRAY['Numbers'], 'Joel 2:1')
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
VALUES ('000497', 'Fear not, O land; be ... and be glad', 'joyful', ARRAY['peaceful','thankful','happy'], 3, 'fitb', ARRAY['Isaiah'], 'Joel 2:21')
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
VALUES ('000498', 'Who is ... who calls you?', 'He', ARRAY['Heavenly Father','Holy Spirit','Lord God'], 3, 'fitb', ARRAY['John'], 'Joel 2:32')
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
VALUES ('000499', 'and everyone who calls on the name of the Lord shall be ...', 'saved', ARRAY['blessed','redeemed','forgiven'], 3, 'fitb', ARRAY['Romans'], 'Joel 2:32')
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
VALUES ('000499', 'And ... shall become a wilderness and desolation', 'Egypt', ARRAY['Judah','Edom','Jerusalem'], 4, 'fitb', ARRAY['Jeremiah'], 'Ezekiel 29:9')
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
VALUES ('000500', 'that when that field is called in their own language ..., that is a field of blood', 'Abel', ARRAY['Cain','Achad','Abeldam'], 2, 'fitb', ARRAY['Genesis'], 'Acts 1:19')
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
VALUES ('000501', 'Who is the father of Joseph, the man of Mary (Jesus'' mother)?', 'Jacob', ARRAY['Eliud','Mattan','Eleazar'], 4, 'mc', ARRAY['Matthew'], 'Matthew 1:16')
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
VALUES ('000502', 'How many days and nights did Jesus fast in the wilderness?', '40', ARRAY['7','10','30'], 1, 'mc', '{}', 'Matthew 4:2')
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
VALUES ('000503', 'Jesus says the salt of the earth has lost its ... What does Jesus say happens to it?', 'It is thrown out and trampled by people', ARRAY['It is blessed and salted','It becomes purified','Its taste changes pleasantly'], 2, 'mc', ARRAY['Matthew'], 'Matthew 5:13')
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
VALUES ('000504', 'What is the first beatitude in the Sermon on the Mount?', 'Blessed are the poor in spirit', ARRAY['Blessed are those who mourn','Blessed are the meek','Blessed are the pure in heart'], 3, 'mc', ARRAY['Matthew'], 'Matthew 5:3')
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
VALUES ('000505', 'What does Jesus do first after coming down from the mountain?', 'He heals a leper', ARRAY['He teaches in the synagogue','He goes again to preach','He calls a disciple'], 4, 'mc', ARRAY['Matthew','Luke','Christ'], 'Matthew 8:1')
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
VALUES ('000506', 'Which disciple walked on the water to Jesus?', 'Peter', ARRAY['John','Thomas','Judas'], 1, 'mc', '{}', 'Matthew 14: 28,29')
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
VALUES ('000507', 'Who asked Jesus if He is the Christ, the Son of God?', 'Caiaphas', ARRAY['Judas','Pilatus','Herod'], 4, 'mc', ARRAY['John'], 'Matthew 26:63')
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
VALUES ('000508', 'What happened when Jesus was baptized?', 'The heavens were opened', ARRAY['The earth shook','The sun darkened','An angel descended'], 2, 'mc', ARRAY['Matthew','Christ'], 'Matthew 3:16')
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
VALUES ('000509', 'Who was the first disciple Jesus called?', 'Peter', ARRAY['John','Jacobus','Andrew'], 2, 'mc', '{}', 'Matthew 4:18')
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
VALUES ('000510', 'What did Jesus say to them when he walked on water to the disciples?', 'I am, do not be afraid', ARRAY['Do not be afraid, I am','Walk to me','I am the Way, do not be afraid'], 3, 'mc', ARRAY['Matthew','Luke'], 'Matthew 14:27')
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
VALUES ('000511', 'For how many silver pieces was Jesus betrayed?', '30', ARRAY['20','40','10'], 1, 'mc', '{}', 'Matthew 26:15')
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
VALUES ('000512', 'Who said to Jesus: You are the King of the Jews?', 'Pilate', ARRAY['Caiphas','Herod','The High Priest'], 3, 'mc', ARRAY['Matthew'], 'Matthew 27: 51, 52')
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
VALUES ('000513', 'What happened after Jesus was dead for 3 hours?', 'The rocks split and the earth shook', ARRAY['The earth was darkened for 3 hours','The temple curtain was torn in two','An angel descended'], 4, 'mc', ARRAY['Matthew'], 'Matthew 27: 51, 52')
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
VALUES ('000514', 'Who said: I have suffered much in a dream to do Your will?', 'Pilate''s wife', ARRAY['The wife of Caiaphas','The wife of Herod','The wife of Judas'], 4, 'mc', ARRAY['Genesis'], 'Matthew 27:19')
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
VALUES ('000515', 'Who found (saw) the empty tomb?', 'Mary Magdalene and the other Mary', ARRAY['Mary, mother of Jesus','Peter and John','Peter and James'], 2, 'mc', ARRAY['Revelation'], 'Matthew 28:1')
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
VALUES ('000516', 'What said the angel first to the women at the tomb?', 'Do not be afraid', ARRAY['He is risen','He is not here; He has risen','He goes ahead quickly'], 3, 'mc', ARRAY['Revelation'], 'Matthew 28:5')
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
VALUES ('000517', 'What did Jesus give to his disciples after His resurrection?', 'A command', ARRAY['The Holy Spirit','A blessing','A promise'], 2, 'mc', ARRAY['Acts','Easter','Pentecost'], 'Matthew 28:19')
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
VALUES ('000518', 'Who was the fourth son of Jacob?', 'Judah', ARRAY['Levi','Dan','Naphtali'], 2, 'mc', ARRAY['Genesis'], 'Genesis 29:35')
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
VALUES ('000519', 'What was the color of the second lamb in Revelation?', 'Red', ARRAY['White','Black','Fawn'], 4, 'mc', ARRAY['Revelation'], 'Revelation 6:4')
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
VALUES ('000520', 'Which disciple was not on the mountain of transfiguration?', 'Andreas', ARRAY['Peter','John','Jacobus'], 1, 'mc', ARRAY['Matthew','Mark','Luke'], 'Luke 9:28')
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
VALUES ('000521', 'How many people went into the ark of Noah?', '8', ARRAY['6','4','10'], 1, 'mc', ARRAY['Genesis'], 'Genesis 8:16')
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
VALUES ('000522', 'Who was not a son of Noah?', 'Gomer', ARRAY['Sem','Ham','Japheth'], 1, 'mc', ARRAY['Genesis'], 'Genesis 9:18')
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
VALUES ('000523', 'From whom was Dan a son?', 'Bilhah', ARRAY['Rachel','Leah','Zilpah'], 4, 'mc', ARRAY['Genesis'], 'Genesis 30:5')
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
VALUES ('000524', 'Who was fourth daughter of Zelophehad?', 'Milcah', ARRAY['Naah','Hoglah','Tirzah'], 4, 'mc', ARRAY['Numbers'], 'Numbers 27:1')
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
VALUES ('000525', 'Who spoke for Job?', 'Elihu', ARRAY['Bildad','Zophar','Elifaz'], 3, 'mc', ARRAY['Job'], 'Job 32:2')
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
VALUES ('000526', 'Which king fell by a falsehood in his territory?', 'Ahabaziah', ARRAY['Joram','Azariah','Jotham'], 4, 'mc', ARRAY['1 Kings'], '2 Kings 1:2')
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
VALUES ('000527', 'Who was mother of Absalom?', 'Maacah', ARRAY['Haggith','Ahinoam','Abigail'], 4, 'mc', ARRAY['2 Samuel'], '2 Samuel 3:3')
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
VALUES ('000528', 'What was the final plague in Egypt?', 'Hail and darkness', ARRAY['Locusts and flies','Lice and boils','Frost and thunder'], 1, 'mc', ARRAY['Exodus'], 'Exodus 9:24')
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
VALUES ('000529', 'Who was queen mother of King Hezekiah?', 'Hephzibah', ARRAY['Jehosheba','Abi','Michal'], 3, 'mc', ARRAY['1 Kings','2 Kings'], 'Isaiah 36:3')
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
VALUES ('000530', 'How many sons had Gideon?', '70', ARRAY['30','50','60'], 3, 'mc', ARRAY['Judges'], 'Judges 8:30')
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
VALUES ('000531', 'Which judge was left-handed?', 'Ehud', ARRAY['Jephthah','Shamgar','Othniel'], 3, 'mc', ARRAY['Judges'], 'Judges 3:15')
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
VALUES ('000532', 'Where was tabernacle of gold made?', 'Gold', ARRAY['Silver','Bronze','Iron'], 1, 'mc', ARRAY['Exodus'], 'Exodus 25:31')
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
VALUES ('000533', 'Who was third son of Aaron?', 'Eleazar', ARRAY['Nadab','Abihu','Ithamar'], 5, 'mc', ARRAY['Leviticus'], 'Exodus 6:22')
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
VALUES ('000534', 'Which community did John write a letter to? John wrote a letter.', 'Philadelphian', ARRAY['Smyrna','Pergamum','Laodicea'], 4, 'mc', ARRAY['Acts','Revelation','John'], 'Revelation 3:7')
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
VALUES ('000535', 'Where was no woman of Esau?', 'Zilpah', ARRAY['Ada','Aholibamah','Basemath'], 3, 'mc', ARRAY['Genesis'], 'Genesis 36: 2,3')
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
VALUES ('000536', 'Who was fourth son of Abraham and Keturah?', 'Midian', ARRAY['Ishbak','Medan','Shuah'], 5, 'mc', ARRAY['Genesis'], 'Genesis 25:2')
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
VALUES ('000537', 'Who plotted to release Joseph from the pit?', 'Reuben', ARRAY['Simeon','Judah','Levi'], 2, 'mc', ARRAY['Genesis'], 'Genesis 37:29')
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
VALUES ('000538', 'Who stood before Benjamin when they were at Jacob?', 'Judah', ARRAY['Simeon','Reuben','Naftali'], 1, 'mc', ARRAY['Genesis'], 'Genesis 43:8-9')
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
VALUES ('000539', 'Which son of Jacob will dwell at the havens of the sea?', 'Zebulon', ARRAY['Reuben','Gad','Asher'], 4, 'mc', ARRAY['Genesis'], 'Genesis 49:13')
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
VALUES ('000540', 'Which prophet preached a funeral lamentation?', 'Joel', ARRAY['Hosea','Micah','Nahum'], 4, 'mc', ARRAY['Jonah'], NULL)
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
VALUES ('000541', 'Who was the father of Abram?', 'Terah', ARRAY['Haran','Nahor','Serug'], 2, 'mc', ARRAY['Genesis'], 'Genesis 11:26')
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
VALUES ('000542', 'How many shekels of silver did Abraham pay to Ephron for Sarah''s grave?', '400', ARRAY['200','500','600'], 4, 'mc', ARRAY['Genesis'], 'Genesis 23:16')
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
VALUES ('000543', 'How old was Abraham when he died?', '175', ARRAY['150','155','180'], 2, 'mc', ARRAY['Genesis'], 'Genesis 25:7')
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
VALUES ('000544', 'Who stayed with Joseph in Egypt?', 'Simeon', ARRAY['Ruben','Judah','Zebulun'], 2, 'mc', ARRAY['Genesis'], 'Genesis 42:24')
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
VALUES ('000545', 'Who was firstborn son of Reuben?', 'Hanoch', ARRAY['Pallu','Hezron','Charmi'], 4, 'mc', ARRAY['Genesis'], 'Genesis 46:9')
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
VALUES ('000546', 'Jacob was deceived, how many days?', '40', ARRAY['20','30','60'], 3, 'mc', ARRAY['Genesis'], 'Genesis 50:3')
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
VALUES ('000547', 'How many days was Jacob mourned at the Jordan?', '7', ARRAY['3','5','10'], 3, 'mc', ARRAY['Genesis'], 'Genesis 50:10')
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
VALUES ('000548', 'How long did Joseph live?', '110', ARRAY['120','130','150'], 2, 'mc', ARRAY['Genesis'], 'Genesis 50:26')
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
VALUES ('000549', 'What was the second plague in Egypt?', 'Frogs', ARRAY['Lice','Locusts and boils'], 2, 'mc', ARRAY['Exodus'], 'Exodus 8:16')
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
VALUES ('000550', 'How many days was there second plague in Egypt?', '2', ARRAY['3','4','6'], 1, 'mc', ARRAY['Exodus'], 'Exodus 10:22')
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
VALUES ('000551', 'Which day is a feast?', '5', ARRAY['2','3','6'], 1, 'mc', ARRAY['Exodus','Deuteronomy'], 'Exodus 20:12')
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
VALUES ('000552', 'On which rows of the breastplate of Aaron were a ruby, an onyx and an amethyst?', '3', ARRAY['1','2','4'], 1, 'mc', ARRAY['Exodus'], 'Exodus 28:19')
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
VALUES ('000553', 'Isaiah was a prophet in the kingdom of Judah', 'True', ARRAY['Not true'], 4, 'tf', ARRAY['Isaiah'], 'Isaiah 1:1')
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
VALUES ('000554', 'Isaiah had visions of the Lord, standing for angels and new ... and new earth', 'Not true', ARRAY['True'], 4, 'tf', ARRAY['Isaiah'], 'Isaiah 6:1')
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
VALUES ('000555', 'Isaiah was a contemporary of King Saul', 'Not true', ARRAY['True'], 3, 'tf', ARRAY['Isaiah'], 'Isaiah 1:1')
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
VALUES ('000556', 'Isaiah prophesied about new heavens and new ...', 'Not true', ARRAY['True'], 3, 'tf', ARRAY['Isaiah'], 'Isaiah 65:17')
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
VALUES ('000557', 'Jeremiah was a prophet in the kingdom of Judah', 'True', ARRAY['Not true'], 4, 'tf', ARRAY['Jeremiah'], 'Jeremiah 1:1')
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
VALUES ('000558', 'Jeremiah prophesied only during the reign of King David', 'Not true', ARRAY['True'], 3, 'tf', ARRAY['Jeremiah'], 'Jeremiah 1:3')
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
VALUES ('000559', 'Pashur took Jeremiah captive', 'True', ARRAY['Not true'], 4, 'mc', ARRAY['Jeremiah'], 'Jeremiah 20:2')
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
VALUES ('000560', 'Jeremiah writes in his letter: Dan has made an end to ... and will not hear to me, and I will pray to you but you will not listen', 'Not true', ARRAY['True'], 3, 'tf', ARRAY['Jeremiah'], 'Jeremiah 29:12')
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
VALUES ('000561', 'Ezekiel was a prophet in Babylon?', 'Not true', ARRAY['True'], 3, 'tf', ARRAY['Ezekiel'], 'Ezekiel 1:1-3')
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
VALUES ('000562', 'Ezekiel became a watchman for Israel ... days', '7', ARRAY['3','14','30'], 2, 'mc', ARRAY['Ezekiel'], 'Ezekiel 3:15')
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
VALUES ('000563', 'Ezekiel prophesied about new heavens and new ...', 'Not true', ARRAY['True'], 3, 'tf', ARRAY['Ezekiel'], 'Ezekiel 32:1')
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
VALUES ('000564', 'Daniel wrote in a dream: ''You shall fast ... days''', '21', ARRAY['3','7','40'], 2, 'mc', ARRAY['Daniel'], 'Daniel 10:2-3')
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
VALUES ('000565', 'Ezekiel prophesied about 430 years of Jerusalem''s ...', 'Not true', ARRAY['True'], 2, 'tf', ARRAY['Ezekiel'], 'Ezekiel 29')
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
VALUES ('000566', 'God made a promise to Abraham in ... BC', '2000', ARRAY['1500','1800','2500'], 2, 'mc', ARRAY['Genesis'], 'Genesis 12:4')
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
VALUES ('000567', 'Which prophet was in Babylon when God spoke to Daniel?', 'Jeremiah', ARRAY['Isaiah','Ezekiel','Daniel himself'], 4, 'mc', ARRAY['Daniel'], 'Daniel 9:2')
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
VALUES ('000568', 'The book of Daniel ends with these words: ''But you, go your way, for the words are ... up to the time of the end.''', 'sealed', ARRAY['closed','open','broken'], 3, 'mc', ARRAY['Daniel'], 'Daniel 12:9')
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
VALUES ('000569', 'The book of Daniel was written in ... languages', '2', ARRAY['1','3','4'], 4, 'mc', ARRAY['Daniel'], 'Daniel')
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
VALUES ('000570', 'The letter to the Romans is Paul''s ... letter', 'Not true', ARRAY['True'], 3, 'tf', ARRAY['Romans'], 'Romans 16')
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
VALUES ('000571', 'Paul speaks about the new life through the Holy ...', 'Not true', ARRAY['True'], 3, 'tf', ARRAY['Romans','1 Corinthians','2 Corinthians','Galatians','Ephesians','Colossians','1 Thessalonians','2 Thessalonians'], 'Romans 8')
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
VALUES ('000572', 'Paul wrote the letter to the Galatians because of their ... to the gospel', 'Not true', ARRAY['True'], 4, 'tf', ARRAY['Galatians'], 'Galatians 1: 6,7')
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
VALUES ('000573', 'The Galatians are ... to make the ... of Christ perfect and to fulfill the law', 'Not true', ARRAY['True'], 3, 'tf', ARRAY['Galatians'], 'Galatians 6:2')
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
VALUES ('000574', 'Paul speaks in the letter to the Ephesians about the ... of Christ', 'Not true', ARRAY['True'], 3, 'tf', ARRAY['Ephesians'], 'Ephesians 3: 17-19')
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
VALUES ('000575', 'Paul writes in Philippians: I can do all things through ... who gives me strength', 'Not true', ARRAY['True'], 3, 'tf', ARRAY['Philippians'], 'Philippians 4:13')
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
VALUES ('000576', 'Paul warns in Colossians against ... teachings', 'Not true', ARRAY['True'], 3, 'tf', ARRAY['Colossians'], 'Colossians 2:8')
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
VALUES ('000577', 'Paul wrote Colossians while he was in ...', 'Not true', ARRAY['True'], 4, 'tf', ARRAY['Colossians'], 'Colossians 4:10')
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
VALUES ('000578', 'Paul speaks in the letter to the Ephesians about the ... of Christ', 'Not true', ARRAY['True'], 3, 'tf', ARRAY['Ephesians'], 'Ephesians 3: 17-19')
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
VALUES ('000579', 'Paul wrote the letter to the ... on the love of Christ', 'Not true', ARRAY['True'], 3, 'tf', ARRAY['Ephesians'], 'Ephesians 3: 17-19')
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
VALUES ('000580', 'And he said to ...: which of these times should you we know? You, me, the Lord do not keep one hour with us.', 'Peter', ARRAY['Johannes','Jakobus','Matthéüs'], 2, 'fitb', '{}', 'Matthew 26:40')
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
VALUES ('000581', 'And so is it ...: The Lord is ... of the Lord.', 'forever', ARRAY['thanked','blessed','praised'], 3, 'fitb', '{}', '1 Chronicles 16:36')
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
VALUES ('000582', 'In which book is David''s psalm preserved?', '1 Chronicles', ARRAY['1 Kings','2 Kings','2 Chronicles'], 5, 'mc', '{}', '1 Chronicles 16: 7-36')
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
VALUES ('000583', 'Which apostle: You have the words of eternal life?', 'Peter', ARRAY['Andreans','Johannes','Jakobus'], 4, 'mc', '{}', 'John 6:68')
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
VALUES ('000584', 'Which disciple: Do not know where we will go?', 'Thomas', ARRAY['Johannes','Petrus','Jakobus'], 1, 'mc', '{}', 'John 11:16')
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
VALUES ('000585', 'Which disciple: He, we know not where we are going?', 'Thomas', ARRAY['Lukas','Andreans','Johannes'], 4, 'mc', '{}', 'John 14:5')
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
VALUES ('000586', 'Which disciple: He, the Father, to You is named?', 'Philip', ARRAY['Johannes','Petrus','Andréas'], 3, 'mc', '{}', 'John 14:8')
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
VALUES ('000587', 'Which port in Jerusalem is a healing well?', 'The Sheep Gate', ARRAY['The Fish Gate','The Golden Gate','The Water Gate'], 3, 'mc', '{}', 'John 5:2')
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
VALUES ('000588', 'How many men had the Samaritan woman''s husbands?', 'Five', ARRAY['Two','Seven','Three'], 3, 'mc', '{}', 'John 4:18')
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
VALUES ('000589', 'Which well in Samaria did Jesus speak to a woman?', 'Jacob''s Well', ARRAY['The King''s Well','The Prophet''s Well','Abraham''s Well'], 2, 'mc', '{}', 'John 4:6')
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
VALUES ('000590', 'Which well is in Sychar, where Jesus met a Samaritan woman?', 'Jacob''s Well', ARRAY['Abraham''s Well','David''s Well','The King''s Well'], 3, 'mc', '{}', 'John 4:6')
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
VALUES ('000591', 'What was the 2nd miraculous sign Jesus performed in Cana?', 'The Lost Coin Healing', ARRAY['Turning Water to Wine','Healing the Official''s Son','Feeding the 5000'], 3, 'mc', '{}', 'John 4:46-54')
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
VALUES ('000592', 'Which pool in Jerusalem had five porches?', 'Bethesda', ARRAY['Siloam','Hezekiah''s Pool','The Upper Pool'], 4, 'mc', '{}', 'John 5:2')
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
VALUES ('000593', 'How long were the disciples in the upper room?', 'Ten days', ARRAY['Three days','Seven days','Forty days'], 2, 'mc', '{}', 'Acts 1:13')
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
VALUES ('000594', 'Which gate is a healing well in Jerusalem?', 'The Sheep Gate', ARRAY['The Golden Gate','The Water Gate','The Fish Gate'], 3, 'mc', '{}', 'Acts 3:2')
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
VALUES ('000595', 'Who was the Samaritan woman''s first husband?', 'Five', ARRAY['Two','Seven','Three'], 3, 'mc', '{}', 'Luke 16:18')
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
VALUES ('000596', 'Which gate in Jerusalem is a healing well?', 'The Sheep Gate', ARRAY['The Golden Gate','The Water Gate','The Fish Gate'], 3, 'mc', '{}', 'Acts 3:2')
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
VALUES ('000597', 'How many days did the feast of Dedication (Hanukkah) last?', 'Two', ARRAY['Three','Five','Seven'], 1, 'mc', '{}', 'Matthew 4:9')
ON CONFLICT (id) DO UPDATE SET
    question = EXCLUDED.question,
    correct_answer = EXCLUDED.correct_answer,
    incorrect_answers = EXCLUDED.incorrect_answers,
    difficulty = EXCLUDED.difficulty,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

-- Total questions processed: 598