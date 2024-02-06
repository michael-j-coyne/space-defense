extends ConfirmationDialog

func _ready() -> void:
	var label = get_label()
	var cancel = get_cancel_button()
	var ok = get_ok_button()

	label.add_theme_font_size_override("font_size", 30)
	cancel.add_theme_font_size_override("font_size", 30)
	ok.add_theme_font_size_override("font_size", 30)
