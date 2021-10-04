'''
==============================
CHAPTER 5: DATA TRANSFORMATION
==============================
'''
library(nycflights13)
library(tidyverse)

#Creating a dataframe in Base R
employee <- c("John Doe", "Peter Gynn", "Jolie Hope")
salary <- c(2100, 23400, 26800)
startdate <- as.Date(c("2010-11-1", "2008-3-25", "2007-3-14"))

employ.data <- data.frame(employee, salary, startdate)
View(employ.data)

#note the conflicts of the dplyr package and base R:
#dplyr::filter() masks stats::filter()
#dplyr::lag() masks stats::lag()

?flights

flights
View(flights)
#note that this function must be capitalized

'''
Tibble - a data frame, slightly tweaked to work better in the tidyverse!

types of variables in R:
int - integers
dbl - doubles/ or real numbers
chr - character vectors or strings
dttm - date-times 

lgl - stands for logical, vectors that contain TRUE or FALSE
fctr - factors, R uses these to represent actegorical variables with fixed possible values
date - stands for dates.
'''
#5.1.3 dplyr basics
'''
5 key functions that help us solve majority of data manipulation challenges:
1. filter() - picking observations by their values
2. arrange() - Reorder the rows
3. select() - picking variables by their names 
4. mutate() - creating new variables with functions of existing variables.
5. summarise() - collapse many values down to a single summary 
6. All of the functions above can be used in conjunction with group_by() which changes 
   the scope of each function from operating on the entire dataset to operating on it group-by-group.

All the six functions above provide the verbes for a language of data manipulation. 

all verbs work similarly: 
1. first argument is a data frame
2. subsequent argument describes what to do with the data frame using the vairable names 
3. the result is a new data frame.###
'''

#5.2 Filter rows with filter()
'''
filter() allows you to subset observations based on their values!
first argument is the name of the data frame
second and subsequent arguments are the expressions that filter the data frame.
'''
a <-  filter(flights, month == 1, day ==1)
View(a)
#now we can see all flights that occurred on January 1st, 2013.

# if you want to print the results and save them as a variable, wrap the 
#statement in parentheses:
(a <-  filter(flights, month == 1, day ==1))

#5.2.1 Comparisons
'''
to use filtering effectively, you have to use the comparison operators.
>, >=, <, <=, != and ==
'''
dec_flights <- filter(flights, month==12)

#run the following code and predict what will happen:
sqrt(2)^2 == 2
1 / 49 *49 == 1
#it is false because computers use finite precision arithmetic
#they cant store an infinite number of digits! so every number you see is an approximation
# use near instead:
near(sqrt(2)^2, 2)

# 5.2.2 Logical Operators
'''
For some types of combinations, we will need to use Boolean Operators :
& - and 
| - or 
! - not
'''
query1 <- filter(flights, month == 12 | month == 11)
View(query1)

# a useful shorthand for this problem above is x %in% y, where every row where 
#x is one of the values in y.

nov_dec <- filter(flights, month %in% c(11, 12))
View(nov_dec)

'''
De Morgans Law: !(x & y) is the same as !x | !y 

example: if we wanted to find flights that werent delayed by more than two hours:
'''
filter(flights, !(arr_delay> 120 | dep_delay> 120))
filter(flights, arr_delay<= 120, dep_delay <= 120)

#5.2.3 Missing Values 
'''
NA is a missing Value - or unknown value. Any operation involving an unknown value will be also unkwon.
'''
NA > 5
10 == NA
NA + 10 
NA / 2 

# if you want to determine if a value is missing, use: 
is.na(x)
b <- NA

is.na(b)

df <- tibble(x = c(1, NA, 3))
c <- filter(df, x > 1)

View(c)

e1 <- filter(flights, arr_delay >= 120)
View(e1)
e2 <- filter(flights, dest == "IAH" | dest == "HOU")
View(e2)
e3 <-  filter(flights, carrier == "B6" | carrier == "UA" | carrier == "AA")
View(e3)
e4 <- filter(flights, month %in% c(7, 8, 9))
View(e4)
e5 <- filter(flights, arr_delay >= 120 & dep_delay <=0)
View(e5)
e7 <- filter(flights, dep_time <= 600)
View(e7)
e22 <- filter(flights, dep_delay == between(x, 5, 200))
View(e22)

#between function is useful shortcut for e7
e7 <- filter(flights, between(dep_time, 1, 600))
View(e7)              

e33 <- filter(flights, dep_time == NA)
view(e33)

#5.3 Arrange rows with arrange()

#you can change the order of rows 

#you can use desc() to re-order by a column in descending order:
arrange(flights, desc(dep_delay))

# missing values are always sorted at the end for desc():
df <- tibble(x = c(5, 2, NA))

arrange(df, x)

arrange(df, desc(x))

is.na(df)

#most delayed flights
arrange(flights, desc(dep_delay))

#flights that left the earliest
arrange(flights, dep_delay)

#flights that travelled the shortest distance, apply desc() to find flights with the largest distance.
View(arrange(flights, distance))

#5.4 Select columns with select()
'''
select() allows you to rapidly zoom in on a useful subset using operations based on 
the names of the variables. 
'''
#to get columns by name
select(flights, year, month, day)

#select all columns between year and day:
select(flights, year:day)

#select all columns except those from year to day 
select(flights, -(year:day))

'''
There are a number of helper functions you can use with select():

1. starts_with("abc") : matches names that begin with "abc"
2. ends_with("xyz"): matches names that end with "xyz".
3. contains("ijk"): matches names that contain "ijk".
4. matches("(.)\\1"): selects variables that match a regular expression. 
5. num_range("x", 1:3): matches x1, x2, x3
'''
?select()

#select() can be used to rename variables, but a better option is to use the rename() function
rename(flights, tail_num = tailnum)
View(flights)

# A helpful way to move a handful of variables to the start of a dataframe:
#USE THE everything() FUNCTION!
select(flights, time_hour, air_time, everything())

#ways to select dep_time, dep_delay, arr_time, arr_delay:
select(flights, dep_time, dep_delay, arr_time, arr_delay)
select(flights, starts_with("dep"), starts_with("arr"))
select(flights, ends_with("time"), ends_with("delay"))
select(flights, dep_time:arr_delay)

select(flights, arr_delay, dep_time, arr_delay)

vars <- c("year", "month", "day", "dep_delay", "arr_delay")
?one_of()

vars

select(flights, contains("TIME", ignore.case = TRUE))

#5.5 Add new variables with mutate()
'''
to add new columns that are functions of existing columns! probably why I got 
an error above !

mutate() adds new columns at the end of your dataset 
'''
#to add new calculated columns with mutate:
#FIRST! Create a new data frame:
flights_sml <- select(flights,
                      year:day,
                      ends_with("delay"),
                      distance,
                      air_time
                      )
#SECOND! Use mutate() to add the columns to that data frame:
flights_sml <- mutate(flights_sml, 
       gain = dep_delay - arr_delay,
       speed = distance / (air_time /60))

View(flights_sml)
a <- select(flights_sml, gain, speed, everything())

arrange(a, desc(speed))

#Note that you can refer to columns that you just created:
mutate(flights_sml,
       gain = dep_delay - arr_delay,
       hours = air_time / 60,
       gain_per_hour = gain / hours)

#if you only want to keep the new variables, use transmute():
transmute(flights, 
          gain = dep_delay - arr_delay,
          hours = air_time / 60,
          gain_per_hour = gain / hours)

#5.5.1 Useful creation functions

''' many functions exist for creating new variables with mutate()
the function must be vectorised: it must take a vector of values as input, return a vector with the 
same number of values as output. 

*arithemetic operators can be used, and are already vectorised 
*modular arithemetic: %/% (integer division), and %% (remainder), where x == y *(x %/% y) + (x %% y)
 modular division is useful because it allows you to break up integers into pieces
 '''
#Example of where modular arithmetic is useful: computing hour and minute from dep_time:
transmute(flights,
          dep_time,
          hour = dep_time %/% 100,
          minute = dep_time %% 100)

''' 
functions that are useful in mutate()/transmute() cont.:

Logs: log(), log2(), log10(). LOGS ARE VERY USEFUL TRANSFORMATIONS FOR DATA THAT 
RANGES OVER MANY ORDERS OF MAGNITUDE
- they also convert multiplicative relationships to additive. 

Offsets: lead() and lag() allows you to refer to leading or lagging values. It allows you to compute running differences. 
e.g. (x-lag(x)) or find when values change (x != lag(x)), most useful in conjunction with group_by()

Cumulative and rolling aggregates: cumsum(), cumprod(), cummax(), cummean()

Logical comparisons: <, <=, >, >=, !=, and ==. 

'''
#ranking is a useful function:
y <- c(1, 2, 2, NA, 3, 4)
min_rank(y) #use the min_rank(y)
#> [1]  1  2  2 NA  4  5
min_rank(desc(y))
#> [1]  5  3  3 NA  2  1

#5.6 Grouped summaries with summarise()

#summarise collapses a data frame to a single row:
summarise(flights, delay = mean(dep_delay, na.rm =TRUE))

''' 
Note: summarise() is note terribly useful unless we pair it with group_by()

This changes the unit of analysis from the complete dataset to individual groups.

'''
# an example of this is listed below:
#line 328 will create groups of records associated by day of the year
#line 329 will perform the summarise function
#this function will compute the average of the delay by day!
by_day <- group_by(flights, year, month, day)
new_data <- summarise(by_day, delay = mean(dep_delay, na.rm = TRUE))
arrange(new_data, desc(delay))
# the result is 365 records, containing the average delay time for every day in 2013.

#5.6.1 combining multiple operations with the pipe:
by_dest <- group_by(flights, dest)
delay <- summarise(by_dest, 
                   count = n(),
                   dist = mean(distance, na.rm = TRUE),
                   delay = mean(arr_delay, na.rm = TRUE))

delay <- filter(delay, count > 20, dest != "HNL")


# It looks like delays increase with distance up to ~750 miles 
# and then decrease. Maybe as flights get longer there's more 
# ability to make up delays in the air?
ggplot(data = delay, mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE)
#> `geom_smooth()` using method = 'loess' and formula 'y ~ x'

#to streamline the code starting on line 334, you can use the pipe operator:
delays <- flights %>% 
  group_by(dest) %>% 
  summarise(
    count = n(),
    dist = mean(distance, na.rm = TRUE),
    delay = mean(arr_delay, na.rm = TRUE)
  ) %>% 
  filter(count > 20, dest != "HNL")

#the pipe operator can be translated as 'then' 
#notice how piping improves the readability of the code!

#5.6.2 Missing Values 

flights %>%
  group_by(year, month, day) %>%
  summarise(mean = mean(dep_delay))
#NOTICE that we get a lot of missing values if we don't 
#use the na.rm function!!

#na.rm function removes all NA values that we are not interested in for our 
#analysis.
flights %>% 
  group_by(year, month, day) %>%
  summarise(mean = mean(dep_delay, na.rm = TRUE))# REMOVES ALL MISSING VALUES!

#could also tackle this problem by removing cancelled flights
not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))

not_cancelled %>% 
  group_by(year, month, day) %>%
  summarise(mean = mean(dep_delay))

#5.6.3 COUNTS

''' 
whenever we do any aggregation, its good to include either a count:
(n())
or a count of non-missing values 
(sum(!is.na(x)))
This way we are not drawing conclusions based on very small amounts of data.
'''

#planes that have the highest average delays:
delays <- not_cancelled %>%
  group_by(tailnum)%>%
  summarise(
    delay = mean(arr_delay)
  )

ggplot(data = delays, mapping = aes(x = delay))+
  geom_freqpoly(binwidth = 10)
#LOOK! HOW TO GET A FREQUENCY PLOT ABOVE!

delays <- not_cancelled %>%
  group_by(tailnum) %>%
  summarise(
    delay = mean(arr_delay, na.rm = TRUE),
    n= n()
  )
  
#Scatterplot of flights vs. average delay:
ggplot(data = delays, mapping = aes(x=n, y =delay))+
  geom_point(alpha = 1/10)
#note - whenever we plot a mean vs. group size, we'll see that the variation decreases as the sample size increases.

#To improve the plot above, let's filter out the groups with the smallest numbers of observations.
delays %>%
  filter(n>25) %>%
  ggplot(mapping = aes(x = n, y = delay))+
  geom_point(alpha =1/10)
#the code above allows you to filter the data that you are putting in your graphic.
#this is an example of how the ggplot2 and dplyr packages can be used together.

#KEYBOARD SHORTCUT! send a chunk from the editor to the console: Cmd + Enter
#TO MODIFY the value of n, press Cmd + Shift + P 

library(Lahman)
#converting to a tibble so it prints nicely
batting <- as_tibble (Lahman::Batting)

batters <- batting %>%
  group_by(playerID) %>%
  summarise(
    ba = sum(H, na.rm = TRUE) / sum(AB, na.rm = TRUE), 
    ab = sum(AB, na.rm = TRUE)
  )
  
batters %>% 
  filter(ab > 100) %>%
  ggplot(mapping = aes(x = ab, y = ba))+ #ba = bb player's batting average; ab = number of times at bat to hit the ball.
  geom_point() + 
  geom_smooth(se = FALSE)
#graph shows positive correlation between skill and opportunities to hit the ball. 

# 5.6.4 Useful summary functions
'''
measures of location are useful in R: 
this includes mean(x) and median().
'''
not_cancelled %>%
  group_by(year, month, day) %>%
  summarise( 
    avg_delay1 = mean(arr_delay),
    avg_delay2 = mean(arr_delay[arr_delay > 0]),#the average positive delay
    IQR_delay = IQR(arr_delay)
    ) %>% 
  arrange(avg_delay1)

#note the other summary functions:
'''
sd(x) - standard deviation
IQR(x) - interquartile range
mad(x) - median absolute deviation 
''' 
#why is distance to some destinations more variable than to others?
not_cancelled %>% 
  group_by(dest) %>%
  summarise(distance_sd = sd(distance))%>%
  arrange(desc(distance_sd))

'''
meausres of rank:
min(x), 
quantile(x, 0.25)- generalization of the median, will find a value of x that is greater than 25% of the values.
max(x).
'''
#earliest and latest flights each day of the year
not_cancelled %>%
  group_by(year, month, day) %>%
  summarise(
    first = min(dep_time),
    last = max(dep_time)
  )
  
#measures of position:
'''
first(x)
nth(x,2)
last(x)
'''

#times of the first and last departures 
not_cancelled %>% 
  group_by(year, month, day) %>%
  summarise(
    first_dep = first(dep_time),
    last_dep = last(dep_time)
  )

#which destinations have the most carriers? 
not_cancelled %>%
  group_by(dest) %>%
  summarise(carriers = n_distinct(carrier)) %>%
  arrange(desc(carriers))

#which destination has the most amount of flights?
not_cancelled %>%
  count(dest)

#Can provide a weight variable: use it to "count" the total number of miles a plane flew:
not_cancelled %>%
  count(tailnum, wt = distance)

#how many flights left before 5am?
not_cancelled %>%
  group_by(year, month, day) %>%
  summarise(n_early = sum(dep_time <500))

# what proportion of flights are delayed by more than an hour?
not_cancelled %>%
  group_by(year, month, day) %>%
  summarise(hour_prop = mean(arr_delay > 60))

#5.6.5 grouping by multiple variables 
#each summary peels off one level of the grouping 

#number of flights in a day
daily <- group_by(flights, year, month, day)
(per_day <- summarise(daily, flights = n()))

#number of flights per month
(per_month <- summarise(per_day, flights = sum(flights)))

#number of flights per year
(per_year <-  summarise(per_month, flights = sum(flights)))

#5.6.6 UNGROUPING

#sometimes you need to ungroup a dataframe

daily%>%
  ungroup() %>% #nolonger grouped by date
  summarise(flights = n())#all flights

''' 
=======================
Questions for Review:
=======================
- what are the 5 main functions that allow us to address data manipulation challenges in R? What does each function 
allow you to do?

- What does the group_by() function do?

-What is the result of using a verb of data manipulation in R? (###)

- how can we print the results of our data and execute it all at the same time, in one line of code?

- Give me an example of what a comparison operator is?

- What are the 3 main boolean operators in R, how do we write them/ what is their syntax?

-what is a useful shorthand to the following code/ another way to write it? What do you use?:
'''
#DONT LOOK YOU WILL SEE THE ANSWER!


filter(flights, month == 12 | month == 11)
(filter(flights, month %in% c(11, 12)))
'''

- how can we determine if a value is missing?

- how do you use the between function in filter, say if you wanted to know all the flights that had 
air time between 10 and 20 hours?

-how would you arrange the dataframe created in the previous question by distance in descending order? 

-how would you create a dataframe with only the columns in the flight dataset from year to carrier?

-how would you write code to select all columns except airtime through time_hour?

-list some of the helper functions you can use with select

- how can you rename variable/attribute/column names? what function?

- I want to put the distance and air_time columns of the flight dataset to the front of the dataframe, how can I
do this with the select() function? what helper function can I use? 

-Say I want to create a new dataframe based off of variables in an existing dataframe, but only keep the newly 
calculated variables in my new dataframe, what function would I use?

-What does the pipe operator do?

- When we use the summarise function, what variables/columns will be contained in our resulting data frame?

- what function do we use to tell R to ignore missing values in our dataset?

-What function do we use to create a frequency plot in R?

-How would you write code, to get a sum of all the non-missing values of dep_delay in the flight dataset in R?

- make me a table showing the number of flights that occured with a specific plane, and the average 
departure delay for each plane.

'''
#5.7 Grouped Mutates and Filters

#Grouping is most useful with summarise, but you can also use it in conjunction with 
#mutate and filter!

#flights_sml dataframe was created under the mutate() section above
#This code below finds the 10 worst flights with highest arrival delays on each day ofthe year?
confused <- flights_sml %>% 
  group_by(year, month, day) %>%
  filter(rank(desc(arr_delay)) < 10)
View(confused)

#makes a table of all destinations that have greater than 365 flights 
pop_dest <- flights %>%
  group_by(dest) %>%
  filter(n() > 365)

#Latest Planes:
Late_plane <- flights %>%
  group_by(tailnum) %>%
  summarise(avg_arr = mean(arr_delay, na.rm = TRUE)) %>%
  arrange(desc(avg_arr))
View(Late_plane)

#Best Time to fly to avoid delays:
times <- flights %>%
  group_by(dep_time) %>%
  filter(arr_delay > 0, dep_delay > 0) %>%
  summarise(avg_arr = mean(arr_delay, na.rm = TRUE), 
         avg_dep = mean(dep_delay, na.rm = TRUE)) %>%
  arrange(desc(avg_arr), desc(avg_dep))
View(times)


