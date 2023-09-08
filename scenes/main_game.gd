extends Node2D

var current_player = 0
var cards = []
var fruits = ['a', 'b', 'c', 'd']
var players = {
	0: [],
	1: [],
	2: [],
	3: [],
}

func _ready() -> void:
	for i in fruits:
		var tmp = []
		tmp.resize(4)
		tmp.fill(i)
		cards.append_array(tmp)
	cards.shuffle()
	for i in range(4):
		players[i] = cards.slice(i * 4, (i + 1) * 4)
	_print_cards()

func _process(delta: float) -> void:
	if _get_input("1"):
		remove_card(1)
	elif _get_input("2"):
		remove_card(2)
	elif _get_input("3"):
		remove_card(3)
	elif _get_input("4"):
		remove_card(4)
	elif _get_input("5"):
		remove_card(5)

## card: card index to remove
func remove_card(card_index: int):	
	var card = players[current_player].pop_at(card_index - 1)
	if card == null: printerr("HOW??")
	print("removing card: ", card, " at: ", card_index , " player: ", current_player)
	current_player = (current_player + 1) % 4 
	players[current_player].append(card)
	check_winner()
	_print_cards()

func check_winner():
	for fruit in fruits:
		if players[current_player].count(fruit) == 4: # TODO: replace with >= 4, but does it worth it?
			print("Winner is %d" % current_player)
			$UI/Label.text = "Player %d Won!" % current_player
			
func _get_input(action: StringName):
	return Input.is_action_just_pressed(action)
	
func _print_cards():
	for player in players:
		players[player].sort()
		var s = str(player) + ": " + str(players[player])
		print(s)
	update_ui()

func update_ui():
	var _players = get_node("%Players").get_children()
	var index = 0
	for player in _players:
		_update_player_ui(player.get_child(0), index)
		index += 1
	
func _update_player_ui(player_cards: Control, player_index):
	var card = player_cards.get_child(0).duplicate()
	for child in player_cards.get_children():
		player_cards.remove_child(child)
	for i in range(len(players[player_index])):
		var new_card = card.duplicate()
		new_card.name = str(i)
		new_card.text = players[player_index][i]
		player_cards.add_child(new_card)
	card.queue_free()
		
	
