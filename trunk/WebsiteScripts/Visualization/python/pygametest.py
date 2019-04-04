import sys
#import and init pygame
import pygame
pygame.init() 

#create the screen
window = pygame.display.set_mode((640, 480)) 

#draw a line - see http://www.pygame.org/docs/ref/draw.html for more 
pygame.draw.line(window, (255, 255, 255), (0, 0), (30, 50))

xval = 50;

#draw it to the screen
pygame.display.flip() 

#custom line drawing fn
def line():
   pygame.draw.line(window, (255, 255, 255), (0, 0), (30, ++xval))


#input handling (somewhat boilerplate code):
while True: 
   for event in pygame.event.get(): 
      if event.type == pygame.QUIT: 
          sys.exit(0) 
      if event.type == pygame.KEYDOWN and event.key == K_ESCAPE:
          sys.exit(0)
      if event.type == pygame.KEYDOWN and event.key == K_a:
          line()
      else: 
          print event 
