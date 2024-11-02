// Function to set language, store it, and redirect
function setLanguage(language) {
  const defaultLanguage = 'en'; // Default language
  const pathWithoutLang = window.location.pathname.replace(/^\/(en|it|es)(\/|$)/, '/');
  const newPath = language === defaultLanguage ? pathWithoutLang : `/${language}${pathWithoutLang}`;

  // Store the user's language choice in localStorage
  localStorage.setItem('userLanguage', language);

  // Redirect to the chosen language URL
  window.location.href = newPath;
}

// Apply stored language preference on page load
document.addEventListener("DOMContentLoaded", function() {
  const userLanguage = localStorage.getItem('userLanguage') || 'en'; // Default to 'en' if no choice is stored
  const currentURL = window.location.pathname;

  // Check if the stored language is different from the current language prefix in the URL
  if (!currentURL.startsWith(`/${userLanguage}`)) {
    const pathWithoutLang = currentURL.replace(/^\/(en|it|es)(\/|$)/, '/');
    const newURL = userLanguage === 'en' ? pathWithoutLang : `/${userLanguage}${pathWithoutLang}`;
    window.location.href = newURL;
  }
});
