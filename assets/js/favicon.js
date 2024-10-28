let setFavicon = () => {
  // Remove old favicons
  document.querySelectorAll('link[rel*="icon"], link[rel="apple-touch-icon"], link[rel="manifest"]').forEach(link => link.remove());

  // Determine theme and base icon path
  let themeSetting = window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches ? "dark" : "light";
  let baseIconPath = themeSetting === "dark" ? "assets/img/favicons/favicon_dark/" : "assets/img/favicons/favicon_light/";

  // Cache-busting parameter
  let timestamp = new Date().getTime();

  // Define favicon files with cache-busting URLs
  let faviconLinks = [
    { rel: "icon", type: "image/png", href: `${baseIconPath}favicon-96x96.png?v=${timestamp}`, sizes: "96x96" },
    { rel: "icon", type: "image/svg+xml", href: `${baseIconPath}favicon.svg?v=${timestamp}` },
    { rel: "shortcut icon", href: `${baseIconPath}favicon.ico?v=${timestamp}` },
    { rel: "apple-touch-icon", sizes: "180x180", href: `${baseIconPath}apple-touch-icon.png?v=${timestamp}` },
    { rel: "manifest", href: `${baseIconPath}site.webmanifest?v=${timestamp}` },
  ];

  // Set each favicon link
  faviconLinks.forEach(attrs => {
    let link = document.createElement("link");
    Object.keys(attrs).forEach(attr => link.setAttribute(attr, attrs[attr]));
    document.head.appendChild(link);
  });
};

// Run on page load and when theme changes with a slight delay for Safari
window.addEventListener('DOMContentLoaded', setFavicon);
window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', () => {
  setTimeout(setFavicon, 100); // Delay of 100ms
});
