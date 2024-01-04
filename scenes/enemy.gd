class_name Enemy extends Area2D

const ENEMY_SIZE = Vector2(100, 100)

# Called when the node enters the scene tree for the first time.
func _ready():
	var sprite = get_node("Sprite2D")
	var collision = get_node("CollisionPolygon2D")
	var scaling = ENEMY_SIZE / sprite.texture.get_size()

	# if this is not true, the collision shape scaling will behave improperly
	assert(scaling.x == scaling.y)

	collision.scale = scaling
	sprite.scale = scaling

func _take_damage(_damage_amount: float) -> void:
	# for now just destroy the node
	queue_free()

func _on_area_entered(area):
	if area.has_method("damage") and\
	area.has_method("get_damage_source") and\
	area.get_damage_source() == "player":
		_take_damage(area.damage())
