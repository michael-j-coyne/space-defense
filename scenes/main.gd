class_name Main extends Node2D

func _ready() -> void:
	new_game()

func new_game():

	var game = Game.new()
	game.new_game_requested.connect(
		func():
			game.queue_free()
			await game.tree_exited
			Globals.reset()
			PlayerVariables.reset()
			new_game()
	)
	add_child(game)

func _process(_delta):
	if OS.is_debug_build():
		if Input.is_action_just_pressed("ui_focus_next"):
			Engine.time_scale *= 2
		if Input.is_action_just_pressed("ui_cancel"):
			Engine.time_scale *= 0.5
		if Input.is_action_just_pressed("add_money"):
			PlayerVariables.money += 1000
