function isAndroid() {
    const userAgent = navigator.userAgent || navigator.vendor || window.opera;
    return /android/i.test(userAgent);
}

function reorderButtons() {
    const ctaButtons = document.querySelector('.cta-buttons');
    if (!ctaButtons) return;

    const googlePlayBtn = document.getElementById('googlePlayBtn');
    const playWebBtn = document.getElementById('playWebBtn');

    if (!googlePlayBtn || !playWebBtn) return;

    if (isAndroid()) {
        googlePlayBtn.className = 'btn primary btn-large';
        playWebBtn.className = 'btn secondary btn-large';
        ctaButtons.insertBefore(googlePlayBtn, playWebBtn);
    } else {
        playWebBtn.className = 'btn primary btn-large';
        googlePlayBtn.className = 'btn secondary btn-large';
        ctaButtons.insertBefore(playWebBtn, googlePlayBtn);
    }
}

function checkCoupon() {
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.has('coupon')) {
        const couponDiv = document.createElement('div');
        couponDiv.innerHTML = '<p>Scan de URL opnieuw in de BijbelQuiz app in het Winkel scherm > inwisselen > QR code om extra punten te krijgen!</p>';
        const h1 = document.querySelector('h1');
        if (h1) {
            h1.insertAdjacentElement('afterend', couponDiv);
        }
    }
}

document.addEventListener('DOMContentLoaded', function() {
    reorderButtons();
    checkCoupon();
});