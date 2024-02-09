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
	load("res://scenes/levels/level_21.tscn"),
	load("res://scenes/levels/level_22.tscn"),
]

var g = Globals

func _ready() -> void:
	show_title_screen()

func show_title_screen():
	var dir = DirAccess.open("user://")
	if dir.file_exists("savegame.save"):
		var continue_screen = load("res://screens/continue.tscn").instantiate()
		add_child(continue_screen)
		continue_screen.continue_game.connect(
			func():
				continue_screen.queue_free()
				await continue_screen.tree_exited
				load_game()
				start_game()
		)

		continue_screen.new_game.connect(
			func():
				continue_screen.queue_free()
				await continue_screen.tree_exited
				Globals.reset()
				PlayerVariables.reset()
				start_game()
		)

		return

	var start_screen = load("res://screens/start.tscn").instantiate()
	add_child(start_screen)
	start_screen.start.connect(
		func():
			start_screen.queue_free()
			await start_screen.tree_exited
			start_game()
	)

func start_game():
	if Globals.in_shop:
		await show_shop()
	if is_instance_valid(g.current_level):
		g.current_level.queue_free()
		await g.current_level.tree_exited
	var level: Level = levels[g.current_level_idx].instantiate() as Level
	start_level(level)

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

	if is_old_save(save_game):
		return

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

func start_level(level):
	Globals.in_shop = false
	g.current_level = level
	save_game()
	level.completed.connect(go_next_level)
	level.failed.connect(_on_level_failed, CONNECT_ONE_SHOT)
	add_child(level)

func show_shop():
	var shop: Shop = load("res://screens/shop.tscn").instantiate()
	add_child(shop)

	await shop.continue_pressed

	shop.queue_free()
	await shop.tree_exited

	Globals.in_shop = false

func go_next_level():
	if is_instance_valid(g.current_level):
		g.current_level.queue_free()
		await g.current_level.tree_exited

	if g.current_level_idx == levels.size() - 1:
		# no more levels
		var dir = DirAccess.open("user://")
		# this doesn't actually work in release version
		dir.remove("savegame.save")

		add_child(load("res://screens/win.tscn").instantiate())
		return

	g.current_level_idx += 1


	Globals.in_shop = true
	# NOTE: we are saving here because the level was completed. But this isn't actually very clear.
	save_game()

	await show_shop()

	var level: Level = levels[g.current_level_idx].instantiate() as Level
	start_level(level)

func restart_level() -> void:
	var level: Level = levels[g.current_level_idx].instantiate() as Level
	start_level(level)

func _on_level_failed() -> void:
	var game_over_screen = load("res://screens/game_over.tscn").instantiate()

	var cleanup_game_over_screen = func():
		game_over_screen.queue_free()
		await game_over_screen.tree_exited
		g.current_level.queue_free()
		await g.current_level.tree_exited
		get_tree().paused = false

	game_over_screen.return_to_title_requested.connect(
		func():
			await cleanup_game_over_screen.call()
			show_title_screen()
	)
	game_over_screen.retry_requested.connect(
		func():
			await cleanup_game_over_screen.call()
			restart_level()
	)
	game_over_screen.shop_requested.connect(
		func():
			await cleanup_game_over_screen.call()
			await show_shop()
			restart_level()
	)

	add_child(game_over_screen)
	get_tree().paused = true

	game_over_screen.process_mode = PROCESS_MODE_ALWAYS
	game_over_screen.modulate.a = 0
	var tween = game_over_screen.create_tween()
	tween.tween_property(game_over_screen, "modulate:a", 1, 3.0)
