extends Sprite2D

signal start

var tween_time = 1.0

func _ready():
	button_flash()

func _process(_delta):
	# Check if the space key is pressed.
	if Input.is_action_just_pressed("ui_accept"):
		start.emit()

func button_flash():
	button_fadeout()

func button_fadeout():
	var tween = $Button.create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property($Button, "modulate:a", 0, tween_time)
	tween.tween_callback(button_fadein)

func button_fadein():
	var tween = $Button.create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property($Button, "modulate:a", 1, tween_time)
	tween.tween_callback(button_fadeout)

func _on_button_pressed() -> void:
	start.emit()
