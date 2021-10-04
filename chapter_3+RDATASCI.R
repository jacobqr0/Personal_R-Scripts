'''
-----------------------------
CHAPTER 3: DATA VISUALIZATION
-----------------------------

''' 

library(tidyverse)

''' 
To make a graph:

ggplot(data = <DATA>)+
<GEOM_FUNCTION>(mapping = aes(<MAPPINGS>))

'''

'''
class is a third variable you can add to a scatter plot
you can map it to an aesthetic
an aesthetic is a visual property of the objects in your plot
aesthetics include: size, shape, color of your points.
*to add color, assign: color to the categorical variable.
color = class

EXAMPLE BELOW:
'''
#Color
ggplot( data = mpg) +
  geom_point(mapping= aes(x = displ, y=hwy, color = class))

#Size
ggplot( data = mpg) +
  geom_point(mapping= aes(x = displ, y=hwy, size = class))

#alpha
ggplot( data = mpg) +
  geom_point(mapping= aes(x = displ, y=hwy, alpha = class))

#Shape
ggplot( data = mpg) +
  geom_point(mapping= aes(x = displ, y=hwy, shape = class))
#NOTE: ggplot2 will only use six shapes at a time.

#Can set aesthetic properties of your geom manually:
ggplot(data = mpg)+
  geom_point(mapping = aes(x=displ, y=hwy), color="magenta")

'''

To manually specify the shape you want, see figure 3.1:

https://r4ds.had.co.nz/data-visualisation.html

Note that the manual aesthetic specifications are set outside of the aes() brackets

'''
ggplot(data = mpg)+
  geom_point(mapping = aes(x=displ, y=hwy), shape=18, color="red")

#Pressing the ESCAPE button deletes any code that you have written.
?function_name

''' 
FACETS - you can add additional variables, by splitting up 
your plot into subplots that each display one subset of the data.

The variable that you pass to facet_wrap() should be discrete.

'''

ggplot(data = mpg) +
  geom_point(mapping = aes(x=displ, y = hwy))+
  facet_wrap(~class, nrow=2)

'''
You can facet your plot with a combination of two variables!
Use the facet_grid() function to call your plot.
Two variable names are listed in the facet_wrap() seperated by ~
'''

ggplot(data=mpg)+
  geom_point(mapping = aes(x=displ, y = hwy))+
  facet_grid(drv ~ cyl)

'''
REMEMBER: if you need to get info on your data, write the
data name with a ? sign in front of it. 
example:
?mpg
'''
#Note the placement of the facets in the following examples:

#here facets are placed on the right of the graph (it looks better this way)
ggplot(data = mpg)+
  geom_point(mapping = aes(x=displ, y=hwy))+
  facet_grid(drv~.)

#here facets are placed on the top of the graph (doesn't look as good)
ggplot(data = mpg)+
  geom_point(mapping = aes(x=displ, y=hwy))+
  facet_grid(.~cyl)

'''
make sure to put the variable with the most unique levels in the coloumns 
when using the facet_grid() function.
'''
'''
GEOMETRIC OBJECTS

a geom is the geometrical object that a plot uses to 
represent data. 

People often describe plots by the type of geom that the plot uses.

bar charts use bar geoms
line charts use line geoms
boxplots use boxplot geoms
scatter plots use point geoms

to change the geom in your plot, change the geom function
that you add to ggplot() Shown below:
'''

#original
ggplot(data = mpg) +
  geom_point(mapping = aes(x=displ, y=hwy))

#smooth line plot
ggplot(data=mpg)+
  geom_smooth(mapping = aes(x=displ,y=hwy))

ggplot(data=mpg)+
  geom_smooth(mapping=aes(x=displ, y =hwy, linetype =drv))

#WE CAN COMBINE GEOMs IN ONE PLOT! EX BELOW:
#simply add multiple geom functions to ggplot():
ggplot(data = mpg) +
  geom_point(mapping = aes(x=displ, y=hwy, color = drv))+
  geom_smooth(mapping = aes(x=displ, y=hwy, linetype = drv, color=drv))

'''
Notice in the example above how there is duplication in our code, (geom_point and geom_smooth),
We can avoid this by passing a set of mappings to ggplot(), example below:

placing the mappings in a geom function will treat them as local mappings for the layer.
it will use these mappings to extend or overwrite the global mappins for that layer only.
'''
ggplot(data = mpg, mapping = aes(x=displ, y=hwy))+
  geom_point()+
  geom_smooth()

# example of how we can manipulate the geom functions in a single local mapping layer
ggplot(data= mpg, mapping = aes(x=displ, y=hwy))+
  geom_point(mapping = aes(color = class))+
  geom_smooth()

#See the geom cheatsheet in R_Statistics folder. Literally so many combinations and possibilities!!

#Can set the group aesthetic to a categorical variable to draw multiple objects.
#will automatically group the data based on their assigned categories
#in the case below, it is the drive type category (four wheel, front wheel etc.)
ggplot(data = mpg)+
  geom_smooth(mapping= aes(x=displ,y=hwy, group=drv))

ggplot(data = mpg)+
  geom_smooth(mapping= aes(x=displ,y=hwy, color = drv),
              show.legend = TRUE)

#note what the component 'se=FALSE' does to the graph.
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + 
  geom_point() + 
  geom_smooth(se = FALSE)

'''
STATISTICAL TRANSFORMATIONS 3.7
'''

#How to make a bar chart in R:
ggplot(data=diamonds)+
  geom_bar(mapping=aes(x=cut))

#note: Histogram to tell the normal distribution of the data.
ggplot(data=diamonds)+
  geom_histogram(mapping=aes(x=price))

#stat_count will create the previous plot( geom_bar)
ggplot(data=diamonds)+
  stat_count(mapping=aes(x=cut))

#Creating tables in R:
demo <- tribble(
  ~cut,         ~freq,
  "Fair",       1610,
  "Good",       4906,
  "Very Good",  12082,
  "Premium",    13791,
  "Ideal",      21551
)

ggplot(data = demo) +
  geom_bar(mapping = aes(x = cut, y = freq), stat = "identity")

#TO MAKE A BAR CHART OUT OF PROPORTION:
ggplot(data=diamonds)+
  geom_bar(mapping = aes(x=cut, y=stat(prop), group=1))
#note how the y axis changed

#stat summary function for summorizing y values for each x vaule:
ggplot(data=diamonds)+
  stat_summary(
    mapping = aes(x=cut, y=depth),
    fun.ymin=min,
    fun.ymax=max,
    fun.y=median)
#its kind of like a box plot

#you can color bar charts 
ggplot(data=diamonds)+
  geom_bar(mapping=aes(x=cut, color=cut))

#note the difference between this bar chart and the one above:
ggplot(data=diamonds)+
  geom_bar(mapping = aes(x=cut, fill = cut))
''' by setting the color you change the color of the outline according to the variable
and by changing the fill you change the color of the entire bar
'''

#if you map the fill aesthetic to another variable, like clarity: the bars are
#automatically stacked according to that variable:
ggplot(data=diamonds)+
  geom_bar(mapping=aes(x=cut, fill=clarity))+
  labs(x="Cut Type", y="Count", title = "Hello")#how to use labels!

ggplot(data=diamonds, mapping=aes(x=cut, fill=clarity))+
  geom_bar(alpha=1/5, position="identity")
ggplot(data=diamonds, mapping = aes(x=cut, colour = clarity))+
  geom_bar(fill=NA, position = "identity")

#The position = "fill" statement is easier to compare proportions of a variable within and among groups
ggplot(data=diamonds)+
  geom_bar(mapping = aes(x=cut, fill = clarity), position = "fill")

#NOTE the position = "dodge". this graph places overlapping objects directly beside one another! 
# displays counts of the clarity types within each group of the cut type:
ggplot(data=diamonds)+
  geom_bar(mapping = aes(x=cut, fill = clarity), position = "dodge")

#Overplotting- rounded points on a grid appear to overlap each other 
#often over plotting makes it difficult to see where the mass of the data is. 
#position = "jitter" introduces random noise to each point 
ggplot(data = mpg)+
  geom_point(mapping = aes(x=displ, y=hwy), position="jitter")

#compare to what the original plot looked like:
ggplot(data = mpg)+
  geom_point(mapping = aes(x=displ, y=hwy))

#adding randomness by using the position = jitter function may mke your graph less accurate 
#at small scales but makes the graph more revealing at larger scales.

#NOTE: geom_jitter() is a shortcut to use this function

# coord_flip() switches the x and y axes :
ggplot(data = mpg, mapping = aes(x=class, y=hwy))+
  geom_boxplot()

ggplot(data=mpg, mapping = aes(x=class, y= hwy))+
  geom_boxplot()+
  coord_flip()

#coord_polar() uses polar coordinates for charts,
#note the difference in the bar chart and the coxcomb chart
bar <- ggplot(data = diamonds) + 
  geom_bar(
    mapping = aes(x = cut, fill = cut), 
    show.legend = FALSE,
    width = 1
  ) + 
  theme(aspect.ratio = 1) +
  labs(x = NULL, y = NULL)

#bar chart 
bar + coord_flip()
#coxcomb chart
bar + coord_polar()

#note the use of labels:
?labs()
#labels:
ggplot(data=diamonds)+
  geom_bar(mapping=aes(x=cut, fill=clarity))+
  labs(x="Cut Type", y="Count", title = "Hello")#how to use labels!

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point() + 
  geom_abline() +
  coord_fixed()

?geom_abline()
?coord_fixed()
# the coord_fixed() function forces a specific aspect ratio between the physical representation
# of data units on the axes

