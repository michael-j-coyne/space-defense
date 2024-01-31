extends RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = "Level " + str(Globals.current_level_idx + 1)
