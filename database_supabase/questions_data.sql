-- SQL INSERT statements for nl questions table
-- Generated from questions-nl-sv.json
-- Generated on: 1763806680.095157

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000001', 'Hoeveel Bijbelboeken heeft het Nieuwe Testament?', '27', ARRAY['26','66','39'], 3, 'mc', '{}', NULL)
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000002', 'Hoe noemde Hanna haar kind?', 'Samuël', ARRAY['Saul','Simson','Gideon'], 1, 'mc', '{}', '1 Samuël 1:20')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000003', 'Wie was verantwoordelijk voor de kindermoord in Bethlehem, vlak na de geboorte van de Jezus?', 'Herodes', ARRAY['Pilatus','De Hogepriester','Quirinius'], 1, 'mc', ARRAY['Matteüs'], 'Mattheüs 1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000004', 'Jezus genas de schoonmoeder van Petrus. Wat mankeerde haar?', 'Koorts', ARRAY['Verlamming','Blind aan een oog','Bloedvloeiingen'], 4, 'mc', '{}', 'Markus 1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000005', 'Welke belofte krijgen de zachtmoedigen van de Heere Jezus in de zaligsprekingen?', 'Zij zullen het aardrijk beërven', ARRAY['Voor hen is het Koninkrijk der hemelen','Zij zullen kinderen van God genoemd worden','Zij zullen God zien'], 3, 'mc', ARRAY['Matteüs'], 'Mattheüs 5:5')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000006', 'Welke belofte staat na de zaligspreking ''zalig zijn de reinen van hart''?', 'zij zullen God zien', ARRAY['Voor hen is het Koninkrijk der hemelen','Zij zullen kinderen van God genoemd worden','Zij zullen het aardrijk beërven'], 3, 'mc', '{}', 'Mattheüs 5:8')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000007', 'Welke profeet mocht niet trouwen van de Heere?', 'Jeremia', ARRAY['Jesaja','Ezechiël','Hoséa'], 5, 'mc', ARRAY['Jeremia'], 'Jeremia 16:2')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000008', 'Welke profeet moest trouwen in opdracht van de Heere?', 'Hoséa', ARRAY['Jesaja','Jeremia','Ezechiël'], 5, 'mc', ARRAY['Hosea'], 'Hosea 1:2')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000009', 'Welke profeet en zijn kinderen waren een symbool voor Israël?', 'Jesaja', ARRAY['Jeremia','Ezechiël','Hoséa'], 5, 'mc', ARRAY['Jesaja'], NULL)
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000010', 'Welke profeet verloor zijn vrouw tijdens zijn tijd als profeet?', 'Ezechiël', ARRAY['Jesaja','Jeremia','Hoséa'], 5, 'mc', ARRAY['Ezechiël'], 'Ezechiël 24:16-24')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000011', 'Op de 1e dag schiep God...', 'het licht', ARRAY['de mens','de planten','de vissen'], 1, 'fitb', ARRAY['Genesis'], 'Genesis 1:4')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000012', 'Op de 2e dag kwam er scheiding tussen...', 'zee en lucht', ARRAY['zee en land','licht en duisternis','licht en land'], 1, 'fitb', ARRAY['Genesis'], 'Genesis 1:6-8')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000013', 'God rustte op de...', '7e dag', ARRAY['1e dag','5e dag','6e dag'], 1, 'fitb', ARRAY['Genesis'], 'Genesis 2:2')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000014', 'Waar stond de boom der kennis, des goeds en des kwaads?', 'In de hof van Eden', ARRAY['In de hof van Aden','Net buiten de hof van Eden','In Sinear'], 1, 'mc', ARRAY['Genesis'], 'Genesis 2 en 3')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000015', 'Wie werd door Kaïn vermoord?', 'Abel', ARRAY['Zijn moeder','Zijn vader','Ezau'], 1, 'mc', ARRAY['Genesis'], NULL)
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000016', 'Hoe oud was Methúsalah toen hij stierf?', '969', ARRAY['996','966','669'], 1, 'mc', ARRAY['Genesis'], 'Genesis 5:27')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000017', 'Hoe lang is Noach met zijn gezin in de ark?', 'Ruim een jaar', ARRAY['40 dagen','7 maanden','1,5 jaar'], 3, 'mc', ARRAY['Genesis'], 'Genesis 8')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000018', 'De top van de toren van Babel moest reiken tot ...', 'in de hemel', ARRAY['de wolken','grote hoogte','een onzichtbare hoogte'], 1, 'fitb', ARRAY['Genesis'], 'Genesis 11:4')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000019', 'Wat betekent het woord ''Babel''?', 'Verwarring', ARRAY['Grote stad','Grote toren','Verderving'], 3, 'mc', ARRAY['Genesis'], 'Genesis 11')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000020', 'Waar is Abram geboren?', 'Ur der Chaldeeën', ARRAY['Kanaän','Egypte','Sinear'], 1, 'mc', ARRAY['Genesis'], 'Genesis 11:26')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000021', 'Hoe heette de vader van Abram?', 'Terah', ARRAY['Lot','Izak','Noach'], 3, 'mc', ARRAY['Genesis'], 'Genesis 11:26')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000022', 'Waarom ging Abram naar Kanaän?', 'God vroeg het aan hem', ARRAY['Daar was werk genoeg','Er woonde al familie van hem','Daar was genoeg te eten'], 1, 'mc', ARRAY['Genesis'], 'Genesis 12')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000023', 'Wie was de vrouw van Abram?', 'Sarai', ARRAY['Rebekka','Rachel','Zilpa'], 1, 'mc', ARRAY['Genesis'], 'Genesis 11')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000024', 'Waarom gingen Abram en Sarai naar Egypte?', 'Er was hongersnood in Kanaän', ARRAY['Daar was veel geld te verdienen','Ze gingen op familiebezoek','Het was een opdracht van de Heere'], 1, 'mc', ARRAY['Genesis'], 'Genesis 12:10')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000025', 'Abram en Lot gaan terug naar Kanaän. Waar gaat Lot wonen?', 'In de Jordaanstreek', ARRAY['Aan de kust','In het gebergte','In Sodom'], 3, 'mc', ARRAY['Genesis'], 'Genesis 19')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000026', 'Sarai blijft onvruchtbaar. Wie wordt de 2e vrouw van Abram?', 'Hagar', ARRAY['Rachel','Zilpa','Bilha'], 1, 'mc', ARRAY['Genesis'], 'Genesis 16:3')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000027', 'Abram en Hagar krijgen een zoon, zijn naam is...', 'Ismaël', ARRAY['Lot','Izak','Jakob'], 1, 'fitb', ARRAY['Genesis'], 'Genesis 16:11')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000028', 'Wat deed de vrouw van Lot?', 'Ze kijkt achterom bij het verlaten van Sodom', ARRAY['Ze waarschuwt haar man Lot','Ze blijft in Sodom','Ze doet wat God van haar vraagt'], 1, 'mc', ARRAY['Genesis'], 'Genesis 19:26')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000029', 'Abraham en Sara krijgen eindelijk een zoon. Hoe oud is Abraham dan?', '100', ARRAY['80','90','120'], 3, 'mc', ARRAY['Genesis'], 'Genesis 21:5')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000030', 'Waar moet Abraham Izak offeren?', 'Op de berg Moria', ARRAY['Op de berg Sinaï','Op de berg Karmel','Op de berg Horeb'], 3, 'mc', ARRAY['Genesis'], 'Genesis 22:2')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000031', 'Met wie trouwt Izak?', 'Rebekka', ARRAY['Rachel','Bilha','Sara'], 1, 'mc', ARRAY['Genesis'], 'Genesis 24:67')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000032', 'Wie volgt Mozes op?', 'Jozua', ARRAY['Aäron','Kaleb','Elia'], 1, 'mc', ARRAY['Jozua'], 'Jozua 1:1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000033', 'Waar sloeg Mozes op de rots?', 'bij Meríba', ARRAY['bij Edom','bij Mara','bij Elim '], 3, 'mc', ARRAY['Exodus'], 'Exodus 17:7')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000034', 'Na ... is een groot gedeelte van Kanaän veroverd', '7 jaar', ARRAY['4 jaar','6 jaar','9 jaar'], 5, 'fitb', ARRAY['Jozua'], 'Jozua')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000035', 'Na het overlijden van Jozua...', 'is er geen leider meer', ARRAY['volgt zijn zoon hem op','volgt Juda hem op','volgt Eleazer hem op'], 3, 'fitb', ARRAY['Jozua'], 'Jozua 24')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000036', 'Wat was de eerste taak van Israël na de dood van Jozua?', 'Vechten tegen de overgebleven Kaänanieten', ARRAY['Het vinden van een nieuwe leider','Het volk kreeg een periode rust','Het vinden van waterbronnen'], 3, 'mc', ARRAY['Richteren'], 'Richteren 1:1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000037', 'Een lange periode na het overlijden van Jozua komt er...', 'een richter', ARRAY['een koning','een keizer','een profeet'], 3, 'fitb', ARRAY['Richteren'], 'Richteren 3:9')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000038', 'Wie was de eerste richter?', 'Othniël', ARRAY['Ehud','Samgar','Barak'], 2, 'mc', ARRAY['Genesis'], 'Richteren 3:9')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000039', 'Onder leiding van de eerste richter...', 'gaat men God weer dienen', ARRAY['gaat men de afgoden weer dienen','wordt de vijand verjaagd','wordt het volk weer opstandig'], 3, 'fitb', ARRAY['Richteren'], 'Richteren 3:9-10')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000040', 'Wie zijn de meest bekende richters?', 'Gideon, Simson en Samuël', ARRAY['Saul, David en Salómo','Jeftha, Debóra en Barak','Otniël, Ehud en Samgar'], 1, 'mc', ARRAY['Richteren'], 'Richteren')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000041', 'Met hoeveel man verjaagt Gideon een groot leger van de Midianieten?', '300 man', ARRAY['1000 man','100 man','500 man'], 3, 'mc', ARRAY['Richteren'], 'Richteren 7:6')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000042', 'Wie was de laatste richter?', 'Samuël', ARRAY['Eli','Simson','Jeftha'], 1, 'mc', ARRAY['Richteren'], '1 Samuël')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000043', 'Welk antwoord hoort er niet tussen. Simson mag ... ', 'niet trouwen', ARRAY['geen wijn of bier drinken','zijn haren niet afknippen','geen dode aanraken'], 1, 'fitb', ARRAY['Richteren'], 'Richteren 13')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000044', 'Debóra versloeg de ... ', 'Kaänanieten', ARRAY['Midianieten','Ammonieten','Filistijnen'], 5, 'fitb', ARRAY['Richteren'], 'Richteren 4')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000045', 'Verschillende richters worden geloofshelden genoemd in de Hebreeënbrief. Welke richter wordt hierin niet genoemd?', 'Debóra', ARRAY['Gideon','Simson','Samuël'], 3, 'mc', '{}', 'Hebreeën 11')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000046', 'Wie leidt het volk na Samuël?', 'Koning Saul', ARRAY['Koning David','Hogepriester Eli','Richter Simson'], 1, 'mc', '{}', '1 Samuël 10:1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000047', 'Wie is de eerste koning van Israël?', 'Saul', ARRAY['David','Salómo','Herodes'], 1, 'mc', '{}', '1 Samuël 10:1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000048', 'Saul wordt door Samuël ... ', 'gezalfd', ARRAY['gekroond','ingewijd','gedoopt'], 1, 'fitb', ARRAY['1 Samuël'], '1 Samuël 10:1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000049', 'Maar ik haat hem, omdat hij over mij niets goeds profeteert, maar kwaad. Wie zei dat?', 'Achab', ARRAY['Micha','Izebél','Baësa'], 5, 'mc', ARRAY['1 Koningen'], '1 Koningen 22:8')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000050', 'In welke tijd speelt de geschiedenis van Ruth zich af?', 'Richterentijd', ARRAY['Koningentijd','Ballingschap','Profetentijd'], 3, 'mc', ARRAY['Genesis','Ruth'], NULL)
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000051', 'Uit welke plaats kwamen Elimélech en Naómi?', 'Bethlehem', ARRAY['Jeruzalem','Kana','Moab'], 3, 'mc', ARRAY['Ruth'], 'Ruth 1:1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000052', 'Hoe heetten de vrouwen waar de zonen van Naómi mee trouwden?', 'Orpa en Ruth', ARRAY['Orpa en Rebekka','Ruth en Rachel','Ruth en Rebekka'], 1, 'mc', ARRAY['Ruth'], 'Ruth 1:4')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000053', 'Hoe wilde Naómi genoemd worden?', 'Mara', ARRAY['Martha','Maria','Mirjam'], 1, 'mc', ARRAY['Ruth'], 'Ruth 1:20')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000054', 'Waarom was Boaz zo vriendelijk voor Ruth?', 'Ruth''s toewijding aan Naómi raakte hem', ARRAY['Hij was verliefd op Ruth','Omdat hij familie was van Naómi','God vroeg dit van hem'], 3, 'mc', ARRAY['Ruth'], 'Ruth 2:11')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000055', 'Wat is een losser?', 'Een nabij familielid, die de plicht heeft een ander lid van de familie te helpen', ARRAY['Een nabij familielid','Een nabij familielid die veel geld heeft','Een nabij familielid die in dezelfde plaats woont'], 1, 'mc', '{}', 'Ruth 3:9')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000056', 'Wat gaf Boaz als bewijs van zijn lossing?', 'Zijn schoen', ARRAY['Een kleitafeltje','Zijn ring','Zijn overjas'], 3, 'mc', ARRAY['Ruth'], 'Ruth 4:7')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000057', 'Hoe heet de zoon van Boaz en Ruth?', 'Obed', ARRAY['Juda','Machlon','Chiljon'], 1, 'mc', ARRAY['Ruth'], 'Ruth 4:17')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000058', 'Van wie werd Obed vader?', 'Isaï', ARRAY['Izak','Ismaël','Issachar'], 1, 'mc', ARRAY['Ruth'], 'Ruth 4:17')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000059', 'Van wie werd Isaï de vader?', 'Van koning David', ARRAY['Van koning Salómo','Van koning Saul','Van koning Abia'], 1, 'mc', '{}', '1 Samuël 17:12')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000060', 'Hoeveel vrouwen had Elkana?', 'Twee', ARRAY['Een','Drie','Vier'], 1, 'mc', ARRAY['Genesis'], '1 Samuël 1:2')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000061', 'Wat dacht de oude priester toen Hanna in de tempel bad?', 'Dat ze dronken was', ARRAY['Dat ze ernstig bad','Dat ze verdrietig was','Dat ze moe was'], 1, 'mc', '{}', '1 Samuël 1:14')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000062', 'Hoe noemde Hanna haar zoon?', 'Samuël', ARRAY['Simson','Gideon','Juda'], 1, 'mc', ARRAY['Genesis'], '1 Samuël 1:20')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000063', 'Wat betekent Samuël?', 'Van God gebeden', ARRAY['Man van God','Trooster','God geeft'], 3, 'mc', ARRAY['1 Samuël','2 Samuël'], '1 Samuël 1:17')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000064', 'Waar bracht Hanna Samuël toe?', 'Naar Eli', ARRAY['Naar Jeruzalem','Naar Elia','Naar de tempel in Jeruzalem'], 3, 'mc', ARRAY['1 Samuël'], '1 Samuël 1:25')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000065', 'Wat had Hanna niet bij zich toen ze Samuël naar Eli bracht?', '2 maten gerst', ARRAY['3 varren','een efa meel','een fles wijn'], 5, 'mc', ARRAY['1 Samuël'], '1 Samuël 1:24')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000066', 'Wie dacht dat Samuël hem riep?', 'Eli', ARRAY['Hofni','Pinehas','de Heere'], 1, 'mc', ARRAY['1 Samuël'], '1 Samuël 3')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000067', 'Welke functie had Samuël niet in zijn leven?', 'Koning', ARRAY['Profeet','Priester','Richter'], 1, 'mc', '{}', '1 Samuël')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000068', 'Hoe wordt de heilige stad in Ezechiël 48 genoemd?', 'De Heere is aldaar', ARRAY['Sion','Jeruzalem','Stad Gods'], 5, 'mc', ARRAY['Ezechiël'], 'Ezechiël 48:35')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000069', 'Welke psalm wordt wel de herderspsalm genoemd?', 'Psalm 23', ARRAY['Psalm 1','Psalm 25','Psalm 42'], 1, 'mc', ARRAY['Psalmen'], 'Psalmen 23')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000070', 'Hoe noem je een mannetjesschaap?', 'Een ram', ARRAY['Een reu','Een lam','Een ooi'], 1, 'mc', ARRAY['Genesis'], 'Genesis 22')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000071', 'Op welk instrument speelde David vaak?', 'Harp', ARRAY['Citer','Fluit','Cimbaal'], 3, 'mc', ARRAY['1 Samuël'], '1 en 2 Samuël')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000072', 'Wie schreef het Bijbelboek Spreuken?', 'Salómo', ARRAY['David','Asaf','Josafat'], 1, 'mc', ARRAY['Spreuken'], 'Spreuken')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000073', 'Wat is het beginsel der wetenschap?', 'De vreze des Heeren', ARRAY['De kennis des Heeren','De onderwijzing des Heeren','De bedachtzaamheid des Heeren'], 3, 'mc', ARRAY['Spreuken'], 'Spreuken 1:7')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000074', 'Wat is God voor degenen die oprecht wandelen?', 'Een Schild', ARRAY['Een Burcht','Een Toevlucht','Een Hoog Vertrek'], 5, 'mc', ARRAY['Spreuken'], 'Spreuken 2:7')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000075', 'Waarmee moet men de Heere vereren', 'Met bezit', ARRAY['Met gebed ','Met wijsheid','Met oprechtheid'], 5, 'mc', ARRAY['Spreuken'], 'Spreuken 3:9')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000076', 'Wat is kostbaarder dan robijnen?', 'De wijsheid', ARRAY['De liefde','De deugd','De kennis'], 5, 'mc', ARRAY['Spreuken'], 'Spreuken 3: 13-15')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000077', 'Wie moeten er gered worden?', 'Die in doodsgevaar zijn', ARRAY['Die wankelen','Die dwalen','Die goddeloos leven'], 5, 'mc', ARRAY['Spreuken'], 'Spreuken 24:11')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000078', 'De wijsheid is als ... ?', 'een sierlijke kroon op het hoofd', ARRAY['een gouden snoer om de hals','een sierraad van kennis','een band van inzicht'], 3, 'fitb', ARRAY['Spreuken'], 'Spreuken 4:9')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000079', 'Waar moet onze voet van verwijderd blijven?', 'Van het kwade', ARRAY['Van de weg der goddelozen','Van oneffen paden','Van de paden des doods'], 5, 'mc', ARRAY['Spreuken'], 'Spreuken 4:14')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000080', 'Hoeveel dingen zijn de Heere een gruwel?', 'Zeven', ARRAY['Vijf','Zes','Drie'], 5, 'mc', ARRAY['Spreuken'], 'Spreuken 6:16')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000081', 'Wat bedekt de liefde?', 'Alle overtredingen', ARRAY['Alle begerigheid','Alle onverstrand','Alle haat'], 5, 'mc', ARRAY['Spreuken'], 'Spreuken 10:12')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000082', 'Wat is er in het huis van een rechtvaardige?', 'Een grote schat', ARRAY['Liefde en trouw','Verstand','Kennis'], 5, 'mc', ARRAY['Spreuken'], 'Spreuken 15:6')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000083', 'Wie zal er in een kuil vallen?', 'Die een kuil graaft', ARRAY['Die brandende pijlen afschiet','Wie wijs is in eigen ogen','Die een dwaas eer geeft'], 3, 'mc', ARRAY['Spreuken'], 'Spreuken 26:27')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000084', 'Wanneer vind men barmhartigheid?', 'Als men zijn zonden bekent en laat', ARRAY['Als men een man van inzicht is','Als men in het verborgene liefheeft','Als men zijn hart niet verhard'], 3, 'mc', ARRAY['Spreuken'], 'Spreuken 28:13')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000085', 'Waar is Jezus opgegroeid?', 'Nazareth', ARRAY['Jeruzalem','Bethlehem','Kapernaüm'], 1, 'mc', ARRAY['Matteüs'], 'Mattheüs 2:23')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000086', 'Hoeveel dagen werd Jezus verzocht door de duivel:', '40 dagen', ARRAY['3 dagen','10 dagen','7 weken'], 1, 'mc', '{}', 'Markus 1:13')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000087', 'Waarop moet men zijn levenshuis bouwen?', 'Rots', ARRAY['Zand','Een berg','Kleigrond'], 1, 'mc', '{}', 'Mattheüs 7:25')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000088', 'Van wie zei Jezus: Ik heb zo groot een geloof zelfs in Israël niet gevonden?', 'De hoofdman', ARRAY['Petrus','De melaatse','De blindgeborene'], 1, 'mc', ARRAY['Matteüs'], 'Mattheüs 8:10')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000089', 'Waar zat Matthéüs toen Jezus hem riep?', 'In het tolhuis', ARRAY['Op het tempelplein','In een boom','Voor zijn huis'], 3, 'mc', ARRAY['Matteüs'], 'Mattheüs 9:9')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000090', 'Hoe groot moet volgens Jezus ons geloof zijn?', 'Als een mosterdzaad', ARRAY['Als een berg','Als een rots','Als een ceder van de Libanon'], 1, 'mc', ARRAY['Matteüs'], 'Mattheüs 17:20')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000091', 'Hoe vaak moeten we elkaar vergeven?', '70 x 7 maal', ARRAY['7 maal','3 maal','altijd'], 1, 'mc', '{}', 'Mattheüs 18:22')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000092', 'Wie riepen: Heere, Gij Zone Davids, ontferm U onzer', '2 blinden', ARRAY['10 melaatsen','de kinderen','de kreupelen'], 1, 'mc', '{}', 'Mattheüs 20:30')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000093', 'Welke boom werd door Jezus vervloekt?', 'De vijgeboom', ARRAY['De olijfboom','De ceder','De dadelpalm'], 3, 'mc', '{}', 'Markus 11:21')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000094', 'Door wie is het boek Openbaring geschreven?', 'Johannes', ARRAY['Paulus','Petrus','Matthéüs'], 1, 'mc', ARRAY['Openbaring'], 'Openbaring 1:1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000095', 'Aan hoeveel gemeenten schreef Johannes een brief?', '7', ARRAY['6','8','5'], 1, 'mc', ARRAY['Openbaring'], 'Openbaring')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000096', 'Wat moest Johannes schrijven aan Éfeze?', 'Gij hebt uw eerste liefde verlaten', ARRAY['Wees getrouw tot de dood','Ik heb voor u een geopende deur gegeven','En Ik zal u geven ieder naar uw werken'], 5, 'mc', ARRAY['Efeziërs'], 'Openbaring 2:4')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000097', 'Wat zal Jezus aan de gemeente te Smyrna geven als ze getrouw zijn?', 'De kroon des levens', ARRAY['Een witte steen','Een nieuwe naam','Het verborgen manna'], 5, 'mc', ARRAY['Openbaring'], 'Openbaring 2:10')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000098', 'Aan welke leer hielden ze in Pérgamum vast?', 'De leer van Bileam', ARRAY['De leer van de Farizeeën','Er is geen opstanding','De leer van Paulus'], 5, 'mc', ARRAY['Openbaring'], 'Openbaring 2:14')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000099', 'Welke vrouw hebben ze in Thyatíra laten begaan?', 'Izebél', ARRAY['de vrouw van Herodes','De vrouw van Potifar','Salomé'], 5, 'mc', ARRAY['Openbaring'], 'Openbaring 2: 20-23')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000100', 'Waar zal Jezus de gemeente Filadélfia voor bewaren?', 'De ure der verzoeking', ARRAY['Voor armoede','Voor ziekten','Voor geestelijk verval'], 5, 'mc', ARRAY['Openbaring'], 'Openbaring 3:10')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000101', 'Waarom zal Jezus Laodicéa uit zijn mond spuwen?', 'Omdat ze lauw zijn', ARRAY['Omdat ze heet zijn','Omdat ze koud zijn','Omdat ze hard zijn'], 3, 'mc', ARRAY['Openbaring'], 'Openbaring 3:15-16')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000102', 'Wat was er rondom de troon van God in Openbaring?', 'Een regenboog', ARRAY['Een licht','Gouden stralen','Een wolk'], 5, 'mc', ARRAY['Openbaring'], 'Openbaring 4:3')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000103', 'En rondom de troon waren tronen; en op de tronen zag ik ... ouderlingen zittende, bekleed met witte klederen, en zij hadden gouden kronen op hun hoofden. ', '24', ARRAY['7','7 x 7','3'], 3, 'fitb', ARRAY['Openbaring'], 'Openbaring 4:4')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000104', 'Wat had de schare die niemand tellen kon in zijn hand?', 'Palmtakken', ARRAY['Fakkels','Trompetten','Schalen met wierook'], 5, 'mc', ARRAY['Openbaring'], 'Openbaring 7:9')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000105', 'Wat doet God met de mensen die uit de grote verdrukking komen?', 'God zal alle tranen van hun ogen afwissen', ARRAY['God zal hen een nieuwe naam geven','God zal hun voor hoofden verzegelen','God zal bij hen wonen'], 3, 'mc', ARRAY['Openbaring'], 'Openbaring 21:4')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000106', 'Wat gebeurde er toen de derde engel heeft gebazuind?', 'Een grote ster, brandende als een fakkel, viel uit de hemel', ARRAY['De rook des reukwerks met de gebeden der heiligen ging op','Er is geworden hagel en vuur, gemengd met bloed','Er werd iets als een grote berg, van vuur brandende, in de zee geworpen'], 5, 'mc', ARRAY['Openbaring'], 'Openbaring 8:10')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000107', 'Hoe heet de engel van de afgrond in Openbaring?', 'Abáddon', ARRAY['Lucifer','De draak','Het Beest'], 5, 'mc', ARRAY['Openbaring'], 'Openbaring 9:11')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000108', 'Wat moest Johannes opeten in Openbaring?', 'Een boeksken', ARRAY['Een honingkoek','Brood','Vijgen'], 5, 'mc', ARRAY['Openbaring'], 'Openbaring 10:9')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000109', 'Hoeveel getuigen gaan er 1260 dagen lang profeteren?', '2', ARRAY['3','7','12'], 5, 'mc', ARRAY['Openbaring'], 'Openbaring 11: 3-12')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000110', 'En de vrouw vluchtte naar de ... , waar zij een plaats had, die door God bereid was', 'woestijn', ARRAY['tempel','bergen','stad'], 3, 'fitb', ARRAY['Openbaring'], 'Openbaring 12:6')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000111', 'Hoeveel fiolen van toorn zijn er?', 'Zeven', ARRAY['Drie','Vijf','Vier'], 5, 'mc', ARRAY['Openbaring'], 'Openbaring 16')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000112', 'Welke stad daalt er neder uit de hemel?', 'Het nieuwe Jeruzalem', ARRAY['De stad Gods','De stad met vele woningen','Die stad die fundamenten heeft'], 1, 'mc', ARRAY['Openbaring'], 'Openbaring 21: 1-4')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000113', 'Wat zeggen de Geest en de Bruid?', 'Kom', ARRAY['Amen','Hallelujah','Ik ben de Alfa en de Omega'], 1, 'mc', ARRAY['Openbaring'], 'Openbaring 22:17')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000114', 'Hoeveel brieven zijn er van Paulus aan de Korinthiërs?', 'Twee', ARRAY['Een','Drie','Vier'], 1, 'mc', ARRAY['1 Korintiërs','2 Korintiërs'], '1 en 2 Korinthe')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000115', 'Hoeveel personen heeft Jezus opgewekt?', 'Drie', ARRAY['Twee','Een','Vier'], 3, 'mc', '{}', 'Evangelïen')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000116', 'Hoeveel jaar heeft Jezus ongeveer gepreekt?', 'Drie', ARRAY['Twee','Een','Vier'], 1, 'mc', '{}', 'In de evangeliën')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000117', 'In welke plaatst dreven ze Jezus uit de stad, naar de rand de berg, om Hem in de afgrond te werpen?', 'Nazareth', ARRAY['Jeruzalem','Bethlehem','Samaria'], 1, 'mc', '{}', 'Lukas 4:29')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000118', 'In welke plaats zat Bartiméüs bij de poort te bedelen?', 'Jericho', ARRAY['Jeruzalem','Samaria','Kapernaüm'], 3, 'mc', '{}', 'Markus 10:46')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000119', 'Aan wie werd gevraagd: Verstaat gij ook hetgeen gij leest?', 'De Moorman', ARRAY['Filippus','Petrus','Saulus'], 1, 'mc', ARRAY['Handelingen'], 'Handelingen 8:30')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000120', 'Welk eiland bezochten Paulus en Bárnabas op hun eerste zendingsreis?', 'Cyprus', ARRAY['Kreta','Malta','Silicië'], 3, 'mc', ARRAY['Handelingen'], 'Handelingen 13:4')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000121', 'Welke koning kreeg een ernstige ziekte, dodelijke ziekte?', 'Hizkía', ARRAY['Ahaz','Manasse','Juda'], 1, 'mc', '{}', 'Hizkia 20:1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000122', 'Na zijn vlucht voor koningin Izébel vluchtte Elia naar de spelonk. Welke?', 'De spelonk op de berg Horeb', ARRAY['De spelonk van Machpéla ','De spelonk van Adullam','De spelonken van Zefánja'], 3, 'mc', ARRAY['1 Koningen'], '1 Koningen 19')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000123', 'Wat namen de Israëlieten niet mee van de Egyptenaren bij de uittocht uit Egypte?', 'Voedsel', ARRAY['Goud','Zilver','Kleding'], 3, 'mc', ARRAY['Exodus'], 'Exodus 3:22')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000124', 'Hoe lang zat Paulus gevangen in Cesaréa ten tijde van Felix en Festus?', '2 jaar', ARRAY['1,5 jaar','2,5 jaar','3 jaar'], 3, 'mc', ARRAY['Handelingen'], 'Handelingen')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000125', 'Welke diaken werd in Jeruzalem gestenigd?', 'Stéfanus', ARRAY['Filippus','Timon','Nikolaüs'], 1, 'mc', ARRAY['Handelingen'], 'Handelingen 7:54-60')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000126', 'Welke zoon wilde David van de troon stoten?', 'Absalom', ARRAY['Joab','Amnon','Adnia'], 1, 'mc', ARRAY['2 Samuël'], '2 Samuël 15')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000127', 'Wie bezochten als eerste Jezus na zijn geboorte?', 'De herders', ARRAY['De wijzen','Koning Heródes ','Zacharias en Elisabet'], 1, 'mc', '{}', 'Lukas 2: 8-20')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000128', '10 melaatsen werden door Jezus genezen. Wie kwam terug om Hem te danken?', 'Een Samaritaan', ARRAY['Een Israëliet','Een Jood','Een Tollenaar'], 3, 'mc', ARRAY['Lucas'], 'Lukas 17: 11-19')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000129', 'Wie was koning toen Daniël in de leeuwenkuil geworpen werd?', 'Daríus', ARRAY['Nebukadnézar','Bélsazar','Kores'], 3, 'mc', ARRAY['Daniël'], 'Daniël 6')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000130', 'De schoonmoeder van Petrus werd genezen van de koorts. In welke plaats was dit?', 'Kapérnaüm', ARRAY['Kana','Naïn','Jericho'], 3, 'mc', '{}', 'Mattheüs 8:14')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000131', 'De inwoners van het Tienstammenrijk werden naar ... weggevoerd.', 'Assyrië', ARRAY['Babel','Perzië','Egypte'], 3, 'fitb', ARRAY['2 Koningen'], '2 Koningen 17:6')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000132', 'Uit welke 2 stammen bestond het tweestammenrijk?', 'Juda en Benjamin', ARRAY['Levi en Juda','Jozef en Benjamin','Juda en Levi'], 3, 'mc', ARRAY['1 Koningen'], '1 Koningen 12:21')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000133', '3 namen zijn voor hetzelfde meer/zee. Welke hoort er niet bij?', 'De Dode Zee', ARRAY['Meer van Galiléa','Meer van Gennésaret','Zee van Tiberias'], 1, 'mc', '{}', NULL)
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000134', 'Er werd een nieuwe apostel gekozen in plaats van Judas. Wie was dat?', 'Matthías', ARRAY['Justus','Filippus','Nathanaël'], 3, 'mc', ARRAY['Handelingen'], 'Handelingen 1:26')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000135', 'Waar denken we aan met Pasen?', 'De opstanding van Jezus', ARRAY['De geboorte van Jezus','De dood van Jezus','De hemelvaart van Jezus'], 1, 'mc', '{}', 'Markus 16')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000136', 'Daniël kreeg een Babylonische naam. Welke?', 'Béltsazar', ARRAY['Bélsazar','Sadrach','Mesach'], 1, 'mc', ARRAY['Daniël'], 'Daniël 1:7')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000137', 'De blindgeborene moest zich in ... wassen om ziende te worden.', 'het badwater van Silóam', ARRAY['het badwater van Bethesda','de Jordaan','het badwater van de reiniging'], 3, 'fitb', ARRAY['Johannes'], 'Johannes 9: 1-7')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000138', 'In de strijd tegen Egypte sneuvelde koning ... van Juda.', 'Josía', ARRAY['Amon','Manasse','Ahaz'], 5, 'fitb', ARRAY['2 Kronieken'], '2 Kronieken 35: 20-24')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000139', 'Waar ontstond de eerste christengemeente?', 'Jeruzalem', ARRAY['Antiochië','Filippi','Korinthe'], 3, 'mc', ARRAY['Handelingen'], 'Handelingen 2:40-41')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000140', 'Wie waren de derde en vierde discipelen van Jezus?', 'Johannes en Jakobus', ARRAY['Simon en Andreas','Simon en Jakobus','Johannes en Andréas'], 5, 'mc', '{}', 'Markus 1: 16-20')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000141', 'Elia, Achab en het volk gingen offeren op de berg ... ', 'Karmel', ARRAY['Horeb','Sinaï','Tabor'], 3, 'fitb', ARRAY['1 Koningen'], '1 Koningen 18: 20 -40')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000142', 'Wat is het laatste woord in de Bijbel?', 'Amen', ARRAY['Komt','Gode zij dank','Zegen'], 1, 'mc', ARRAY['Openbaring'], 'Openbaring 22:21')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000143', 'Wie hoorde een Grote stem uit de Hemel zeggen: ''Zie, de tabernakel Gods is bij de mensen en Hij zal bij hen wonen''?', 'Johannes', ARRAY['Petrus','Jakobus','Jezus zelf'], 5, 'mc', ARRAY['Openbaring'], 'Openbaring 21:3')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000144', 'Hoe heet de Ruiter op het witte paard in Openbaring?', 'Getrouw en Waarachtig', ARRAY['Zaligmaker','Christus Jezus','Vast en zeker'], 5, 'mc', ARRAY['Openbaring'], 'Openbaring 19:11')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000145', 'Maak de zin af: Wee, wee, de grote stad ... , de sterke stad ', 'Babylon', ARRAY['Jericho','Jeruzalem','Ninevé'], 5, 'fitb', ARRAY['Openbaring'], 'Openbaring 18:10')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000146', 'Hoe vaak werd er op de bazuin geblazen in Openbaring?', '7 keer', ARRAY['7 keer 70 keer','70 keer','700 keer'], 5, 'mc', ARRAY['Openbaring'], 'Openbaring 8, 9, 10, 11')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000147', 'Hoeveel zegels worden er geopend in Openbaring?', '7', ARRAY['8','6','3'], 5, 'mc', ARRAY['Openbaring'], 'Openbaring 6, 7, 8')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000148', 'Wie alleen kon het boek met de 7 zegels openen?', 'Het Lam', ARRAY['De Rots','Het monster met 7 ogen','Niemand'], 5, 'mc', ARRAY['Openbaring'], 'Openbaring 5')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000149', 'Wat stond er in de Brief van Christus aan Sardis?', 'Gij hebt een naam dat gij leeft, en gij zijt dood', ARRAY['Wee u','De regels waar die gemeente zich aan moest houden','U is het Eeuwige Leven'], 5, 'mc', ARRAY['Openbaring'], 'Openbaring 3:1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000150', 'Waar schreef Johannes het Bijbelboek Openbaring?', 'Op het eiland Patmos', ARRAY['In de gevangenis','Johannes schreef Openbaring niet','In de woestijn'], 1, 'mc', ARRAY['Openbaring'], 'Openbaring 1:9')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000151', 'Waarvoor waarschuwde Judas in zijn Bijbelboek?', 'Tegen dwaalleraars', ARRAY['Tegen de duivel','Tegen de zonde','Tegen de wereld'], 3, 'mc', ARRAY['Judas'], 'Judas 1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000152', 'Aan wie schreef Johannes zijn brief, 3 Johannes?', 'Gajus', ARRAY['De gemeente van Laodicéa','Aan niemand specifiek','Aan Diótrefes'], 5, 'mc', ARRAY['3 Johannes'], '3 Johannes 1:1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000153', 'Vanuit welke plaats schreef Johannes zijn brief, 2 Johannes?', 'Vanuit Eféze', ARRAY['Vanuit Korinthe','Vanuit Klein-Azië','Dat is onbekend'], 3, 'mc', ARRAY['Johannes'], '2 Johannes')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000154', 'Welke profeet zei tegen koning Hizkía dat hij moest sterven?', 'Jesaja', ARRAY['Jeremía','Micha','Atmos'], 3, 'mc', ARRAY['Jesaja'], 'Jesaja 38:1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000155', 'Van wie sloeg Petrus het oor af?', 'Malchus', ARRAY['Matthéüs','Maltus','Kajafas'], 1, 'mc', ARRAY['Johannes'], 'Johannes 18:10')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000156', 'Wat vroeg de Macedónische man in de droom van Paulus?', '''Kom over in Macedónië en help ons''', ARRAY['''Kom over en help ons''','''Kom en zie''','''Kom over in Macedónië en predik het evangelie'''], 3, 'mc', ARRAY['Handelingen'], 'Handelingen 19: 9, 10')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000157', 'Welke straf kondigde de profeet Elía aan voor koning Achab?', 'Er zal geen dauw of regen zijn', ARRAY['Er zal geen regen meer zijn','Er zal hongersnood komen','Er zullen veel mensen sterven'], 3, 'mc', ARRAY['1 Koningen'], '1 Koningen 17:1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000158', 'Wie was de vader van Samuël?', 'Elkana', ARRAY['Elihu','Elam','Jerobeam'], 1, 'mc', ARRAY['1 Samuël'], '1 Samuël 1:1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000159', 'In welke stad sprak Paulus over de onbekende God?', 'In Athene', ARRAY['In Korinthe','In Filippi','In Thyatira'], 3, 'mc', ARRAY['Handelingen','Romeinen'], 'Handelingen 17:23')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000160', 'Wie ging er mee op de eerste zendingsreis van Paulus en Barnabas?', 'Johannes Marcus', ARRAY['Marcus','Johannes','Petrus'], 3, 'mc', ARRAY['Handelingen'], 'Handelingen 13')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000161', 'Wie waren de zonen van Zebedeüs?', 'Jakobus en Johannes', ARRAY['Johannes en Andreas','Andreas en Petrus','Jakobus en Petrus'], 3, 'mc', '{}', 'Markus 1: 19 , 20')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000162', 'In welke plaats werd David tot koning uitgeroepen?', 'Hebron', ARRAY['Jeruzalem','Juda','Gilead'], 3, 'mc', ARRAY['2 Koningen'], '2 Koningen 2:4')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000163', 'Wie zij: ''Gij beweegt mij bijna een Christen te worden''?', 'Koning Agrippa', ARRAY['Silas','Stadhouder Felia','Koning David'], 1, 'mc', ARRAY['Handelingen'], 'Handelingen 26:28')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000164', 'Tijdens de woestijnreis was het water bitter bij ... ', 'Mara', ARRAY['Elim','Rafidim','Kades Barnea'], 1, 'fitb', '{}', 'Exodus 15:23')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000165', 'Welke afgodendienst voerde koning Jerobeam in?', 'De dienst van de gouden kalveren', ARRAY['De dienst van de Baël','De dienst van Astarte','De dienst van de sterren'], 3, 'mc', ARRAY['1 Koningen'], '1 Koningen 12: 25-33')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000166', 'Hoeveel zendingsreizen maakte Paulus?', '3', ARRAY['2','4','5'], 1, 'mc', ARRAY['Handelingen'], 'Handelingen')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000167', 'Op welke berg was de Hemelvaart van Jezus?', 'Olijfberg', ARRAY['Horeb','Moria','Nebo'], 1, 'mc', ARRAY['Handelingen'], 'Handelingen 1: 9-12')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000168', 'Waar woonde de moeder van Jezus?', 'Nazareth', ARRAY['Bethlehem','Jeruzalem','Dat is onbekend'], 1, 'mc', ARRAY['Lucas'], 'Lukas 1:26')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000169', 'Hoeveel dagen zijn er tussen Hemelvaart en Pinksteren?', '10', ARRAY['40','3','12'], 1, 'mc', ARRAY['Pinksteren','Hemelvaart'], 'Handelingen 1 en 2')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000170', 'Wie was de eerste Christen die stierf voor zijn geloof?', 'Stéfanus', ARRAY['Petrus','Jakobus','Filippus'], 1, 'mc', ARRAY['Handelingen'], 'Handelingen 7: 54-60')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000171', 'Welgelukzalig is de man die niet ... in de raad der goddelozen', 'wandelt', ARRAY['loopt','staat','gaat'], 1, 'fitb', ARRAY['Psalmen'], 'Psalmen 1:1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000172', 'Hoe heette de vrouw van Aaron', 'Eliséba', ARRAY['Zippora','Jehosabat','Elisabet'], 5, 'mc', ARRAY['Exodus'], 'Exodus 6:22')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000173', 'Hoe reageerde het volk bij het voorlezen van de wet, voorgelezen door Ezra?', 'Ze weenden', ARRAY['Ze dansten','Ze verlieten de stad','Ze kwamen in opstand'], 5, 'mc', ARRAY['Nehemia'], 'Nehemia 8:9')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000174', 'Wat was Nehémia''s functie aan het hof van de koning van Perzië?', 'Schenker', ARRAY['Hoofd van de wachters','Bode','Boekhouder'], 4, 'mc', ARRAY['Nehemia'], 'Nehemia 1:11')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000175', 'Wat was de belangrijkste taak van Ezra bij zijn komst naar Jeruzalem?', 'Het volk onderwijzen in de wet des Heeren', ARRAY['De stad herbouwen','De muren herstellen','De tempel reinigen'], 5, 'mc', ARRAY['Ezra'], 'Ezra 7:10')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000176', 'Wat gebeurde er met koning Uzzia toen hij het priesterambt wilde uitoefenen?', 'Hij kreeg melaatsheid', ARRAY['Hij werd gezegend','Hij werd koning over alle stammen','Hij werd uit Jeruzalem verdreven'], 5, 'mc', ARRAY['2 Kronieken'], '2 Kronieken 26: 16-21')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000177', 'Wat deed Salomo nadat hij de tempel had voltooid?', 'Hij bad', ARRAY['Hij verliet Jeruzalem','Hij vernietigde de hoogten','Hij verborg de ark'], 4, 'mc', ARRAY['1 Koningen'], '1 Koningen 8: 22, 23')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000178', 'Wie bracht de ark van God naar Jeruzalem, nadat het eerst was mislukt?', 'David', ARRAY['Mozes','Saul','Joab'], 3, 'mc', '{}', '2 Samuël 6: 12-15')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000179', 'Wat deed Elisa om het bittere water van Jericho gezond te maken?', 'Hij strooide zout in de bron', ARRAY['Hij bad tot God','Hij sloeg op het water met zijn mantel','Hij gebood het water stil te staan'], 4, 'mc', ARRAY['2 Koningen'], '2 Koningen 2:21')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000180', 'Wat gebeurde er bij de inwijding van de tempel die Salomo bouwde?', 'De wolk vervulde het huis des Heeren', ARRAY['Er kwam vuur uit de hemel','De ark verdween','De priesters gingen in het heiligdom'], 4, 'mc', ARRAY['1 Koningen'], '1 Koningen 8: 10, 11')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000181', 'Wat deed David toen hij hoorde van de dood van Absalom?', 'Hij weende en rouwde', ARRAY['Hij vierde feest','Hij vluchtte','Hij sloeg zich met stenen'], 2, 'mc', ARRAY['2 Samuël'], '2 Samuël 18:33')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000182', 'Met hoeveel man versloeg Gídeon het leger van Midian?', '300', ARRAY['30','1000','3000'], 2, 'mc', ARRAY['Richteren'], 'Richteren 7:6')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000183', 'Wie was de enige vrouwelijke richter van Israël?', 'Debóra', ARRAY['Hanna','Ruth','Jaël'], 1, 'mc', ARRAY['Richteren'], 'Richteren 4: 4 en 5')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000184', 'Wat zei Jozua tot het volk in zijn afscheidsrede?', 'Maar aangaande mij en mijn huis, wij zullen de Heere dienen', ARRAY['Verlaat dit land, want het is onrein','Zoek u deze dag een andere god','Laat ons terugkeren naar Egypte'], 2, 'mc', ARRAY['Jozua'], 'Jozua 25:15')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000185', 'Wat moest Mozes doen om water uit de rots te krijgen bij Mériba?', 'Met zijn staf op de rots slaan', ARRAY['Tot de rots spreken','Bidden tot de Heere','De rots besprenkelen met bloed'], 3, 'mc', ARRAY['Genesis','Exodus'], 'Éxodus 17: 1-7')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000186', 'Wat moest de priester doen met het bloed van het schuldoffer?', 'Aan de hoornen van het altaar strijken', ARRAY['Op de ark strijken','Aan de westzijden van het heilige der heiligen strijken','Met wierook vermengen'], 3, 'mc', ARRAY['Exodus'], 'Exodus 29:12')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000187', 'Wat sprak God tot Mozes uit de brandende braambos?', 'Ik ben de God uws vaders', ARRAY['Ga heen naar Ninevé','Gij zijt uitverkoren boven alle volken','Ik ben uw God'], 4, 'mc', ARRAY['Genesis','Exodus'], 'Exodus 3:6')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000188', 'Wat bouwde Noach als eerste, na de zondvloed?', 'Een altaar', ARRAY['Een stad','Een schip','Een toren'], 1, 'mc', ARRAY['Genesis'], 'Genesis 8:20')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000189', 'Wat zei God tot de slang na de zondeval van Adam en Eva?', '"Vervloekt zijt gij boven al het vee"', ARRAY['"Gij zult tot stof wederkeren"','"Gij zult uw vrouw verlaten"','"Ik zal u genadig zijn"'], 2, 'mc', ARRAY['Genesis'], 'Genesis 3:14')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000190', 'Welke naam had de discipel Mattheüs eerst?', 'Levi', ARRAY['Simon','Markus','Lazarus'], 1, 'mc', ARRAY['Matteüs'], 'Markus 9:9')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000191', 'Bij wie ging Maria, de moeder van de Heere Jezus, wonen na Jezus dood?', 'Bij Johannes', ARRAY['Bij Martha','Bij Petrus','Bij haar zuster'], 2, 'mc', ARRAY['Johannes'], 'Johannes 19: 26, 27')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000192', 'Waarheen werd de Heere Jezus door de Geest geleid na zijn doop in de Jordaan?', 'In de woestijn', ARRAY['Naar Galilea','Naar Kapernaüm','Naar zijn discipelen'], 2, 'mc', ARRAY['Matteüs'], 'Matthéüs 4 : 1-3')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000193', 'Hoe begint de bergrede in Mattheüs 5?', 'Met de zaligsprekingen', ARRAY['Met het Onze Vader','Met de gelijkenissen van het zaad','Met het gebod der liefde'], 3, 'mc', ARRAY['Matteüs'], 'Matthéüs 5: 1-12')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000194', 'Wat is het eerst wonder van Jezus, genoemd in het bijbelboek Markus?', 'Een onreine geest uitdrijven', ARRAY['Water in wijn veranderen','Petrus loopt op het water','Jezus stilt de storm'], 4, 'mc', ARRAY['Matteüs','Marcus','Lucas'], 'Markus 1:21-28')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000195', 'Wie wordt in Mattheüs het eerst genoemd in de geslachtsrekening van Jezus?', 'Abraham', ARRAY['Jakob','Adam','Mozes'], 3, 'mc', ARRAY['Matteüs'], 'Mattheüs 1:1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000196', 'Wat was de eerste boodschap die Jezus predikte in Markus 1?', 'Bekeert u en gelooft het Evangelie', ARRAY['Hebt elkander lief','Gaat heen in de gehele wereld','Bidt en waakt'], 4, 'mc', '{}', 'Markus 1:15')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000197', 'Aan wie is het evangelie van Lukas gericht?', 'Theófilus', ARRAY['Timotheüs','Titus','Silas'], 2, 'mc', ARRAY['Lucas'], 'Lukas 1:3')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000198', 'Wie zag/zagen Jezus als eerste na Zijn opstanding?', 'De Emmaüsgangers', ARRAY['Petrus','Maria Magdalena','Johannes'], 2, 'mc', ARRAY['Lucas'], 'Lukas 24:15')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000199', 'Waar eindigt het bijbelboek Lukas?', 'Bij de hemelvaart van Jezus', ARRAY['Bij de kruisiging','Bij Pinkensteren in Jeruzalem','Bij de voorzegging van de wederkomst'], 3, 'mc', '{}', 'Lukas 24: 50-53')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000200', 'Met welke woorden begint Johannes 1?', 'In den beginne was het Woord', ARRAY['In den beginne schiep God','En het geschiedde','Deze is het boek der geslachten'], 2, 'mc', '{}', 'Johannes 1: 1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000201', 'Wie was de vrouw bij de bron?', 'Een Samaritaanse', ARRAY['Een Jodin','Een Romeinse','Een Filistijnse'], 1, 'mc', ARRAY['Johannes'], 'Johannes 4:7')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000202', 'Wie nam de plaats van Judas in als apostel?', 'Matthías', ARRAY['Barnabas','Paulus','Silas'], 3, 'mc', ARRAY['Handelingen'], 'Handelingen 1: 15-26')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000203', 'Wat deed Petrus na Pinksteren?', 'Hij predikte', ARRAY['Hij zweeg','Hij bad in stilte','Hij vluchtte'], 1, 'mc', ARRAY['Handelingen'], 'Handelingen 2:14-41')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000204', 'Wie bekeerde zich op de weg naar Damascus?', 'Saulus', ARRAY['Petrus','Barnabas','Timotheüs'], 1, 'mc', ARRAY['Handelingen'], 'Handelingen 9: 1-6')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000205', 'Hoe eindigt het boek Handelingen?', 'Met Paulus'' verblijf in Rome', ARRAY['Met Paulus'' dood','Met de verwoesting van Jeruzalem','Met het Pinksteren'], 4, 'mc', ARRAY['Handelingen'], 'Handelingen 28')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000206', 'Hoe beschrijft Paulus zichzelf in Romeinen 1:1?', 'Een dienstknecht van Jezus Christus', ARRAY['Een profeest van Jezus Christus','Een dienaar van de mensen','Een apostel van Johannes'], 2, 'mc', ARRAY['Romeinen'], 'Romeinen 1:1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000207', 'Wie zijn de ware kinderen van Abraham?', 'Zij die uit het geloof zijn', ARRAY['Zij die uit de Geest zijn','Zij die in Israël zijn geboren','Zij die uit het vlees zijn'], 2, 'mc', ARRAY['Romeinen'], 'Romeinen 4:16')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000208', 'Wat zegt Paulus dat wij moeten doen met onze lichamen?', 'Ze stellen tot een levende, heilige en Gode welbehaaglijke offerande', ARRAY['Ze onderwerpen aan de wet','Ze gebruiken voor de goede werken','Ze stellen tot offeranden'], 4, 'mc', ARRAY['Romeinen'], 'Romeinen 12: 1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000209', 'Wat is de samenvatting van de wet?', 'Liefde', ARRAY['Geloof','Gehoorzaamheid','Hoop'], 1, 'mc', ARRAY['Romeinen'], 'Romeinen 13: 8-14')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000210', 'Wat is het probleem in de gemeente te Korinthe?', 'Twist en verdeeldheid', ARRAY['Vervolging','Gebrek aan geloof','Gebrek aan liefde'], 4, 'mc', ARRAY['1 Korintiërs'], '1 Korinthe 1: 10-13')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000211', 'Wat is het lichaam van een gelovige?', 'Een tempel van de Heilige Geest', ARRAY['Stof der aarde','Een zondig vat','Een tijdelijke tent'], 2, 'mc', ARRAY['1 Korintiërs'], '1 Korintiërs 6 en 20')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000212', 'Hoeveel brieven schreef Paulus aan de Korinthiërs die bewaard zijn gebleven?', 'Twee', ARRAY['Een','Drie','Vier'], 1, 'mc', ARRAY['1 Korintiërs'], 'Korintiërs 1 en 2')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000213', 'Wat zegt Paulus over zwakheid?', 'Mijn kracht wordt in zwakheid volbracht', ARRAY['Zwakheid is een zonde','Vermijd zwakte ten alle tijde','Geloof overwint de zwakheid'], 2, 'mc', ARRAY['2 Korintiërs'], '2 Korintiërs 12:9')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000214', 'Wat is de bediening die God aan ons gegeven heeft?', 'Bediening der verzoening', ARRAY['Bediening van het oordeel','Bediening van genade','Bediening der geboden'], 2, 'mc', ARRAY['2 Korintiërs'], '2 Korintiërs 5:18')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000215', 'Wat verwondert Paulus?', 'Dat zij haast wijken naar een ander evangelie', ARRAY['Dat de Galaten vroom zijn','Dat zij veel vasten','Dat zij veel bidden'], 3, 'mc', '{}', 'Galaten 1:6')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000216', 'Wat zegt Paulus over de wet?', 'Zij is een tuchtmeester tot Christus', ARRAY['Zij rechtvaardigt','Zij leidt weg van de zonden','Zij is vervuld in Christus'], 4, 'mc', ARRAY['Galaten'], 'Galaten 3:24')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000217', 'Door wat zijn wij zalig geworden?', 'Door het geloof, uit genade', ARRAY['Door de werken der wet','Door het onderhouden van de wet','Door gebed en vasten'], 2, 'mc', ARRAY['Galaten'], 'Galaten 2:16')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000218', 'Wat moeten kinderen doen?', 'Gehoorzaam zijn aan hun ouders', ARRAY['Stil zijn','Werken','Bidden'], 1, 'mc', '{}', 'Éfeze 6: 1-3')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000219', 'Wat is het leven voor Paulus?', 'Christus', ARRAY['Lijden','Strijd','Hoop'], 2, 'mc', ARRAY['Filippenzen'], 'Filippenzen 1:21')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000220', 'Wie wordt genoemd als Paulus'' broeder en medearbeider?', 'Epafroditus', ARRAY['Barnabas','Silas','Timotheüs'], 4, 'mc', ARRAY['Filippenzen'], 'Filippenzen 2:25')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000221', 'Wie schreef de brief aan de Kolossenzen?', 'Paulus', ARRAY['Kolossenzen','Silas','Timotheus'], 1, 'mc', ARRAY['Kerst','Pasen','Pinksteren','Hemelvaart','Goede Vrijdag','Stille Zaterdag','Paasmaandag','Pinkstermaandag','Kolossenzen'], 'Kolossenzen 1: 1 en 2')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000222', 'Wie schreef de brief aan de Thessalonicenzen?', 'Paulus, Silvanus en Timotheüs', ARRAY['Paulus','Paulus en Timotheüs','Paulus en Barnabas'], 5, 'mc', '{}', '1 Thessalonicenzen 1:1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000223', 'Wie is het beeld van de onzienlijke God?', 'Christus', ARRAY['Mozes','De engel des Heeren','De Heilige Geest'], 3, 'mc', ARRAY['Kolossenzen'], 'Kolossenzen 1:15')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000224', 'Wat gebeurt er met de doden in Christus bij Zijn wederkomst?', 'Zij zullen eerst opstaan', ARRAY['Zij worden geoordeeld','Zij keren terug met Jezus','Zij zullen als laatsten opstaan'], 2, 'mc', '{}', '1 Thessalonicenzen 4:16')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000225', 'Wat moet er eerst gebeuren voor de dag des Heeren komt?', 'De geloofsafval en de openbaring van de mens der zonde', ARRAY['De wederkomst','De opstanding uit de doden','De verdrukking'], 3, 'mc', '{}', '2 Thessalonicenzen 2')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000226', 'Hoe wordt de "mens der zonde" ook wel genoemd?', 'De zoon des verderfs', ARRAY['De antichrist','De draak','De overste der duisternis'], 3, 'mc', '{}', '2 Thessalonicenzen 2:3')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000227', 'Wat is Paulus'' zegenwens aan het eind van Thessalonicenzen?', 'De genade van onze Heere Jezus Christus zij met u allen. Amen.', ARRAY['Genade en vrede zij met u allen. Amen.','De liefde Gods en de gemeenschap des Heiligen Geestes zij met u allen, Amen.','De vrede Gods zij met u allen. Amen.'], 4, 'mc', '{}', '2 Thessalonicenzen 3:18')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000228', 'Wat zegt Paulus over vrouwen in de eredienst?', 'Dat zij in stilheid zij', ARRAY['Dat zij profetere','Dat zij het volk onderwijze','Dat zij het volk predike'], 3, 'mc', '{}', '1 Timotheüs 2:11')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000229', 'Wat is God niet?', 'Een geest der vreesachtigheid', ARRAY['Een verterend vuur','Een God van het oordeel','Een God der twist'], 4, 'mc', '{}', '2 Timotheüs 1:7')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000230', 'Welke vergelijking gebruikt Paulus voor het leven van een gelovige?', 'Soldaat, atleet, landbouwer', ARRAY['Profeet, priester, koning','Vreemdeling, pelgrim, reiziger','Visser, landbouwer, soldaat'], 5, 'mc', ARRAY['2 Timoteüs'], '2 Timotheüs 2')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000231', 'Wie heeft Paulus verlaten, hebbende de tegenwoordige wereld lief gekregen?', 'Démas', ARRAY['Timotheüs'], 4, 'mc', ARRAY['Romeinen'], '2 Timotheüs 4:10')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000232', 'Wat moest Titus doen op Kreta?', 'Ouderlingen aanstellen in elke stad', ARRAY['De Romeinen overtuigen','Diakenen aanstellen in elke stad','Een gemeente stichten'], 4, 'mc', ARRAY['Titus'], 'Titus 1:5')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000233', 'Wat zegt Paulus over de zaligmakende genade Gods?', 'Zij is verschenen aan alle mensen', ARRAY['Zij is voor Israël gekomen','Zij is voor de uitverkorenen','Zij leert ons door de wet Christus kennen'], 5, 'mc', ARRAY['Titus'], 'Titus 2:11')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000234', 'Wie was Onésimus?', 'Een weggelopen slaaf', ARRAY['Een Romeinse soldaat','Een ouderling','Een diaken'], 3, 'mc', ARRAY['Filemon'], 'Filémon 1:16')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000235', 'Wie was Melchizédek?', 'Een priester zonder geslachtsrekening', ARRAY['Een priester uit het geslacht van David','Een nakomeling van Abraham','Een nakomeling van Mozes'], 3, 'mc', ARRAY['Hebreeën'], 'Hebreeën 7:3')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000236', 'Wie worden in Hebreeën 11 genoemd als voorbeelden van geloof?', 'Noach, Abraham, Mozes', ARRAY['David, Elia, Jesaja','Johannes, Petrus, Andreas','Paulus, Timotheüs, Titus'], 2, 'mc', ARRAY['Hebreeën'], 'Hebreeën 11')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000237', 'Wat is de oorsprong van verzoeking?', 'Eigen begeerlijkheid', ARRAY['De duivel','Het eigen vlees','De wereld'], 2, 'mc', ARRAY['Jakobus'], 'Jakobus 1:14')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000238', 'Wie moet bidden voor de zieke?', 'De ouderlingen van de gemeente', ARRAY['De diakenen van de gemeente','De voorganger van de gemeente','De medegelovigen uit de gemeente'], 3, 'mc', ARRAY['Jakobus'], 'Jakobus 5:14-15')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000239', 'God schiep de hemel en aarde in zeven dagen', 'Niet waar', ARRAY['Waar'], 1, 'tf', ARRAY['Genesis'], 'Genesis 2:2')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000240', 'Kaïn doodde zijn neef Abel', 'Niet waar', ARRAY['Waar'], 1, 'tf', ARRAY['Genesis'], 'Genesis 4:8')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000241', 'Aäron was de vader van Mozes', 'Niet waar', ARRAY['Waar'], 1, 'tf', '{}', 'Exodus 6:19')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000242', 'De wet van het jubeljaar wordt uitgelegd in Leviticus', 'Waar', ARRAY['Niet waar'], 3, 'tf', ARRAY['Leviticus'], 'Leviticus 25: 8-55')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000243', 'Leviticus richt zich voornamelijk tot de stam van Juda', 'Niet waar', ARRAY['Waar'], 4, 'tf', ARRAY['Leviticus'], 'Leviticus')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000244', 'Bileam''s ezel sprak tot hem', 'Waar', ARRAY['Niet waar'], 1, 'tf', ARRAY['Numeri'], 'Numeri 22:28')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000245', 'Deuteronomium betekent "herhaling van de wet"', 'Waar', ARRAY['Niet waar'], 4, 'tf', ARRAY['Deuteronomium'], 'Deuteronomium')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000246', 'Deuteronomium beschrijft Mozes'' laatste toespraak', 'Waar', ARRAY['Niet waar'], 3, 'tf', ARRAY['Deuteronomium'], 'Deuteronomium 32 en 33')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000247', 'Jozua was de kleinzoon van Nun', 'Niet waar', ARRAY['Waar'], 2, 'tf', ARRAY['Jozua'], 'Jozua 1:1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000248', 'De zon stond stil tijdens een strijd onder Jozua''s leiding', 'Waar', ARRAY['Niet waar'], 3, 'tf', ARRAY['Jozua'], 'Jozua 10:12-14')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000249', 'Het boek Jozua eindigt met de dood van Mozes', 'Niet waar', ARRAY['Waar'], 3, 'tf', ARRAY['Jozua'], 'Jozua 24')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000250', 'Het boek richteren eindigt met de woorden: "In die dagen was er geen koning in Israël, een iegelijk deed wat recht was in zijn ogen"', 'Waar', ARRAY['Niet waar'], 4, 'tf', ARRAY['Richteren'], 'Richteren 21')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000251', 'Simson was een richter in Israël', 'Waar', ARRAY['Niet waar'], 3, 'tf', ARRAY['Richteren'], 'Richteren 13')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000252', 'Ruth werd de grootmoeder van koning Salómo', 'Niet waar', ARRAY['Waar'], 3, 'tf', ARRAY['Ruth'], 'Ruth 4')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000253', 'Samuël werd opgevoed in het heiligdom in Jeruzalem', 'Niet waar', ARRAY['Waar'], 3, 'tf', ARRAY['1 Samuël'], '1 Samuël 1:3')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000254', 'Saul was de eerste koning van Israël', 'Waar', ARRAY['Niet waar'], 2, 'tf', ARRAY['Genesis'], '1 Samuël 10:1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000255', 'Uza stierf toen hij de ark van God aanraakte', 'Waar', ARRAY['Niet waar'], 3, 'tf', ARRAY['Exodus'], '2 Samuël 6: 6 en 7')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000256', 'Absalom, Davids zoon, kwam in opstand tegen David', 'Waar', ARRAY['Niet waar'], 1, 'tf', ARRAY['2 Samuël'], '2 Samuël 13 - 18')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000257', 'Elia daagde de Baäl-priesters uit op de berg Karmel', 'Waar', ARRAY['Niet waar'], 2, 'mc', ARRAY['Genesis'], '1 Koningen 18')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000258', 'Na Salómo bleef het koninkrijk een geheel', 'Niet waar', ARRAY['Waar'], 3, 'tf', ARRAY['1 Koningen'], '1 Koningen 12')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000259', 'Elisa kreeg een dubbel deel van Elia''s geest', 'Waar', ARRAY['Niet waar'], 4, 'tf', ARRAY['Openbaring'], '2 Koningen 2: 9 en 10')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000260', 'David bracht de ark naar Jeruzalem', 'Waar', ARRAY['Niet waar'], 3, 'tf', '{}', '1 Kronieken 15')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000261', 'David bouwde de tempel in Jeruzalem', 'Niet waar', ARRAY['Waar'], 2, 'tf', ARRAY['2 Kronieken'], '2 Kronieken 2:1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000262', 'Josia vond het wetboek in de tempel', 'Waar', ARRAY['Niet waar'], 4, 'tf', ARRAY['1 Kronieken'], '2 Kronieken 34')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000263', 'Kores was de koning van de Meden', 'Niet waar', ARRAY['Waar'], 3, 'tf', ARRAY['Daniël'], 'Ezra 1:1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000264', 'Ezra leidde de eerste groep ballingen terug naar Jeruzalem', 'Niet waar', ARRAY['Waar'], 5, 'tf', ARRAY['Ezra'], 'Ezra 2: 1 en 2')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000265', 'Ezra was priester en schriftgeleerde', 'Waar', ARRAY['Niet waar'], 4, 'tf', ARRAY['Ezra'], 'Ezra 7: 6 en 11')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000266', 'De tempel werd opnieuw gebouwd tijdens het bijbelboek Ezra', 'Waar', ARRAY['Niet waar'], 4, 'tf', ARRAY['Ezra'], 'Ezra 5 en 6')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000267', 'De herbouw van de tempel werd nooit tegengehouden', 'Niet waar', ARRAY['Waar'], 2, 'tf', ARRAY['Ezra'], 'Ezra 4: 1-5')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000268', 'Nehémia was schenker aan het hof van de koning van Babel', 'Niet waar', ARRAY['Waar'], 4, 'tf', ARRAY['Nehemia'], 'Nehemia 1:11')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000269', 'Nehémia leidde de herbouw van de muren van Jeruzalem', 'Waar', ARRAY['Niet waar'], 3, 'tf', ARRAY['Nehemia'], 'Nehemia 2 en 18')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000270', 'Mórdechai was de vader van Esther', 'Niet waar', ARRAY['Waar'], 1, 'tf', ARRAY['Esther'], 'Esther 2:7')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000271', 'Het boek Esther noemt nooit de naam van God', 'Waar', ARRAY['Niet waar'], 1, 'tf', ARRAY['Esther'], 'Esther 1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000272', 'Job was een rijke man uit het land van Uz', 'Waar', ARRAY['Niet waar'], 3, 'tf', ARRAY['Job'], 'Job 1:1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000273', 'De vrouw van Job zei: "Zegen God en leef"', 'Niet waar', ARRAY['Waar'], 2, 'tf', ARRAY['Job'], 'Job 2:9')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000274', 'De Psalmen bevatten zowel lofzangen als klaagliederen', 'Waar', ARRAY['Niet waar'], 1, 'tf', ARRAY['Psalmen'], 'Psalmen')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000275', 'David was de schrijver van het bijbelboek Psalmen', 'Niet waar', ARRAY['Waar'], 2, 'tf', ARRAY['Psalmen'], 'Psalmen')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000276', 'Salómo is de belangrijkste schrijver van het bijbelboek Spreuken', 'Waar', ARRAY['Niet waar'], 2, 'tf', ARRAY['Spreuken'], 'Spreuken 1:1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000277', 'Luiheid doet de slaap wijken', 'Niet waar', ARRAY['Waar'], 3, 'tf', ARRAY['Spreuken'], 'Spreuken')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000278', 'Prediker wordt toegeschreven aan Salómo', 'Waar', ARRAY['Niet waar'], 3, 'tf', ARRAY['Prediker'], 'Prediker 1:1 en 12')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000279', 'Veel lezen is vermoeiing des geestes', 'Niet waar', ARRAY['Waar'], 3, 'tf', ARRAY['Prediker'], 'Prediker 12:12')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000280', 'De koning heeft zich een koets gemaakt van het hout van Jeruzalem', 'Niet waar', ARRAY['Waar'], 2, 'tf', ARRAY['Hooglied'], 'Hooglied 3:9')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000281', 'Trek mij, wij zullen u nalopen', 'Waar', ARRAY['Niet waar'], 1, 'tf', ARRAY['Hooglied'], 'Hooglied 1:4')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000282', 'Jesaja profeteerde over de komst van de Messias', 'Waar', ARRAY['Niet waar'], 1, 'tf', ARRAY['Jesaja'], 'Jesaja 7, 9, 11 en 53')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000283', 'Het bijbelboek Jesaja heeft 65 hoofdstukken', 'Niet waar', ARRAY['Waar'], 3, 'tf', ARRAY['Jesaja'], 'Jesaja 66')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000284', 'Jeremía schreef een boek aan de ballingen in Babel', 'Waar', ARRAY['Niet waar'], 3, 'tf', ARRAY['Jeremia'], 'Jeremia 29:1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000285', 'Jeremía zei: Ach Heere HEERE, zie, ik kan niet spreken, want ik ben oud', 'Niet waar', ARRAY['Waar'], 4, 'tf', ARRAY['Jeremia'], 'Jeremia 1:6')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000286', 'Klaagliederen werd geschreven na de verwoesting van Jeruzalem', 'Waar', ARRAY['Niet waar'], 5, 'tf', ARRAY['Klaagliederen'], 'Klaagliederen 1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000287', 'In Klaagliederen komt geen enkele hoop tot uiting', 'Niet waar', ARRAY['Waar'], 3, 'tf', ARRAY['Klaagliederen'], 'Klaagliederen 3: 21-23')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000288', 'Ezechiël predikte in Babel, ver weg van Jeruzalem', 'Waar', ARRAY['Niet waar'], 3, 'tf', ARRAY['Ezechiël'], 'Ezechiël 1:1-3')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000289', 'Ezechiël eindigt met: en ik was aldaar', 'Niet waar', ARRAY['Waar'], 5, 'tf', ARRAY['Ezechiël'], 'Ezechiël 48:35')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000290', 'Daniël werkte aan het hof van meerdere koningen in Babel', 'Waar', ARRAY['Niet waar'], 2, 'tf', ARRAY['Daniël'], 'Daniël')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000291', 'Koning Nebukadnézar maakte een beeld van goud, de hoogte was 66 ellen', 'Niet waar', ARRAY['Waar'], 3, 'tf', ARRAY['Daniël'], 'Daniël 3:1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000292', 'Hoséa roept het volk op om weder te keren tot de Heere', 'Waar', ARRAY['Niet waar'], 2, 'tf', ARRAY['Hosea'], 'Hosea 6:1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000293', 'Hoséa preekte alleen over liefde en vergeving', 'Niet waar', ARRAY['Waar'], 3, 'tf', ARRAY['Hosea'], 'Hosea')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000294', 'Joël beschrijft een sprinkhanenplaag als oordeel', 'Waar', ARRAY['Niet waar'], 5, 'tf', ARRAY['Joël'], 'Joël 1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000295', 'Egypte en Edom zullen worden gespaard, ondanks dat ze zicht tegen God hebben gekeerd', 'Niet waar', ARRAY['Waar'], 4, 'tf', ARRAY['Joël'], 'Joël 3:19')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000296', 'Amos was een herder uit Tekóa', 'Waar', ARRAY['Niet waar'], 2, 'tf', ARRAY['Amos'], 'Amos 1:1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000297', 'Amos zag in een visioen een korf met wintervruchten', 'Niet waar', ARRAY['Waar'], 3, 'tf', ARRAY['Amos'], 'Amos 8:1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000298', 'Obadja is het kortste bijbelboek uit het Oude Testament', 'Waar', ARRAY['Niet waar'], 3, 'tf', ARRAY['Obadja'], 'Obadja 1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000299', 'Obadja''s profetie richt zich tegen Israël', 'Niet waar', ARRAY['Waar'], 4, 'tf', ARRAY['Obadja'], 'Obadja 1:1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000300', 'Jona was blij met Gods barmhartigheid voor Ninevé', 'Niet waar', ARRAY['Waar'], 3, 'tf', ARRAY['Jona'], 'Jona 4')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000301', 'Jona werd door God geroepen om naar Ninevé te gaan', 'Waar', ARRAY['Niet waar'], 1, 'tf', ARRAY['Jona'], 'Jona 1:2')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000302', 'Micha voorspelde de geboorteplaats van de Messias', 'Waar', ARRAY['Niet waar'], 3, 'tf', ARRAY['Micha'], 'Micha 5:1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000303', 'Micha leefde in de tijd van koning Achab', 'Niet waar', ARRAY['Waar'], 4, 'tf', ARRAY['Micha'], 'Micha 1:1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000304', 'Nahum profeteerde tegen de stad Ninevé', 'Waar', ARRAY['Niet waar'], 3, 'tf', ARRAY['Nahum'], 'Nahum 1, 2 en 3')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000305', 'In Nahum staat: vier uw vierdagen, o Jeruzalem, betaal uw geloften', 'Niet waar', ARRAY['Waar'], 5, 'tf', ARRAY['Nahum'], 'Nahum')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000306', 'Hábakuk vermeldt: "de rechtvaardige zal door zijn geloof leven"', 'Waar', ARRAY['Niet waar'], 4, 'tf', ARRAY['Habakuk'], 'Habakuk 2:4')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000307', 'Hábakuk wordt door God gestraft vanwege zijn twijfels', 'Niet waar', ARRAY['Waar'], 4, 'tf', ARRAY['Habakuk'], 'Habakuk')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000308', 'Zefánja roept zachtmoedigen op om de Heere te zoeken', 'Waar', ARRAY['Niet waar'], 3, 'tf', ARRAY['Zefanja'], 'Sefanja 2:3')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000309', 'Het boek Zefánja heeft slechts twee hoofdstukken', 'Niet waar', ARRAY['Waar'], 4, 'tf', ARRAY['Zefanja'], 'Sefanja')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000310', 'Haggaï werkte samen met de profeet Zacharía', 'Waar', ARRAY['Niet waar'], 4, 'tf', ARRAY['Zacharia'], 'Haggaï en Zacharía')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000311', 'Haggaï moest zich richten tot Sealthiël', 'Niet waar', ARRAY['Waar'], 5, 'tf', ARRAY['Haggai'], 'Haggaï 1: 1,2 en 12')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000312', 'Zacharía bevat visioenen, waaronder die van de van de Man met het meetsnoer', 'Waar', ARRAY['Niet waar'], 4, 'tf', ARRAY['Zacharia'], 'Zacharía 2: 1-4')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000313', 'Zacharía bevat geen voorspellingen over de toekomst van Jeruzalem', 'Niet waar', ARRAY['Waar'], 4, 'tf', ARRAY['Zacharia'], 'Zacharia 1 en 9')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000314', 'Maleáchi is het laatste bijbelboek van het Nieuwe Testament', 'Niet waar', ARRAY['Waar'], 1, 'tf', '{}', 'Maleachi 1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000315', 'Maleáchi houdt een strafprediking tegen de priesters', 'Waar', ARRAY['Niet waar'], 5, 'tf', ARRAY['Maleachi'], 'Maleáchi 1:6 - 2:9')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000316', 'De Bergrede staat in het evangelie van van Mattheüs', 'Waar', ARRAY['Niet waar'], 3, 'tf', ARRAY['Matteüs'], 'Mattheüs 5 en 7')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000317', 'Mattheüs richt zich vooral op het Romeinse publiek', 'Niet waar', ARRAY['Waar'], 4, 'tf', ARRAY['Matteüs'], 'Matthéüs 1, 2, 4')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000318', 'In Mattheüs wordt Jezus vaak de "Zoon van David" genoemd', 'Waar', ARRAY['Niet waar'], 3, 'tf', ARRAY['Matteüs'], 'Matthéüs 1, 9, 21')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000319', 'Markus is het kortste evangelie', 'Waar', ARRAY['Niet waar'], 3, 'tf', ARRAY['Matteüs','Marcus','Lucas','Johannes'], 'Markus')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000320', 'Markus was een ooggetuige van het leven van Jezus', 'Niet waar', ARRAY['Waar'], 5, 'tf', '{}', 'Markus, Handelingen')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000321', 'Markus legt veel nadruk op de wonderen die Jezus deed', 'Waar', ARRAY['Niet waar'], 3, 'tf', ARRAY['Matteüs','Marcus','Lucas','Johannes'], 'Markus')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000322', 'Lukas was arts van beroep', 'Waar', ARRAY['Niet waar'], 1, 'tf', ARRAY['Lucas'], 'Kolossenzen 4:14')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000323', 'Lukas was een Joodse discipel', 'Niet waar', ARRAY['Waar'], 4, 'tf', ARRAY['Lucas'], 'Kolossenzen 4:14')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000324', 'Het evangelie van Lukas bevat de gelijkenis van de verloren zoon', 'Waar', ARRAY['Niet waar'], 2, 'tf', ARRAY['Lucas'], 'Lukas 15: 11-32')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000325', 'In Johannes noemt Jezus zichzelf "Ik ben de Goede Herder"', 'Waar', ARRAY['Niet waar'], 2, 'tf', ARRAY['Johannes'], 'Johannes 10:11')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000326', 'Johannes bevat geen gelijkenissen', 'Waar', ARRAY['Niet waar'], 5, 'tf', '{}', 'Johannes')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000327', 'Johannes noemt zichzelf vaak bij naam in zijn evangelie', 'Niet waar', ARRAY['Waar'], 3, 'tf', ARRAY['Johannes'], 'Johannes')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000328', 'Handelingen werd geschreven door Paulus', 'Niet waar', ARRAY['Waar'], 3, 'tf', ARRAY['Handelingen'], 'Handelingen 1:1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000329', 'De bekering van Paulus staat beschreven in Handelingen', 'Waar', ARRAY['Niet waar'], 2, 'tf', ARRAY['Handelingen'], 'Handelingen 9')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000330', 'In Romeinen wordt de rechtvaardiging door het geloof uitgelegd', 'Waar', ARRAY['Niet waar'], 3, 'tf', ARRAY['Romeinen'], 'Romeinen 3:21-28 en Romeinen 4')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000331', 'Paulus schreef Romeinen tijdens zijn gevangenschap in Rome', 'Niet waar', ARRAY['Waar'], 4, 'tf', ARRAY['Romeinen','Handelingen'], 'Romeinen 15 en 16')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000332', 'Korinthe is geschreven aan de christenen in Éfeze', 'Niet waar', ARRAY['Waar'], 2, 'tf', ARRAY['1 Korintiërs','2 Korintiërs'], '1 Korintiërs 1:2')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000333', 'In 1 Korinthe staat de uitnemendheid van de liefde beschreven', 'Waar', ARRAY['Niet waar'], 2, 'tf', ARRAY['1 Korintiërs'], '1 Korintiërs 13')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000334', 'Paulus schrijft 2 Korinthe terwijl hij in Korinthe verblijft', 'Niet waar', ARRAY['Waar'], 4, 'tf', ARRAY['Romeinen','2 Korintiërs'], '2 Korintiërs 7:5')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000335', 'In 2 Korinthe wekt Paulus op tot offervaardigheid', 'Waar', ARRAY['Niet waar'], 3, 'tf', ARRAY['2 Korintiërs'], '2 Korintiërs 8 en 9')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000336', 'Paulus noemt in Galaten de vruchten van de Geest', 'Waar', ARRAY['Niet waar'], 2, 'tf', ARRAY['Galaten'], 'Galaten 5:22')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000337', 'In Christus is er verschil tussen Jood en Griek, schrijft Paulus in Galaten', 'Niet waar', ARRAY['Waar'], 2, 'tf', ARRAY['Galaten'], 'Galaten 3:28')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000338', 'In Éfeze wordt de geestelijke wapenrusting beschreven', 'Waar', ARRAY['Niet waar'], 3, 'tf', ARRAY['Efeziërs'], 'Éfeze 6: 10-20')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000339', 'Paulus schrijft het bijbelboek Éfeze tijdens zijn eerste zendingsreis', 'Niet waar', ARRAY['Waar'], 3, 'tf', ARRAY['Efeziërs','Handelingen'], 'Efeziërs 3:1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000340', 'Filippenzen is gericht aan de Christenen in Filippi', 'Waar', ARRAY['Niet waar'], 4, 'tf', ARRAY['Filippenzen'], 'Fillipenzen')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000341', 'In Filippenzen staat "Want het leven is mij Christus, en het sterven is mij gewin"', 'Waar', ARRAY['Niet waar'], 2, 'tf', ARRAY['Filippenzen'], 'Filippenzen 1:21')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000342', 'In Kolossenzen worden de vruchten van de Geest beschreven', 'Niet waar', ARRAY['Waar'], 2, 'tf', '{}', 'Kolossenzen')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000343', 'Paulus kende de Christenen van Kolosse persoonlijk', 'Niet waar', ARRAY['Waar'], 4, 'tf', ARRAY['Kolossenzen'], 'Kolossenzen 1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000344', '1 Thessalonicenzen is waarschijnlijk Paulus oudste brief', 'Waar', ARRAY['Niet waar'], 4, 'tf', '{}', '1 Thessalonicenzen')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000345', 'In Thessalonicenzen roept Paulus op tot heilige wandel en broederlijke liefde', 'Waar', ARRAY['Niet waar'], 3, 'tf', ARRAY['1 Tessalonicenzen'], '1 Thessalonicenzen 4')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000346', 'In 2 Thessalonicenzen roept Paulus op tot standvastigheid', 'Waar', ARRAY['Niet waar'], 3, 'tf', '{}', '2 Thessalonicenzen 2: 13-17')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000347', '2 Thessalonicenzen is vooral een herhaling van de eerste brief', 'Niet waar', ARRAY['Waar'], 3, 'tf', '{}', '2 Thessalonicenzen')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000348', 'Paulus schrijft in 1 Timotheüs over het ambt van ouderlingen en diakenen', 'Waar', ARRAY['Niet waar'], 3, 'tf', ARRAY['1 Timoteüs'], '1 Timotheüs 3')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000349', 'Timotheüs was voorganger in Rome', 'Niet waar', ARRAY['Waar'], 4, 'tf', ARRAY['1 Timoteüs'], '1 Timotheüs')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000350', 'Paulus schrijft in 1 Timotheüs over de rol van de vrouw in de gemeente', 'Waar', ARRAY['Niet waar'], 3, 'tf', ARRAY['1 Timoteüs'], '1 Timotheüs')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000351', 'In 2 Timotheüs noemt Paulus "Al de schrift is van God ingegeven"', 'Waar', ARRAY['Niet waar'], 4, 'tf', '{}', '2 Timotheüs 3:16')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000352', 'In 2 Timotheüs verwacht Paulus dat hij binnenkort op reis zal gaan', 'Niet waar', ARRAY['Waar'], 4, 'tf', ARRAY['1 Timoteüs','2 Timoteüs'], '2 Timotheüs')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000353', 'Titus was door Paulus achtergelaten op het eiland Cyprus', 'Niet waar', ARRAY['Waar'], 4, 'tf', ARRAY['Filemon'], 'Titus 1:5')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000354', 'Titus bevat instructies voor het aanstellen van ouderlingen', 'Waar', ARRAY['Niet waar'], 3, 'tf', ARRAY['Filemon','Titus'], 'Titus 1: 5-9')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000355', 'Als nu ... zag dat zij Jakob niet baarde, zo benijdde ... haar zuster.', 'Rachel', ARRAY['Lea','Bilha','Zilpa'], 1, 'fitb', ARRAY['Genesis'], 'Genesis 30:1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000356', 'En Adam leefde ... jaar en gewon een zoon naar zijn gelijkenis, naar zijn evenbeeld, en noemde zijn naam Seth', '130', ARRAY['90','110','140'], 4, 'fitb', ARRAY['Genesis'], 'Genesis 5:3')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000357', 'Zo waren dan de dagen van Henoch ... jaar', '365', ARRAY['969','300','782'], 4, 'fitb', ARRAY['Genesis'], 'Genesis 5:23')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000358', 'Maar Noach vond ... in de ogen den Heeren', 'genade', ARRAY['barmhartigheid','vergeving','goedertierenheid'], 1, 'fitb', ARRAY['Genesis'], 'Genesis 6:8')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000359', 'En de Heere zeide: Zal ik voor ... verbergen wat Ik doe?', 'Abraham', ARRAY['Adam','Noach','Lot'], 3, 'fitb', ARRAY['Genesis'], 'Genesis 18:17')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000360', 'Mozes leidde het volk uit ... ', 'Egypte', ARRAY['Babylon','Kanaän','Assyrië'], 1, 'fitb', ARRAY['Exodus'], 'Exodus 12')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000361', 'De wet werd gegeven op de berg ... ', 'Sinaï', ARRAY['Horeb','Nebo','Moria'], 1, 'fitb', ARRAY['Exodus'], 'Exodus 19 en 20')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000362', 'En zij zullen Mij een ... maken, dat Ik in het midden van hen wone', 'heiligdom', ARRAY['tent','tabernakel','tempel'], 4, 'fitb', ARRAY['Johannes'], 'Exodus 25:8')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000363', 'Zijn snuiters en zijn ... zullen louter goud zijn', 'blusvaten', ARRAY['lampen','knopen','rieten'], 3, 'fitb', ARRAY['Exodus'], 'Exodus 25:38')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000364', 'Toen zeide hij (Mozes): Toon mij uw ... ', 'heerlijkheid', ARRAY['goedheid','genade','grootheid'], 2, 'fitb', ARRAY['Exodus'], 'Exodus 33:18')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000365', 'Breek ze in stukken en giet olie daarop: het is een ... ', 'spijsoffer', ARRAY['brandoffer','vuuroffer','dankoffer'], 4, 'fitb', ARRAY['Psalmen'], 'Leviticus 2:6')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000366', 'Het is een ... ; hij heeft zich voorzeker schuldig gemaakt aan den Heere', 'schuldoffer', ARRAY['brandoffer','dankoffer','zoenoffer'], 3, 'fitb', ARRAY['Job'], 'Leviticus 5:19')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000367', 'En de priester zal die aansteken op het altaar ten vuuroffer den Heere; het is een ... ', 'schuldoffer', ARRAY['zondoffer','brandoffer','dankoffer'], 3, 'fitb', ARRAY['Leviticus'], 'Leviticus 7:5')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000368', 'Als Mozes dat hoorde, zo was het ... in zijn ogen', 'goed', ARRAY['kwaad','recht','liefelijk'], 4, 'fitb', ARRAY['Exodus'], 'Leviticus 10:20')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000369', 'Ook zal de ... van die olie op des priesters linkerhand gieten', 'priester', ARRAY['profeet','man','overgeblevene'], 3, 'fitb', ARRAY['Leviticus'], 'Leviticus 14:26')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000370', 'Het boek Numeri begint met een telling van de ... ', 'Israëlieten', ARRAY['priesters','Levieten','vreemdelingen'], 2, 'fitb', ARRAY['Numeri'], 'Numeri 1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000371', 'Mozes dan sprak tot de kinderen Israëls, dat zij het ... houden zouden', 'pascha', ARRAY['gebod','loofhuttenfeest','geloof'], 2, 'fitb', ARRAY['Exodus','Deuteronomium'], 'Numeri 9:4')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000372', 'Van den stam van Juda ..., de zoon van Jefunne', 'Kaleb', ARRAY['Simeon','Issaschar','Benjamin'], 3, 'fitb', ARRAY['Genesis'], 'Numeri 13:6')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000373', 'En ... deed het; gelijk als de Heere hem geboden had, alzo deed hij', 'Mozes', ARRAY['Aäron','Levi','Edom'], 2, 'fitb', ARRAY['Exodus'], 'Numeri 17:11')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000374', 'Maar de kinderen van ... stierven niet', 'Korach', ARRAY['Dathan','Abiram','Eliab'], 2, 'fitb', ARRAY['Exodus'], 'Numeri 26:11')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000375', 'Mozes sprak tot het volk voordat ze het beloofde land ... ', 'binnenkwamen', ARRAY['verlieten','veroverder','vergeten'], 2, 'fitb', ARRAY['Exodus','Deuteronomium'], 'Deuteronomium 1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000376', 'Mozes stierf op de berg ... ', 'Nebo', ARRAY['Sinaï','Horeb','Hor'], 1, 'fitb', ARRAY['Exodus','Deuteronomium'], 'Deuteronomium 34:5')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000377', 'daartoe heeft de Heere tot mij gezegd: Gij zult over deze ... niet gaan', 'Jordaan', ARRAY['Landpale','Rivier','Berg'], 3, 'fitb', ARRAY['Jeremia'], 'Deuterononium 3:27')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000378', 'Een ... zult gij niet muilbanden, als hij dorst', 'os', ARRAY['stier','ram','beer'], 2, 'fitb', ARRAY['Spreuken'], 'Deuteronomium 25:4')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000379', 'Want gij zult doen wat ... is in de ogen des Heeren', 'recht', ARRAY['goed','kwaad','billijk'], 3, 'fitb', ARRAY['Deuteronomium'], 'Deuteronomium 12:28')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000380', 'Toen gebood Jozua den ... des volks, zeggende: ', 'ambtlieden', ARRAY['leiders','hoofden','zonen'], 3, 'fitb', ARRAY['Jozua'], 'Jozua')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000381', 'En Hij zeide: Neen, maar Ik ben de ... van het heir des Heeren', 'Vorst', ARRAY['Koning','Priester','Profeet'], 3, 'fitb', ARRAY['Exodus'], 'Jozua 5')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000382', 'Toen bouwde Jozua een altaar den Heere, den God Israëls, op den berg ... ', 'Ebal', ARRAY['Horeb','Sinaï','Hermon'], 3, 'fitb', ARRAY['Jozua'], 'Jozua 8:30')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000383', 'Doch de koning van ... grepen zij levend, en zij brachten hem tot Jozua', 'Ai', ARRAY['Libanon','Ferez','Gibeon'], 3, 'fitb', ARRAY['Jozua'], 'Jozua 8:23')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000384', 'Die vijf koningen zijn gevonden, verborgen in de spelonk bij ... ', 'Makkéda', ARRAY['Adullam','Machpela','de profeten'], 3, 'fitb', ARRAY['1 Samuël'], 'Jozua 10:16')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000385', 'De eerste richter van Israël was ... ', 'Othniël', ARRAY['Ehud','Samgar','Gideon'], 2, 'fitb', ARRAY['Richteren'], 'Richteren 3')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000386', ' ... nu, een vrouw die een profetes was, de huisvrouw van Lappidoth', 'Debóra', ARRAY['Rebekka','Jaël','Priscilla'], 1, 'fitb', ARRAY['1 Samuël'], 'Richteren 4:4')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000387', 'Gídeon vroeg om een teken van God met een ... ', 'wollen vlies', ARRAY['droom','visioen','stem'], 1, 'fitb', ARRAY['Richteren'], 'Richteren 6:37')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000388', 'Toen zeiden de bomen tot de wijnstok: Kom gij, wees ... over ons', 'koning', ARRAY['heerser','vorst','overste'], 3, 'fitb', ARRAY['Prediker'], 'Richteren 9:12')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000389', 'En ... beloofde den Heere een gelofte', 'Jefta', ARRAY['Jaïr','Gideon','Efraïm'], 1, 'fitb', ARRAY['Genesis'], 'Richteren 11')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000390', 'En ... , de man van Naomi stierf', 'Elimélech', ARRAY['Machlon','Chiljon','Boaz'], 2, 'fitb', ARRAY['Genesis','Ruth'], 'Ruth 1:3')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000391', 'Noemt mij niet Naómi, noemt mij ... ', 'Mara', ARRAY['Orpa','Ruth','Rachel'], 1, 'fitb', ARRAY['Ruth'], 'Ruth 1:20')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000392', 'Naómi nu had een bloedvriend van haar man, een man, geweldig van ...', 'vermogen', ARRAY['naam','geest','goedheid'], 2, 'fitb', ARRAY['Ruth'], 'Ruth 2:1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000393', 'De Heere vergelde u uw ... , en uw loon zij volkomen van de Heere', 'daad', ARRAY['loon','goedheid','geloof'], 2, 'fitb', ARRAY['Ruth'], 'Ruth 2:12')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000394', 'Als zij nu opstond ... ', 'om op te lezen', ARRAY['om op te gaan','om te arbeiden','om haar te troosten'], 3, 'fitb', ARRAY['Openbaring'], 'Ruth')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000395', 'En zij zeide tot haar: Al wat gij ... , zal ik doen', 'tot mij zegt', ARRAY['mij gebied','mij beveelt','tot mij spreekt'], 3, 'fitb', ARRAY['Ruth'], '1 Samuël')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000396', 'Elkana ging jaarlijks offeren in ... ', 'Silo', ARRAY['Jeruzalem','de tempel','de tabernakel'], 2, 'fitb', ARRAY['1 Samuël'], '1 Samuël 1:3')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000397', 'Maar wanneer een mens tegen de Heere zondigt, wie zal ... ', 'voor hem bidden', ARRAY['kunnen bestaan','dan nog zoeken','dan vinden'], 2, 'fitb', '{}', '1 Samuël 2:25')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000398', 'En ik zal Mij een getrouwen ... verwekken, die zal doen gelijk als in Mijn hart en in Mijn ziel zijn zal', 'priester', ARRAY['man','profeet','zoon'], 2, 'fitb', ARRAY['Jesaja'], '1 Samuël 2:35')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000399', 'Saul werd jaloers op David omdat hij ... ', 'meer lof ontving', ARRAY['meer rijkdom had','meer vrienden had','meer land bezat'], 2, 'fitb', ARRAY['1 Samuël','2 Samuël'], '1 Samuël 18')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000400', 'David werd koning over Israël in de stad ... ', 'Hebron', ARRAY['Jeruzalem','Bethlehem','Jericho'], 3, 'fitb', ARRAY['1 Samuël','2 Samuël'], '2 Samuël 2')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000401', 'David bracht de ark Gods naar ... ', 'Jeruzalem', ARRAY['Bethel','Hebron','Gilgal'], 2, 'mc', ARRAY['1 Samuël','2 Samuël'], '2 Samuël 6')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000402', 'De Heere zond de profeet ... tot David', 'Nathan', ARRAY['Elia','Elisa','Jesaja'], 1, 'mc', ARRAY['1 Samuël'], '2 Samuël 12:1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000403', 'Absalom vluchtte naar ... ', 'Gesur', ARRAY['Jeruzalem','Rabba','Ziklag'], 4, 'fitb', ARRAY['2 Samuël'], '2 Samuël 13:38')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000404', 'Welke vrouw zei: Behoud o koning', 'de Tekoïtische', ARRAY['de Ammonitische','de Hetitische','de Israëlitische'], 5, 'fitb', ARRAY['1 Koningen'], '2 Samuël')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000405', 'Wie wilde koning worden toen David oud was?', 'Adónia', ARRAY['Sálomo','Joab','Absalom'], 3, 'fitb', ARRAY['1 Samuël','2 Samuël'], '1 Koningen 1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000406', 'Roept mij ... , den priester', 'Zadok', ARRAY['Nathan','Benája','Jójada'], 3, 'fitb', ARRAY['Exodus'], '1 Koningen 1:32')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000407', 'en zij hebben hem doen rijden op ... des konings', 'de muilezelin', ARRAY['de ezelin','het veulen','het paard'], 3, 'fitb', ARRAY['Matteüs','Kerst'], '1 Koningen 1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000408', 'Ik ga heen in den weg der ganse aarde; zo zijt sterk en wees ... ', 'een man', ARRAY['moedig','een wachter','Godvrezende'], 4, 'fitb', ARRAY['Deuteronomium'], '1 Koningen 2:2')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000409', 'Doe dan naar uw ... , dat gij zijn grauwe haar niet met vrede in het graf laat dalen', 'wijsheid', ARRAY['woord','verstand','vermogen'], 3, 'fitb', ARRAY['Prediker'], '1 Koningen 2:6')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000410', 'De koning van Israël in de tijd van Elisa was ... ', 'Joram', ARRAY['Achab','Sálomo','David'], 4, 'fitb', ARRAY['1 Koningen','2 Koningen'], '2 Koningen 3')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000411', 'Hij dan zeide tot de jongen: ... hem tot zijn moeder', 'draag', ARRAY['breng','leid','geef'], 3, 'fitb', '{}', '2 Koningen 4:27')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000412', 'Als nu Elísa weder te ... kwam, zo was er honger in dat land', 'Gilgal', ARRAY['Sunem','Baäl-Salisa','Syrië'], 3, 'fitb', ARRAY['1 Koningen'], '2 Koningen 4:38')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000413', 'Zijn niet ... en ... , de rivieren van Damascus, beter dan alle wateren van Israël', 'Abana, Farpar', ARRAY['Eufraat, Tigris','Pison, Gihon','Jordaan, Nijl'], 5, 'fitb', ARRAY['2 Koningen'], '2 Koningen 5:12')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000414', 'dat het ijzer in het water viel, en hij riep en zeide: Ach, mijn heer; want het was ... ', 'geleend', ARRAY['gevallen','gekocht','verouderd'], 3, 'fitb', ARRAY['2 Koningen'], '2 Koningen 6:5')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000415', '1 Kronieken begint met een lijst van ... ', 'stambomen', ARRAY['koningen','profeten','priesters'], 3, 'fitb', ARRAY['1 Kronieken'], '1 Kronieken 1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000416', 'en zijn moeder had hem ... genoemd, zeggende: Want ik heb hem met smarten gebaard', 'Jabez', ARRAY['Perez','Hezron','Etam'], 1, 'fitb', ARRAY['Genesis'], '1 Kronieken 4:9')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000417', 'En in de dagen van Saul voerden zij krijg tegen de ... ; die vielen door hun hand', 'Hagarenen', ARRAY['Gadieten','Rubennieten','Hevieten'], 5, 'fitb', ARRAY['1 Samuël'], '1 Kronieken 5:10')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000418', 'Aäron nu en zijn zonen rookten op het altaar des ... en op het reukaltaar', 'brandoffers', ARRAY['spijsoffers','zondoffers','dankoffers'], 3, 'fitb', ARRAY['Exodus'], '1 Kronieken 6:49')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000419', 'Alzo stierf Saul en zijn ... zonen', 'twee', ARRAY['drie','vier','vijf'], 4, 'fitb', ARRAY['1 Samuël'], '1 Kronieken 10:13')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000420', 'Sálomo bouwde een tempel te Jeruzalem op den berg ... ', 'Moria', ARRAY['Sinaï','Karmel','Sion'], 3, 'fitb', ARRAY['1 Koningen','2 Kronieken'], '2 Kronieken 3:1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000421', 'De koning die de tempel herstelde was ... ', 'Josía', ARRAY['David','Sálomo','Achaz'], 3, 'fitb', ARRAY['1 Kronieken','2 Kronieken'], '2 Kronieken 34')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000422', 'en hij noemde de naam van den rechter ... en van den linker Boaz', 'Jachin', ARRAY['Joachin','Jakob','Jodon'], 2, 'fitb', ARRAY['Ruth'], '2 Kronieken 3:17')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000423', 'En zij brachten voor Sálomo ... uit Egypte en uit al die landen', 'paarden', ARRAY['goud','zilver','kamelen'], 3, 'fitb', ARRAY['1 Koningen'], '2 Kronieken 1:17')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000424', 'En Salomo regeerde te Jeruzalem over gans Israël ... jaar', '40', ARRAY['30','34','45'], 1, 'fitb', ARRAY['1 Koningen'], '2 Kronieken')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000425', 'De terugkeer van de ballingen begon onder koning ... ', 'Kores', ARRAY['Darius','Nebukadnézar','Xerxes'], 2, 'fitb', ARRAY['Ezra'], 'Ezra')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000426', 'Ezra leidde de terugkeer van de Israëlieten naar ... ', 'Jeruzalem', ARRAY['Egypte','Babylon','Moab'], 2, 'fitb', ARRAY['Ezra'], 'Ezra')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000427', 'En zij stelden de Levieten van ... jaar oud en daarboven om opzicht te nemen over het werk van des Heeren huis', '18', ARRAY['20','22','25'], 3, 'fitb', ARRAY['Exodus'], 'Ezra 3:8')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000428', 'De brief die gij aan ons geschikt hebt, is ... voor mij gelezen', 'duidelijk', ARRAY['onduidelijk','goed','leesbaar'], 3, 'fitb', ARRAY['Filemon'], 'Ezra 4:18')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000429', 'Toen riep ik aldaar een vasten uit aan de rivier ...', 'Ahava', ARRAY['Tigris','Eufraat','Pison'], 5, 'fitb', ARRAY['Ezra'], 'Ezra 8:21')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000430', 'Ik nu was des konings ...', 'schenker', ARRAY['bakker','priester','profeet'], 2, 'fitb', '{}', 'Nehemia 1:11')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000431', 'De muren van Jeruzalem werden herbouwd in ... dagen', '52', ARRAY['42','30','70'], 1, 'fitb', ARRAY['Ezra','Nehemia'], 'Nehemia 6:15')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000432', 'Nehémia was bezorgd over de ... van het volk', 'zonden', ARRAY['rijkdom','ziekten','gaven'], 2, 'fitb', ARRAY['Nehemia','Ezra'], 'Nehémia 1: 6,7')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000433', 'Gedenk mijner, mijn God, ten goede, alles wat ik ... gedaan heb', 'aan dit volk', ARRAY['aan U','aan hen','aan dezen'], 3, 'fitb', ARRAY['Psalmen'], 'Nehemia 5:19')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000434', 'Kom en laat ons tezamen vergaderen in de dorpen, in het dal ...', 'Ona', ARRAY['Ela','Kison','Hinnom'], 5, 'fitb', ARRAY['Psalmen'], 'Nehemia 6:2')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000435', 'Het geschiedde nu in de dagen van ...', 'Ahasvéros', ARRAY['Ammon','Moab','Mórdechai'], 2, 'fitb', ARRAY['Genesis','Exodus','Leviticus','Numeri','Deuteronomium','Jozua','Richteren','Ruth','1 Samuël','2 Samuël','1 Koningen','2 Koningen','1 Kronieken','2 Kronieken','Ezra','Nehemia','Esther'], 'Esther 1:1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000436', 'Er waren ..., groene en hemelsblauwe behangsels', 'witte', ARRAY['zwarte','gele','rode'], 3, 'fitb', ARRAY['Exodus'], 'Esther 1:6')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000437', 'in de tiende maand, welke is de maand ..., in het zevende jaar zijns rijks', 'Tebeth', ARRAY['Nisan','Sivan','Adar'], 4, 'fitb', ARRAY['1 Koningen'], 'Esther 2:16')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000438', 'Toen riep Esther ..., een van de kamerlingen des konings', 'Hatach', ARRAY['Haman','Heber','Hanan'], 4, 'fitb', ARRAY['Esther'], 'Esther 4:5')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000439', 'Bij de joden was licht en blijdschap en vreugde en ...', 'eer', ARRAY['aanzien','lof','vrolijkheid'], 3, 'fitb', '{}', 'Esther 8:16')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000440', 'En hem werden ... zonen en drie dochters geboren', '7', ARRAY['5','8','3'], 2, 'fitb', ARRAY['Genesis'], 'Job 1:2')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000441', 'In dit alles zondigde Job niet, en schreef Gode niets ... toe', 'ongerijmds', ARRAY['verkeerds','kwaads','goeds'], 2, 'fitb', ARRAY['Job'], 'Job 1:22')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000442', 'Want hij doet smart aan en Hij ...; Hij doorwondt en Zijn handen helen', 'verbindt', ARRAY['heelt','geneest','helpt'], 3, 'fitb', ARRAY['Jesaja','Kerst','Paasmaandag'], 'Job 5:18')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000443', 'Leert mij, en ik zal ... en geeft mij te verstaan waarin ik gedwaald heb', 'zwijgen', ARRAY['spreken','gaan','wandelen'], 4, 'fitb', ARRAY['Psalmen'], 'Job 6:24')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000444', 'Toen antwoordde ..., de Suhiet, en zeide:', 'Bildad', ARRAY['Elifaz','Sofar','Elihu'], 5, 'fitb', ARRAY['1 Samuël'], 'Job 25:1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000445', 'Dient den Heere met ..., en verheugt u met beving', 'vreze', ARRAY['vreugde','blijdschap','eer'], 3, 'fitb', ARRAY['Psalmen'], 'Psalmen 2:11')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000446', 'Ik lag neder en sliep; ik ontwaakte, want de de Heere ... mij', 'ondersteunde', ARRAY['hielp','redde','hoorde'], 3, 'fitb', ARRAY['Psalmen'], 'Psalmen 3:6')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000447', 'De Heere heeft mijn ... gehoord; de Heere zal mijn gebed aannemen', 'smeking', ARRAY['gebed','roepen','klacht'], 3, 'fitb', ARRAY['Psalmen'], 'Psalmen 6:10')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000448', 'O Heere, onze Heere, hoe ... is Uw Naam op de ganse aarde', 'heerlijk', ARRAY['groot','verheven','liefelijk'], 2, 'fitb', ARRAY['Psalmen'], 'Psalmen 8:10')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000449', 'Daarom zal ik U, o Heere, loven onder de heidenen, en Uw naam zal ik ...', 'psalmzingen', ARRAY['loven','eren','vrezen'], 2, 'fitb', ARRAY['Psalmen'], 'Psalmen 18:50')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000450', 'De vreze des Heeren is het beginsel der ...', 'wetenschap', ARRAY['wijsheid','vreugde','gelukzaligheid'], 2, 'fitb', ARRAY['Psalmen','Spreuken','Prediker','Hooglied'], 'Spreuken 1:7')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000451', 'Zo gij haar zoekt als zilver, en naspeurt als verborgen ...', 'schatten', ARRAY['rijkdom','bezittigen','goud'], 3, 'fitb', ARRAY['Spreuken'], 'Spreuken 2:4')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000452', 'Vertrouw op de Heere met uw ganse hart, en steun op uw ... niet', 'verstand', ARRAY['hart','vermogen','kennis'], 2, 'fitb', ARRAY['Psalmen','Spreuken'], 'Spreuken 3:5')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000453', 'Ik onderwijs u in den weg der wijsheid; ik doe u treden in ... sporen', 'rechte', ARRAY['effen','goede','vlakke'], 3, 'fitb', ARRAY['Spreuken'], 'Spreuken 4:11')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000454', 'Wentel uw ... op den Heere, en uw gedachten zullen bevestigd worden', 'werken', ARRAY['weg','gedachten','ogen'], 3, 'fitb', ARRAY['Psalmen'], 'Spreuken 16:3')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000455', 'Alles heeft een ... tijd', 'bestemde', ARRAY['gezette','goede','bepaalde'], 2, 'fitb', ARRAY['Prediker'], 'Prediker 3:1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000456', 'De schrijver van Prediker wordt toegeschreven aan ...', 'Sálomo', ARRAY['David','Mozes','Jesaja'], 1, 'fitb', ARRAY['Prediker'], 'Prediker 1:1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000457', 'Ook heeft zij de ... niet gezien, noch bekend; zij heeft meer rust dan hij', 'zon', ARRAY['maan','sterren','wateren'], 3, 'fitb', ARRAY['Prediker'], 'Prediker 6:5')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000458', 'en wie een muur doorbreekt, een ... zal hem bijten', 'slang', ARRAY['schorpioen','leeuw','spin'], 2, 'fitb', ARRAY['Spreuken'], 'Prediker 10:8')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000459', 'en veel lezen is vermoeiing des ...', 'vleses', ARRAY['geestes','verstands','ogen'], 2, 'fitb', ARRAY['Spreuken'], 'Prediker 12:12')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000460', 'Trek mij, wij zullen u ...', 'nalopen', ARRAY['vinden','nagaan','zoeken'], 2, 'fitb', ARRAY['Hooglied'], 'Hooglied 1:4')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000461', 'De balken onzer huizen zijn ...', 'ceders', ARRAY['cipressen','van olijfhout','van acaciahout'], 3, 'fitb', ARRAY['Psalmen','Prediker'], 'Hooglied 1:17')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000462', 'Want zie, de ... is voorbij;', 'winter', ARRAY['zomer','plasregen','schaduw'], 1, 'fitb', '{}', 'Hooglied 2:11')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000463', 'Eer ik het wist, zette Mij Mijn ziel op de wagens van Mijn ... volk', 'vrijwillig', ARRAY['gewillig','liefelijk','wederstrevig'], 3, 'fitb', ARRAY['Jesaja'], 'Hooglied 6:12')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000464', 'Salomo had een wijngaard te ...', 'Baäl-Hamon', ARRAY['Hamon','Baäl-Gad','Kirjat-Baäl'], 5, 'fitb', ARRAY['1 Koningen','2 Kronieken'], 'Hooglied 8:11')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000465', 'Het overblijfsel zal wederkeren, het overblijfsel ..., tot den sterken God', 'Jakobs', ARRAY['Israëls','Abrahams','Davids'], 4, 'fitb', ARRAY['Jesaja'], 'Jesaja 10:21')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000466', 'De koe en de ... zullen tezamen weiden', 'berin', ARRAY['leeuw','wolf','slang'], 3, 'fitb', ARRAY['Genesis'], 'Jesaja 11:7')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000467', 'Psalmzingt de Heere, want Hij heeft ... dingen gedaan', 'heerlijke', ARRAY['grote','goede','Goddelijke'], 3, 'fitb', ARRAY['Psalmen'], 'Jesaja 12:5')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000468', 'en de profeet Jesaja, de zoon van ..., kwam tot hem', 'Amoz', ARRAY['Hizkia','Achaz','Juda'], 3, 'fitb', ARRAY['Jesaja'], 'Jesaja 38:1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000469', 'O Sion, gij ... van goede boodschap', 'verkondigster', ARRAY['brenger','gever','uitdrager'], 3, 'fitb', ARRAY['Psalmen'], 'Jesaja 40:9')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000470', 'Toen zeide ik: Ach Heere Heere, zie, ik kan niet spreken, want ik ben ...', 'jong', ARRAY['oud','onervaren','afhankelijk'], 3, 'fitb', ARRAY['Jesaja'], 'Jeremia 1:6')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000471', 'want Ik ben met u, om u te ..., spreekt de Heere', 'redden', ARRAY['helpen','steunen','horen'], 3, 'fitb', '{}', 'Jeremia 1:8')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000472', 'Er zal mij een ... komen die hun te sterk zal zijn', 'wind', ARRAY['storm','vloed','overvloed'], 3, 'fitb', '{}', 'Jeremia 4:12')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000473', 'Zie, gij vertrouwt op valse ..., die geen nut doen', 'woorden', ARRAY['daden','gedachten','leraars'], 4, 'fitb', ARRAY['Jesaja'], 'Jeremia 7:8')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000474', 'Gij zijt mijn ... ten dage des kwaads', 'Toevlucht', ARRAY['Beschermer','God','Hulpe'], 3, 'fitb', ARRAY['Psalmen'], 'Jeremia 17:17')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000475', 'Mijn ziel gedenkt er wel ... aan, en zij bukt zich neder in mij', 'terdege', ARRAY['voortdurend','gedurig','gestaag'], 3, 'fitb', ARRAY['Psalmen'], 'Klaagliederen 3:20')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000476', 'Het zijn de ... des Heeren, dat wij niet vernield zijn', 'goedertierenheden', ARRAY['gerechtigheden','goedheden','rechtvaardigheden'], 3, 'fitb', ARRAY['Romeinen'], 'Klaagliederen 3:22')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000477', 'Zij zijn allen morgen nieuw, Uw ... is groot', 'trouw', ARRAY['goedheid','macht','liefde'], 3, 'fitb', ARRAY['Psalmen'], 'Klaagliederen 3:23')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000478', 'Want hij plaagt en bedroeft des mensen kinderen niet ...', 'van harte', ARRAY['met lust','altoos','in eeuwigheid'], 3, 'fitb', ARRAY['Job'], 'Klaagliederen 3:33')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000479', 'Gij hebt al hun ... gezien, al hun gedachten tegen mij', 'wraak', ARRAY['boosheid','zonden','gedachten'], 4, 'fitb', ARRAY['Jeremia'], 'Klaagliederen 3:60')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000480', 'Toen opende ik mijn mond, en Hij gaf mij die rol te ...', 'eten', ARRAY['lezen','overdenken','zien'], 3, 'fitb', ARRAY['Openbaring'], 'Ezechiël 3:2')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000481', 'Mensenkind, zet uw aangezicht tegen de bergen ...', 'Israëls', ARRAY['Cherubs','rondom Jeruzalem','Sions'], 3, 'fitb', ARRAY['Ezechiël'], 'Ezechiël 6:2')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000482', 'En Hij zeide tot mij: Mensenkind, graaf nu in dien ...', 'wand', ARRAY['aarde','muur','rivier'], 3, 'fitb', ARRAY['Ezechiël'], 'Ezechiël 8:8')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000483', 'En de bewoonde steden zullen ... worden', 'woest', ARRAY['droog','verlaten','verwoest'], 3, 'fitb', ARRAY['Jesaja'], 'Ezechiël 12:20')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000484', 'Ofschoon Noach, Daniël en ... in het midden van hetzelve waren', 'Job', ARRAY['Amos','Jona','David'], 4, 'fitb', ARRAY['Daniël'], 'Ezechiël 14:20')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000485', 'en dat men hen onderwees in de spraak der ...', 'Chaldeeën', ARRAY['volkeren','Chaldiërs','Judeeën'], 2, 'fitb', ARRAY['Exodus'], 'Daniël 1:4')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000486', 'en Daniël noemde hij ...', 'Béltsazar', ARRAY['Sadrach','Mesach','Abed-nego'], 1, 'fitb', ARRAY['Daniël'], 'Daniël 1:7')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000487', 'Beproef toch uw knechten ... dagen lang, en men geve ons van het gezaaide te eten en water te drinken', '10', ARRAY['6','7','14'], 2, 'fitb', ARRAY['Genesis'], 'Daniël 1:12')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000488', 'Daarom ging Daniël in tot..., dien de koning gesteld had om de wijzen van Babel om te brengen', 'Arioch', ARRAY['Melzar','Sadrach','Ariël'], 2, 'fitb', ARRAY['Daniël'], 'Daniël 2:24')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000489', '..., uw koninkrijk is verdeeld', 'Peres', ARRAY['Tekel','Mene','Upharsin'], 2, 'fitb', ARRAY['1 Koningen','2 Samuël'], 'Daniël 5:28')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000490', 'en in de dagen van ..., zoon van Joas, koning van Israël', 'Jeróbeam', ARRAY['Jotham','Achaz','Hizkia'], 5, 'fitb', ARRAY['1 Koningen','2 Koningen','1 Kronieken','2 Kronieken'], 'Hosea 1:1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000491', 'Noem zijn naam...; want gijlieden zijt Mijn volk niet', 'Lo-Ammi', ARRAY['Lo-Ruchama','Jizreël','Gomer'], 5, 'fitb', ARRAY['Jeremia'], 'Hosea 1:9')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000492', 'Efraïm is vergezeld met de..., laat hem varen', 'afgoden', ARRAY['broederen','priesters','profeten'], 3, 'fitb', ARRAY['Genesis'], 'Hosea 4:17')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000493', 'Komt en laat ons... tot den Heere', 'wederkeren', ARRAY['terugkeren','opzien','bidden'], 3, 'fitb', ARRAY['Psalmen'], 'Hosea 6:1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000494', 'Wie is...? Die versta deze dingen', 'wijs', ARRAY['verstandig','recht','opmerkzaam'], 3, 'fitb', ARRAY['Johannes'], 'Hosea 14:10')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000495', 'Het woord den Heeren dat geschied is tot Joël, den zoon van...', 'Pethuël', ARRAY['Paltiël','Petahja','Jojada'], 4, 'fitb', ARRAY['Hooglied'], 'Joël 1:1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000496', 'Blaast de bazuin te...', 'Sion', ARRAY['Jeruzalem','Sichem','Jericho'], 1, 'fitb', ARRAY['Numeri'], 'Joël 2:1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000497', 'Vrees niet, o land; verheug u en zijt...', 'blijde', ARRAY['verheugd','blijmoedig','heilig'], 3, 'fitb', ARRAY['Jesaja'], 'Joël 2:21')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000498', 'al wie de Naam des Heeren zal aanroepen, zal ... worden', 'behouden', ARRAY['zalig','bewaard','bekeerd'], 3, 'fitb', ARRAY['Romeinen'], 'Joël 2:32')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000499', 'En ... zal worden tot een wildernis en woestheid', 'Egypteland', ARRAY['Juda','Edom','Jeruzalem'], 4, 'fitb', ARRAY['Jeremia'], 'Ezechiël 29:9')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000500', 'alzo dat die akker in hun eigen taal genoemd wordt ... , dat is een akker des bloeds', 'Akeldama', ARRAY['Kedron','Akkad','Akeldam'], 2, 'fitb', ARRAY['Genesis'], 'Handelingen 1:19')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000501', 'Wie is de vader van Jozef, de man van Maria (Jezus moeder)?', 'Jakob', ARRAY['Eliud','Mattan','Eleázar'], 4, 'mc', ARRAY['Matteüs'], 'Mattheüs 1:16')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000502', 'Hoeveel dagen en nachten vastte Jezus in de woestijn?', '40', ARRAY['7','10','30'], 1, 'mc', '{}', 'Mattheüs 4:2')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000503', 'Jezus noemt zijn volgelingen ''het zout der aarde''. Wat zegt Jezus dat er gebeurt als het zout zijn kracht verliest?', 'Het wordt buitengeworpen en van de mensen vertreden', ARRAY['Het is tot genezing','Het wordt gezuiverd','Het veranderd smakeloos'], 2, 'mc', ARRAY['Matteüs'], 'Mattheüs 5:13')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000504', 'Wat is de eerste zaligspreking in de Bergrede?', 'Zalig zijn de armen van geest', ARRAY['Zalig zijn die treuren','Zalig zijn de zachtmoedigen','Zalig zijn de barmhartigen'], 3, 'mc', ARRAY['Matteüs'], 'Mattheüs 5:3')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000505', 'Wat doet Jezus eerst nadat hij van de berg is afgedaald?', 'Hij geneest een melaatse', ARRAY['Hij onderwijst in de synagoge','Hij gaat opnieuw prediken','Hij roept een discipel'], 4, 'mc', ARRAY['Matteüs','Lucas','Kerst'], 'Mattheüs 8:1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000506', 'Welke discipel liep op het water naar Jezus toe?', 'Petrus', ARRAY['Johannes','Thomas','Judas'], 1, 'mc', '{}', 'Matthéüs  14: 28,29')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000507', 'Wie vroeg aan Jezus of Hij hen zegt of Hij de Christus, de Zoon van God is?', 'Kájafas', ARRAY['Judas','Pilatus','Herodes'], 4, 'mc', ARRAY['Johannes'], 'Mattheüs 26:63')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000508', 'Wat gebeurde er toen Jezus werd gedoopt?', 'De hemelen werden geopend', ARRAY['De aarde beefde','De zon verduisterde','Een engel verscheen'], 2, 'mc', ARRAY['Matteüs','Kerst'], 'Mattheüs 3:16')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000509', 'Wie is de eerst genoemde discipel die Jezus riep?', 'Petrus', ARRAY['Johannes','Jakobus','Andreas'], 2, 'mc', '{}', 'Mattheüs 4:18')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000510', 'Wat zei Jezus toen hij op het water liep naar de discipelen toe?', 'Ik ben het, vreest niet', ARRAY['Vreest niet, Ik ben het','Volg mij','Ik ben de Weg, vreest niet'], 3, 'mc', ARRAY['Matteüs','Lucas'], 'Mattheüs 14:27')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000511', 'Voor hoeveel zilveren penningen werd Jezus verraden?', '30', ARRAY['20','40','10'], 1, 'mc', '{}', 'Mattheüs 26:15')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000512', 'Wie vroeg aan Jezus: Zijt Gij de Koning der Joden?', 'Pilatus', ARRAY['Kájafas','Herodes','De Hogepriester'], 3, 'mc', ARRAY['Matteüs'], 'Mattheüs 27:11')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000513', 'Toen Jezus stierf gebeurden er een aantal dingen. Welke hoort er niet bij?', 'Het voorhangsel scheurde van boven tot beneden', ARRAY['De aarde beefde','Het werd 3 uur lang donker','De steenrotsen scheurden'], 3, 'mc', ARRAY['Matteüs','Marcus','Lucas','Johannes','Handelingen','Kerst','Pasen','Pinksteren','Hemelvaart','Goede Vrijdag','Stille Zaterdag','Paasmaandag','Pinkstermaandag'], 'Matthéüs 27: 51, 52')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000514', 'Wie zei: Heb toch niet te doen met dien Rechtvaardige; want ik heb veel geleden in den droom om Zijnentwil?', 'De vrouw van Pilatus', ARRAY['De vrouw van Kájafas','De vrouw van Herodes','De vrouw Judas'], 4, 'mc', ARRAY['Genesis'], 'Mattheüs 27:19')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000515', 'Wie vond(en) het lege graf?', 'Maria Magdaléna en de de andere Maria', ARRAY['Maria Magdaléna','Maria, de moeder van Jezus','Petrus en Johannes'], 2, 'mc', ARRAY['Openbaring'], 'Mattheüs 28:1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000516', 'Wat zei de engel als eerste tegen de vrouwen bij het graf?', 'Vreest gijlieden niet', ARRAY['Hij is opgestaan','Hij is hier niet; want Hij is opgestaan','Gaat haastelijk heen'], 3, 'mc', ARRAY['Openbaring'], 'Mattheüs 28:5')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000517', 'Wat gaf Jezus aan zijn discipelen na Zijn opstanding?', 'Een opdracht', ARRAY['De Heilige Geest','Een zegen','Een belofte'], 2, 'mc', ARRAY['Handelingen','Pasen','Hemelvaart'], 'Mattheüs 28:19')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000518', 'Wie was de vierde zoon van Jakob?', 'Juda', ARRAY['Levi','Dan','Naftali'], 2, 'mc', ARRAY['Genesis'], 'Genesis 29:35')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000519', 'Wat was de kleur van het tweede paard in Openbaring?', 'Rood', ARRAY['Wit','Zwart','Vaal'], 4, 'mc', ARRAY['Openbaring'], 'Openbaring 6:4')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000520', 'Welke discipel was er niet bij op berg der verheerlijking?', 'Andréas', ARRAY['Petrus','Johannes','Jakobus'], 1, 'mc', ARRAY['Matteüs','Marcus','Lucas'], 'Lukas 9:28')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000521', 'Hoeveel mensen gingen er in de ark van Noach?', '8', ARRAY['6','4','10'], 1, 'mc', ARRAY['Genesis'], 'Genesis 8:16')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000522', 'Wie was geen zoon van Noach?', 'Gomer', ARRAY['Sem','Cham','Jafeth'], 1, 'mc', ARRAY['Genesis'], 'Genesis 9:18')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000523', 'Van wie was Dan een zoon?', 'Bilha', ARRAY['Rachel','Lea','Zilpa'], 4, 'mc', ARRAY['Genesis'], 'Genesis 30:5')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000524', 'Wie was de vierde dochter van Zeláfead?', 'Milka', ARRAY['Noa','Hogla','Tirza'], 4, 'mc', ARRAY['Numeri'], 'Numeri 27:1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000525', 'Wie nam het op voor Job?', 'Elihu', ARRAY['Bildad','Zofar','Elifaz'], 3, 'mc', ARRAY['Job'], 'Job 32:2')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000526', 'Welke koning viel door een tralie in zijn opperzaal?', 'Aházia', ARRAY['Joram','Azária','Joas'], 4, 'mc', ARRAY['1 Koningen'], '2 Koningen 1:2')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000527', 'Wie was de moeder van Absalom?', 'Máächa', ARRAY['Haggith','Ahinóam','Abígaïl'], 4, 'mc', ARRAY['2 Samuël'], '2 Samuël 3:3')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000528', 'Wat was de zevende plaag in Egypte?', 'Hagel en vuur', ARRAY['Kikvorsen','Veepest','Luizen'], 1, 'mc', ARRAY['Exodus'], 'Exodus 9:24')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000529', 'Wie was de hofmeester van koning Hizkía?', 'Eljakim', ARRAY['Hilkía','Sebna','Joah'], 3, 'mc', ARRAY['1 Koningen','2 Koningen'], 'Jesaja 36:3')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000530', 'Hoeveel zonen had Gídeon?', '70', ARRAY['30','50','60'], 3, 'mc', ARRAY['Richteren'], 'Richteren 8:30')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000531', 'Welke richter was linkshandig?', 'Ehud', ARRAY['Jeftha','Samgar','Othniël'], 3, 'mc', ARRAY['Richteren'], 'Richteren 3:15')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000532', 'Waar moest de kandelaar van gemaakt worden?', 'Goud', ARRAY['Zilver','Koper','IJzer'], 1, 'mc', ARRAY['Exodus'], 'Exodus 25:31')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000533', 'Wie was de derde zoon van Aäron?', 'Eleázar', ARRAY['Nadab','Abíhu','Ithamar'], 5, 'mc', ARRAY['Leviticus'], 'Exodus 6:22')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000534', 'Welke gemeente had een geopende deur? Johannes schreef er een brief aan.', 'Filadélfia', ARRAY['Sardis','Smyrna','Éfeze'], 4, 'mc', ARRAY['Openbaring','Johannes'], 'Openbaring 3:7')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000535', 'Wie was geen vrouw van Ezau?', 'Zilpa', ARRAY['Ada','Aholibáma','Basmath'], 3, 'mc', ARRAY['Genesis'], 'Genesis 36: 2,3')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000536', 'Wie was de vierde zoon van Abraham en Ketûra?', 'Midian', ARRAY['Jisbak','Medan','Zimran'], 5, 'mc', ARRAY['Genesis'], 'Genesis 25:2')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000537', 'Wie wilde Jozef uit de kuil halen?', 'Ruben', ARRAY['Simeon','Juda','Zebulon'], 2, 'mc', ARRAY['Genesis'], 'Genesis 37:29')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000538', 'Wie stond borg voor Benjamin toen ze bij Jozef waren?', 'Juda', ARRAY['Simeon','Ruben','Naftali'], 1, 'mc', ARRAY['Genesis'], 'Genesis 43:8-9')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000539', 'Welke zoon van Jakob zal aan de haven der zeeën wonen?', 'Zebulon', ARRAY['Ruben','Gad','Aser'], 4, 'mc', ARRAY['Genesis'], 'Genesis 49:13')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000540', 'Welke profeet voorspelde een zware sprinkhanenplaag?', 'Joël', ARRAY['Hoséa','Micha','Nahum'], 4, 'mc', ARRAY['Jona'], NULL)
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000541', 'Wie was de vader van Abram?', 'Terah', ARRAY['Haran','Nahor','Serug'], 2, 'mc', ARRAY['Genesis'], 'Genesis 11:26')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000542', 'Hoeveel sikkelen zilver moest Abraham aan Efron geven voor voor Sara''s graf?', '400', ARRAY['200','500','600'], 4, 'mc', ARRAY['Genesis'], 'Genesis 23:16')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000543', 'Hoe oud was Abraham toen hij stierf?', '175', ARRAY['150','155','180'], 2, 'mc', ARRAY['Genesis'], 'Genesis 25:7')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000544', 'Wie moest er bij Jozef in Egypte blijven?', 'Simeon', ARRAY['Ruben','Juda','Zebulon'], 2, 'mc', ARRAY['Genesis'], 'Genesis 42:24')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000545', 'Wie was de eerstgeboren zoon van Ruben?', 'Hanoch', ARRAY['Pallu','Hezron','Charmi'], 4, 'mc', ARRAY['Genesis'], 'Genesis 46:9')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000546', 'Jakob werd gebalsemd, hoeveel dagen?', '40', ARRAY['20','30','60'], 3, 'mc', ARRAY['Genesis'], 'Genesis 50:3')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000547', 'Hoeveel dagen was er rouw bij de begrafenis van Jakob bij de Jordaan?', '7', ARRAY['3','5','10'], 3, 'mc', ARRAY['Genesis'], 'Genesis 50:10')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000548', 'Hoe lang leefde Jozef?', '110', ARRAY['120','130','150'], 2, 'mc', ARRAY['Genesis'], 'Genesis 50:26')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000549', 'Wat was de derde plaag in Egypte?', 'Luizen', ARRAY['Kikvorsen','Ongedierte','Veepest'], 2, 'mc', ARRAY['Exodus'], 'Exodus 8:16')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000550', 'Hoeveel dagen duisternis was er tijdens de 9e plaag in Egypte?', '2', ARRAY['3','4','6'], 1, 'mc', ARRAY['Exodus'], 'Exodus 10:22')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000551', 'Welk gebod heeft een belofte?', '5', ARRAY['2','3','6'], 1, 'mc', ARRAY['Exodus','Deuteronomium'], 'Exodus 20:12')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000552', 'Op welke rij van de borslap van Aäron waren een hyacint, agaat en amethist?', '3', ARRAY['1','2','4'], 1, 'mc', ARRAY['Exodus'], 'Exodus 28:19')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000553', 'Jesaja was een profeet in het koninkrijk van Juda', 'Waar', ARRAY['Niet waar'], 4, 'tf', ARRAY['Jesaja'], 'Jesaja 1:1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000554', 'Jesaja had een visioen van de Heere, staande voor hogen en verheven troon', 'Niet waar', ARRAY['Waar'], 4, 'tf', ARRAY['Jesaja'], 'Jesaja 6:1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000555', 'Jesaja was een tijdgenoot van koning Saul', 'Niet waar', ARRAY['Waar'], 3, 'tf', ARRAY['Jesaja'], 'Jesaja 1:1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000556', 'Jesaja profeteerde over nieuwe hemelen en een nieuwe aarde', 'Waar', ARRAY['Niet waar'], 3, 'tf', ARRAY['Jesaja'], 'Jesaja 65:17')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000557', 'Jeremía was een profeet in het koninkrijk van Juda', 'Waar', ARRAY['Niet waar'], 4, 'tf', ARRAY['Jeremia'], 'Jeremia 1:1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000558', 'Jeremía profeteerde alleen tijdens de regering van koning David', 'Niet waar', ARRAY['Waar'], 3, 'tf', ARRAY['Jeremia'], 'Jeremia 1:3')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000559', 'Pashur nam Jeremía gevangen', 'Waar', ARRAY['Niet waar'], 4, 'tf', ARRAY['Jeremia'], 'Jeremia 20:2')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000560', 'Jeremía schrijft in zijn brief: Dan zult gij Mij aanroepen en heengaan en tot Mij bidden; en Ik zal naar u niet horen', 'Niet waar', ARRAY['Waar'], 3, 'tf', ARRAY['Jeremia'], 'Jeremia 29:12')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000561', 'Ezechiël was een profeet in ballingschap in Babel', 'Waar', ARRAY['Niet waar'], 3, 'tf', ARRAY['Ezechiël'], 'Ezechiël 1: 1-3')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000562', 'Ezechiël werd tot een wachter gesteld over het huis van Jeruzalem', 'Niet waar', ARRAY['Waar'], 4, 'tf', ARRAY['Ezechiël'], 'Ezechiël 3:17')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000563', 'Ezechiël werd geroepen om de zonden van Israël te verkondigen', 'Waar', ARRAY['Niet waar'], 3, 'tf', ARRAY['Ezechiël'], 'Ezechiël 2: 3-5')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000564', 'Joël voorspelde de uitstorting van de Heilige Geest', 'Waar', ARRAY['Niet waar'], 3, 'tf', ARRAY['Joël'], 'Joël 2: 28, 29')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000565', 'Joël eindigt met een waarschuwing voor Israëls vijanden', 'Niet waar', ARRAY['Waar'], 4, 'tf', ARRAY['Joël'], 'Joël 3: 18-21')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000566', 'Hoséa sprak over de terugkeer van het volk naar God', 'Waar', ARRAY['Niet waar'], 4, 'tf', ARRAY['Hosea'], 'Hoséa 6: 1-2')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000567', 'Hoséa schrijft dat Assur ons niet zal behouden, wij zullen rijden op paarden', 'Niet waar', ARRAY['Waar'], 3, 'tf', ARRAY['Hosea'], 'Hosea 14:4')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000568', 'Amos was een ossenherder en las wilde vijgen af (plukker)', 'Waar', ARRAY['Niet waar'], 3, 'tf', ARRAY['Amos'], 'Amos 7:14')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000569', 'Amos voorspelde de verwoesting van Jeruzalem', 'Niet waar', ARRAY['Waar'], 3, 'tf', ARRAY['Amos'], 'Amos 9: 8-10')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000570', 'De brief aan de Romeinen is de kortste van Paulus'' brieven', 'Niet waar', ARRAY['Waar'], 3, 'tf', ARRAY['Romeinen'], 'Romeinen 16')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000571', 'Paulus spreekt over het nieuwe leven door de Heilige Geest', 'Waar', ARRAY['Niet waar'], 3, 'tf', ARRAY['Romeinen','1 Korintiërs','2 Korintiërs','Galaten','Efeziërs','Kolossenzen','1 Tessalonicenzen','2 Tessalonicenzen'], 'Romeinen 8')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000572', 'Paulus schrijft de brief aan de Galaten vanwege hun trouw aan het evangelie', 'Niet waar', ARRAY['Waar'], 4, 'tf', ARRAY['Galaten'], 'Galaten 1: 6,7')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000573', 'De Galaten worden opgeroepen om elkaars lasten te dragen en zo de wet van Christus te vervullen', 'Waar', ARRAY['Niet waar'], 3, 'tf', ARRAY['Galaten'], 'Galaten 6:2')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000574', 'Paulus behandelt in de brief aan Éfeze de eenheid van de gemeente', 'Waar', ARRAY['Niet waar'], 3, 'tf', ARRAY['Efeziërs','Kerst','Pasen','Pinksteren','Hemelvaart','Goede Vrijdag','Stille Zaterdag','Paasmaandag','Pinkstermaandag'], 'Éfeze 4: 3-6')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000575', 'Paulus spreekt in de brief aan Éfeze over de liefde van Christus', 'Waar', ARRAY['Niet waar'], 3, 'tf', ARRAY['Efeziërs'], 'Éfeze 3: 17-19')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000576', 'Paulus schreef de brief aan de Filippenzen terwijl hij in vrijheid was', 'Niet waar', ARRAY['Waar'], 4, 'tf', ARRAY['Filippenzen'], 'Filippenzen 1:7')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000577', 'Paulus schrijft in Filippenzen: Ik vermag alle dingen door Christus, Die mij kracht geeft', 'Waar', ARRAY['Niet waar'], 3, 'tf', ARRAY['Filippenzen'], 'Filippenzen 4:13')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000578', 'Paulus waarschuwt in Kolossenzen voor valse leringen', 'Waar', ARRAY['Niet waar'], 3, 'tf', ARRAY['Kolossenzen'], 'Kolossenzen 2:8')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000579', 'Paulus schrijft Kolossenzen terwijl hij in vrijheid is', 'Niet waar', ARRAY['Waar'], 4, 'tf', ARRAY['Kolossenzen'], 'Kolossenzen 4:10')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000580', 'En zeide tot ... : Kunt gij dan niet één uur met mij waken?', 'Petrus', ARRAY['Johannes','Jakobus','Matthéüs'], 2, 'fitb', '{}', 'Mattheüs 26:40')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000581', 'En al het volk zeide: Amen; en het ... den Heere', 'loofde', ARRAY['dankte','prijsde','eerde'], 3, 'fitb', '{}', '1 Kronieken 16:36')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000582', 'In welk bijbelboek staat Davids psalm?', '1 Kronieken', ARRAY['1 Koningen','2 Koningen','2 Kronieken'], 5, 'mc', '{}', '1 Kronieken 16: 7-36')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000583', 'Welke discipel zei: Gij hebt de woorden des eeuwigen levens?', 'Petrus', ARRAY['Andréas','Johannes','Jakobus'], 4, 'mc', '{}', 'Johannes 6:68')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000584', 'Welke discipel zei: Laat ons ook gaan, opdat wij met hem sterven?', 'Thomas', ARRAY['Johannes','Petrus','Jakobus'], 1, 'mc', '{}', 'Johannes 11:16')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000585', 'Welke discipel zei: Heere, wij weten niet waar Gij heengaat, en hoe kunnen wij de weg weten?', 'Thomas', ARRAY['Lukas','Andréas','Johannes'], 4, 'mc', '{}', 'Johannes 14:5')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000586', 'Welke discipel zei: Heere, toon ons de Vader, en het is ons genoeg?', 'Filippus', ARRAY['Andréas','Johannes','Jakobus'], 3, 'mc', '{}', 'Johannes 14:8')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000587', 'Na het pascha wisten Jozef en Maria niet waar Jezus was. Na hoeveel dagen vonden zij  Hem in Jeruzalem?', 'Drie', ARRAY['Één','Twee','Vier'], 1, 'mc', '{}', 'Lukas 2:46')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000588', 'En Jezus zei tot hen: Hoeveel broden hebt gij (2e wonderbare spijziging)?', 'Zeven', ARRAY['Vijf','Drie','Tien'], 3, 'mc', '{}', 'Mattheüs 15:34')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000589', 'Wie zei: Gij zijt de Christus, de Zoon des levenden Gods?', 'Petrus', ARRAY['Johannes','Lukas','Thomas'], 2, 'mc', '{}', 'Mattheüs 16:16')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000590', 'Wat was de 2e gelijkenis die Jezus uitsprak in Lukas 15?', 'De verloren penning', ARRAY['Het verloren schaap','De verloren zoon','De barmhartige Samaritaan'], 3, 'mc', '{}', 'Lukas 15:8-10')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000591', 'Hoeveel mannen had de Samaritaanse vrouw gehad?', 'Vijf', ARRAY['Drie','Zes','Zeven'], 2, 'mc', '{}', 'Johannes 4:18')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000592', 'Aan welke poort van Jeruzalem is er een badwater?', 'De Schaapspoort', ARRAY['De Oostpoort','De Vispoort','De Leeuwenpoort'], 4, 'mc', '{}', 'Johannes 5:2')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000593', 'Hoeveel dagen duurde het Loofhuttenfeest?', 'Zeven', ARRAY['Vijf','Vier','Tien'], 1, 'mc', '{}', 'Leviticus 23:34')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000594', 'Waar kwamen de wijzen vandaan?', 'Oosten', ARRAY['Noorden','Zuiden','Westen'], 1, 'mc', '{}', 'Mattheüs 2:1')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000595', 'De derde verzoeking in de woestijn was: de duivel aanbidden', 'Waar', ARRAY['Niet waar'], 3, 'tf', '{}', 'Mattheüs 4:9')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000596', 'De vijfde zaligspreking is: Zalig zijn de reinen van hart', 'Niet waar', ARRAY['Waar'], 4, 'tf', '{}', 'Mattheüs 5:7')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

INSERT INTO questions (id, vraag, juiste_antwoord, foute_antwoorden, moeilijkheidsgraad, type, categories, biblical_reference)
VALUES ('000597', 'Hoeveel korven brood bleven er over na de eerste wonderbare spijziging?', 'Twaalf', ARRAY['Vijf','Twee','Tien'], 2, 'mc', '{}', 'Mattheüs 14:20')
ON CONFLICT (id) DO UPDATE SET
    vraag = EXCLUDED.vraag,
    juiste_antwoord = EXCLUDED.juiste_antwoord,
    foute_antwoorden = EXCLUDED.foute_antwoorden,
    moeilijkheidsgraad = EXCLUDED.moeilijkheidsgraad,
    type = EXCLUDED.type,
    categories = EXCLUDED.categories,
    biblical_reference = EXCLUDED.biblical_reference,
    updated_at = NOW();

-- Total questions processed: 597