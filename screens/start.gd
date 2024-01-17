extends Sprite2D

signal start

func _process(_delta):
	# Check if the space key is pressed.
	if Input.is_action_just_pressed("ui_accept"):
		start.emit()

func _on_button_pressed() -> void:
	start.emit()
