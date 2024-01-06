class_name Main extends Node
const enemy_grid_scene = preload("res://scenes/enemy_grid.tscn")
const TIME_BETWEEN_ROUNDS = 3.0

var enemy_grid: EnemyGrid

func _ready() -> void:
	create_enemy_grid()

func create_enemy_grid():
	enemy_grid = enemy_grid_scene.instantiate()
	enemy_grid.all_enemies_defeated.connect(_on_enemy_grid_all_enemies_defeated)
	add_child(enemy_grid)

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_released("ui_text_backspace"):
		$TransitionCamera.pan_to_camera($InitialCamera, get_node("Player/Camera2D"), 2.0)
		$Player.change_state("free")

func _on_enemy_grid_all_enemies_defeated() -> void:
	enemy_grid.queue_free()
	await get_tree().create_timer(TIME_BETWEEN_ROUNDS).timeout
	create_enemy_grid()
