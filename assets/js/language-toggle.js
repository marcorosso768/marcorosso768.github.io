// Function to set language, store it, and redirect
function setLanguage(language) {
  const defaultLanguage = 'en'; // Default language
  const baseURL = '{{ site.baseurl }}'; // Base URL, if applicable
  const currentPath = window.location.pathname;

  // Remove any language prefix from the current URL path
  const pathWithoutLang = currentPath.replace(/^\/(it|es)(\/|$)/, '/');
  const newPath = language === defaultLanguage ? pathWithoutLang : `/${language}${pathWithoutLang}`;

  // Store the user's language choice in localStorage
  localStorage.setItem('userLanguage', language);

  // Redirect to the chosen language URL, including base URL if necessary
  window.location.href = `${baseURL}${newPath}`;
}

// Apply stored language preference on page load
document.addEventListener("DOMContentLoaded", function() {
  const userLanguage = localStorage.getItem('userLanguage') || 'en'; // Default to 'en' if no choice is stored
  const currentURL = window.location.pathname;

  // Check if the current URL matches the stored language preference
  if (userLanguage !== 'en' && !currentURL.startsWith(`/${userLanguage}`)) {
    const baseURL = '{{ site.baseurl }}'; // Use base URL if applicable
    const pathWithoutLang = currentURL.replace(/^\/(it|es)(\/|$)/, '/');
    const newURL = `${baseURL}/${userLanguage}${pathWithoutLang}`;

    // Redirect to the preferred language URL if needed
    window.location.href = newURL;
  } else if (userLanguage === 'en' && currentURL.match(/^\/(it|es)(\/|$)/)) {
    // If the preferred language is English and there is an unwanted prefix, remove it
    const baseURL = '{{ site.baseurl }}'; // Use base URL if applicable
    const pathWithoutLang = currentURL.replace(/^\/(it|es)(\/|$)/, '/');
    window.location.href = `${baseURL}${pathWithoutLang}`;
  }
});
