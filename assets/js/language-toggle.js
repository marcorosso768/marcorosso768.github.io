// Function to set language, store in LocalStorage, and redirect
function setLanguage(language) {
  localStorage.setItem('userLanguage', language);
  window.location.href = languageURL(language);
}

// Generate URL based on the selected language
function languageURL(language) {
  const currentURL = window.location.pathname;
  const defaultLanguage = 'en'; // Default language is English

  if (language === defaultLanguage) {
    return `{{ site.baseurl }}${currentURL}`; // No prefix for default language
  } else {
    return `{{ site.baseurl }}/${language}${currentURL}`; // Add prefix for other languages
  }
}

// Redirect to preferred language on page load, defaulting to English
document.addEventListener("DOMContentLoaded", function() {
  // Always start with English unless a choice has already been saved
  const userLanguage = localStorage.getItem('userLanguage') || 'en';
  const currentURL = window.location.pathname;

  // Redirect to stored language if different from the default (English) or current path
  if (userLanguage !== 'en' && !currentURL.startsWith(`/${userLanguage}`)) {
    window.location.href = `{{ site.baseurl }}/${userLanguage}${currentURL}`;
  } else if (userLanguage === 'en' && currentURL.startsWith(`/${userLanguage}`)) {
    // Redirect to base URL if in English and there is an unnecessary prefix
    window.location.href = `{{ site.baseurl }}${currentURL.substring(userLanguage.length + 1)}`;
  }
});
