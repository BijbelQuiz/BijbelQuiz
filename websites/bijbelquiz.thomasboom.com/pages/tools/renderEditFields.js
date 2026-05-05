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