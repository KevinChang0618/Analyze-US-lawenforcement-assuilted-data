1. Make sure you split up your analyses across multiple Rmd's. Each Rmd should
   study one aspect of the data and there should be some conclusion with
   respect to that file.
2. There aren't many comments on the analysis in your Rmds. This will make
   it difficult to re-explore your conclusions if you come back to the
   project a few months from now.
3. Tab 1: I would make "All US" one of the selections, rather than a separate
   check box. Otherwise, it's a little confusing to select CA but and then
   OH but not have it change because "All US" is checked.
4. Tab 2: Do you mean "Time" rather than "Timezone"? I really like the
   idea for Tab 2. But it doesn't seem to change when I chang the State.
   An action button would also be a better idea for "random year & state".
5. For the "t-test", my understanding is that you want to test whether the
   *number* of crimes in the day is significantly higher than the *number*
   of crimes at night? If so, it's probably better to use something
   like `poisson.test()`.
6. It would be nice to have a little bit more exploration before jumping
   into the shiny app. I only see two plots?
7. The ideas for the shiny app are sound. Make sure you check the assumptions
   of any modeling you use.
