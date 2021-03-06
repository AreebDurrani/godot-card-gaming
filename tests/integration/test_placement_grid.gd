extends "res://tests/UTcommon.gd"

var cards := []
var grid : BoardPlacementGrid

func before_each():
	var confirm_return = setup_board()
	if confirm_return is GDScriptFunctionState: # Still working.
		confirm_return = yield(confirm_return, "completed")
	board.get_node("BoardPlacementGrid").visible = true
	cards = draw_test_cards(5)
	yield(yield_for(0.1), YIELD)
	grid = board.get_node("BoardPlacementGrid")
	grid.rect_position = Vector2(200,200)
	grid.visible = true

func test_placement_slots():
	var card = cards[1]
	yield(drag_card(card, Vector2(250,300)), 'completed')
	assert_eq(grid.get_highlighted_slot(), grid.get_slot(0),
			"First slot highlighted")
	assert_eq(grid.highlight,
			grid.get_slot(0).get_node("Highlight").modulate,
			"slot highlight matches the var of the grid container")
	yield(move_mouse(Vector2(350,300)), 'completed')
	assert_eq(grid.get_highlighted_slot(), grid.get_slot(1),
			"Second slot highlighted")
	grid.highlight = CFConst.TARGET_HOVER_COLOUR
	yield(move_mouse(Vector2(500,300)), 'completed')
	assert_eq(grid.get_highlighted_slot(), grid.get_slot(2),
			"Third slot highlighted")
	assert_eq(CFConst.TARGET_HOVER_COLOUR,
			grid.get_slot(2).get_node("Highlight").modulate,
			"Third slot highlighted with new colour")
	yield(move_mouse(Vector2(650,300)), 'completed')
	assert_eq(grid.get_highlighted_slot(), grid.get_slot(3),
			"Fourth slot highlighted")
	yield(move_mouse(Vector2(250,300)), 'completed')
	assert_eq(grid.get_highlighted_slot(), grid.get_slot(0),
			"First slot highlighted again")
	assert_eq(grid.highlight,
			grid.get_slot(0).get_node("Highlight").modulate,
			"First slot highlighted with new colour")
	drop_card(card,board._UT_mouse_position)
	yield(yield_to(card._tween, "tween_all_completed", 0.5), YIELD)
	assert_almost_eq(grid.get_slot(0).rect_global_position, card.global_position, Vector2(2,2),
			"Card moved to the slot placement")
	assert_eq(card._placement_slot, grid.get_slot(0),
			"card refers to its placement slot")
	assert_eq(grid.get_slot(0).occupying_card, card,
			"placement slot refers to the card")
	yield(drag_drop(card,Vector2(500,300)), 'completed')
	assert_eq(card._placement_slot, grid.get_slot(2),
			"card refers to  newplacement slot")
	assert_null(grid.get_slot(0).occupying_card,
			"old placement slot cleared reference")
	assert_eq(grid.get_slot(2).occupying_card, card,
			"new placement slot refers to the card")
	yield(drag_drop(card,Vector2(1000,300)), 'completed')
	assert_null(card._placement_slot,
			"card placement slot cleared when dropping to the table")
	assert_null(grid.get_slot(2).occupying_card,
			"placement slot clears reference to the card")
	yield(drag_drop(card,Vector2(500,300)), 'completed')
	yield(drag_drop(card,Vector2(500,600)), 'completed')
	assert_null(card._placement_slot,
			"card placement slot cleared when dropping to the hand")
	assert_null(grid.get_slot(2).occupying_card,
			"placement slot clears reference to the card after dropping to hand")

func test_any_grid_placement():
	var card: Card = cards[0]
	card.board_placement = Card.BoardPlacement.ANY_GRID
	yield(drag_drop(card,Vector2(1000,300)), 'completed')
	assert_eq(card.get_parent(), cfc.NMAP.hand,
		"Card not moved to board")
	yield(move_mouse(Vector2(300,200)), 'completed')
	yield(drag_drop(card,Vector2(500,300)), 'completed')
	assert_eq(card.get_parent(), cfc.NMAP.board,
		"Card moved to board")
	yield(drag_drop(card,Vector2(1000,300)), 'completed')
	yield(yield_to(card._tween, "tween_all_completed", 0.5), YIELD)
	assert_almost_eq(grid.get_slot(2).rect_global_position, card.global_position, Vector2(2,2),
			"Card returned back to the slot")

func test_specific_grid_placement():
	var card: Card = cards[0]
	card.board_placement = Card.BoardPlacement.SPECIFIC_GRID
	card.mandatory_grid_name = "GUT Grid"
	yield(drag_drop(card,Vector2(1000,300)), 'completed')
	assert_eq(card.get_parent(), cfc.NMAP.hand,
		"Card not moved to board")
	yield(move_mouse(Vector2(300,200)), 'completed')
	yield(drag_drop(card,Vector2(500,300)), 'completed')
	assert_eq(card.get_parent(), cfc.NMAP.hand,
		"Card not moved to wrong grid name")
	card.mandatory_grid_name = grid.name_label.text
	yield(move_mouse(Vector2(300,200)), 'completed')
	yield(drag_drop(card,Vector2(500,300)), 'completed')
	yield(yield_to(card._tween, "tween_all_completed", 0.5), YIELD)
	assert_eq(card.get_parent(), cfc.NMAP.board,
		"Card moved to correct grid name")

func test_occupied_slot():
	var card: Card = cards[0]
	card.board_placement = Card.BoardPlacement.ANY_GRID
	yield(drag_drop(card,Vector2(500,300)), 'completed')
	assert_eq(card.get_parent(), cfc.NMAP.board,
		"Card moved to board")
	card = cards[3]
	card.board_placement = Card.BoardPlacement.ANY_GRID
	yield(drag_card(card, Vector2(500,300)), 'completed')
	assert_null(grid.get_highlighted_slot(),"No slot highlighted")
	drop_card(card,board._UT_mouse_position)
	yield(yield_to(card._tween, "tween_all_completed", 0.5), YIELD)
	assert_eq(card.get_parent(), cfc.NMAP.hand,
		"Card not moved to board when slot is occupied")
