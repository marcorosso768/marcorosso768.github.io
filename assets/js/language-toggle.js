// Function to set language and redirect
function setLanguage(language) {
  const defaultLanguage = 'en';
  const isHomepage = window.location.pathname === '/';
  
  // Only store and redirect if on the homepage
  if (isHomepage) {
    const newPath = language === defaultLanguage ? '/' : `/${language}/`;
    localStorage.setItem('userLanguage', language);
    window.location.href = newPath;
  }
}

// Apply language preference on homepage load
document.addEventListener("DOMContentLoaded", function() {
  const userLanguage = localStorage.getItem('userLanguage') || 'en';
  const isHomepage = window.location.pathname === '/';

  // Only redirect on the homepage if the user has a stored language preference
  if (isHomepage && userLanguage !== 'en') {
    window.location.href = `/${userLanguage}/`;
  }
});
