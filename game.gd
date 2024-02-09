class_name Game extends Node

var levels := [
	load("res://scenes/levels/level_1.tscn"),
	load("res://scenes/levels/level_2.tscn"),
	load("res://scenes/levels/level_3.tscn"),
	load("res://scenes/levels/level_4.tscn"),
	load("res://scenes/levels/level_5.tscn"),
	load("res://scenes/levels/level_6.tscn"),
	load("res://scenes/levels/level_7.tscn"),
	load("res://scenes/levels/level_8.tscn"),
	load("res://scenes/levels/level_9.tscn"),
	load("res://scenes/levels/level_10.tscn"),
	load("res://scenes/levels/level_11.tscn"),
	load("res://scenes/levels/level_12.tscn"),
	load("res://scenes/levels/level_13.tscn"),
	load("res://scenes/levels/level_14.tscn"),
	load("res://scenes/levels/level_15.tscn"),
	load("res://scenes/levels/level_16.tscn"),
	load("res://scenes/levels/level_17.tscn"),
	load("res://scenes/levels/level_18.tscn"),
	load("res://scenes/levels/level_19.tscn"),
	load("res://scenes/levels/level_20.tscn"),
]

var g = Globals

func _ready() -> void:
	show_title_screen()

func set_game_to_initial_state():
	Globals.reset()
	PlayerVariables.reset()

func show_continue_screen():
	var continue_screen = load("res://screens/continue.tscn").instantiate()
	# TODO: remove this function and use a lambda
	var cleanup_and_start_game = func():
		if g.current_level_idx > 0:
			show_shop()
		else:
			start_level(instance_current_level())

	continue_screen.continue_game.connect(cleanup_and_start_game)

	continue_screen.new_game.connect(
		func():
			set_game_to_initial_state()
			cleanup_and_start_game.call()
	)

	add_child(continue_screen)

func show_start_screen():
	var start_screen = load("res://screens/start.tscn").instantiate()

	start_screen.start.connect(
		func():
			set_game_to_initial_state()
			start_level(instance_current_level())
	)
	add_child(start_screen)

func show_title_screen():
	# We must load the game to get the correct state of g.current_level_idx
	load_game()

	if g.current_level_idx == 0 or g.current_level_idx == levels.size() - 1:
		show_start_screen()
	else:
		show_continue_screen()

func save_game():
	var save_game = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var save_nodes = [PlayerVariables, Globals]
	for node in save_nodes:

		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		var node_data = node.call("save")

		save_game.store_var(node_data)

func is_old_save(save_game: FileAccess):
	while save_game.get_position() < save_game.get_length():
		var data = save_game.get_var()

		for key in data.keys():
			if key == "version" and data[key] == Globals.VERSION_NUMBER:
				return false

	return true

func load_game():
	# v0.01 and v0.011 saves have no "version number"
	if not FileAccess.file_exists("user://savegame.save"):
		return

	var save_game = FileAccess.open("user://savegame.save", FileAccess.READ)

	# if is_old_save(save_game):
	# 	return

	while save_game.get_position() < save_game.get_length():
		var data = save_game.get_var()
		var singleton = get_node("/root/" + data["singleton_name"])

		if not singleton:
			push_error("No singleton found with name '%s'" % data["singleton_name"])
			return

		for key in data.keys():
			if key == "singleton_name":
				continue
			if key == "version":
				# Versioning logic goes here
				continue
			if key == "shop_stock":
				for item_name in data[key].keys():
					var saved_stock = data[key][item_name]
					if singleton.shop_inventory.has(item_name):
						singleton.shop_inventory[item_name].stock = saved_stock
				continue
			singleton.set(key, data[key])

func instance_current_level() -> Level:
	return levels[g.current_level_idx].instantiate() as Level

func start_level(level):
	save_game()

	g.current_level = level
	level.completed.connect(go_next_level)
	level.failed.connect(_on_level_failed, CONNECT_ONE_SHOT)
	add_child(level)

func show_shop():
	var shop: Shop = load("res://screens/shop.tscn").instantiate()
	shop.setup(func(): start_level(instance_current_level()))
	add_child(shop)

func go_next_level():
	if g.current_level_idx == levels.size() - 1:
		add_child(load("res://screens/win.tscn").instantiate())
		return

	# Save the level index
	# TODO: This is a crucial operation but its just kind of hidden here
	g.current_level_idx += 1
	save_game()

	show_shop()

func _on_level_failed(screenshot: Sprite2D) -> void:
	var game_over_screen = load("res://screens/game_over.tscn").instantiate()
	game_over_screen.add_level_screenshot(screenshot)

	game_over_screen.return_to_title_requested.connect(show_title_screen)
	game_over_screen.retry_requested.connect(func(): start_level(instance_current_level()))
	game_over_screen.shop_requested.connect(show_shop)

	add_child(game_over_screen)
