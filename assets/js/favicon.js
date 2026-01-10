let setFavicon = () => {
  // Remove old favicons
  document.querySelectorAll('link[rel*="icon"], link[rel="apple-touch-icon"], link[rel="manifest"]').forEach(link => link.remove());

  // VERSION CONTROL - Incrementa manualmente questo numero quando aggiorni le icone
  const iconVersion = "v2";

  // Determine the current language from the URL
  const pathSegments = window.location.pathname.split('/');
  const lang = pathSegments[1] || 'en';

  // Determine theme and base icon path
  const themeSetting = window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches ? "dark" : "light";
  const themeFolder = themeSetting === "dark" ? 'favicon_dark' : 'favicon_light';
  const baseIconPath = `assets/img/favicons/${lang}/${themeFolder}/`;

  // Define favicon files with version in filename (not query parameter)
  const faviconLinks = [
    // Standard favicons
    { rel: "icon", type: "image/png", href: `${baseIconPath}favicon-96x96-${iconVersion}.png`, sizes: "96x96" },
    { rel: "icon", type: "image/png", href: `${baseIconPath}favicon-32x32-${iconVersion}.png`, sizes: "32x32" },
    { rel: "icon", type: "image/png", href: `${baseIconPath}favicon-16x16-${iconVersion}.png`, sizes: "16x16" },
    { rel: "icon", type: "image/svg+xml", href: `${baseIconPath}favicon-${iconVersion}.svg` },
    { rel: "shortcut icon", href: `${baseIconPath}favicon-${iconVersion}.ico` },
    
    // Apple touch icon (iOS/iPadOS)
    { rel: "apple-touch-icon", sizes: "180x180", href: `${baseIconPath}apple-touch-icon-180-${iconVersion}.png` },
    
    // Web manifest
    { rel: "manifest", href: `${baseIconPath}site-${iconVersion}.webmanifest` },
  ];

  // Set each favicon link
  faviconLinks.forEach(attrs => {
    const link = document.createElement("link");
    Object.keys(attrs).forEach(attr => link.setAttribute(attr, attrs[attr]));
    document.head.appendChild(link);
  });
};

// Helper function to re-run favicon setting on navigation
const initFavicon = () => {
  setFavicon();
  // Listen for theme changes
  window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', () => {
    setTimeout(setFavicon, 200);
  });
};

// Run on initial load
window.addEventListener('DOMContentLoaded', () => setTimeout(initFavicon, 100));

// Handle client-side navigation (SPA support)
window.addEventListener('popstate', initFavicon);

// Override pushState and replaceState to trigger favicon update
const originalPushState = history.pushState;
history.pushState = function () {
  originalPushState.apply(this, arguments);
  initFavicon();
};

const originalReplaceState = history.replaceState;
history.replaceState = function () {
  originalReplaceState.apply(this, arguments);
  initFavicon();
};
