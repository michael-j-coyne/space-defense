extends Sprite2D

signal new_game_requested
signal retry_requested

var tween_time = 1.0

func _ready():
	button_flash()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		retry_requested.emit()

func _on_button_pressed() -> void:
	new_game_requested.emit()

func button_flash():
	button_fadeout()

func button_fadeout():
	var tween = $RichTextLabel2.create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property($RichTextLabel2, "modulate:a", 0, tween_time)
	tween.tween_callback(button_fadein)

func button_fadein():
	var tween = $RichTextLabel2.create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property($RichTextLabel2, "modulate:a", 1, tween_time)
	tween.tween_callback(button_fadeout)
