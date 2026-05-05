function loadFooter() {
    fetch('/assets/components/footer.html')
        .then(response => response.text())
        .then(data => {
            const footer = document.getElementById('main-footer');
            if (footer) {
                footer.innerHTML = data;
            }
        })
        .catch(error => {
            console.error('Error loading footer:', error);
        });
}

document.addEventListener('DOMContentLoaded', loadFooter);