# Final_project
# Jonathan Ebrahimian Nathan Gage Edward Jiang



# AR Scavenger Project Specifications

# Models

## Environment Model 


### Data



* Dictionary with location as key, list of objects as values
    * Example: {‘kitchen’: [‘spoon’, ‘fork’, ‘sink’, ‘milk carton’]}
    * Objects are based on YOLO categories
    * Each room has the same set of items EVERY TIME
* Dictionary with difficulty as key, list of locations as values
    * Example: {‘easy’: [‘bedroom’, ‘kitchen’, ‘bathroom’], ‘medium’: [‘house’, ‘school’, ‘office’]}
* Dictionary with location as key, integer representing time in seconds for that room


## Player Model

### Functions

* Load from local storage
* Save to local storage
* Add found item
* Save high score for room
* Save room as completed
* Reset player (fully reset everything)
* Calculate % items not found (for the home screen)


### Data

* High score per room
    * Example: scores = {‘bedroom’: 5000, ‘kitchen’: 3420}
* Completion of rooms
    * Example: completed = [‘bedroom’, ‘kitchen’, ‘office’]
* List of items that have been found
    * Example: {‘bedroom’: [‘pillow’], ‘kitchen’: [‘spoon’, ‘milk carton’]}


## Game Model

We should save items to the player model & local storage as they are found. Store room completion iff players find all items for that room, in the allotted time.


### Functions

* SetState(GameState)
* PredictLabels(Image) -> async (for loading animation in UI)
    * If the top 3 predictions contain an item to be found, mark it as found in the player model
    * If all items are found, SetState(FINISHING)
* StateListener()
    * Listens to updates to GameState, sets things accordingly
        * E.g., OnFinish-> if player completed room, store that info, store high score
* CalculateHighScore()
    * High score = # of items * 100 points + (if completed) 10 points per extra second on the clock


### Data


* Game state
    * OUT_OF_GAME, READY, IN_GAME, FINISHING, END_SCREEN
* Time game started
* Current location
* Items to be found
* Parallel array (to “Items to be found”) of boolean values whether or not it has been found


# Views 

## Home View Controller



* Segmented control for difficulty
* Picker for location
    * Contents change based off of the difficulty
* Locations should have indication that they have been completed (3 stars or gold text, for example)
* Progress bar for % completion of items
* Start button
* Reset player button


## Game View Controller



* On all states
    * Camera Viewfinder
* GameState = READY
    * Countdown w/ 3... 2... 1...
    * High score in big text
    * Items that need to be found
    * Location of game
* GameState = IN_GAME
    * Timer at the top with remaining time
    * Card on bottom that shows 1-3 items up coming, but can be swiped up on to reveal entire list w/ items that are both found and not found w/ checkmarks
    * “Find Item” button that is clicked on when user is aiming camera at the item they’d like to check off the list
        * This calls the game model PredictLabels(Image)
        * If all items are found -> GameState = FINISHING
    * Quit button
        * If you quit early, you only receive points for items found, NOT extra remaining 
        * Calls GameState = FINISHING
* GameState = FINISHING
    * Calculate & save high score
    * Reset any necessary variables
    * Set GameState = END_SCREEN
* GameState = END_SCREEN
    * Display list of items found / not found
    * Display time remaining
    * Display score
    * Display if player beat PR
    * Display if room has been completed
        * Special text if it is their first completion 
    * Replay button
    * Exit button
