Colour Blind: a game made in 48 hours by David Watson, David Walton and Joseph
Lansdowne, for the theme 'blindfolded players'.

This is a 2-player co-operative game; play using WASD and the arrow keys,
where S/down toggle switches.  Press R to reset the current level and M to
toggle sound.  WASD and R are also in the same place for the Dvorak keyboard
layout.

There's a level editor you can play around with: F2 to toggle it, ctrl to show
the available things, mouse to do stuff with the things. 


Connecting walls and switches is a little complicated to allow for interesting
events to happen. Here is how it currently works (I hope to try to keep this
updated).

To get into edit event mode click on the thing that looks like a line
(currently in the 3rd row). This will bring up a box of the events currently
in the level and the list of the affects.  You can move this box by clicking
and dragging.

Each entry in the wall will look something like this

   The logic of the block               Another affect
   in reverse Polish       An affect    block
   notation.               block         |
              |               |          |
            --+---           -+------  --+-
LogicBlock: NOT b1, affects: [WT, w0], [-1]
            -+- -+            +-  +-    -+
             |   |            |   |      |
             | Switch      Affect |      |
             |             Type   |   no affect
          Not block               |   
                                Wall

The are 3 logical operators AND, OR and NOT, with the obvious meanings. The
notation for switches is b (for button) and the switch number this will be
written on the switch. The logic is in reverse Polish notation separated by
spaces. All buttons start off false.

Each affect of the event will have will be of the form [*], where star is the
data of the block. In the above example either * = "WT, w0" or * = "-1". The first 
component is from the folling list

Code   |   Meaning                             | Following componentents
-----------------------------------------------|--------------------------
       |                                       |
-1     |   no affect                           |   none
WT     |   wall toggle (on if true)            |   "w" followed by the number
       |                                       |   of a wall to affect
WTI    |   wall toggle inverted (on if false)  |   "w" followed by the number 
       |                                       |   of a wall to affect


What happens if you actually want to change things?

To select an event click on it, by default this will put you at the top level
of the logic block, but what does that mean?

e.g. If you clicked on the block in the above example you would see something
like this 

LogicBlock: {NOT b1}, affects: ([WT, w0]), ([-1])

The braces around the "NOT b1" signifies that it is the currently selected
item. (As pretty much everything has braces around it you are on the top
level.) To move across the level press left and right, you will notice that
moving right which you've reached the end will add a new affect block. (It is
easy to see what you can move to using left and right, they are the things
enclosed in "(" and ")".)

When you are on a logic block you may move down a level (ie to a lower logic
block) by pressing down and up a level (ie to a parent logic block) by pressing
up.

Thing work slightly differently on the affect side, up and down now move left
and right within the affect block.

So how do you make changes? 

Press enter.

If you've got an event selected, this let you add some text to the currently
selected element. There isn't terrific error checking so keep your inputs sane.
Press enter again will make the change. Note empty cancels.

If you've not got an selected this will create a new block with the entered
text. Note empty cancels.

Allowed items to enter

Code    |   Meaning
----------------------------------------------------------
        |                                   
""      |   Do nothing
        |  
NOT     |   create NOT block
AND     |   create AND block
OR      |   create OR block
Bn      |   block to get the state of switch n
B       |   set it to get no switch data
        |   
WT      |   set the affect type to wall toggle
WTI     |   set the affect type to wall toggle inverted
Wn      |   set it to affect wall n (n is an integer)
W       |   set it to affect no wall
