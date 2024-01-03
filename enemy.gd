extends Area2D

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
