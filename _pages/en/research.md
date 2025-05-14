---
page_id: research
layout: page
permalink: /research/
title: research
description:
subtitle: >
    <div class="lang-links">
        <a href="/it/ricerca/" hreflang="it">ricerca</a>&nbsp;|&nbsp;<a href="/es/investigacion/" hreflang="es">investigación</a>
    </div>
nav: true
nav_order: 1
---

<!-- Publications Section -->
<div class="projects">
  <a href="javascript:void(0);" onclick="toggleVisibility('content-1')">
    <h2 class="category">
      <i class="fa-solid fa-chevron-right fa-2xs rotated" id="chevron-content-1"></i>
      <span>publications</span>
    </h2>
  </a>
</div>

<div id="content-1" style="display: block;">
<div style="line-height: 1.2;">
  <div class="icon-entry indented">
  <i class="fa-solid fa-newspaper fa-fw"></i>
  <span>
    Farina E., Rosso M., Dansero L., et al. (2023). 
    <a href="https://doi.org/10.1136/jech-2022-220088" target="_blank" rel="noopener noreferrer">
      Short-term effect of colorectal cancer on income.
    </a> 
    <i>Journal of Epidemiology & Community Health</i>
  </span>
  </div>
  
<div id="toggle-abstract-crc" class="abstract-toggle-pill"
     onclick="toggleAbstract('abstract-crc', ABSTRACT_TEXT.show, ABSTRACT_TEXT.hide)"
     title="{{ site.data.strings.abstract.show }}">
  <i class="fa-solid fa-chevron-right fa-2xs" id="icon-abstract-crc"></i>
  <span id="label-abstract-crc" class="toggle-label" style="color:var(--global-theme-color);">
    {{ site.data.strings.abstract.label }}
  </span>
</div>

<div id="abstract-crc" class="abstract">
      <b>Introduction</b> The ability to return to work after a cancer diagnosis is a key aspect of cancer survivorship and quality of life. Studies have reported a significant risk of income loss for cancer survivors; however, there is limited evidence of the Italian context.
              <br>
              <b>Methods</b> The Work Histories Italian Panel (WHIP)-Salute database was used to select a cohort of incident cases of colorectal cancer (CRC) among workers in the private sector, based on hospital discharges. A propensity score matching was used to find a balanced control group for several confounders. Ordinary least square and logistic regressions were used to estimate the effect of a CRC diagnosis on annual income and the probability of switching from a full-time contract to a part-time one considering 3 years after the diagnosis.
              <br>
              <b>Results</b> Overall, we identified 925 CRC incident cases from 2006 until 2012. Our results confirm a statistically significant reduction in survivors’ income compared with controls. This reduction was greater in the first year and then tend to decrease, with an average income loss over 3 years of about €12 000. Stratified analyses by sex and position confirmed the overall trend while indicating a strong effect modification. Regarding the switching from full-time to part-time employment, the results were never significant.
              <br>
              <b>Conclusion</b> Income loss does not seem to be related to an increase in part-time contracts, but rather to survivors’ reduced work capacity following the invasive treatments. Further research is needed to investigate the complex dynamics behind this association.
</div>
</div>
</div>
<!-- Working Papers Section -->
<div class="projects">
  <a href="javascript:void(0);" onclick="toggleVisibility('content-2')">
    <h2 class="category">
      <i class="fa-solid fa-chevron-right fa-2xs rotated" id="chevron-content-2"></i>
      <span>working papers</span>
    </h2>
  </a>
</div>

<div id="content-2" style="display: block;">

<div style="line-height: 1.2;">
    <div class="icon-entry indented">
      <i class="fa-solid fa-book-open fa-fw"></i>
      <span>
        <em>Crime Perception and Voting Behavior</em> 
        (with 
        <a href="https://sites.google.com/site/giovanniprarolo/" target="_blank" rel="noopener noreferrer">
          Giovanni Prarolo</a>)
      </span>
    </div>

<div class="pill-container">
  <div class="pill-button toggle-pill" data-target="abstract-crime">
    <i class="fa-solid fa-chevron-right fa-2xs"></i>
    <span class="toggle-label">Abstract</span>
  </div>
  <div class="pill-button toggle-pill" data-target="keywords-crime">
    <i class="fa-solid fa-chevron-right fa-2xs"></i>
    <span class="toggle-label">Keywords</span>
  </div>
</div>

<div id="abstract-crime" class="toggle-box">
  This study examines the impact of local crime salience on individual voting behavior, using geolocated crime-related news as a proxy for public concern about crime. Drawing on a retrospective survey of 5000 individuals across several election rounds, our analysis exploits the occurrence of a criminal event in the vicinity of a voter in the lead-up to elections. The results for general elections are mixed overall, showing no effects on voting behavior when crimes are committed by Italians. Conversely, crimes attributed to immigrants results in lower support for the populist right-wing parties, sometimes having an ambiguous stance on immigration, and instead higher support for the more traditional right-wing parties, which emphasizes law and order. In administrative elections, the effect of crime salience diverges. Crimes committed by Italians result in the punishment of incumbents, while immigrant-related crimes lead to increased voter abstention, possibly reflecting the social stigma associated with party-switching among left-leaning voters, the incumbent party. These findings provide novel insights into the relationship between crime salience, particularly regarding immigration, and individual voting behavior.
</div>

<div id="keywords-crime" class="toggle-box">
  crime, elections, political parties, newspapers, individual voting behavior, dictionary-based classification
</div>

</div>

<div class="icon-entry indented">
  <i class="fa-solid fa-book-open fa-fw" title="Working paper"></i>
  <em>Corruption, temptation, and self-selection in the public sector</em>
</div>

<div id="toggle-abstract-corruption" class="abstract-toggle-pill"
     onclick="toggleAbstract('abstract-corruption', ABSTRACT_TEXT.show, ABSTRACT_TEXT.hide)"
     title="{{ site.data.strings.abstract.show }}">
  <i class="fa-solid fa-chevron-right fa-2xs" id="icon-abstract-corruption"></i>
  <span id="label-abstract-corruption" class="toggle-label" style="color:var(--global-theme-color);">
    {{ site.data.strings.abstract.label }}
  </span>
</div>

<div id="abstract-corruption" class="abstract">
       This paper presents a theoretical model that examines the impact of corruption opportunities on the self-selection process of individuals in the public sector. The study explores how the temptation of engaging in corruption influences individuals' career choices. The main finding of the research reveals a dual effect of corruption opportunities in the public sector. On one hand, such opportunities attract individuals with lower ambition and motivation, who are more likely to engage in unethical behavior. On the other hand, when the temptation to participate in corruption becomes significant, highly motivated individuals may be deterred from pursuing a career in the public sector due to self-control issues, leading them to opt for employment in the private sector instead. This finding highlights the importance of considering the impact of corruption and self-control problems on the quality and composition of the public sector workforce, which can have broader implications for economic outcomes.
      <br><b>Keywords:</b> corruption, self-selection, motivation, ethics.
</div>
</div>

<!-- Work in Progress Section -->
<div class="projects">
  <a href="javascript:void(0);" onclick="toggleVisibility('content-3')">
    <h2 class="category">
      <i class="fa-solid fa-chevron-right fa-2xs rotated" id="chevron-content-3"></i>
      <span>work in progress</span>
    </h2>
  </a>
</div>

<div id="content-3" style="display: block;">
    <div class="icon-entry indented">
      <i class="fa-solid fa-bookmark fa-fw" title="In progress"></i>
      <span>
        <em>Public Goods Provision and Voting Turnout</em> (with 
        <a href="https://sites.google.com/view/mgeiras/inicio" target="_blank" rel="noopener noreferrer">
          Martín Gonzalez-Eiras
        </a> and 
        <a href="https://sites.google.com/site/giovanniprarolo/" target="_blank" rel="noopener noreferrer">
          Giovanni Prarolo
        </a>)
      </span>
    </div>
    <div class="icon-entry indented">
        <i class="fa-solid fa-bookmark fa-fw" title="In progress"></i>
        <span><em>The Effect of Erasmus Programs on Voting</em></span>
    </div>
</div>
