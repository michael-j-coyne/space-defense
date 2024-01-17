extends Node2D

func _ready() -> void:
	new_game()

func new_game():
	Globals.reset()
	PlayerVariables.reset()
	add_child(Game.new())
