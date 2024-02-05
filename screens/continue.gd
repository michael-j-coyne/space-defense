extends TextureRect

signal new_game
signal continue_game

var tween_time = 1.0

func _ready():
	$ContinueButton.grab_focus()

#func _process(_delta):
	#if Input.is_action_just_pressed("ui_accept"):
		#if not $ConfirmationDialog.visible:
			#continue_game.emit()

func _on_new_game_pressed() -> void:
	$ConfirmationDialog.visible = true
	$ConfirmationDialog.confirmed.connect(func(): new_game.emit())

func _on_continue_pressed() -> void:
	continue_game.emit()


func _on_new_game_button_mouse_entered() -> void:
	$NewGameButton.grab_focus()



func _on_continue_button_mouse_entered() -> void:
	$ContinueButton.grab_focus()
