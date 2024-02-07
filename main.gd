class_name Main extends Node2D

func _ready() -> void:
	var game = Game.new()
	add_child(game)

func _process(_delta):
	if OS.is_debug_build():
		# F1
		if Input.is_action_just_pressed("add_money"):
			PlayerVariables.money += 500
	#if Input.is_action_just_pressed("ui_focus_next"):
	#Engine.time_scale *= 2
	#if Input.is_action_just_pressed("ui_cancel"):
	#Engine.time_scale *= 0.5

