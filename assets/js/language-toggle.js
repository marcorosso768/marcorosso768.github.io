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
    return `{{ site.baseurl }}${currentURL}`; // Default: no prefix
  } else {
    return `{{ site.baseurl }}/${language}${currentURL}`; // Add prefix for other languages
  }
}

// Redirect to preferred language on page load
document.addEventListener("DOMContentLoaded", function() {
  const userLanguage = localStorage.getItem('userLanguage') || 'en';
  const currentURL = window.location.pathname;

  if (userLanguage !== 'en' && !currentURL.startsWith(`/${userLanguage}`)) {
    window.location.href = `{{ site.baseurl }}/${userLanguage}${currentURL}`;
  }
});
