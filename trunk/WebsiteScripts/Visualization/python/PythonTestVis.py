import sys
#http://ocemp.sourceforge.net/old_manual/ar01s06.html
import ocempgui.draw
from ocempgui.draw import String
#import and init pygame
import pygame
from pygame.locals import *
pygame.init()
pygame.display.set_caption('PromWeek Visualization Test!')

#create the screen
window = pygame.display.set_mode((640, 480)) 

#draw it to the screen
pygame.display.flip()

#get some test data in there
a = "Make Plans,Naomi,Zack,15"
b = "Pick-up Line,Zack,Naomi,5"
c = "Show Off,Zack,Naomi,4"
d = "Share Interest,Zack,Cassie,3"
e = "Embarrass Self,Naomi,Zack,4"
f = "Brag,Cassie,Naomi,9"
g = "Open Up,Zack,Cassie,7"
h = "Idolize,Zack,Naomi,8"

#make some sample paths:
path1 = "adef"
path2 = "adec"
path3 = "hfeba"
path4 = "efghabcd"
path5 = "abcdefgh"

DEBUG = 0

class Node:
    def __init__(self,value,parent):
        self.value = value #the test data
        self.parent = parent #parent is required I think
        self.children = {} #N number of children
    def __iter__(self):
        tmp = Node(self.value,self.parent)
        tmp.children = self.children
        return tmp
    def drawPath(self): #this function is just for playing around
        pygame.draw.line(window, (255,255,255),(self.x1,self.y1),(self.x1,self.y1+5))
        self.y1 += 5
        self.x1 += 1
        pygame.display.flip()
    def getName(self): #should be obvious
        return self.value
    #this is where it gets tricky. Inserts a path starting at this node
    def insertPath(self,path): 
        if(DEBUG):
            print "Working on: " + path
        if(path == ""): #if we're done [this shouldn't be called]
            if(DEBUG):
                print "Done with the path!"
            return
        if(self.children.has_key(path[0])): #if I have this child already
            if(len(path) < 2): #if I'm on the last child
                if(DEBUG):
                    print "Path is done:: " + path
                return #don't mess up the value (it could have more children)
            #otherwise, insert onto this child
            if(DEBUG):
                print "1)**Inserting: " + path[1:] + " into " + path[0] + " of " + self.value
            self.children[path[0]].insertPath(path[1:])
        else: #I don't have that child yet
            self.children[path[0]] = Node(path[0],self) #put it into our children
            if(DEBUG):
                print "3)Inserting: " + path[1:]
            self.children[path[0]].insertPath(path[1:]) #insert onto it            
    def drawNode(self,x,y,px,py): #this will be my attempt to draw this node
        mover = 0;
        if(len(self.children) == 0):
            pygame.draw.circle(window, (255,255,255),(x,y),2)
            self.drawString(x,y)
            #draw a line back to the parent
            pygame.draw.line(window,(0,255,0),(x,y),(px,py))
            return
        else:
            #run through all the children
            for c in self.children:
                self.children[c].drawNode(x + mover, y + 15,x,y)
                mover += 15
        #draw a circle here
        pygame.draw.circle(window, (255,255,255),(x,y),2)
        #draw the letter here
        self.drawString(x,y)
        #draw a line to the parent
        pygame.draw.line(window,(0,255,0),(x,y),(px,py))
        #flush
        pygame.display.flip()
    def drawString(self,x,y):
        # string drawing shenanigans
        text = String.draw_string (self.value, "Times",14,1,(255,0,0))
        window.blit (text, (x, y))
    def printNode(self,buff=""):
        if(len(self.children) == 0):
            print buff + self.value
            return
        else:
            for c in self.children:
                self.children[c].printNode(buff + "   ")
        print buff + self.value
    def clearScreen(self):
        window.fill((0,0,0))
        pygame.display.flip()
            


root = Node("R",None)
root.insertPath("abcd")
root.insertPath("abdc")
root.insertPath("bcde")
root.insertPath("acdb")
root.insertPath("axdb")

root.printNode()
root.drawNode(25,25,25,25)
print "Done!"
while(1): #used just so we can keep it in view
    flag = 0
    for event in pygame.event.get():
        if event.type == pygame.KEYDOWN and event.key == K_q: # quit on pressing q
            flag = 1
            break
    if flag:
        print "Quitting"
        break
               

