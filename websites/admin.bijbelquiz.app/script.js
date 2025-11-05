// BijbelQuiz Admin Dashboard - Main JavaScript file

// Global variables
let isLoggedIn = false;
let currentTab = 'tracking';
let currentFeatureSelection = null;
let currentErrorSelection = null;
let currentStoreSelection = null;
let currentMessageSelection = null;
let trackingData = [];
let errorReports = [];
let storeItems = [];
let messages = [];
let chart = null;

// DOM Elements
const loginContainer = document.getElementById('login-container');
const dashboardContainer = document.getElementById('dashboard-container');
const authForm = document.getElementById('auth-form');
const authBtn = document.getElementById('auth-btn');
const logoutBtn = document.getElementById('logout-btn');
const tabLinks = document.querySelectorAll('.tab-link');
const tabPanes = document.querySelectorAll('.tab-pane');
const passwordInput = document.getElementById('password');

// Initialize the application
document.addEventListener('DOMContentLoaded', () => {
    setupEventListeners();
    loadEnvConfig();
});

// Set up all event listeners
function setupEventListeners() {
    // Auth form submission
    authForm.addEventListener('submit', handleLogin);
    
    // Logout button
    logoutBtn.addEventListener('click', handleLogout);
    
    // Tab navigation
    tabLinks.forEach(link => {
        link.addEventListener('click', (e) => {
            e.preventDefault();
            changeTab(link.dataset.tab);
        });
    });
    
    // Tracking tab events
    document.getElementById('load-tracking-data').addEventListener('click', loadTrackingData);
    document.getElementById('apply-filters').addEventListener('click', applyTrackingFilters);
    document.getElementById('analyze-feature').addEventListener('click', analyzeFeatureUsage);
    
    // Error reports tab events
    document.getElementById('load-error-reports').addEventListener('click', loadErrorReports);
    document.getElementById('clear-error-filters').addEventListener('click', clearErrorFilters);
    document.getElementById('delete-selected-error').addEventListener('click', deleteSelectedError);
    
    // Store management tab events
    document.getElementById('load-store-items').addEventListener('click', loadStoreItems);
    document.getElementById('add-new-store-item').addEventListener('click', showAddStoreItemModal);
    document.getElementById('store-item-form').addEventListener('submit', updateStoreItem);
    document.getElementById('delete-store-item').addEventListener('click', deleteStoreItem);
    
    // Message management tab events
    document.getElementById('load-messages').addEventListener('click', loadMessages);
    document.getElementById('add-new-message').addEventListener('click', showAddMessageModal);
    document.getElementById('message-form').addEventListener('submit', updateMessage);
    document.getElementById('delete-message').addEventListener('click', deleteMessage);
    
    // Modal events
    setupModalEventListeners();
}

// Load environment configuration
function loadEnvConfig() {
    // In a real implementation, this would load from a secure server endpoint
    // For now, we'll use a placeholder structure
    console.log('Environment configuration loaded');
}

// Handle login
async function handleLogin(e) {
    e.preventDefault();
    
    const password = passwordInput.value.trim();
    
    if (!password) {
        showError('Please enter the admin password');
        return;
    }
    
    // In a real implementation, this would be a secure server-side check
    // For security, never do password comparison in client-side JavaScript
    // This is just a placeholder implementation
    try {
        const response = await authenticate(password);
        if (response.success) {
            showDashboard();
            clearError();
        } else {
            showError(response.message || 'Invalid password');
        }
    } catch (error) {
        showError('Authentication error: ' + error.message);
    }
}

// Authentication function that connects to the server
async function authenticate(password) {
    try {
        const response = await fetch('/api/login', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ password })
        });

        const data = await response.json();
        
        if (data.success) {
            // Store the JWT token
            localStorage.setItem('adminToken', data.token);
            return { success: true };
        } else {
            return { success: false, message: data.error || 'Invalid password' };
        }
    } catch (error) {
        console.error('Authentication error:', error);
        return { success: false, message: 'Authentication failed due to network error' };
    }
}

// Show dashboard after successful login
function showDashboard() {
    loginContainer.style.display = 'none';
    dashboardContainer.style.display = 'flex';
    isLoggedIn = true;
    
    // The authentication is handled server-side, no client-side password storage needed
    // Server will validate against the password in the .env file
}

// Handle logout
async function handleLogout() {
    try {
        // Send logout request to server to invalidate token (if needed)
        await fetch('/api/logout', {
            method: 'POST',
            headers: {
                'Authorization': `Bearer ${localStorage.getItem('adminToken')}`,
                'Content-Type': 'application/json'
            }
        });
    } catch (error) {
        console.error('Logout request failed:', error);
        // Continue with client-side logout even if server request fails
    } finally {
        isLoggedIn = false;
        loginContainer.style.display = 'flex';
        dashboardContainer.style.display = 'none';
        passwordInput.value = '';
        
        // Clear stored authentication data
        localStorage.removeItem('adminToken');
    }
}

// Show error message
function showError(message) {
    const errorElement = document.getElementById('auth-error');
    errorElement.textContent = message;
    errorElement.classList.add('show');
}

// Clear error message
function clearError() {
    const errorElement = document.getElementById('auth-error');
    errorElement.textContent = '';
    errorElement.classList.remove('show');
}

// Change active tab
function changeTab(tabName) {
    // Update active tab in navigation
    tabLinks.forEach(link => {
        if (link.dataset.tab === tabName) {
            link.classList.add('active');
        } else {
            link.classList.remove('active');
        }
    });
    
    // Show active tab content
    tabPanes.forEach(pane => {
        if (pane.id === `${tabName}-tab`) {
            pane.classList.add('active');
            currentTab = tabName;
        } else {
            pane.classList.remove('active');
        }
    });
    
    // Load data for the specific tab if needed
    switch(tabName) {
        case 'tracking':
            // Tracking data already loaded or will be loaded when needed
            break;
        case 'errors':
            // Error reports will be loaded when the button is clicked
            break;
        case 'store':
            // Store items will be loaded when the button is clicked
            break;
        case 'messages':
            // Messages will be loaded when the button is clicked
            break;
    }
}

// Setup modal event listeners
function setupModalEventListeners() {
    // Store item modal
    const storeModal = document.getElementById('add-store-modal');
    const storeCloseBtn = storeModal.querySelector('.close');
    const storeCancelBtn = storeModal.querySelector('.cancel-btn');
    const addStoreForm = document.getElementById('add-store-form');
    
    storeCloseBtn.addEventListener('click', () => {
        storeModal.style.display = 'none';
    });
    
    storeCancelBtn.addEventListener('click', () => {
        storeModal.style.display = 'none';
    });
    
    window.addEventListener('click', (e) => {
        if (e.target === storeModal) {
            storeModal.style.display = 'none';
        }
    });
    
    addStoreForm.addEventListener('submit', saveNewStoreItem);
    
    // Discount checkbox event
    document.getElementById('add-is-discounted').addEventListener('change', function() {
        const discountPercentage = document.getElementById('add-discount-percentage');
        const discountStart = document.getElementById('add-discount-start');
        const discountEnd = document.getElementById('add-discount-end');
        
        if (this.checked) {
            discountPercentage.disabled = false;
            discountStart.disabled = false;
            discountEnd.disabled = false;
        } else {
            discountPercentage.disabled = true;
            discountStart.disabled = true;
            discountEnd.disabled = true;
        }
    });
    
    // Message modal
    const messageModal = document.getElementById('add-message-modal');
    const messageCloseBtn = messageModal.querySelector('.close');
    const messageCancelBtn = messageModal.querySelector('.cancel-btn');
    const addMessageForm = document.getElementById('add-message-form');
    
    messageCloseBtn.addEventListener('click', () => {
        messageModal.style.display = 'none';
    });
    
    messageCancelBtn.addEventListener('click', () => {
        messageModal.style.display = 'none';
    });
    
    window.addEventListener('click', (e) => {
        if (e.target === messageModal) {
            messageModal.style.display = 'none';
        }
    });
    
    addMessageForm.addEventListener('submit', saveNewMessage);
}

// Show add store item modal
function showAddStoreItemModal() {
    // Reset form
    document.getElementById('add-store-form').reset();
    
    // Disable discount fields initially
    document.getElementById('add-discount-percentage').disabled = true;
    document.getElementById('add-discount-start').disabled = true;
    document.getElementById('add-discount-end').disabled = true;
    
    // Show modal
    document.getElementById('add-store-modal').style.display = 'flex';
}

// Show add message modal
function showAddMessageModal() {
    // Reset form
    document.getElementById('add-message-form').reset();
    
    // Show modal
    document.getElementById('add-message-modal').style.display = 'flex';
}

// Load tracking data
async function loadTrackingData() {
    showLoading('load-tracking-data');
    
    try {
        // In a real implementation, fetch from Supabase
        // For demo purposes, using mock data
        trackingData = await fetchTrackingData();
        displayFeaturesOverview();
        updateFeatureFilters();
    } catch (error) {
        console.error('Error loading tracking data:', error);
        showErrorInTab('tracking', 'Failed to load tracking data');
    } finally {
        hideLoading('load-tracking-data');
    }
}

// Fetch tracking data from API
async function fetchTrackingData() {
    try {
        const response = await fetch(`/api/tracking-data`, {
            method: 'GET',
            headers: {
                'Authorization': `Bearer ${localStorage.getItem('adminToken')}`,
                'Content-Type': 'application/json'
            }
        });

        if (!response.ok) {
            const errorData = await response.json();
            throw new Error(errorData.error || 'Failed to fetch tracking data');
        }

        const data = await response.json();
        return data.data || [];
    } catch (error) {
        console.error('Error fetching tracking data:', error);
        throw error;
    }
}

// Display features overview
function displayFeaturesOverview() {
    const tableBody = document.getElementById('features-table-body');
    tableBody.innerHTML = '';
    
    if (!trackingData || trackingData.length === 0) {
        tableBody.innerHTML = '<tr><td colspan="4">No data available</td></tr>';
        return;
    }
    
    // Group data by feature
    const featureStats = {};
    trackingData.forEach(record => {
        const feature = record.event_name;
        if (!featureStats[feature]) {
            featureStats[feature] = {
                totalUsage: 0,
                uniqueUsers: new Set(),
                lastUsed: new Date(0)
            };
        }
        
        featureStats[feature].totalUsage++;
        featureStats[feature].uniqueUsers.add(record.user_id);
        
        const recordDate = new Date(record.timestamp);
        if (recordDate > featureStats[feature].lastUsed) {
            featureStats[feature].lastUsed = recordDate;
        }
    });
    
    // Convert to array and sort
    const featuresArray = Object.keys(featureStats).map(feature => ({
        name: feature,
        totalUsage: featureStats[feature].totalUsage,
        uniqueUsers: featureStats[feature].uniqueUsers.size,
        lastUsed: featureStats[feature].lastUsed.toISOString().substring(0, 19).replace('T', ' ')
    }));
    
    featuresArray.sort((a, b) => b.totalUsage - a.totalUsage);
    
    // Add rows to table
    featuresArray.forEach(feature => {
        const row = document.createElement('tr');
        row.innerHTML = `
            <td>${feature.name}</td>
            <td>${feature.totalUsage}</td>
            <td>${feature.uniqueUsers}</td>
            <td>${feature.lastUsed}</td>
        `;
        
        row.addEventListener('click', () => {
            selectFeature(feature.name);
        });
        
        tableBody.appendChild(row);
    });
}

// Update feature filters
function updateFeatureFilters() {
    const featureFilter = document.getElementById('feature-filter');
    const actionFilter = document.getElementById('action-filter');
    
    if (!trackingData || trackingData.length === 0) {
        // If no tracking data is loaded yet, we'll update filters when data is loaded
        return;
    }
    
    // Get unique features
    const features = [...new Set(trackingData.map(item => item.event_name))].sort();
    featureFilter.innerHTML = '<option value="">All Features</option>';
    features.forEach(feature => {
        const option = document.createElement('option');
        option.value = feature;
        option.textContent = feature;
        featureFilter.appendChild(option);
    });
    
    // Get unique actions
    const actions = [...new Set(trackingData.map(item => item.event_type))].sort();
    actionFilter.innerHTML = '<option value="">All Actions</option>';
    actions.forEach(action => {
        const option = document.createElement('option');
        option.value = action;
        option.textContent = action;
        actionFilter.appendChild(option);
    });
}

// Select a feature
function selectFeature(featureName) {
    currentFeatureSelection = featureName;
    
    // Highlight selected row
    document.querySelectorAll('#features-table tbody tr').forEach(row => {
        row.classList.remove('selected');
    });
    
    // Find and highlight the selected row
    const rows = document.querySelectorAll('#features-table tbody tr');
    rows.forEach(row => {
        if (row.cells[0].textContent === featureName) {
            row.classList.add('selected');
        }
    });
    
    // Display feature details
    displayFeatureDetails(featureName);
    displayFeatureStats(featureName);
    visualizeFeatureUsage(featureName);
}

// Display feature details
function displayFeatureDetails(featureName) {
    if (!trackingData || trackingData.length === 0) {
        document.getElementById('feature-details-content').textContent = 'No data available';
        return;
    }
    
    const featureData = trackingData.filter(item => item.event_name === featureName);
    
    if (featureData.length === 0) {
        document.getElementById('feature-details-content').textContent = `No data found for feature: ${featureName}`;
        return;
    }
    
    const details = `
        <strong>Feature:</strong> ${featureName}<br>
        <strong>Total Usage:</strong> ${featureData.length} events<br>
        <strong>Unique Users:</strong> ${[...new Set(featureData.map(item => item.user_id))].length}<br>
        <strong>Date Range:</strong> ${new Date(Math.min(...featureData.map(item => new Date(item.timestamp)))).toLocaleString()} to ${new Date(Math.max(...featureData.map(item => new Date(item.timestamp)))).toLocaleString()}<br>
        <strong>First Used:</strong> ${new Date(Math.min(...featureData.map(item => new Date(item.timestamp)))).toLocaleString()}<br>
        <strong>Last Used:</strong> ${new Date(Math.max(...featureData.map(item => new Date(item.timestamp)))).toLocaleString()}<br>
    `;
    
    document.getElementById('feature-details-content').innerHTML = details;
}

// Display feature stats
function displayFeatureStats(featureName) {
    if (!trackingData || trackingData.length === 0) {
        document.getElementById('feature-stats-display').textContent = 'No data available';
        return;
    }
    
    const featureData = trackingData.filter(item => item.event_name === featureName);
    
    if (featureData.length === 0) {
        document.getElementById('feature-stats-display').textContent = `No data found for feature: ${featureName}`;
        return;
    }
    
    // Count actions
    const actionCounts = {};
    featureData.forEach(item => {
        actionCounts[item.event_type] = (actionCounts[item.event_type] || 0) + 1;
    });
    
    // Build stats string
    let stats = `
        <p><strong>Feature:</strong> ${featureName}</p>
        <p><strong>Total Events:</strong> ${featureData.length}</p>
        <p><strong>Unique Users:</strong> ${[...new Set(featureData.map(item => item.user_id))].length}</p>
        <p><strong>Date Range:</strong> ${new Date(Math.min(...featureData.map(item => new Date(item.timestamp)))).toLocaleString()} to ${new Date(Math.max(...featureData.map(item => new Date(item.timestamp)))).toLocaleString()}</p>
    `;
    
    stats += '<p><strong>Event Type Breakdown:</strong></p><ul>';
    for (const [action, count] of Object.entries(actionCounts)) {
        stats += `<li>${action}: ${count}</li>`;
    }
    stats += '</ul>';
    
    // Platform breakdown
    const platformCounts = {};
    featureData.forEach(item => {
        if (item.platform) {
            platformCounts[item.platform] = (platformCounts[item.platform] || 0) + 1;
        }
    });
    
    if (Object.keys(platformCounts).length > 0) {
        stats += '<p><strong>Platform Breakdown:</strong></p><ul>';
        for (const [platform, count] of Object.entries(platformCounts)) {
            stats += `<li>${platform}: ${count}</li>`;
        }
        stats += '</ul>';
    }
    
    // App version breakdown
    const versionCounts = {};
    featureData.forEach(item => {
        if (item.app_version) {
            versionCounts[item.app_version] = (versionCounts[item.app_version] || 0) + 1;
        }
    });
    
    if (Object.keys(versionCounts).length > 0) {
        stats += '<p><strong>App Version Breakdown:</strong></p><ul>';
        for (const [version, count] of Object.entries(versionCounts)) {
            stats += `<li>${version}: ${count}</li>`;
        }
        stats += '</ul>';
    }
    
    document.getElementById('feature-stats-display').innerHTML = stats;
}

// Visualize feature usage with multiple chart types
function visualizeFeatureUsage(featureName) {
    if (!trackingData || trackingData.length === 0) {
        return;
    }
    
    const featureData = trackingData.filter(item => item.event_name === featureName);
    
    if (featureData.length === 0) {
        return;
    }
    
    // Destroy existing chart if present
    if (chart) {
        chart.destroy();
    }
    
    // Get canvas context
    const ctx = document.getElementById('feature-usage-chart').getContext('2d');
    
    // Prepare data for chart
    // Group by date
    const dailyCounts = {};
    featureData.forEach(item => {
        const date = new Date(item.timestamp).toDateString();
        dailyCounts[date] = (dailyCounts[date] || 0) + 1;
    });
    
    // Get event type counts
    const eventTypes = {};
    featureData.forEach(item => {
        eventTypes[item.event_type] = (eventTypes[item.event_type] || 0) + 1;
    });
    
    // Group by platform
    const platformCounts = {};
    featureData.forEach(item => {
        if (item.platform) {
            platformCounts[item.platform] = (platformCounts[item.platform] || 0) + 1;
        }
    });
    
    // Prepare chart data
    const dateLabels = Object.keys(dailyCounts).sort();
    const dailyValues = dateLabels.map(date => dailyCounts[date]);
    
    const eventTypeLabels = Object.keys(eventTypes);
    const eventTypeValues = eventTypeLabels.map(type => eventTypes[type]);
    
    // Create a composite chart with multiple datasets
    chart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: dateLabels,
            datasets: [
                {
                    label: 'Daily Usage',
                    data: dailyValues,
                    backgroundColor: 'rgba(75, 192, 192, 0.2)',
                    borderColor: 'rgba(75, 192, 192, 1)',
                    borderWidth: 1,
                    yAxisID: 'y'
                }
            ]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            interaction: {
                mode: 'index',
                intersect: false
            },
            scales: {
                y: {
                    type: 'linear',
                    display: true,
                    position: 'left',
                    beginAtZero: true,
                    title: {
                        display: true,
                        text: 'Event Count'
                    }
                }
            },
            plugins: {
                title: {
                    display: true,
                    text: `Daily Usage for ${featureName}`
                },
                tooltip: {
                    mode: 'index',
                    intersect: false
                }
            }
        }
    });
}

// Analyze feature usage in more detail
function analyzeFeatureUsage() {
    if (!currentFeatureSelection) {
        alert('Please select a feature to analyze');
        return;
    }
    
    displayFeatureStats(currentFeatureSelection);
    
    // Additional analysis could include:
    // - Daily/weekly/monthly trends
    // - User engagement metrics
    // - Platform distribution analysis
    // - Session analysis
    // For now, we'll perform more detailed stats
    performDetailedAnalysis(currentFeatureSelection);
}

// Perform detailed analysis for a selected feature
function performDetailedAnalysis(featureName) {
    if (!trackingData || trackingData.length === 0) {
        document.getElementById('feature-stats-display').textContent = 'No data available for analysis';
        return;
    }
    
    const featureData = trackingData.filter(item => item.event_name === featureName);
    
    if (featureData.length === 0) {
        document.getElementById('feature-stats-display').textContent = `No data found for feature: ${featureName}`;
        return;
    }
    
    // Calculate advanced metrics
    // 1. Daily active users
    const dailyUsers = {};
    featureData.forEach(item => {
        const date = new Date(item.timestamp).toDateString();
        if (!dailyUsers[date]) dailyUsers[date] = new Set();
        dailyUsers[date].add(item.user_id);
    });
    
    // 2. Peak usage day
    let peakDay = '';
    let peakCount = 0;
    for (const [date, users] of Object.entries(dailyUsers)) {
        if (users.size > peakCount) {
            peakCount = users.size;
            peakDay = date;
        }
    }
    
    // 3. Platform distribution
    const platformDistribution = {};
    featureData.forEach(item => {
        if (item.platform) {
            platformDistribution[item.platform] = (platformDistribution[item.platform] || 0) + 1;
        }
    });
    
    // 4. Action distribution
    const actionDistribution = {};
    featureData.forEach(item => {
        actionDistribution[item.event_type] = (actionDistribution[item.event_type] || 0) + 1;
    });
    
    // 5. User retention analysis (simplified)
    const uniqueUsers = new Set(featureData.map(item => item.user_id));
    const userActivityCount = {};
    featureData.forEach(item => {
        userActivityCount[item.user_id] = (userActivityCount[item.user_id] || 0) + 1;
    });
    
    // Count how many users are power users (> 5 interactions)
    const powerUsers = Object.values(userActivityCount).filter(count => count > 5).length;
    
    // Build detailed analysis
    let analysis = `
        <h3>Detailed Analysis for ${featureName}</h3>
        <p><strong>Total Events:</strong> ${featureData.length}</p>
        <p><strong>Unique Users:</strong> ${uniqueUsers.size}</p>
        <p><strong>Power Users (>5 interactions):</strong> ${powerUsers}</p>
        <p><strong>Peak Usage Day:</strong> ${peakDay} with ${peakCount} unique users</p>
    `;
    
    // Add platform distribution
    analysis += '<h4>Platform Distribution</h4><ul>';
    for (const [platform, count] of Object.entries(platformDistribution)) {
        const percentage = ((count / featureData.length) * 100).toFixed(2);
        analysis += `<li>${platform}: ${count} events (${percentage}%)</li>`;
    }
    analysis += '</ul>';
    
    // Add action distribution
    analysis += '<h4>Action Distribution</h4><ul>';
    for (const [action, count] of Object.entries(actionDistribution)) {
        const percentage = ((count / featureData.length) * 100).toFixed(2);
        analysis += `<li>${action}: ${count} events (${percentage}%)</li>`;
    }
    analysis += '</ul>';
    
    // Add daily usage trend
    const sortedDates = Object.keys(dailyUsers).sort();
    analysis += '<h4>Daily Usage Trend</h4>';
    analysis += '<table><tr><th>Date</th><th>Unique Users</th></tr>';
    for (const date of sortedDates) {
        analysis += `<tr><td>${date}</td><td>${dailyUsers[date].size}</td></tr>`;
    }
    analysis += '</table>';
    
    document.getElementById('feature-stats-display').innerHTML = analysis;
}

// Apply tracking filters
async function applyTrackingFilters() {
    try {
        // Build query parameters
        const queryParams = new URLSearchParams();
        const featureFilter = document.getElementById('feature-filter').value;
        const actionFilter = document.getElementById('action-filter').value;
        const dateFrom = document.getElementById('date-from').value;
        const dateTo = document.getElementById('date-to').value;
        
        if (featureFilter && featureFilter !== '') {
            queryParams.append('feature', featureFilter);
        }
        
        if (actionFilter && actionFilter !== '') {
            queryParams.append('action', actionFilter);
        }
        
        if (dateFrom) {
            queryParams.append('dateFrom', dateFrom);
        }
        
        if (dateTo) {
            queryParams.append('dateTo', dateTo);
        }
        
        // Fetch filtered data
        const queryString = queryParams.toString();
        const response = await fetch(`/api/tracking-data${queryString ? `?${queryString}` : ''}`, {
            method: 'GET',
            headers: {
                'Authorization': `Bearer ${localStorage.getItem('adminToken')}`,
                'Content-Type': 'application/json'
            }
        });

        if (!response.ok) {
            const errorData = await response.json();
            throw new Error(errorData.error || 'Failed to apply filters');
        }

        const data = await response.json();
        trackingData = data.data || [];
        displayFeaturesOverview();
        updateFeatureFilters();
    } catch (error) {
        console.error('Error applying tracking filters:', error);
        alert(`Error applying filters: ${error.message}`);
    }
}

// Load error reports
async function loadErrorReports() {
    showLoading('load-error-reports');
    
    try {
        // Build query parameters for filters
        const queryParams = new URLSearchParams();
        const errorTypeFilter = document.getElementById('error-type-filter').value;
        const userIdFilter = document.getElementById('user-id-filter').value;
        const questionIdFilter = document.getElementById('question-id-filter').value;
        
        if (errorTypeFilter && errorTypeFilter !== '') {
            queryParams.append('errorType', errorTypeFilter);
        }
        
        if (userIdFilter) {
            queryParams.append('userId', userIdFilter);
        }
        
        if (questionIdFilter) {
            queryParams.append('questionId', questionIdFilter);
        }
        
        // Fetch data from API with filters
        const queryString = queryParams.toString();
        const response = await fetch(`/api/error-reports${queryString ? `?${queryString}` : ''}`, {
            method: 'GET',
            headers: {
                'Authorization': `Bearer ${localStorage.getItem('adminToken')}`,
                'Content-Type': 'application/json'
            }
        });

        if (!response.ok) {
            const errorData = await response.json();
            throw new Error(errorData.error || 'Failed to fetch error reports');
        }

        const data = await response.json();
        errorReports = data.data || [];
        displayErrorReports();
        
        // Update the filter options based on the data
        updateErrorTypeFilters();
    } catch (error) {
        console.error('Error loading error reports:', error);
        showErrorInTab('errors', 'Failed to load error reports');
    } finally {
        hideLoading('load-error-reports');
    }
}

// Fetch error reports from API
async function fetchErrorReports() {
    try {
        const response = await fetch(`/api/error-reports`, {
            method: 'GET',
            headers: {
                'Authorization': `Bearer ${localStorage.getItem('adminToken')}`,
                'Content-Type': 'application/json'
            }
        });

        if (!response.ok) {
            const errorData = await response.json();
            throw new Error(errorData.error || 'Failed to fetch error reports');
        }

        const data = await response.json();
        return data.data || [];
    } catch (error) {
        console.error('Error fetching error reports:', error);
        throw error;
    }
}

// Display error reports
function displayErrorReports() {
    const tableBody = document.getElementById('errors-table-body');
    tableBody.innerHTML = '';
    
    if (!errorReports || errorReports.length === 0) {
        tableBody.innerHTML = '<tr><td colspan="5">No error reports available</td></tr>';
        return;
    }
    
    errorReports.forEach(error => {
        const row = document.createElement('tr');
        row.innerHTML = `
            <td>${error.timestamp.substring(0, 19).replace('T', ' ')}</td>
            <td>${error.error_type}</td>
            <td>${error.user_id}</td>
            <td>${error.question_id}</td>
            <td>${error.error_message.substring(0, 50)}${error.error_message.length > 50 ? '...' : ''}</td>
        `;
        
        row.addEventListener('click', () => {
            selectError(error.id);
        });
        
        tableBody.appendChild(row);
    });
}

// Select an error
function selectError(errorId) {
    currentErrorSelection = errorId;
    
    // Highlight selected row
    document.querySelectorAll('#errors-table tbody tr').forEach(row => {
        row.classList.remove('selected');
    });
    
    // Find and highlight the selected row
    const rows = document.querySelectorAll('#errors-table tbody tr');
    rows.forEach(row => {
        if (parseInt(row.cells[0].textContent) === errorId) {
            row.classList.add('selected');
        }
    });
    
    // Display error details
    displayErrorDetails(errorId);
}

// Display error details
function displayErrorDetails(errorId) {
    const error = errorReports.find(e => e.id === errorId);
    if (!error) {
        document.getElementById('error-details-content').textContent = 'Error not found';
        return;
    }
    
    const details = `
        <h4>ERROR DETAILS</h4>
        <p><strong>ID:</strong> ${error.id}</p>
        <p><strong>Timestamp:</strong> ${error.timestamp.substring(0, 19).replace('T', ' ')}</p>
        <p><strong>Error Type:</strong> ${error.error_type}</p>
        <p><strong>User ID:</strong> ${error.user_id || 'N/A'}</p>
        <p><strong>Question ID:</strong> ${error.question_id || 'N/A'}</p>

        <h4>ERROR INFORMATION</h4>
        <p><strong>Technical Message:</strong> ${error.error_message}</p>
        <p><strong>User Message:</strong> ${error.user_message || 'N/A'}</p>
        <p><strong>Error Code:</strong> ${error.error_code || 'N/A'}</p>

        <h4>CONTEXT INFORMATION</h4>
        <p><strong>Context:</strong> ${error.context || 'N/A'}</p>
        <p><strong>Additional Info:</strong> ${error.additional_info || 'N/A'}</p>
        <p><strong>Stack Trace:</strong> ${error.stack_trace || 'N/A'}</p>

        <h4>APP INFORMATION</h4>
        <p><strong>Device Info:</strong> ${error.device_info || 'N/A'}</p>
        <p><strong>App Version:</strong> ${error.app_version || 'N/A'}</p>
        <p><strong>Build Number:</strong> ${error.build_number || 'N/A'}</p>
    `;
    
    document.getElementById('error-details-content').innerHTML = details;
}

// Clear error filters
async function clearErrorFilters() {
    document.getElementById('error-type-filter').value = '';
    document.getElementById('user-id-filter').value = '';
    document.getElementById('question-id-filter').value = '';
    
    // Refresh the display
    await loadErrorReports();
}

// Update error type filters based on available data
function updateErrorTypeFilters() {
    if (!errorReports || errorReports.length === 0) {
        return;
    }
    
    // Get unique error types
    const errorTypes = [...new Set(errorReports.map(item => item.error_type))].sort();
    
    // Update the filter dropdown
    const errorTypeFilter = document.getElementById('error-type-filter');
    errorTypeFilter.innerHTML = '<option value="">All Error Types</option>';
    
    errorTypes.forEach(errorType => {
        const option = document.createElement('option');
        option.value = errorType;
        option.textContent = errorType;
        errorTypeFilter.appendChild(option);
    });
}

// Delete selected error
async function deleteSelectedError() {
    if (!currentErrorSelection) {
        alert('Please select an error to delete');
        return;
    }
    
    if (confirm(`Are you sure you want to delete error report with ID: ${currentErrorSelection}? This action cannot be undone.`)) {
        try {
            const response = await fetch(`/api/error-reports/${currentErrorSelection}`, {
                method: 'DELETE',
                headers: {
                    'Authorization': `Bearer ${localStorage.getItem('adminToken')}`,
                    'Content-Type': 'application/json'
                }
            });

            if (!response.ok) {
                const errorData = await response.json();
                throw new Error(errorData.error || 'Failed to delete error report');
            }

            // Remove from local data
            errorReports = errorReports.filter(e => e.id !== currentErrorSelection);
            displayErrorReports();
            document.getElementById('error-details-content').textContent = 'Select an error to view details';
            currentErrorSelection = null;
            
            alert('Error report deleted successfully');
        } catch (error) {
            console.error('Error deleting error report:', error);
            alert(`Error deleting error report: ${error.message}`);
        }
    }
}

// Load store items
async function loadStoreItems() {
    showLoading('load-store-items');
    
    try {
        // Build query parameters for filters
        const queryParams = new URLSearchParams();
        const itemTypeFilter = document.getElementById('item-type-filter').value;
        const searchFilter = document.getElementById('store-search').value;
        
        if (itemTypeFilter && itemTypeFilter !== '') {
            queryParams.append('itemType', itemTypeFilter);
        }
        
        if (searchFilter) {
            queryParams.append('search', searchFilter);
        }
        
        // Fetch data from API with filters
        const queryString = queryParams.toString();
        const response = await fetch(`/api/store-items${queryString ? `?${queryString}` : ''}`, {
            method: 'GET',
            headers: {
                'Authorization': `Bearer ${localStorage.getItem('adminToken')}`,
                'Content-Type': 'application/json'
            }
        });

        if (!response.ok) {
            const errorData = await response.json();
            throw new Error(errorData.error || 'Failed to fetch store items');
        }

        const data = await response.json();
        storeItems = data.data || [];
        displayStoreItems();
    } catch (error) {
        console.error('Error loading store items:', error);
        showErrorInTab('store', 'Failed to load store items');
    } finally {
        hideLoading('load-store-items');
    }
}

// Fetch store items from API
async function fetchStoreItems() {
    try {
        const response = await fetch(`/api/store-items`, {
            method: 'GET',
            headers: {
                'Authorization': `Bearer ${localStorage.getItem('adminToken')}`,
                'Content-Type': 'application/json'
            }
        });

        if (!response.ok) {
            const errorData = await response.json();
            throw new Error(errorData.error || 'Failed to fetch store items');
        }

        const data = await response.json();
        return data.data || [];
    } catch (error) {
        console.error('Error fetching store items:', error);
        throw error;
    }
}

// Display store items
function displayStoreItems() {
    const tableBody = document.getElementById('store-table-body');
    tableBody.innerHTML = '';
    
    if (!storeItems || storeItems.length === 0) {
        tableBody.innerHTML = '<tr><td colspan="6">No store items available</td></tr>';
        return;
    }
    
    storeItems.forEach(item => {
        const row = document.createElement('tr');
        row.innerHTML = `
            <td>${item.item_key}</td>
            <td>${item.item_name}</td>
            <td>${item.item_type}</td>
            <td>${item.base_price}</td>
            <td>${item.current_price}</td>
            <td>${item.is_discounted ? 'Yes' : 'No'}</td>
        `;
        
        row.addEventListener('click', () => {
            selectStoreItem(item.id);
        });
        
        tableBody.appendChild(row);
    });
}

// Select a store item
function selectStoreItem(itemId) {
    const item = storeItems.find(i => i.id === itemId);
    if (!item) return;
    
    currentStoreSelection = itemId;
    
    // Highlight selected row
    document.querySelectorAll('#store-table tbody tr').forEach(row => {
        row.classList.remove('selected');
    });
    
    // Find and highlight the selected row
    const rows = document.querySelectorAll('#store-table tbody tr');
    rows.forEach(row => {
        if (row.cells[0].textContent === item.item_key) {
            row.classList.add('selected');
        }
    });
    
    // Populate form with item details
    document.getElementById('item-key').value = item.item_key;
    document.getElementById('item-name').value = item.item_name;
    document.getElementById('item-description').value = item.item_description;
    document.getElementById('item-type').value = item.item_type;
    document.getElementById('icon').value = item.icon;
    document.getElementById('base-price').value = item.base_price;
    document.getElementById('category').value = item.category;
    document.getElementById('is-active').checked = item.is_active;
    document.getElementById('current-price').value = item.current_price;
    document.getElementById('is-discounted').checked = item.is_discounted;
    document.getElementById('discount-percentage').value = item.discount_percentage;
    
    // Format dates for datetime-local input
    if (item.discount_start) {
        document.getElementById('discount-start').value = item.discount_start.substring(0, 16); // YYYY-MM-DDTHH:mm
    } else {
        document.getElementById('discount-start').value = '';
    }
    
    if (item.discount_end) {
        document.getElementById('discount-end').value = item.discount_end.substring(0, 16); // YYYY-MM-DDTHH:mm
    } else {
        document.getElementById('discount-end').value = '';
    }
    
    // Update discount fields based on checkbox
    toggleDiscountFields();
}

// Toggle discount fields based on checkbox
function toggleDiscountFields() {
    const isDiscounted = document.getElementById('is-discounted').checked;
    const discountPercentage = document.getElementById('discount-percentage');
    const discountStart = document.getElementById('discount-start');
    const discountEnd = document.getElementById('discount-end');
    
    discountPercentage.disabled = !isDiscounted;
    discountStart.disabled = !isDiscounted;
    discountEnd.disabled = !isDiscounted;
}

// Update store item
async function updateStoreItem(e) {
    e.preventDefault();
    
    if (!currentStoreSelection) {
        alert('Please select a store item to update');
        return;
    }
    
    // Get form values
    const updateData = {
        item_name: document.getElementById('item-name').value,
        item_description: document.getElementById('item-description').value,
        item_type: document.getElementById('item-type').value,
        icon: document.getElementById('icon').value,
        base_price: parseInt(document.getElementById('base-price').value) || 0,
        category: document.getElementById('category').value,
        is_active: document.getElementById('is-active').checked,
        is_discounted: document.getElementById('is-discounted').checked,
        discount_percentage: parseInt(document.getElementById('discount-percentage').value) || 0
    };
    
    // Calculate current price based on discount
    if (updateData.is_discounted && updateData.discount_percentage > 0) {
        updateData.current_price = Math.round(updateData.base_price * (1 - updateData.discount_percentage / 100));
    } else {
        updateData.current_price = updateData.base_price;
    }
    
    // Format dates
    const discountStartVal = document.getElementById('discount-start').value;
    const discountEndVal = document.getElementById('discount-end').value;
    
    updateData.discount_start = discountStartVal ? new Date(discountStartVal).toISOString() : null;
    updateData.discount_end = discountEndVal ? new Date(discountEndVal).toISOString() : null;
    
    try {
        const response = await fetch(`/api/store-items/${currentStoreSelection}`, {
            method: 'PUT',
            headers: {
                'Authorization': `Bearer ${localStorage.getItem('adminToken')}`,
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(updateData)
        });

        if (!response.ok) {
            const errorData = await response.json();
            throw new Error(errorData.error || 'Failed to update store item');
        }

        const result = await response.json();
        
        // Update local data
        const itemIndex = storeItems.findIndex(i => i.id === currentStoreSelection);
        if (itemIndex !== -1) {
            storeItems[itemIndex] = result.data;
        }
        
        // Update the table
        displayStoreItems();
        
        alert('Store item updated successfully');
    } catch (error) {
        console.error('Error updating store item:', error);
        alert(`Error updating store item: ${error.message}`);
    }
}

// Delete store item
async function deleteStoreItem() {
    if (!currentStoreSelection) {
        alert('Please select a store item to delete');
        return;
    }
    
    if (confirm('Are you sure you want to delete this store item? This action cannot be undone.')) {
        try {
            const response = await fetch(`/api/store-items/${currentStoreSelection}`, {
                method: 'DELETE',
                headers: {
                    'Authorization': `Bearer ${localStorage.getItem('adminToken')}`,
                    'Content-Type': 'application/json'
                }
            });

            if (!response.ok) {
                const errorData = await response.json();
                throw new Error(errorData.error || 'Failed to delete store item');
            }

            // Remove from local data
            storeItems = storeItems.filter(i => i.id !== currentStoreSelection);
            displayStoreItems();
            
            // Reset form
            document.getElementById('store-item-form').reset();
            currentStoreSelection = null;
            
            alert('Store item deleted successfully');
        } catch (error) {
            console.error('Error deleting store item:', error);
            alert(`Error deleting store item: ${error.message}`);
        }
    }
}

// Save new store item
async function saveNewStoreItem(e) {
    e.preventDefault();
    
    // Get form values
    const newItem = {
        item_key: document.getElementById('add-item-key').value,
        item_name: document.getElementById('add-item-name').value,
        item_description: document.getElementById('add-item-description').value,
        item_type: document.getElementById('add-item-type').value,
        icon: document.getElementById('add-icon').value,
        base_price: parseInt(document.getElementById('add-base-price').value) || 0,
        category: document.getElementById('add-category').value,
        is_active: document.getElementById('add-is-active').checked,
        is_discounted: document.getElementById('add-is-discounted').checked,
        discount_percentage: parseInt(document.getElementById('add-discount-percentage').value) || 0
    };
    
    // Calculate current price based on discount
    if (newItem.is_discounted && newItem.discount_percentage > 0) {
        newItem.current_price = Math.round(newItem.base_price * (1 - newItem.discount_percentage / 100));
    } else {
        newItem.current_price = newItem.base_price;
    }
    
    // Format dates
    const discountStartVal = document.getElementById('add-discount-start').value;
    const discountEndVal = document.getElementById('add-discount-end').value;
    
    newItem.discount_start = discountStartVal ? new Date(discountStartVal).toISOString() : null;
    newItem.discount_end = discountEndVal ? new Date(discountEndVal).toISOString() : null;
    
    try {
        const response = await fetch('/api/store-items', {
            method: 'POST',
            headers: {
                'Authorization': `Bearer ${localStorage.getItem('adminToken')}`,
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(newItem)
        });

        if (!response.ok) {
            const errorData = await response.json();
            throw new Error(errorData.error || 'Failed to add store item');
        }

        const result = await response.json();
        
        // Add to local data
        storeItems.push(result.data);
        
        // Update the table
        displayStoreItems();
        
        // Hide modal
        document.getElementById('add-store-modal').style.display = 'none';
        
        alert('Store item added successfully');
    } catch (error) {
        console.error('Error adding store item:', error);
        alert(`Error adding store item: ${error.message}`);
    }
}

// Load messages
async function loadMessages() {
    showLoading('load-messages');
    
    try {
        // Build query parameters for search filter
        const queryParams = new URLSearchParams();
        const searchFilter = document.getElementById('message-search').value;
        
        if (searchFilter) {
            queryParams.append('search', searchFilter);
        }
        
        // Fetch data from API with filters
        const queryString = queryParams.toString();
        const response = await fetch(`/api/messages${queryString ? `?${queryString}` : ''}`, {
            method: 'GET',
            headers: {
                'Authorization': `Bearer ${localStorage.getItem('adminToken')}`,
                'Content-Type': 'application/json'
            }
        });

        if (!response.ok) {
            const errorData = await response.json();
            throw new Error(errorData.error || 'Failed to fetch messages');
        }

        const data = await response.json();
        messages = data.data || [];
        displayMessages();
    } catch (error) {
        console.error('Error loading messages:', error);
        showErrorInTab('messages', 'Failed to load messages');
    } finally {
        hideLoading('load-messages');
    }
}

// Fetch messages from API
async function fetchMessages() {
    try {
        const response = await fetch(`/api/messages`, {
            method: 'GET',
            headers: {
                'Authorization': `Bearer ${localStorage.getItem('adminToken')}`,
                'Content-Type': 'application/json'
            }
        });

        if (!response.ok) {
            const errorData = await response.json();
            throw new Error(errorData.error || 'Failed to fetch messages');
        }

        const data = await response.json();
        return data.data || [];
    } catch (error) {
        console.error('Error fetching messages:', error);
        throw error;
    }
}

// Display messages
function displayMessages() {
    const tableBody = document.getElementById('messages-table-body');
    tableBody.innerHTML = '';
    
    if (!messages || messages.length === 0) {
        tableBody.innerHTML = '<tr><td colspan="5">No messages available</td></tr>';
        return;
    }
    
    messages.forEach(message => {
        const row = document.createElement('tr');
        row.innerHTML = `
            <td>${message.id}</td>
            <td>${message.title}</td>
            <td>${message.content.substring(0, 50)}${message.content.length > 50 ? '...' : ''}</td>
            <td>${message.expiration_date.substring(0, 19).replace('T', ' ')}</td>
            <td>${message.created_at.substring(0, 19).replace('T', ' ')}</td>
        `;
        
        row.addEventListener('click', () => {
            selectMessage(message.id);
        });
        
        tableBody.appendChild(row);
    });
}

// Select a message
function selectMessage(messageId) {
    const message = messages.find(m => m.id === messageId);
    if (!message) return;
    
    currentMessageSelection = messageId;
    
    // Highlight selected row
    document.querySelectorAll('#messages-table tbody tr').forEach(row => {
        row.classList.remove('selected');
    });
    
    // Find and highlight the selected row
    const rows = document.querySelectorAll('#messages-table tbody tr');
    rows.forEach(row => {
        if (parseInt(row.cells[0].textContent) === messageId) {
            row.classList.add('selected');
        }
    });
    
    // Populate form with message details
    document.getElementById('message-id').value = message.id;
    document.getElementById('message-title').value = message.title;
    document.getElementById('message-content').value = message.content;
    document.getElementById('expiration-date').value = message.expiration_date.substring(0, 16); // YYYY-MM-DDTHH:mm
    document.getElementById('message-created-at').value = message.created_at.substring(0, 19).replace('T', ' ');
}

// Update message
async function updateMessage(e) {
    e.preventDefault();
    
    if (!currentMessageSelection) {
        alert('Please select a message to update');
        return;
    }
    
    // Get form values
    const updateData = {
        title: document.getElementById('message-title').value.trim(),
        content: document.getElementById('message-content').value.trim(),
        expiration_date: new Date(document.getElementById('expiration-date').value).toISOString()
    };
    
    // Validate required fields
    if (!updateData.title || !updateData.content || !updateData.expiration_date) {
        alert('Please fill in all required fields');
        return;
    }
    
    try {
        const response = await fetch(`/api/messages/${currentMessageSelection}`, {
            method: 'PUT',
            headers: {
                'Authorization': `Bearer ${localStorage.getItem('adminToken')}`,
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(updateData)
        });

        if (!response.ok) {
            const errorData = await response.json();
            throw new Error(errorData.error || 'Failed to update message');
        }

        const result = await response.json();
        
        // Update local data
        const messageIndex = messages.findIndex(m => m.id === currentMessageSelection);
        if (messageIndex !== -1) {
            messages[messageIndex] = result.data;
        }
        
        // Update the table
        displayMessages();
        
        alert('Message updated successfully');
    } catch (error) {
        console.error('Error updating message:', error);
        alert(`Error updating message: ${error.message}`);
    }
}

// Delete message
async function deleteMessage() {
    if (!currentMessageSelection) {
        alert('Please select a message to delete');
        return;
    }
    
    if (confirm('Are you sure you want to delete this message? This action cannot be undone.')) {
        try {
            const response = await fetch(`/api/messages/${currentMessageSelection}`, {
                method: 'DELETE',
                headers: {
                    'Authorization': `Bearer ${localStorage.getItem('adminToken')}`,
                    'Content-Type': 'application/json'
                }
            });

            if (!response.ok) {
                const errorData = await response.json();
                throw new Error(errorData.error || 'Failed to delete message');
            }

            // Remove from local data
            messages = messages.filter(m => m.id !== currentMessageSelection);
            displayMessages();
            
            // Reset form
            document.getElementById('message-form').reset();
            currentMessageSelection = null;
            
            alert('Message deleted successfully');
        } catch (error) {
            console.error('Error deleting message:', error);
            alert(`Error deleting message: ${error.message}`);
        }
    }
}

// Save new message
async function saveNewMessage(e) {
    e.preventDefault();
    
    // Get form values
    const newMessage = {
        title: document.getElementById('add-message-title').value.trim(),
        content: document.getElementById('add-message-content').value.trim(),
        expiration_date: new Date(document.getElementById('add-expiration-date').value).toISOString()
    };
    
    if (!newMessage.title || !newMessage.content || !newMessage.expiration_date) {
        alert('Please fill in all required fields');
        return;
    }
    
    try {
        const response = await fetch('/api/messages', {
            method: 'POST',
            headers: {
                'Authorization': `Bearer ${localStorage.getItem('adminToken')}`,
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(newMessage)
        });

        if (!response.ok) {
            const errorData = await response.json();
            throw new Error(errorData.error || 'Failed to add message');
        }

        const result = await response.json();
        
        // Add to local data
        messages.push(result.data);
        
        // Update the table
        displayMessages();
        
        // Hide modal
        document.getElementById('add-message-modal').style.display = 'none';
        
        alert('Message added successfully');
    } catch (error) {
        console.error('Error adding message:', error);
        alert(`Error adding message: ${error.message}`);
    }
}

// Helper function to show loading state
function showLoading(buttonId) {
    const button = document.getElementById(buttonId);
    const originalText = button.textContent;
    button.innerHTML = '<div class="loading"></div> Loading...';
    button.disabled = true;
    button.dataset.originalText = originalText;
}

// Helper function to hide loading state
function hideLoading(buttonId) {
    const button = document.getElementById(buttonId);
    button.innerHTML = button.dataset.originalText;
    button.disabled = false;
}

// Helper function to show error in a specific tab
function showErrorInTab(tabName, message) {
    const tabPane = document.getElementById(`${tabName}-tab`);
    const errorDiv = document.createElement('div');
    errorDiv.className = 'error-message show';
    errorDiv.textContent = message;
    tabPane.insertBefore(errorDiv, tabPane.firstChild);
    
    // Remove the error after 5 seconds
    setTimeout(() => {
        if (errorDiv.parentNode) {
            errorDiv.parentNode.removeChild(errorDiv);
        }
    }, 5000);
}

// Add CSS for selected rows
const style = document.createElement('style');
style.textContent = `
    .data-table tbody tr.selected {
        background-color: #d1ecf1;
        border-left: 4px solid #4a6fa5;
    }
`;
document.head.appendChild(style);