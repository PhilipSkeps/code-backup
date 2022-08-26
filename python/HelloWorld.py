#!/usr/bin/python

import random # random number time

print("\nHelloWorld")
x = 4 + 3
print(x)
i = 0
for i in range(10):
    print(i,end=" ")
print("\nballs")
print("nuts even\n")
f = float(5) / 3
print(f)
g = int(5 / 3)
print(g)
x, y, z = "1", "2", "3"
print(x,y,z,sep=" ")
x = y = z = "Balls"
print(x,y,z,sep = " ")
firstList = [1,2,3] 
x, y, z = firstList # needs to be same size as list otherwise error
print(x,y,z,sep = " ")
def dummyfunction():
    global y # make global
x =3+2j # complex numbers are built in
print(type(x))
x = random.randrange(0,30,1) # does not include upper bound (30)
print(x)
if x < 20:
    print(x,"is less than 20")
else:
    print(x,"is not less than 20")
    
##############################################################################################
##################################### STRINGS ################################################ 
   
x = """multiline 
string"""
print(x)
print(x[0]) # print first letter of the string
print(len(x)) # return length of string
print("multi" in x) # return true if substring is in string
print("multi" not in x) # checks if substring not in string
print(x[2:5]) # return slice of string
print(x[:5]) # from start
print(x[1:]) # to end
print(x[-5:-2]) # if negative indices start from end of string
x = " Balls Nuts Even"
print(x.upper()) # upper case it
print(x.strip()) # trim whitespace
print(x.lower()) # lower case it
print(x.replace("e","E")) # replace letter 1 with letter 2
x,y,z=x.strip().split(" ") # split string based on spaces
print(x)
z = x + " " + y # concat string
print(z)
x = "This many balls {0} and this many nuts {1}" # cannot concat numbers so need to use format
print(x.format(2,3)) # like this
x = "This many balls {1} and this many nuts {0}" # cannot concat numbers so need to use format
print(x.format(2,3)) # check out difference
# there is a bunch of different string methods should check them out. NOT DONE

###############################################################################################
##################################### BOOLS ###################################################

# empty strings are false if cast as bool
# zero is false if cast as bool
# ist, tuple, set, and dictionary if empty are false if cast as bool
# all else is true if cast as bool
print(bool("")) # empty string
print(bool(0))  # empty zero value
print(bool([])) # empty array
print(bool({})) # empty dictionary
print(bool(())) # empty tuple
def testfunction():
    return True
print(testfunction()) # functions can return a bool

###############################################################################################
##################################### OPERATORS ###############################################
