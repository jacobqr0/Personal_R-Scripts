'''
==========================
CHAPTER 4: WORKFLOW BASICS
==========================

Always assign new objects with ' <- '

You can use the RStudio keyboard shortcut Alt + - to quickly
type the assignment operator. 

It is good practice to put spaces between the assignment operator
and the objects you assign to it. 

''' 
x <- 6
y <- 7
x*y

'''
Object names must start with a letter, and can only contain letters, numbers,
_ and .

You want your object names to be descriptive, must maintain a convention for multiple words.

snake _case:
i_use_snake_case

otherPeopleUseCamelCase
some.people.use.periods

you can inspect an object by typing its name:
'''
x

this_is_a_really_long_name <- 2.5
'''
to fix mistakes in assignment statements:

type "this" in the console
press Cmd/Ctrl + uparrow 
Press enter to retype the command and change 2.5 to 3.5!

'''
r_rocks <- 2^3

#seq() will make a large sequence of numbers:
# type se and hit TAB
seq(1,10)

'''
The continuation character '+' tells you that R is waiting for more input;
it doesnt think youre done yet

if you press ESCAPE, you can abort the expression and try again.

''' 
y <- seq(1,10,length.out =5)
#if we surround this assignment with parentheses, it causes the assingment 
#to 'print to screen':
(y <- seq(1,10,length.out=5))

'''
Look at the environment in the upper right pane:
You can see all the objects that you created!!
'''
#ALSO! Pressing alt + shift + K will open the shortcut commands!


