extends Sprite2D

signal start

var tween_time = 1.0
@export var start_button: Button

func _ready():
	start_button.grab_focus()
	NodeFlasher.node_flash(start_button, tween_time)

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		start.emit()

func _on_button_pressed() -> void:
	start.emit()
	queue_free()
