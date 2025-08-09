<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update BijbelQuiz</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #2563EB;
            --secondary: #7C3AED;
            --tertiary: #DC2626;
            --surface: #FAFAFA;
            --surface-container: #F8FAFC;
            --on-surface: #0F172A;
            --outline: #E2E8F0;
            --card-radius: 20px;
            --button-radius: 16px;
            --shadow: 0 4px 24px rgba(15, 23, 42, 0.06);
        }
        @media (prefers-color-scheme: dark) {
            :root {
                --primary: #3B82F6;
                --secondary: #8B5CF6;
                --tertiary: #EF4444;
                --surface: #0F172A;
                --surface-container: #1E293B;
                --on-surface: #F8FAFC;
                --outline: #334155;
                --shadow: 0 4px 24px rgba(0,0,0,0.12);
            }
        }
        html {
            box-sizing: border-box;
        }
        *, *:before, *:after {
            box-sizing: inherit;
        }
        body {
            font-family: 'Quicksand', sans-serif;
            background: var(--surface);
            color: var(--on-surface);
            margin: 0;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            -webkit-font-smoothing: antialiased;
        }
        .quiz-card {
            background: var(--surface-container);
            border-radius: var(--card-radius);
            box-shadow: var(--shadow);
            border: 1px solid var(--outline);
            max-width: 420px;
            width: 100%;
            margin: 24px;
            padding: 40px 28px 32px 28px;
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        .quiz-title {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 12px;
            text-align: center;
            color: var(--on-surface);
        }
        .quiz-subtitle {
            font-size: 1.1rem;
            color: var(--secondary);
            margin-bottom: 24px;
            text-align: center;
        }
        .cta-button {
            display: inline-block;
            background: var(--primary);
            color: #fff;
            padding: 16px 0;
            border-radius: var(--button-radius);
            text-decoration: none;
            font-weight: 600;
            font-size: 1.1rem;
            width: 100%;
            text-align: center;
            border: none;
            transition: background 0.2s, box-shadow 0.2s, opacity 0.2s;
            margin-top: 8px;
        }
        .cta-button:hover {
            opacity: 0.93;
            box-shadow: 0 2px 8px rgba(37,99,235,0.10);
        }
        .error {
            color: var(--tertiary);
            font-weight: 600;
            margin-bottom: 12px;
        }
        @media (max-width: 500px) {
            .quiz-card {
                padding: 18px 2vw 18px 2vw;
            }
            .quiz-title {
                font-size: 1.3rem;
            }
        }
    </style>
</head>
<body>
    <div class="quiz-card">
        <?php
        $platform = isset($_GET['platform']) ? strtolower($_GET['platform']) : null;
        $current_version = isset($_GET['version']) ? $_GET['version'] : null;

        if (!$platform || !$current_version) {
            echo '<div class="error">Fout</div>';
            echo '<div class="quiz-title">Platform- of versie-informatie ontbreekt.</div>';
            exit;
        }

        $versions_file = 'versions.json';
        if (!file_exists($versions_file)) {
            echo '<div class="error">Serverfout</div>';
            echo '<div class="quiz-title">Kon de versie-informatie niet vinden.</div>';
            exit;
        }

        $versions_data = json_decode(file_get_contents($versions_file), true);

        if (!isset($versions_data[$platform])) {
            echo '<div class="error">Platform niet ondersteund</div>';
            echo '<div class="quiz-title">Sorry, we hebben geen update-informatie voor dit platform.</div>';
            exit;
        }

        $latest_version_info = $versions_data[$platform];
        $latest_version = $latest_version_info['version'];
        $download_url = $latest_version_info['url'];

        if (version_compare($current_version, $latest_version, '<')) {
            echo '<div class="quiz-title">Update Beschikbaar!</div>';
            echo '<div class="quiz-subtitle">Er is een nieuwe versie (<strong>' . htmlspecialchars($latest_version) . '</strong>) beschikbaar.<br>Je hebt nu versie <strong>' . htmlspecialchars($current_version) . '</strong>.</div>';
            echo '<a href="' . htmlspecialchars($download_url) . '" class="cta-button">Download Update</a>';
        } else {
            echo '<div class="quiz-title">Je bent up-to-date!</div>';
            echo '<div class="quiz-subtitle">Je hebt de nieuwste versie (<strong>' . htmlspecialchars($current_version) . '</strong>) van de BijbelQuiz app.</div>';
        }
        ?>
    </div>
</body>
</html> 