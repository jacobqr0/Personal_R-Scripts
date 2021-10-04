

library(dplyr)
library(nycflights13)

not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay))

delay_f <- flights %>%
  group_by(dest) %>%
  filter(dep_delay > 0) %>%
  summarise(avg_delay = mean(dep_delay, na.rm = TRUE))

#note: you can run a script completely by continuously pressing Cmd + Enter down the lines

# You can also run code of your entire script by using: Cmd + Shift + S

# alt + arrows to swap lines of code. Try it!!

