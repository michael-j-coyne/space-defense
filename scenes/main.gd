extends Node2D

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
