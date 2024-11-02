// Function to set language, store it, and redirect
function setLanguage(language) {
  const defaultLanguage = 'en';
  const isHomepage = window.location.pathname === '/';

  // Only store and redirect if on the homepage
  if (isHomepage) {
    const newPath = language === defaultLanguage ? '/' : `/${language}/`;
    localStorage.setItem('userLanguage', language); // Store the user's choice for future visits
    sessionStorage.setItem('languageRedirected', 'true'); // Mark that we handled redirection in this session
    window.location.href = newPath; // Redirect to the new path
  } else {
    // If not on the homepage, just store the language and clear the session redirect flag
    localStorage.setItem('userLanguage', language);
    sessionStorage.removeItem('languageRedirected'); // Clear flag to allow further changes
    const newPath = language === defaultLanguage ? '/' : `/${language}/`;
    window.location.href = newPath; // Redirect to the selected language path
  }
}

// Apply language preference on homepage load, only if no redirect was done in the session
document.addEventListener("DOMContentLoaded", function() {
  const userLanguage = localStorage.getItem('userLanguage') || 'en';
  const isHomepage = window.location.pathname === '/';
  const hasRedirected = sessionStorage.getItem('languageRedirected');

  // Only redirect on the homepage if no redirect has been done in this session
  if (isHomepage && userLanguage !== 'en' && !hasRedirected) {
    const newURL = `/${userLanguage}/`;
    sessionStorage.setItem('languageRedirected', 'true'); // Prevent further redirects in this session
    window.location.href = newURL;
  }
});
