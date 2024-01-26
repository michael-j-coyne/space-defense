extends Sprite2D

signal start

var tween_time = 1.0

func _ready():
	NodeFlasher.node_flash($StartButton, tween_time)

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		start.emit()

func _on_button_pressed() -> void:
	start.emit()
