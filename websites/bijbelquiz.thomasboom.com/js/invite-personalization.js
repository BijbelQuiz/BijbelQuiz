function personalizeInvite() {
    const urlParams = new URLSearchParams(window.location.search);
    const yourName = urlParams.get('yourName');
    const friendName = urlParams.get('friendName');

    if (yourName || friendName) {
        let titleText = '';
        let descriptionText = '';

        if (friendName && yourName) {
            titleText = `${friendName}, je bent uitgenodigd voor BijbelQuiz!`;
            descriptionText = `${yourName} heeft je uitgenodigd om deel te nemen aan BijbelQuiz, de interactieve bijbelkennis quiz app. Test je bijbelkennis met uitdagende vragen over personen, gebeurtenissen en geschiedenissen in de Bijbel. Speel alleen, met familie of vrienden!`;
        } else if (friendName) {
            titleText = `${friendName}, je bent uitgenodigd voor BijbelQuiz!`;
            descriptionText = `Een vriend heeft je uitgenodigd om deel te nemen aan BijbelQuiz, de interactieve bijbelkennis quiz app. Test je bijbelkennis met uitdagende vragen over personen, gebeurtenissen en geschiedenissen in de Bijbel. Speel alleen, met familie of vrienden!`;
        } else if (yourName) {
            titleText = `Je bent uitgenodigd voor BijbelQuiz!`;
            descriptionText = `${yourName} heeft je uitgenodigd om deel te nemen aan BijbelQuiz, de interactieve bijbelkennis quiz app. Test je bijbelkennis met uitdagende vragen over personen, gebeurtenissen en geschiedenissen in de Bijbel. Speel alleen, met familie of vrienden!`;
        }

        if (titleText) {
            document.getElementById('main-title').textContent = titleText;
        }
        if (descriptionText) {
            document.getElementById('main-description').textContent = descriptionText;
        }
    }
}

document.addEventListener('DOMContentLoaded', personalizeInvite);