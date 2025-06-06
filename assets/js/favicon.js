let setFavicon = () => {
  // Remove old favicons
  document.querySelectorAll('link[rel*="icon"], link[rel="apple-touch-icon"], link[rel="manifest"]').forEach(link => link.remove());

  // Determine the current language from the URL
  const pathSegments = window.location.pathname.split('/');
  const lang = pathSegments[1] || 'en'; // Default to 'en' if no language prefix is found

  // Determine theme and base icon path
  const themeSetting = window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches ? "dark" : "light";
  const baseIconPath = `assets/img/favicons/${lang}/${themeSetting === "dark" ? 'favicon_dark' : 'favicon_light'}/`;

  // Cache-busting parameter
  const timestamp = new Date().getTime();

  // Define favicon files with cache-busting URLs
  const faviconLinks = [
    { rel: "icon", type: "image/png", href: `${baseIconPath}favicon-96x96.png?v=${timestamp}`, sizes: "96x96" },
    { rel: "icon", type: "image/svg+xml", href: `${baseIconPath}favicon.svg?v=${timestamp}` },
    { rel: "shortcut icon", href: `${baseIconPath}favicon.ico?v=${timestamp}` },
    { rel: "apple-touch-icon", sizes: "180x180", href: `${baseIconPath}apple-touch-icon.png?v=${timestamp}` },
    { rel: "manifest", href: `${baseIconPath}site.webmanifest?v=${timestamp}` },
  ];

  // Set each favicon link
  faviconLinks.forEach(attrs => {
    const link = document.createElement("link");
    Object.keys(attrs).forEach(attr => link.setAttribute(attr, attrs[attr]));
    document.head.appendChild(link);
  });

  // Optional: Fallback static favicon for iOS, based on theme
  const staticLink = document.createElement("link");
  const staticIconPath = `${baseIconPath}favicon_static_${themeSetting}.png`;
  staticLink.setAttribute("rel", "icon");
  staticLink.setAttribute("href", staticIconPath);
  document.head.appendChild(staticLink);
};

// Helper function to re-run favicon setting on navigation
const initFavicon = () => {
  setFavicon();
  // Listen for theme changes
  window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', () => {
    setTimeout(setFavicon, 200); // Slight delay for Safari
  });
};

// Run on initial load
window.addEventListener('DOMContentLoaded', () => setTimeout(initFavicon, 100));

// Handle client-side navigation (SPA support)
window.addEventListener('popstate', initFavicon);
window.addEventListener('pushstate', initFavicon);
window.addEventListener('replaceState', initFavicon);

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
