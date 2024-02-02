class_name AfterImage extends Node2D

var sprite: Sprite2D
var fadeout_time: float

# The client needs to set the sprite and scale and choose a parent
# for this node. Also needs to choose how long until the sprite fades out.

func _init(sprite: Sprite2D, pos: Vector2, sprite_scale, fadeout_time: float) -> void:
	self.sprite = sprite
	self.position = pos
	self.fadeout_time = fadeout_time
	self.scale = sprite_scale

func _ready() -> void:
	add_child(sprite)

	sprite.modulate = Color(1, 1, 1, 0.5) # Set half transparency

	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(sprite, "modulate", Color(1, 1, 1, 0), fadeout_time)
	tween.finished.connect(func(): queue_free())
