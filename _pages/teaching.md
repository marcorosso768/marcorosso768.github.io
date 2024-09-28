---
layout: page
permalink: /teaching/
title: teaching
description:
nav: true
nav_order: 2
---

<div class="progress-container">
  <div class="progress-bar" style="width: 0%;"></div>
</div>

<div class="projects">
  <a id="current-courses" href="javascript:void(0);" onclick="toggleVisibility('current-courses-content')">
    <h2 class="category"> current courses </h2>
  </a>
</div>

<!-- Show current courses by default -->
<div id="current-courses-content" style="display: block;">
  <p><b>2024/25</b></p>
  
<p style="margin-left: 10px;"> <span style="color: var(--global-theme-color);">•</span> <span style="color: var(--global-theme-color);">Teaching Assistant</span> for the Undergraduate Course <span style="color: var(--global-theme-color);"><i>Political Economy</i></span> <br> Economics, Politics and Social Sciences, <i> University of Bologna </i> <br> Assistant to <span style="color: var(--global-theme-color);">Enrico Cantoni</span> </p>

<p style="margin-left: 10px;"> <span style="color: var(--global-theme-color);">•</span> <span style="color: var(--global-theme-color);">Teaching Assistant</span> for the Undergraduate Course <span style="color: var(--global-theme-color);"><i>Microeconomics</i></span> <br> Economics, Politics and Social Sciences, <i> University of Bologna </i> <br> Assistant to <span style="color: var(--global-theme-color);">Marco Casari</span> </p>

<p><b>2022/25</b></p>

<p style="margin-left: 10px;"> <span style="color: var(--global-theme-color);">•</span> <span style="color: var(--global-theme-color);">Teaching Assistant</span> for the Master Course <span style="color: var(--global-theme-color);"><i>Game Theory</i></span> <br> Economics and Econometrics, <i> University of Bologna </i> <br> Assistant to <span style="color: var(--global-theme-color);">Andrea Mattozzi</span> </p>

<p style="margin-left: 10px;"> <span style="color: var(--global-theme-color);">•</span> <span style="color: var(--global-theme-color);">Teaching Assistant</span> for the Undergraduate Course <span style="color: var(--global-theme-color);"><i>Introduction to Behavioral Economics</i></span> <br> Economics and Finance, <i> University of Bologna </i> <br> Assistant to <span style="color: var(--global-theme-color);">Maria Bigoni</span> </p>
</div>

<div class="projects">
  <a id="past-courses" href="javascript:void(0);" onclick="toggleVisibility('past-courses-content')">
    <h2 class="category"> past courses </h2>
  </a>
</div>

<!-- Hide past courses by default -->
<div id="past-courses-content" style="display: none;">
  <p><b>2022/24</b></p>

<p style="margin-left: 10px;"> <span style="color: var(--global-theme-color);">•</span> <span style="color: var(--global-theme-color);">Teaching Assistant</span> for the Undergraduate Course <span style="color: var(--global-theme-color);"><i>Globalization: Trade, Migrations and Multinationals</i></span> <br> Economics and Finance, <i> University of Bologna </i> <br> Assistant to <span style="color: var(--global-theme-color);">Giovanni Prarolo</span> </p>

<p><b>2021/22</b></p>

<p style="margin-left: 10px;"> <span style="color: var(--global-theme-color);">•</span> <span style="color: var(--global-theme-color);">Teaching Assistant</span> for the Master Course <span style="color: var(--global-theme-color);"><i>Competion Economics and Policy</i></span> <br> Economics and Management, <i> Forlì Campus, University of Bologna </i> <br> Assistant to <span style="color: var(--global-theme-color);">Francesca Barigozzi</span> </p>

<p style="margin-left: 10px;"> <span style="color: var(--global-theme-color);">•</span> <span style="color: var(--global-theme-color);">Teaching Assistant</span> for the Undergraduate Course <span style="color: var(--global-theme-color);"><i>Microeconomics</i></span> <br> Economics and Business, <i> Forlì Campus, University of Bologna </i> <br> Assistant to <span style="color: var(--global-theme-color);">Francesca Barigozzi</span> </p>

<p style="margin-left: 10px;"> <span style="color: var(--global-theme-color);">•</span> <span style="color: var(--global-theme-color);">Teaching Assistant</span> for the Master Course <span style="color: var(--global-theme-color);"><i>Game Theory</i></span> <br> Economics and Management, <i> Forlì Campus, University of Bologna </i> <br> Assistant to <span style="color: var(--global-theme-color);">Natalia Montinari</span> </p>

<p><b>2019/20</b></p>

<p style="margin-left: 10px;"> <span style="color: var(--global-theme-color);">•</span> <span style="color: var(--global-theme-color);">Teaching Assistant</span> for the Master Course <span style="color: var(--global-theme-color);"><i>Public Management and Public Economics</i></span> <br> SAA School of Management, <i> University of Turin </i> <br> Assistant to <span style="color: var(--global-theme-color);">Francesco Figari</span> </p>

<p style="margin-left: 10px;"> <span style="color: var(--global-theme-color);">•</span> <span style="color: var(--global-theme-color);">Teaching Assistant</span> for the Undergraduate Course <span style="color: var(--global-theme-color);"><i>Microeconomics</i></span> <br> SAA School of Management, <i> University of Turin </i> <br> Assistant to <span style="color: var(--global-theme-color);">Nadia Campaniello</span> </p>
</div>


<!-- Inline script -->
<script>
  function toggleVisibility(id) {
    var content = document.getElementById(id);
    content.style.display = content.style.display === "none" ? "block" : "none";
  }

  function updateProgressBar() {
    // Calculate the total height of the document
    var totalHeight = document.body.scrollHeight;
    var viewportHeight = window.innerHeight;
    var scrolled = window.scrollY || window.pageYOffset;

    // Calculate progress percentage
    var progress = (scrolled / (totalHeight - viewportHeight)) * 100;

    // Update the custom progress bar width
    document.querySelector('.progress-bar').style.width = Math.min(progress, 100) + "%"; // Ensure it does not exceed 100%
  }

  // Event listener for scrolling to update the progress bar
  window.addEventListener("scroll", updateProgressBar);

  // Initial call to set the progress bar on page load
  document.addEventListener("DOMContentLoaded", updateProgressBar);
</script>

<style>
.progress-container {
  width: 100%;
  background-color: transparent;
  position: fixed;
  top: 56px;
  left: 0;
  height: 5px;
  z-index: 10; /* Make sure it appears above other elements */
}

.progress-bar {
  background-color: var(--global-theme-color);
  width: 0%;
  height: inherit; /* This should maintain the height of the container */
}
</style>
