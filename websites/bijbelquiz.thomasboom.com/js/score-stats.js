async function sha256(message) {
    const msgBuffer = new TextEncoder().encode(message);
    const hashBuffer = await crypto.subtle.digest('SHA-256', msgBuffer);
    const hashArray = Array.from(new Uint8Array(hashBuffer));
    return hashArray.map(b => b.toString(16).padStart(2, '0')).join('');
}

function initScoreStats() {
    const urlParams = new URLSearchParams(window.location.search);
    const statsString = urlParams.get('s');
    const urlHash = urlParams.get('h');

    let stats = null;
    let isValid = false;

    async function verifyAndParseStats() {
        if (!statsString || !urlHash) {
            return false;
        }

        try {
            const parts = statsString.split(':');
            if (parts.length !== 6) {
                console.warn('Invalid stats format');
                return false;
            }

            const statsData = {
                score: parseInt(parts[0]) || 0,
                currentStreak: parseInt(parts[1]) || 0,
                longestStreak: parseInt(parts[2]) || 0,
                incorrectAnswers: parseInt(parts[3]) || 0,
                totalQuestions: parseInt(parts[4]) || 0,
                correctPercentage: parseInt(parts[5]) || 0
            };

            const computedHash = await sha256(statsString);
            const truncatedHash = computedHash.substring(0, 16);

            if (truncatedHash === urlHash) {
                return statsData;
            } else {
                console.warn('Hash verification failed');
                return false;
            }
        } catch (error) {
            console.error('Error verifying stats:', error);
            return false;
        }
    }

    async function displayStats() {
        const container = document.getElementById('statsContainer');

        if (!isValid) {
            stats = await verifyAndParseStats();
            isValid = !!stats;
        }

        if (!isValid || !stats) {
            container.innerHTML = `
                <div class="no-stats">
                    <i class="material-icons" style="font-size: 3rem; color: var(--text-secondary); margin-bottom: 1rem;">warning</i>
                    <h3>Ongeldige of gemanipuleerde statistieken</h3>
                    <p>De statistieken link is ongeldig, verlopen of gemanipuleerd. Deel je statistieken opnieuw om een geldige link te krijgen.</p>
                </div>
            `;
            return;
        }

        if (stats.totalQuestions === 0 && stats.score === 0) {
            container.innerHTML = `
                <div class="no-stats">
                    <i class="material-icons" style="font-size: 3rem; color: var(--text-secondary); margin-bottom: 1rem;">info</i>
                    <h3>Geen statistieken beschikbaar</h3>
                    <p>Speel eerst een paar quizzen om je statistieken te bekijken!</p>
                </div>
            `;
            return;
        }

        const totalQuestions = stats.totalQuestions || (stats.score + stats.incorrectAnswers);
        const correctPercentage = stats.correctPercentage || (totalQuestions > 0 ? Math.round((stats.score / totalQuestions) * 100) : 0);

        container.innerHTML = `
            <div class="stats-grid">
                <div class="stat-card primary">
                    <div class="stat-icon">
                        <i class="material-icons">emoji_events</i>
                    </div>
                    <div class="stat-content">
                        <div class="stat-number">${stats.score.toLocaleString()}</div>
                        <div class="stat-label">Totaal Score</div>
                    </div>
                </div>

                <div class="stat-card success">
                    <div class="stat-icon">
                        <i class="material-icons">local_fire_department</i>
                    </div>
                    <div class="stat-content">
                        <div class="stat-number">${stats.longestStreak}</div>
                        <div class="stat-label">Langste Reeks</div>
                    </div>
                </div>

                <div class="stat-card info">
                    <div class="stat-icon">
                        <i class="material-icons">timeline</i>
                    </div>
                    <div class="stat-content">
                        <div class="stat-number">${stats.currentStreak}</div>
                        <div class="stat-label">Huidige Reeks</div>
                    </div>
                </div>

                <div class="stat-card warning">
                    <div class="stat-icon">
                        <i class="material-icons">trending_up</i>
                    </div>
                    <div class="stat-content">
                        <div class="stat-number">${correctPercentage}%</div>
                        <div class="stat-label">Juist Percentage</div>
                    </div>
                </div>
            </div>
        `;
    }

    displayStats();
}

document.addEventListener('DOMContentLoaded', initScoreStats);