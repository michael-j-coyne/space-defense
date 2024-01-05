class_name Main extends Node

@onready var enemy_spawn: EnemyGrid = get_node("EnemyGrid") as EnemyGrid

func _ready() -> void:
	enemy_spawn.spawn_enemies()

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_released("ui_text_backspace"):
		$TransitionCamera.pan_to_camera($InitialCamera, get_node("Player/Camera2D"), 2.0)
