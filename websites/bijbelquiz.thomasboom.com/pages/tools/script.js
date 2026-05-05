const form = document.getElementById('questionForm');
const dynamicFields = document.getElementById('dynamicFields');
const downloadBtn = document.getElementById('downloadBtn');

// Declare questions array for use throughout the script
let questions = [];
let editingIndex = null;

// Categories list from categories.json
const categoriesList = [
  "Genesis", "Exodus", "Leviticus", "Numeri", "Deuteronomium",
  "Jozua", "Richteren", "Ruth", "1 Samuël", "2 Samuël",
  "1 Koningen", "2 Koningen", "1 Kronieken", "2 Kronieken",
  "Ezra", "Nehemia", "Esther", "Job", "Psalmen", "Spreuken",
  "Prediker", "Hooglied", "Jesaja", "Jeremia", "Klaagliederen",
  "Ezechiël", "Daniël", "Hosea", "Joël", "Amos", "Obadja",
  "Jona", "Micha", "Nahum", "Habakuk", "Zefanja", "Haggai",
  "Zacharia", "Maleachi", "Matteüs", "Marcus", "Lucas",
  "Johannes", "Handelingen", "Romeinen", "1 Korintiërs",
  "2 Korintiërs", "Galaten", "Efeziërs", "Filippenzen",
  "Kolossenzen", "1 Tessalonicenzen", "2 Tessalonicenzen",
  "1 Timoteüs", "2 Timoteüs", "Titus", "Filemon", "Hebreeën",
  "Jakobus", "1 Petrus", "2 Petrus", "1 Johannes", "2 Johannes",
  "3 Johannes", "Judas", "Openbaring", "Kerst", "Pasen",
  "Pinksteren", "Hemelvaart", "Goede Vrijdag", "Stille Zaterdag",
  "Paasmaandag", "Pinkstermaandag"
];

// Bible book names for autocomplete and validation
const bibleBookNames = [
  "Genesis", "Exodus", "Leviticus", "Numeri", "Deuteronomium",
  "Jozua", "Richteren", "Ruth", "1 Samuel", "2 Samuel",
  "1 Koningen", "2 Koningen", "1 Kronieken", "2 Kronieken",
  "Ezra", "Nehemia", "Esther", "Job", "Psalmen", "Spreuken",
  "Prediker", "Hooglied", "Jesaja", "Jeremia", "Klaagliederen",
  "Ezechiël", "Daniël", "Hosea", "Joël", "Amos", "Obadja",
  "Jona", "Micha", "Nahum", "Habakuk", "Zefanja", "Haggai",
  "Zacharia", "Maleachi", "Matteüs", "Marcus", "Lucas",
  "Johannes", "Handelingen", "Romeinen", "1 Korintiërs",
  "2 Korintiërs", "Galaten", "Efeziërs", "Filippenzen",
  "Kolossenzen", "1 Tessalonicenzen", "2 Tessalonicenzen",
  "1 Timoteüs", "2 Timoteüs", "Titus", "Filemon", "Hebreeën",
  "Jakobus", "1 Petrus", "2 Petrus", "1 Johannes", "2 Johannes",
  "3 Johannes", "Judas", "Openbaring"
];

// Common misspellings and their corrections
const bibleBookCorrections = {
  "genesis": "Genesis", "gen": "Genesis",
  "exodus": "Exodus", "ex": "Exodus",
  "leviticus": "Leviticus", "lev": "Leviticus",
  "numeri": "Numeri", "num": "Numeri", "nummers": "Numeri",
  "deuteronomium": "Deuteronomium", "deut": "Deuteronomium",
  "jozua": "Jozua", "joz": "Jozua",
  "richteren": "Richteren", "richt": "Richteren",
  "ruth": "Ruth",
  "1 samuel": "1 Samuel", "1samuel": "1 Samuel", "1sam": "1 Samuel",
  "2 samuel": "2 Samuel", "2samuel": "2 Samuel", "2sam": "2 Samuel",
  "1 koningen": "1 Koningen", "1koningen": "1 Koningen", "1kon": "1 Koningen",
  "2 koningen": "2 Koningen", "2koningen": "2 Koningen", "2kon": "2 Koningen",
  "1 kronieken": "1 Kronieken", "1kronieken": "1 Kronieken", "1kron": "1 Kronieken",
  "2 kronieken": "2 Kronieken", "2kronieken": "2 Kronieken", "2kron": "2 Kronieken",
  "ezra": "Ezra",
  "nehemia": "Nehemia", "neh": "Nehemia",
  "esther": "Esther", "est": "Esther",
  "job": "Job",
  "psalmen": "Psalmen", "ps": "Psalmen", "psalm": "Psalmen",
  "spreuken": "Spreuken", "spr": "Spreuken",
  "prediker": "Prediker", "pred": "Prediker",
  "hooglied": "Hooglied", "hoog": "Hooglied",
  "jesaja": "Jesaja", "jes": "Jesaja", "isaiah": "Jesaja",
  "jeremia": "Jeremia", "jer": "Jeremia",
  "klaagliederen": "Klaagliederen", "klagl": "Klaagliederen",
  "ezechiël": "Ezechiël", "ezechiel": "Ezechiël", "ez": "Ezechiël", "ezech": "Ezechiël",
  "daniël": "Daniël", "daniel": "Daniël", "dan": "Daniël",
  "hosea": "Hosea", "hos": "Hosea",
  "joël": "Joël", "joel": "Joël",
  "amos": "Amos",
  "obadja": "Obadja", "obad": "Obadja",
  "jona": "Jona",
  "micha": "Micha", "mich": "Micha",
  "nahum": "Nahum", "nah": "Nahum",
  "habakuk": "Habakuk", "hab": "Habakuk",
  "zefanja": "Zefanja", "zef": "Zefanja",
  "haggai": "Haggai", "hag": "Haggai",
  "zacharia": "Zacharia", "zach": "Zacharia",
  "maleachi": "Maleachi", "mal": "Maleachi",
  "matteüs": "Matteüs", "matteus": "Matteüs", "mat": "Matteüs", "matt": "Matteüs",
  "marcus": "Marcus", "mar": "Marcus", "mark": "Marcus", "markus": "Marcus",
  "lukas": "Lukas", "luk": "Lukas", "luke": "Lukas",
  "johannes": "Johannes", "joh": "Johannes", "john": "Johannes",
  "handelingen": "Handelingen", "hand": "Handelingen", "acts": "Handelingen",
  "romeinen": "Romeinen", "rom": "Romeinen", "romans": "Romeinen",
  "1 korintiërs": "1 Korintiërs", "1korintiërs": "1 Korintiërs", "1kor": "1 Korintiërs",
  "1 corinthians": "1 Korintiërs",
  "2 korintiërs": "2 Korintiërs", "2korintiërs": "2 Korintiërs", "2kor": "2 Korintiërs",
  "2 corinthians": "2 Korintiërs",
  "galaten": "Galaten", "gal": "Galaten", "galatians": "Galaten",
  "efeziërs": "Efeziërs", "efeziers": "Efeziërs", "ef": "Efeziërs", "eph": "Efeziërs", "ephesians": "Efeziërs",
  "filippenzen": "Filippenzen", "fil": "Filippenzen", "phil": "Filippenzen", "philippians": "Filippenzen",
  "kolossenzen": "Kolossenzen", "kol": "Kolossenzen", "col": "Kolossenzen", "colossians": "Kolossenzen",
  "1 tessalonicenzen": "1 Tessalonicenzen", "1tessalonicenzen": "1 Tessalonicenzen", "1tess": "1 Tessalonicenzen",
  "1 thessalonians": "1 Tessalonicenzen",
  "2 tessalonicenzen": "2 Tessalonicenzen", "2tessalonicenzen": "2 Tessalonicenzen", "2tess": "2 Tessalonicenzen",
  "2 thessalonians": "2 Tessalonicenzen",
  "1 timoteüs": "1 Timoteüs", "1timoteüs": "1 Timoteüs", "1tim": "1 Timoteüs",
  "1 timothy": "1 Timoteüs",
  "2 timoteüs": "2 Timoteüs", "2timoteüs": "2 Timoteüs", "2tim": "2 Timoteüs",
  "2 timothy": "2 Timoteüs",
  "titus": "Titus",
  "filemon": "Filemon", "fil": "Filemon", "philemon": "Filemon",
  "hebreeën": "Hebreeën", "hebreeen": "Hebreeën", "heb": "Hebreeën", "hebrews": "Hebreeën",
  "jakobus": "Jakobus", "jak": "Jakobus", "james": "Jakobus",
  "1 petrus": "1 Petrus", "1petrus": "1 Petrus", "1pet": "1 Petrus", "1peter": "1 Petrus",
  "2 petrus": "2 Petrus", "2petrus": "2 Petrus", "2pet": "2 Petrus", "2peter": "2 Petrus",
  "1 johannes": "1 Johannes", "1johannes": "1 Johannes", "1joh": "1 Johannes", "1john": "1 Johannes",
  "2 johannes": "2 Johannes", "2johannes": "2 Johannes", "2joh": "2 Johannes", "2john": "2 Johannes",
  "3 johannes": "3 Johannes", "3johannes": "3 Johannes", "3joh": "3 Johannes", "3john": "3 Johannes",
  "judas": "Judas", "jude": "Judas",
  "openbaring": "Openbaring", "openb": "Openbaring", "apocalypse": "Openbaring", "revelation": "Openbaring", "rev": "Openbaring"
};

// Normalize book name (remove special chars for matching)
function normalizeBookName(bookName) {
  return bookName
    .toLowerCase()
    .replace(/[ëïéèêâôûîäöüÿç]/g, char => {
      const map = { 'ë': 'e', 'ï': 'i', 'é': 'e', 'è': 'e', 'ê': 'e', 'â': 'a', 'ô': 'o', 'û': 'u', 'î': 'i', 'ä': 'a', 'ö': 'o', 'ü': 'u', 'ÿ': 'y', 'ç': 'c' };
      return map[char] || char;
    })
    .replace(/[^\w\s]/g, '')
    .trim();
}

// Get corrected book name
function getCorrectedBookName(input) {
  const normalized = normalizeBookName(input);
  
  // First check exact match
  if (bibleBookNames.includes(input)) {
    return input;
  }
  
  // Check corrections map
  if (bibleBookCorrections[normalized]) {
    return bibleBookCorrections[normalized];
  }
  
  // Try to find partial match
  const partialMatches = bibleBookNames.filter(book => 
    normalizeBookName(book).startsWith(normalized) ||
    normalized.startsWith(normalizeBookName(book))
  );
  
  if (partialMatches.length === 1) {
    return partialMatches[0];
  }
  
  return null;
}

// Format the biblical reference properly
function formatBiblicalReference(input) {
  if (!input || !input.trim()) return '';
  
  input = input.trim();
  
  // Try to parse the input
  // Common formats: "Genesis 1:1", "Gen 1:1", "1:1", "Genesis 1", "Gen 1"
  
  // Check for chapter:verse pattern
  const chapterVerseMatch = input.match(/^(\d+)[:\s]*(\d+)$/);
  if (chapterVerseMatch && window.lastSelectedBook) {
    // Just chapter:verse provided, use last selected book
    return `${window.lastSelectedBook} ${chapterVerseMatch[1]}:${chapterVerseMatch[2]}`;
  }
  
  // Try to extract book name and reference
  // Match patterns like "Genesis 1:1" or "Gen 1:1" or "Genesis 1" or "1 Cor 1:1"
  const bookRefMatch = input.match(/^((?:\d\s*)?[a-zA-Zëïéèêâôûîäöüÿç\s]+)[:\s]*(\d.*)$/i);
  
  if (bookRefMatch) {
    let bookPart = bookRefMatch[1].trim();
    let refPart = bookRefMatch[2].trim();
    
    // Remove extra spaces from book part
    bookPart = bookPart.replace(/\s+/g, ' ');
    
    // Try to correct the book name
    const correctedBook = getCorrectedBookName(bookPart);
    
    if (correctedBook) {
      window.lastSelectedBook = correctedBook;
      
      // Clean up the reference part
      // Handle formats like "1:1", "1 - 2", "1:1-5", "1:1,3", "1:1-2:5"
      refPart = refPart
        .replace(/\s*[-–—]\s*/g, '-')  // Normalize dashes
        .replace(/\s*,\s*/g, ',')      // Normalize commas
        .replace(/\s+/g, ':');         // Convert spaces to colons for chapter:verse
      
      return `${correctedBook} ${refPart}`;
    }
  }
  
  // If it's just a book name
  const justBook = getCorrectedBookName(input);
  if (justBook) {
    window.lastSelectedBook = justBook;
    return justBook;
  }
  
  // Return original if we can't parse it
  return input;
}

// Validate biblical reference format
function isValidBiblicalReference(reference) {
  if (!reference || !reference.trim()) return true; // Empty is valid (optional field)
  
  const formatted = formatBiblicalReference(reference);
  
  // Check if it starts with a valid book name
  for (const book of bibleBookNames) {
    if (formatted.startsWith(book)) {
      // Check if there's a chapter reference
      const afterBook = formatted.slice(book.length).trim();
      if (!afterBook) return true; // Just book name is valid
      
      // Validate chapter:verse format
      return /^\s*\d+([:\-]\d+)*(,\d+([:\-]\d+)*)*$/.test(afterBook);
    }
  }
  
  return false;
}

// Toast utility
function showToast(message, isError = false) {
  let toast = document.createElement('div');
  toast.className = 'toast' + (isError ? ' error' : '');
  toast.setAttribute('role', 'alert');
  toast.textContent = message;
  document.body.appendChild(toast);
  setTimeout(() => { toast.classList.add('show'); }, 10);
  setTimeout(() => { toast.classList.remove('show'); setTimeout(() => toast.remove(), 400); }, 2200);
}

// Local backup helpers
function saveBackup() {
  localStorage.setItem('bijbelquiz_questions', JSON.stringify(questions));
}
function restoreBackup() {
  const data = localStorage.getItem('bijbelquiz_questions');
  if (data) {
    questions = JSON.parse(data);
    updatePreview(true);
    renderQuestionsList();
    showToast('Backup hersteld!');
  } else {
    showToast('Geen backup gevonden.', true);
  }
}

// Function to save the last selected question type
function saveLastQuestionType(type) {
  localStorage.setItem('bijbelquiz_last_type', type);
}

// Generate the next question ID based on existing questions
function getNextQuestionId() {
  if (questions.length === 0) {
    return '000001';
  }
  // Find the highest ID number
  let maxId = 0;
  questions.forEach(q => {
    if (q.id) {
      const idNum = parseInt(q.id, 10);
      if (!isNaN(idNum) && idNum > maxId) {
        maxId = idNum;
      }
    }
  });
  // Generate next ID with leading zeros
  const nextId = (maxId + 1).toString().padStart(6, '0');
  return nextId;
}

// Render category checkboxes
function renderCategories(selectedCategories = []) {
  let html = '<label>Categorieën (optioneel):</label>';
  html += '<div class="categories-container">';
  categoriesList.forEach(cat => {
    const catId = 'cat_' + cat.replace(/\s+/g, '_').replace(/[^a-zA-Z0-9_]/g, '');
    const isChecked = selectedCategories.includes(cat) ? 'checked' : '';
    html += `<div class="category-item">`;
    html += `<input type="checkbox" id="${catId}" name="categories" value="${cat}" ${isChecked}>`;
    html += `<label for="${catId}">${cat}</label>`;
    html += `</div>`;
  });
  html += '</div>';
  return html;
}

// Load existing questions from questions-nl-sv.json
async function loadExistingQuestions() {
  try {
    const response = await fetch('questions-nl-sv.json');
    if (response.ok) {
      const data = await response.json();
      if (Array.isArray(data) && data.length > 0) {
        questions = data;
        saveBackup();
        updatePreview();
        renderQuestionsList();
        showToast(`${questions.length} vragen geladen!`);
      }
    } else {
      showToast('Kon bestaande vragen niet laden.', true);
    }
  } catch (error) {
    console.log('Geen bestaande vragen gevonden, start met lege lijst');
  }
}

// Mode toggle functionality
const addModeBtn = document.getElementById('addModeBtn');
const editModeBtn = document.getElementById('editModeBtn');
const addModeSection = document.getElementById('addModeSection');
const editModeSection = document.getElementById('editModeSection');

addModeBtn.addEventListener('click', () => {
  setMode('add');
});

editModeBtn.addEventListener('click', () => {
  setMode('edit');
  renderQuestionsList();
});

function setMode(mode) {
  if (mode === 'add') {
    addModeSection.style.display = '';
    editModeSection.style.display = 'none';
    addModeBtn.classList.add('active');
    editModeBtn.classList.remove('active');
  } else {
    addModeSection.style.display = 'none';
    editModeSection.style.display = '';
    addModeBtn.classList.remove('active');
    editModeBtn.classList.add('active');
    renderQuestionsList();
  }
}

// Render questions list for edit mode
function renderQuestionsList(searchTerm = '') {
  const container = document.getElementById('questionsList');
  
  let filteredQuestions = questions;
  if (searchTerm) {
    const term = searchTerm.toLowerCase();
    filteredQuestions = questions.filter(q => 
      q.vraag.toLowerCase().includes(term) ||
      q.id.toLowerCase().includes(term) ||
      (q.biblicalReference && q.biblicalReference.toLowerCase().includes(term))
    );
  }
  
  if (filteredQuestions.length === 0) {
    container.innerHTML = '<p class="no-questions">Geen vragen gevonden.</p>';
    return;
  }
  
  let html = '';
  filteredQuestions.forEach((q, index) => {
    const realIndex = questions.indexOf(q);
    const typeLabel = q.type === 'mc' ? 'Meerkeuze' : q.type === 'fitb' ? 'Invulvraag' : 'Waar/Niet Waar';
    const categoriesLabel = q.categories && q.categories.length > 0 ? q.categories.join(', ') : 'Geen categorieën';
    
    html += `<div class="question-item" data-index="${realIndex}">`;
    html += `<div class="question-header">`;
    html += `<span class="question-id">${q.id}</span>`;
    html += `<span class="question-type">${typeLabel}</span>`;
    html += `<span class="question-difficulty">Moeilijkheid: ${q.moeilijkheidsgraad}</span>`;
    html += `</div>`;
    html += `<div class="question-text">${escapeHtml(q.vraag)}</div>`;
    html += `<div class="question-categories">${escapeHtml(categoriesLabel)}</div>`;
    if (q.biblicalReference) {
      html += `<div class="question-reference">${escapeHtml(q.biblicalReference)}</div>`;
    }
    html += `<div class="question-actions">`;
    html += `<button type="button" class="edit-btn" onclick="editQuestion(${realIndex})">Bewerken</button>`;
    html += `<button type="button" class="delete-btn" onclick="deleteQuestion(${realIndex})">Verwijderen</button>`;
    html += `</div>`;
    html += `</div>`;
  });
  
  container.innerHTML = html;
}

// Escape HTML to prevent XSS
function escapeHtml(text) {
  const div = document.createElement('div');
  div.textContent = text;
  return div.innerHTML;
}

// Search functionality
const searchInput = document.getElementById('searchQuestions');
if (searchInput) {
  searchInput.addEventListener('input', (e) => {
    renderQuestionsList(e.target.value);
  });
}

// Edit question
function editQuestion(index) {
  editingIndex = index;
  const q = questions[index];
  
  document.getElementById('editIndex').value = index;
  document.getElementById('editType').value = q.type;
  document.getElementById('editDifficulty').value = q.moeilijkheidsgraad;
  
  renderEditFields(q.type, q);
  document.getElementById('editModal').style.display = 'flex';
}

// Render edit form fields
function renderEditFields(type, question = null) {
  const container = document.getElementById('editDynamicFields');
  let html = '';
  
  if (type === 'mc') {
    html += `<label for="editVraag">Vraag:</label>`;
    html += `<input type="text" id="editVraag" name="editVraag" required value="${escapeHtml(question ? question.vraag : '')}">`;
    html += `<label for="editJuisteAntwoord">Juiste antwoord:</label>`;
    html += `<input type="text" id="editJuisteAntwoord" name="editJuisteAntwoord" required value="${escapeHtml(question ? question.juisteAntwoord : '')}">`;
    html += `<label>Foute antwoorden:</label>`;
    html += `<input type="text" id="editFouteAntwoord1" name="editFouteAntwoord1" required value="${escapeHtml(question && question.fouteAntwoorden[0] ? question.fouteAntwoorden[0] : '')}">`;
    html += `<input type="text" id="editFouteAntwoord2" name="editFouteAntwoord2" required value="${escapeHtml(question && question.fouteAntwoorden[1] ? question.fouteAntwoorden[1] : '')}">`;
    html += `<input type="text" id="editFouteAntwoord3" name="editFouteAntwoord3" required value="${escapeHtml(question && question.fouteAntwoorden[2] ? question.fouteAntwoorden[2] : '')}">`;
    html += renderBibleReferenceInput('editBiblicalReference', 'editBiblicalReference', question && question.biblicalReference ? question.biblicalReference : '');
    html += renderEditCategories(question ? question.categories : []);
  } else if (type === 'fitb') {
    html += `<label for="editVraag">Vraag (gebruik _____ voor het invulveld):</label>`;
    html += `<input type="text" id="editVraag" name="editVraag" required value="${escapeHtml(question ? question.vraag : '')}">`;
    html += `<label for="editJuisteAntwoord">Juiste antwoord:</label>`;
    html += `<input type="text" id="editJuisteAntwoord" name="editJuisteAntwoord" required value="${escapeHtml(question ? question.juisteAntwoord : '')}">`;
    html += `<label>Foute antwoorden:</label>`;
    html += `<input type="text" id="editFouteAntwoord1" name="editFouteAntwoord1" required value="${escapeHtml(question && question.fouteAntwoorden[0] ? question.fouteAntwoorden[0] : '')}">`;
    html += `<input type="text" id="editFouteAntwoord2" name="editFouteAntwoord2" required value="${escapeHtml(question && question.fouteAntwoorden[1] ? question.fouteAntwoorden[1] : '')}">`;
    html += `<input type="text" id="editFouteAntwoord3" name="editFouteAntwoord3" required value="${escapeHtml(question && question.fouteAntwoorden[2] ? question.fouteAntwoorden[2] : '')}">`;
    html += renderBibleReferenceInput('editBiblicalReference', 'editBiblicalReference', question && question.biblicalReference ? question.biblicalReference : '');
    html += renderEditCategories(question ? question.categories : []);
  } else if (type === 'tf') {
    const isWaar = question && question.juisteAntwoord === 'Waar';
    html += `<label for="editVraag">Stelling:</label>`;
    html += `<input type="text" id="editVraag" name="editVraag" required value="${escapeHtml(question ? question.vraag : '')}">`;
    html += `<label for="editJuisteAntwoord">Is dit waar?</label>`;
    html += `<select id="editJuisteAntwoord" name="editJuisteAntwoord">`;
    html += `<option value="Waar" ${isWaar ? 'selected' : ''}>Waar</option>`;
    html += `<option value="Niet waar" ${!isWaar ? 'selected' : ''}>Niet waar</option>`;
    html += `</select>`;
    html += renderBibleReferenceInput('editBiblicalReference', 'editBiblicalReference', question && question.biblicalReference ? question.biblicalReference : '');
    html += renderEditCategories(question ? question.categories : []);
  }
  
  container.innerHTML = html;
  
  // Setup autocomplete for edit Bible reference input
  setupBibleReferenceAutocomplete('editBiblicalReference');
}

// Render category checkboxes for edit form
function renderEditCategories(selectedCategories = []) {
  let html = '<label>Categorieën (optioneel):</label>';
  html += '<div class="categories-container">';
  categoriesList.forEach(cat => {
    const catId = 'editcat_' + cat.replace(/\s+/g, '_').replace(/[^a-zA-Z0-9_]/g, '');
    const isChecked = selectedCategories.includes(cat) ? 'checked' : '';
    html += `<div class="category-item">`;
    html += `<input type="checkbox" id="${catId}" name="editCategories" value="${cat}" ${isChecked}>`;
    html += `<label for="${catId}">${cat}</label>`;
    html += `</div>`;
  });
  html += '</div>';
  return html;
}

// Get selected categories from edit form
function getEditSelectedCategories() {
  const checkboxes = document.querySelectorAll('#editForm input[name="editCategories"]:checked');
  return Array.from(checkboxes).map(cb => cb.value);
}

// Edit type change handler
document.getElementById('editType').addEventListener('change', (e) => {
  renderEditFields(e.target.value);
});

// Save edited question
document.getElementById('editForm').addEventListener('submit', (e) => {
  e.preventDefault();
  
  const index = parseInt(document.getElementById('editIndex').value, 10);
  const type = document.getElementById('editType').value;
  const vraag = document.getElementById('editVraag').value.trim();
  const juisteAntwoord = document.getElementById('editJuisteAntwoord').value.trim();
  const moeilijkheidsgraad = Number(document.getElementById('editDifficulty').value);
  const biblicalReference = document.getElementById('editBiblicalReference').value.trim();
  const categories = getEditSelectedCategories();
  
  // Keep the original ID
  const id = questions[index].id;
  
  let updatedQuestion = {
    vraag,
    juisteAntwoord,
    moeilijkheidsgraad,
    type,
    categories,
    biblicalReference: biblicalReference || null,
    fouteAntwoorden: [],
    id
  };
  
  if (type === 'mc' || type === 'fitb') {
    const fouteAntwoorden = [
      document.getElementById('editFouteAntwoord1').value.trim(),
      document.getElementById('editFouteAntwoord2').value.trim(),
      document.getElementById('editFouteAntwoord3').value.trim()
    ];
    updatedQuestion.fouteAntwoorden = fouteAntwoorden;
    
    if (!vraag || !juisteAntwoord || fouteAntwoorden.some(f => !f)) {
      showToast('Vul alle verplichte velden in.', true);
      return;
    }
  } else if (type === 'tf') {
    updatedQuestion.juisteAntwoord = juisteAntwoord === 'Waar' ? 'Waar' : 'Niet waar';
    updatedQuestion.fouteAntwoorden = [juisteAntwoord === 'Waar' ? 'Niet waar' : 'Waar'];
    
    if (!vraag || !juisteAntwoord) {
      showToast('Vul alle verplichte velden in.', true);
      return;
    }
  }
  
  questions[index] = updatedQuestion;
  saveBackup();
  renderQuestionsList(searchInput ? searchInput.value : '');
  updatePreview();
  
  document.getElementById('editModal').style.display = 'none';
  showToast(`Vraag ${id} bijgewerkt!`);
});

// Cancel edit
document.getElementById('cancelEditBtn').addEventListener('click', () => {
  document.getElementById('editModal').style.display = 'none';
  editingIndex = null;
});

// Delete question
function deleteQuestion(index) {
  if (confirm(`Weet je zeker dat je vraag ${questions[index].id} wilt verwijderen?`)) {
    questions.splice(index, 1);
    saveBackup();
    renderQuestionsList(searchInput ? searchInput.value : '');
    updatePreview();
    showToast('Vraag verwijderd!');
  }
}

// Make functions global for onclick handlers
window.editQuestion = editQuestion;
window.deleteQuestion = deleteQuestion;

window.addEventListener('DOMContentLoaded', () => {
  // Restore last selected question type
  const lastType = localStorage.getItem('bijbelquiz_last_type');
  if (lastType) {
    const typeSelect = document.getElementById('type');
    typeSelect.value = lastType;
    renderFields(lastType);
  }

  // Restore questions if they exist
  if (localStorage.getItem('bijbelquiz_questions')) {
    restoreBackup();
    document.getElementById('restoreBtn').style.display = '';
    document.getElementById('clearBtn').style.display = '';
  } else {
    // Load existing questions from file
    loadExistingQuestions();
  }
});

// Render Bible reference input with autocomplete
function renderBibleReferenceInput(id, name, value = '') {
  let html = `<div class="bible-reference-container">`;
  html += `<label for="${id}">Bijbelreferentie (optioneel):</label>`;
  html += `<input type="text" id="${id}" name="${name}" class="bible-reference-input" placeholder="Bijv. Genesis 1:1 of Gen 1:1" value="${escapeHtml(value)}" autocomplete="off">`;
  html += `<div class="bible-autocomplete-dropdown" id="${id}_dropdown"></div>`;
  html += `<div class="bible-reference-validation" id="${id}_validation"></div>`;
  html += `</div>`;
  return html;
}

// Setup Bible reference autocomplete
function setupBibleReferenceAutocomplete(inputId) {
  const input = document.getElementById(inputId);
  const dropdown = document.getElementById(inputId + '_dropdown');
  const validation = document.getElementById(inputId + '_validation');
  
  if (!input) return;
  
  let selectedIndex = -1;
  let filteredBooks = [];
  
  input.addEventListener('input', (e) => {
    const value = e.target.value;
    selectedIndex = -1;
    
    if (value.length < 1) {
      dropdown.style.display = 'none';
      validation.textContent = '';
      input.classList.remove('valid', 'invalid');
      return;
    }
    
    // Check if user is typing book name or reference
    const parts = value.split(/[\s:]+/);
    const firstPart = parts[0].toLowerCase();
    
    // If only one part or first part looks like a book name
    if (parts.length <= 2 && !/^\d+$/.test(parts[0])) {
      // Filter book names
      filteredBooks = bibleBookNames.filter(book => {
        const normalizedBook = normalizeBookName(book);
        const normalizedInput = normalizeBookName(firstPart);
        return normalizedBook.includes(normalizedInput) ||
               normalizedInput.includes(normalizedBook);
      });
      
      // Add corrections
      const normalizedFirst = normalizeBookName(firstPart);
      if (bibleBookCorrections[normalizedFirst] && !filteredBooks.includes(bibleBookCorrections[normalizedFirst])) {
        filteredBooks.unshift(bibleBookCorrections[normalizedFirst]);
      }
      
      if (filteredBooks.length > 0) {
        dropdown.innerHTML = filteredBooks.slice(0, 10).map((book, index) => 
          `<div class="autocomplete-item ${index === selectedIndex ? 'selected' : ''}" data-book="${escapeHtml(book)}">${escapeHtml(book)}</div>`
        ).join('');
        dropdown.style.display = 'block';
        
        // Add click handlers
        dropdown.querySelectorAll('.autocomplete-item').forEach(item => {
          item.addEventListener('click', () => {
            const book = item.getAttribute('data-book');
            window.lastSelectedBook = book;
            const rest = parts.slice(1).join(':');
            input.value = rest ? `${book} ${rest}` : book;
            dropdown.style.display = 'none';
            validateReference();
          });
        });
      } else {
        dropdown.style.display = 'none';
      }
    } else {
      dropdown.style.display = 'none';
    }
    
    validateReference();
  });
  
  // Keyboard navigation
  input.addEventListener('keydown', (e) => {
    if (dropdown.style.display === 'none') return;
    
    const items = dropdown.querySelectorAll('.autocomplete-item');
    
    if (e.key === 'ArrowDown') {
      e.preventDefault();
      selectedIndex = Math.min(selectedIndex + 1, items.length - 1);
      updateSelection(items);
    } else if (e.key === 'ArrowUp') {
      e.preventDefault();
      selectedIndex = Math.max(selectedIndex - 1, -1);
      updateSelection(items);
    } else if (e.key === 'Enter' && selectedIndex >= 0) {
      e.preventDefault();
      items[selectedIndex].click();
    } else if (e.key === 'Escape') {
      dropdown.style.display = 'none';
    }
  });
  
  // Format on blur
  input.addEventListener('blur', () => {
    setTimeout(() => {
      dropdown.style.display = 'none';
      if (input.value.trim()) {
        const formatted = formatBiblicalReference(input.value);
        input.value = formatted;
        validateReference();
      }
    }, 200);
  });
  
  // Close dropdown when clicking outside
  document.addEventListener('click', (e) => {
    if (!input.contains(e.target) && !dropdown.contains(e.target)) {
      dropdown.style.display = 'none';
    }
  });
  
  function updateSelection(items) {
    items.forEach((item, index) => {
      item.classList.toggle('selected', index === selectedIndex);
    });
    if (selectedIndex >= 0 && items[selectedIndex]) {
      items[selectedIndex].scrollIntoView({ block: 'nearest' });
    }
  }
  
  function validateReference() {
    const value = input.value.trim();
    if (!value) {
      validation.textContent = '';
      input.classList.remove('valid', 'invalid');
      return;
    }
    
    const formatted = formatBiblicalReference(value);
    const isValid = isValidBiblicalReference(value);
    
    if (isValid) {
      validation.textContent = '✓ Geldige referentie';
      validation.className = 'bible-reference-validation valid';
      input.classList.add('valid');
      input.classList.remove('invalid');
    } else {
      const corrected = getCorrectedBookName(value.split(/[\s:]+/)[0]);
      if (corrected && corrected !== value.split(/[\s:]+/)[0]) {
        validation.textContent = `Bedoelt u: ${corrected}?`;
        validation.className = 'bible-reference-validation hint';
      } else {
        validation.textContent = '⚠ Ongeldige referentie formaat';
        validation.className = 'bible-reference-validation invalid';
      }
      input.classList.add('invalid');
      input.classList.remove('valid');
    }
  }
}

function renderFields(type) {
  // Always clear previous dynamic fields and their values
  dynamicFields.innerHTML = '';
  let html = '';
  if (type === 'mc') {
    html += `<label for="vraag">Vraag:</label>
`;
    html += `<input type="text" id="vraag" name="vraag" required aria-required="true" placeholder="Typ hier de vraag...">
`;
    html += `<label for="juisteAntwoord">Juiste antwoord:</label>
`;
    html += `<input type="text" id="juisteAntwoord" name="juisteAntwoord" required aria-required="true" placeholder="Typ hier het juiste antwoord...">
`;
    html += `<label>Foute antwoorden:</label>
`;
    html += `<input type="text" id="fouteAntwoord1" name="fouteAntwoord1" required placeholder="Typ hier een fout antwoord..." aria-required="true">
`;
    html += `<input type="text" id="fouteAntwoord2" name="fouteAntwoord2" required placeholder="Typ hier een fout antwoord..." aria-required="true">
`;
    html += `<input type="text" id="fouteAntwoord3" name="fouteAntwoord3" required placeholder="Typ hier een fout antwoord..." aria-required="true">
`;
    html += renderBibleReferenceInput('biblicalReference', 'biblicalReference');
    html += renderCategories();
  } else if (type === 'fitb') {
    html += `<label for="vraag">Vraag (gebruik _____ voor het invulveld):</label>
`;
    html += `<input type="text" id="vraag" name="vraag" required placeholder="Bijv. Mozes leidde het volk _____ uit Egypte" aria-required="true">
`;
    html += `<label for="juisteAntwoord">Juiste antwoord:</label>
`;
    html += `<input type="text" id="juisteAntwoord" name="juisteAntwoord" required aria-required="true" placeholder="Typ hier het juiste antwoord...">
`;
    html += `<label>Foute antwoorden:</label>
`;
    html += `<input type="text" id="fouteAntwoord1" name="fouteAntwoord1" required placeholder="Typ hier een fout antwoord..." aria-required="true">
`;
    html += `<input type="text" id="fouteAntwoord2" name="fouteAntwoord2" required placeholder="Typ hier een fout antwoord..." aria-required="true">
`;
    html += `<input type="text" id="fouteAntwoord3" name="fouteAntwoord3" required placeholder="Typ hier een fout antwoord..." aria-required="true">
`;
    html += renderBibleReferenceInput('biblicalReference', 'biblicalReference');
    html += renderCategories();
  } else if (type === 'tf') {
    html += `<label for="vraag">Stelling:</label>
`;
    html += `<input type="text" id="vraag" name="vraag" required aria-required="true" placeholder="Typ hier de stelling...">
`;
    html += `<label for="juisteAntwoord">Is dit waar?</label>
`;
    html += `<select id="juisteAntwoord" name="juisteAntwoord"><option value="Waar">Waar</option><option value="Niet waar">Niet waar</option></select>
`;
    html += renderBibleReferenceInput('biblicalReference', 'biblicalReference');
    html += renderCategories();
  }
  dynamicFields.innerHTML = html;
  
  // Setup autocomplete for Bible reference inputs
  setupBibleReferenceAutocomplete('biblicalReference');
}

form.type.addEventListener('change', e => {
  // Only reset dynamic fields, not the whole form
  const selectedType = e.target.value;
  renderFields(selectedType);
  saveLastQuestionType(selectedType);
});

// Initial render
renderFields(form.type.value);

// Collect selected categories from checkboxes
function getSelectedCategories() {
  const checkboxes = form.querySelectorAll('input[name="categories"]:checked');
  return Array.from(checkboxes).map(cb => cb.value);
}

// In form submit, use checked checkboxes for categories
form.addEventListener('submit', function(e) {
  e.preventDefault();
  const type = form.type.value;
  const vraag = form.querySelector('#vraag') ? form.querySelector('#vraag').value.trim() : '';
  const juisteAntwoord = form.querySelector('#juisteAntwoord') ? form.querySelector('#juisteAntwoord').value.trim() : '';
  const moeilijkheidsgraad = Number(form.difficulty.value);
  const biblicalReference = form.querySelector('#biblicalReference') ? form.querySelector('#biblicalReference').value.trim() : '';
  // Get selected categories from checkboxes
  const categories = getSelectedCategories();
  // Generate unique ID
  const id = getNextQuestionId();
  
  let questionObj = {
    vraag,
    juisteAntwoord,
    moeilijkheidsgraad,
    type,
    categories,
    biblicalReference: biblicalReference || null, // Set to null if empty
    fouteAntwoorden: [], // Always present for all types
    id
  };
  
  if (type === 'mc' || type === 'fitb') {
    const fouteAntwoorden = [
      form.querySelector('#fouteAntwoord1').value.trim(),
      form.querySelector('#fouteAntwoord2').value.trim(),
      form.querySelector('#fouteAntwoord3').value.trim()
    ];
    questionObj.fouteAntwoorden = fouteAntwoorden;
    // Validation for MC and FITB
    if (!vraag || !juisteAntwoord || fouteAntwoorden.some(f => !f)) {
      showToast('Vul alle verplichte velden in.', true);
      return;
    }
  } else if (type === 'tf') {
    questionObj.juisteAntwoord = juisteAntwoord === 'Waar' ? 'Waar' : 'Niet waar';
    questionObj.fouteAntwoorden = [juisteAntwoord === 'Waar' ? 'Niet waar' : 'Waar'];
    // Validation for TF
    if (!vraag || !juisteAntwoord) {
      showToast('Vul alle verplichte velden in.', true);
      return;
    }
  }
  
  questions.push(questionObj);
  saveBackup();
  updatePreview();
  showToast('Vraag toegevoegd! ID: ' + id);
  form.reset();
  form.type.value = type; // Keep the same question type selected
  saveLastQuestionType(type); // Save the type
  renderFields(type); // Reset dynamic fields
});

function updatePreview(animate = false) {
  // Update question count box only
  const countBox = document.getElementById('questionCountBox');
  if (questions.length > 0) {
    countBox.textContent = `Aantal vragen in lijst: ${questions.length}`;
    countBox.style.display = '';
    document.getElementById('clearBtn').style.display = '';
  } else {
    countBox.style.display = 'none';
    document.getElementById('clearBtn').style.display = 'none';
  }
}

// Modal confirmation for clear all
const clearBtn = document.getElementById('clearBtn');
const confirmModal = document.getElementById('confirmModal');
const confirmDeleteBtn = document.getElementById('confirmDeleteBtn');
const cancelDeleteBtn = document.getElementById('cancelDeleteBtn');

clearBtn.addEventListener('click', function() {
  confirmModal.style.display = 'flex';
});

cancelDeleteBtn.addEventListener('click', function() {
  confirmModal.style.display = 'none';
});

confirmDeleteBtn.addEventListener('click', function() {
  confirmModal.style.display = 'none';
  questions = [];
  saveBackup();
  updatePreview(true);
  if (editModeSection.style.display !== 'none') {
    renderQuestionsList();
  }
  showToast('Alle vragen verwijderd!');
});

downloadBtn.addEventListener('click', function() {
  if (questions.length === 0) {
    showToast('Geen vragen toegevoegd!', true);
    return;
  }
  const dataStr = "data:text/json;charset=utf-8," + encodeURIComponent(JSON.stringify(questions, null, 2));
  const dlAnchor = document.createElement('a');
  dlAnchor.setAttribute("href", dataStr);
  dlAnchor.setAttribute("download", "questions-nl-sv.json");
  document.body.appendChild(dlAnchor);
  dlAnchor.click();
  dlAnchor.remove();
  showToast('Download gestart!');
  // Don't clear questions anymore - user might want to continue editing
});

document.getElementById('restoreBtn').addEventListener('click', restoreBackup);
