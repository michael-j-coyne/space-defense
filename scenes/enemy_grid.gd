class_name EnemyGrid extends Node2D

const enemy_scene = preload("res://scenes/Enemy.tscn")
const ENEMY_SIZE = Enemy.ENEMY_SIZE
@export var NUM_ENEMIES = Vector2i(8, 4)
var NUM_GAPS = Vector2i(NUM_ENEMIES.x - 1, NUM_ENEMIES.y - 1)
const GAP_SIZE = ENEMY_SIZE / Vector2(2, 4)
var ENEMY_GROUP_SIZE = Vector2(
	ENEMY_SIZE.x * NUM_ENEMIES.x + GAP_SIZE.x * NUM_GAPS.x,
	ENEMY_SIZE.y * NUM_ENEMIES.y + GAP_SIZE.y * NUM_GAPS.y)
@export var FIRE_CHANCE = 0.04
@export var INITIAL_POSITION = Vector2(350, 0)
@export var INITIAL_VELOCITY = Vector2(-100, 0)

@onready var SCREEN_SIZE = get_tree().root.content_scale_size
var velocity = INITIAL_VELOCITY
var rng = RandomNumberGenerator.new()

signal all_enemies_defeated
signal enemy_killed(enemy_info: Shooter.EnemyInfo)

func _ready() -> void:
	position = INITIAL_POSITION
	spawn_enemies()

static func _enemy_position(row_idx: int, col_idx: int) -> Vector2:
	var pos_x = 0.5 * ENEMY_SIZE.x + col_idx * (ENEMY_SIZE.x + GAP_SIZE.x)
	var pos_y = 0.5 * ENEMY_SIZE.y + row_idx * (ENEMY_SIZE.y + GAP_SIZE.y)

	return Vector2(pos_x, pos_y)

func spawn_enemies() -> void:
	for row_idx in range(NUM_ENEMIES.y):
		for col_idx in range(NUM_ENEMIES.x):
			var enemy = enemy_scene.instantiate()
			enemy.set_position(EnemyGrid._enemy_position(row_idx, col_idx))
			enemy.killed.connect(_on_enemy_killed)
			$Enemies.add_child(enemy)

func _on_enemy_killed(enemy_info: Shooter.EnemyInfo) -> void:
	enemy_killed.emit(enemy_info)

func _fire_randomly():
	for enemy in $Enemies.get_children():
		if rng.randf() < FIRE_CHANCE:
			enemy.fire_weapon()

func _physics_process(delta: float) -> void:
	if position.x < 0:
		velocity.x *= -1
		position.x = 0
		position.y += ENEMY_SIZE.y
	elif position.x + ENEMY_GROUP_SIZE.x > SCREEN_SIZE.x:
		velocity.x *= -1
		position.x = SCREEN_SIZE.x - ENEMY_GROUP_SIZE.x
		position.y += ENEMY_SIZE.y

	position += velocity * delta

	if $Enemies.get_child_count() == 0:
		all_enemies_defeated.emit()
