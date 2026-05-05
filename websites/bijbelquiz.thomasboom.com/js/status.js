// Service Status Checker for BijbelQuiz
// Fetches status from Instatus and displays it in the footer

document.addEventListener('DOMContentLoaded', function() {
    // Function to fetch status from Instatus
    async function fetchServiceStatus() {
        try {
            const response = await fetch('https://bijbelquiz.instatus.com/summary.json');
            if (!response.ok) {
                throw new Error('Failed to fetch status');
            }
            
            const data = await response.json();
            return data;
        } catch (error) {
            console.error('Error fetching service status:', error);
            return null;
        }
    }
    
    // Function to determine status text based on Instatus data
    function determineStatusText(statusData) {
        if (!statusData || !statusData.page) {
            return 'Status onbekend';
        }
        
        const pageStatus = statusData.page.status;
        const activeIncidents = statusData.activeIncidents || [];
        const activeMaintenances = statusData.activeMaintenances || [];
        
        // Check if all services are down
        if (pageStatus === 'UNDERMAINTENANCE' && activeMaintenances.length > 0) {
            return 'Alle diensten onder onderhoud';
        }
        
        // Check if there are major issues
        const majorIssues = activeIncidents.filter(incident => 
            incident.impact === 'MAJOROUTAGE' 
        );
        
        if (majorIssues.length > 0 || pageStatus === 'HASISSUES') {
            return 'Sommige diensten zijn niet beschikbaar';
        }
        
        // Everything is working
        return 'Alle diensten werken normaal';
    }
    
    // Function to update the status display in the footer
    async function updateStatusDisplay() {
        const statusData = await fetchServiceStatus();
        const statusText = determineStatusText(statusData);
        
        // Find the status element in the footer
        const statusElement = document.getElementById('service-status');
        
        if (statusElement) {
            statusElement.textContent = statusText;
            // Keep only the base class for plain text styling
            statusElement.className = 'service-status';
        }
    }
    
    // Check if we're on a page that uses the footer component
    // We'll use a mutation observer to wait for the footer to be loaded
    const footerObserver = new MutationObserver(function(mutations) {
        mutations.forEach(function(mutation) {
            if (mutation.addedNodes && mutation.addedNodes.length > 0) {
                for (let node of mutation.addedNodes) {
                    if (node.id === 'main-footer' || (node.querySelector && node.querySelector('#service-status'))) {
                        updateStatusDisplay();
                        footerObserver.disconnect();
                        break;
                    }
                }
            }
        });
    });
    
    // Start observing the document body for footer changes
    footerObserver.observe(document.body, { childList: true, subtree: true });
    
    // Also try to update immediately in case footer is already loaded
    setTimeout(updateStatusDisplay, 1000);
});