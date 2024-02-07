extends Control

@export var move_left_prompt: Panel
@export var move_right_prompt: Panel
@export var shoot_prompt: Panel
var waiting_for_left_input = false
var waiting_for_right_input = false
var waiting_for_shoot_input = false

var delay := 0.25

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show_move_left_prompt()

func show_move_left_prompt():
	get_tree().paused = true
	move_left_prompt.show()
	waiting_for_left_input = true

func show_move_right_prompt():
	get_tree().paused = true
	move_right_prompt.show()
	waiting_for_right_input = true

func show_shoot_prompt():
	get_tree().paused = true
	shoot_prompt.show()
	waiting_for_shoot_input = true

func _input(event):
	if event.is_action_pressed("ui_left") and waiting_for_left_input:
		move_left_prompt.hide()
		get_tree().paused = false
		waiting_for_left_input = false
		get_tree().create_timer(delay).timeout.connect(show_move_right_prompt)
	elif event.is_action_pressed("ui_right") and waiting_for_right_input:
		move_right_prompt.hide()
		get_tree().paused = false
		waiting_for_right_input = false
		get_tree().create_timer(delay).timeout.connect(show_shoot_prompt)
	elif event.is_action_pressed("shoot") and waiting_for_shoot_input:
		shoot_prompt.hide()
		get_tree().paused = false
		waiting_for_shoot_input = false
		queue_free()
