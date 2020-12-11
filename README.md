<h1 style="font-weight:normal"> 
  How different are shiny Pokemon? 
</h1>

[![Status](https://www.repostatus.org/badges/latest/wip.svg)]() [![GitHub Issues](https://img.shields.io/github/issues/wjsutton/pogo_shiny_colour_difference.svg)](https://github.com/wjsutton/pogo_shiny_colour_difference/issues) [![GitHub Pull Requests](https://img.shields.io/github/issues-pr/wjsutton/pogo_shiny_colour_difference.svg)](https://github.com/wjsutton/pogo_shiny_colour_difference/pulls) [![License](https://img.shields.io/badge/license-MIT-blue.svg)](/LICENSE)

A dataviz project looking at the differences in colour between shiny pokemon & non-shiny pokemon in the mobile game Pokemon Go.

Data Sources
 - Images forked from github repo [ZeChrales/PogoAssets](https://github.com/ZeChrales/PogoAssets)
 - Pokemon Metadata from [Kaggle Dataset](https://www.kaggle.com/rounakbanik/pokemon)

:construction: Repo Under Construction :construction: 

[Twitter][Twitter] :speech_balloon:&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;[LinkedIn][LinkedIn] :necktie:&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;[GitHub :octocat:][GitHub]&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;[Website][Website] :link:

<!--/div-->

<!--
Quick Link 
-->

[Twitter]:https://twitter.com/WJSutton12
[LinkedIn]:https://www.linkedin.com/in/will-sutton-14711627/
[GitHub]:https://github.com/wjsutton
[Website]:https://wjsutton.github.io/

### :a: About

Pokemon Go is a mobile game about capturing and battling virtual creatures called Pokemon. A shiny Pokemon is like any other Pokemon except it is a different colour than its non-shiny version, and much rarer to find on average the chances of finding a shiny Pokemon is 1 in 450 (with some exceptions around events like community days).

However, some shiny Pokemon look very similar to their non-shiny versions. I was fortunate to catch a shiny Pikachu but could hardly notice the difference to the regular non-shiny Pikachu.

A Shiny Pikachu | A Non-shiny Pikachu
:-------------------------:|:-------------------------:|
![](pokemon_icons/pokemon_icon_025_00_shiny.png) | ![](pokemon_icons/pokemon_icon_025_00.png)

For other Pokemon, the colour difference is much more obvious.

A Shiny Charizard | A Non-shiny Charizard
:-------------------------:|:-------------------------:|
![](pokemon_icons/pokemon_icon_006_00_shiny.png) | ![](pokemon_icons/pokemon_icon_006_00.png)

And hence the motivation for this project, can we determine which Pokemon differ the most (or least) from their shiny versions.

### Method 

- Simplifying the Pokemon colours using K-means clusters
- Calculating the difference colour

### Simplifying the Pokemon colours using K-means clusters

- read images
- remove white background
- run clustering
- determine which cluster is the best

![](143_Snorlax_shiny_comparison.png)


### Splitting Project Workflows

The project has gone down a bit of a rabbit hole and needs to get more focused so that some objectives can be achieved. 

Calculating the difference in Pokemon colour only requires a single non-white cluster, using multiple clusters achieves the same results as just one cluster as we are calculating the weighted average difference in colour. However multiple clusters has provided interesting colour palettes that could be used for dashboard colour palettes.

###  To Do

**Create workflow For calculating difference in colour:**

- [ ] read images
- [ ] remove white background
- [ ] run kmeans k = 1 cluster 
- [ ] create comparison output file for Tableau
- [ ] create image output folder (one shiny, one not-shiny) for Tableau shapes location

**Create workflow for extracting multiple colours for palettes:**

- [ ] read images
- [ ] remove white background
- [ ] run kmeans k >= 1 cluster 
- [ ] create output file of possible colours by number of clusters
- [ ] create example comparison rails

