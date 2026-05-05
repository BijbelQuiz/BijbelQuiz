function initGenStats() {
    function getUrlParameter(name) {
        const urlParams = new URLSearchParams(window.location.search);
        return urlParams.get(name);
    }

    function updateStatsFromUrl() {
        const score = parseInt(getUrlParameter("score")) || 0;
        const currentStreak = parseInt(getUrlParameter("currentStreak")) || 0;
        const longestStreak = parseInt(getUrlParameter("longestStreak")) || 0;
        const incorrect = parseInt(getUrlParameter("incorrect")) || 0;
        const totalQuestions = parseInt(getUrlParameter("totalQuestions")) || Math.max(score + incorrect, 1);
        const accuracy = parseInt(getUrlParameter("accuracy")) || 0;
        const hoursSpent = parseFloat(getUrlParameter("hoursSpent")) || 0.0;

        document.getElementById("scoreValue").textContent = score;
        document.getElementById("accuracyValue").textContent = `${accuracy}%`;
        document.getElementById("hoursValue").textContent = hoursSpent.toFixed(1);
        document.getElementById("streakValue").textContent = currentStreak;
        document.getElementById("longestStreakValue").textContent = longestStreak;
        document.getElementById("mistakesValue").textContent = incorrect;
        document.getElementById("totalQuestionsValue").textContent = totalQuestions;

        document.querySelector(".title").textContent = `Jaar in Review - ${score} correct`;
        document.querySelector(".subtitle").textContent = `Bekijk de BijbelQuiz resultaten: ${accuracy}% accuraatheid, ${currentStreak} reeks`;
    }

    updateStatsFromUrl();
}

document.addEventListener('DOMContentLoaded', initGenStats);