# Changelog

## 1.4 (Ongoing)


### New Features

* Added ability for BoardPlacementGrid to be set to autoextend based on exported var. Only really useful for scripting, when a script requests a position to said grid, it will automatically add a new slot.
	(defaults to false)

#### ScriptingEngine

* Added support for placing cards directly into Grids
* Having enough space in a grid can also be considered a cost check
* Now can spawn more than 1 card at the same time
* Spawned cards can be placed in grids directly.

### Tweaks
#### ScriptingEngine

* Consolidated move_card_cont_to_cont to move_card_to_container
* Consolidated move_card_cont_to_board to move_card_to_board

You have to adjust any scripts which used the former two tasks, to use the latter two. No need to adjust any keys.


## 1.3

### New Features

* Refactoring was done so that the Framework is easier to upgrade to a newer version by simply overwritting the `res://src/core` folder with the newer version
  * Moved CFConst to `res://src/custom` which is not meant to be overwritten. This will ensure tweaks to the way the engine works will remain after an upgrade.
  * Main.tcsn now doesn't have the board scene instanced directly. Rather you specify the board scene via an exported variable.
	This allows developers to create a new inherited Main.tcsn scene and set it to load their own custom board scene. This in turn allows a developer to upgrade their Main.tcsn in `res://src/core` and take advantage of any upgrades, while not losing their own customizations
  * Moved Card Front to its own instance, with a same method used for card back. Now inherited card scenes from CardTemplate can have radically different Front layout from each other.
  * Moved Manipulation buttons to code, instanced from a single button scene. Code exists inside ManipulationButtons class and can be overriden by any card that uses its own script to extend it.
  * Developers can now also specify the Scripting Engine location inside CFConst. This will allow them to extend its functionality with more tasks, specific to their game.
* Can now define global CARD_SIZE to CFConst. Now you can change card size globally and all cardcontainers will also adjust their size accordingly.
* Developers do not need to define critical node locations in CFConst anymore.
* Made it easier for other devs to extend the ScriptingEngine
* Added configuration option that selectively disables drag or drop.
* Added overridable function `check_play_costs()` which can determine on runtime is costs can be paid, and allow the card to be dragged from hand
* Can now create grid containers which will highlight when a card is being dragged on top of them so signify the position the card will move to.
* Can now specify where each card type will be able to drop on the board. Options are Anywhere, Any Grid only, Specific Grid only, or None (which means this card type cannot be dropped on the board at all)

## 1.2

### New Features

* Pile name and card count will be displayed. Possibility to add an image or colour to the pile which will not be shown when there's cards inside.
* Added new card back that meets proper gambling symmetry rules.  - Contribution by [@zombieCraig](https://github.com/zombieCraig).
* A pile can now be renamed from the editor properties, instead of having to edit node properties and look for the label. - Contribution by [@zombieCraig](https://github.com/zombieCraig).

### Tweaks

* Card Back scene has to be defined in the new card_back_design exported variable. You have to select the scene you want from for each different card type (assuming they're using a different one)
* Switched BoardTemplate to expect Control instead of Node2D, to allow potential GUI elements to orient themselves easier.
* Card back now can include the "Viewed" node in in any form they wish.
	The function set_is_viewed() will handle setting the viewed node to visible or not.
	if another method to show viewed has been setup for this card back, then the set_is_viewed() function can be overriden.


### Bugfixes

* Card properties will now properly ignore properties defined with _underscore in the name start.
	If the property's label is missing and the property does not start with an underscore, the framework will print out an error. - Contribution by [@zombieCraig](https://github.com/zombieCraig).

## 1.1

We're now [added a quickstart guide](tutorial/QUICKSTART.md)!

### New Features

* Card Front labels should be defined in the _card_labels variable. This is defined inside `_init_front_labels()`. This allows any developer to modify the Front control nodes layout and still allow the setup() to find the label nodes to modify them.

### Tweaks

* Synchronized card focus animations
* Changed colour for the Requirements label to make it more obvious in the demonstration that an empty label is hidden
* If a label expands too much in rect._size.y, a pre-specified label will shrink to compensate. Defined in CardConfig.

## 1.0

First stable release is here! We will attempt to not break (too much) existing names and calls from this point on.

### New Features

* Pile shuffle is now animated - Contribution by [@vmjcv](https://github.com/vmjcv).
* Many types of pile shuffle animation and ability to select a different one per pile.
	Available anims:
   * corgi
   * splash
   * snap - Contribution by [@vmjcv](https://github.com/vmjcv).
   * overhand - Contribution by [@EasternMouse](https://github.com/EasternMouse).
* Piles and Hand will highlight when a dragged card hovers over them to display where the card will be dropped when released.
* Framework godot source directories can now be renamed or moved.
* Added "Placement" option to select where each CardContainer will be setup on the board
* If CardContainers have a specified placement on the board, a table resize will automatically move them to the right location. This means that stretch mode "disabled" is usable now.
* Added switch to disable placement on board (for games that don't use it)

#### Scripting Engine

* Added new task "modify_properties", which allows scripts to change the card details.
* Added new task "ask_integer", which allows the script to request a number from the player. Subsequent tasks can pull that number for their own effects
* Some tasks can now use the new "subject_count" modulator which allows to affect more than 1 card.
* Moving cards from containers can now be treated as a cost.

### Bugfixes

* Refactored how mouse detection works. Should avoid clicking or highlighting the wrong card
* Now clicking on buttons or tokens too long should not try to drag the card. Likewise clicking them too fast shouldn't try to execute scripts

## 0.12

### New Features

* Scipting Engine target finding now supports tutoring cards from deck
* Scipting Engine target finding now supports affecting multiple cards from the board by filtering their properties
* Scripting Engine now supports cards with multiple choices for abilities.
* Scripting Engine now supports cards with optional abilities
* Hand shape can now be oval (default) - Contribution by [@vmjcv](https://github.com/vmjcv).
* Font-size will decrease when it amount of chars is too large, in order to stay within the defined label rectangle - Contribution by [@vmjcv](https://github.com/vmjcv).

### Bugfixes

* Fixed manipulation buttonsd messing with player's actions


## 0.11

* Added new card back
* Made the card back glow-pulse
* Can add or remove tokens from cards
* Piles now display the size of the card stack
* Cards in Piles are now places face-up or facedown depending on the pile config
* Card definitions can now be created using json
* Supports multiple sets of card and script definitions
* Added [Scripting Engine](https://github.com/db0/godot-card-gaming/wiki/ScriptDefinitions)!
  * Tasks supported:
    * Rotate Card
    * Flip card face-up/down
    * Move card to a CardContainer
    * Move card to board
    * Move card from Container to Container
    * Spawn new card
	* Shuffle CardContainer
	* Attach to card
	* Attach card to self
  * Trigger-based execution supported:
    * Card rotated
	* Card flipped
	* Card viewed
	* Card moved to board
	* Card moved to hand
	* Card moved to pile
	* Card_tokens_modified
	* Card attached to another
	* Card unattached from another
  * Filtering of triggers supported:
	* Card properties
	* Card rotation degrees
	* Card facing
	* Source container of move
	* Destination container of move
	* Token count
	* Token increase/decrease
	* Token name
* Scripting also support setting some tasks as costs required and targetting cards on the table.


In case you're wondering why the FocusHighlight node has two children panel nodes, instead of making it itself a Panel node.

This is because of https://github.com/godotengine/godot/issues/32030 which doesn't not consistently apply glow effects to vertical lines.

As such, I had to create the vertical and horizontal lines sepearately and apply different intensity of colour to each, to make the glow effect match.

## 0.10

* Added visible highlight when mousing over a card
* Can move cards to top/bottom or any index in Card Containers
* Can retrieve cards from top/bottom of Card Containers
* Can retrieve random cards from Card Containers
* Can shuffle Card Containers
* Can attach cards to other cards
* Can target cards with a targetting arrow
* Made highlights glowing
* Enabled ability to make cards face-down
* New button to view face-down cards that appears only when card is faced-down

## 0.9

* Added viewport-based focus
* Switched back to control-centric signals. Kept the Area2D base of cards for collision detection only. Ignored z_index except when dragging
* Added a way to display buttons when hovering over CardContainers and Cards.The buttons would trigger predefined actions.
* Added capability to look inside containers and manipulate cards
* Added a container button which creates a rudimentary popup for seeing the cards inside containers
* Added a container button which shuffles the contained cards
* Added method to get random cards from CardContainer. Added Hand button to trigger it as a demo
* Added capability to rotate cards on table
* Added a card buttons which rotate cards 90 or 180 degrees


## 0.8

* Added capability for any number of hands and/or piles
* Can drop cards into piles
* Can pick up cards from table
* Hand is a type of container (like piles) and behaves similarly to keep things consistent.
* Cards dragged will always be in front of other elements now
* When 2+ cards overlap on the board, game will always pick the top one when clicking to drag.


## 0.7

* Added GUT and initial tests
* Added button to reshuffle cards to the deck
* Added fancy movement
* Made hand into a control container
* Removed config from Card object into an singleton

## 0.6

* Can drag cards
* Can drop cards back to the hand or table

## 0.5

* First published version
* Code for drawing cards to hand
* Automatic reorganization of cards as hand size changes
* Automatic zoom in/out on mouse enter/exit respectively.
