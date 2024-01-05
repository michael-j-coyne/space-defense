class_name PlayerState extends Node

var _player

func _init(player: Player):
	_player = player

func physics_process(_delta: float):
	pass

func take_damage(_damage_amount: float):
	pass

class InitialState:
	extends PlayerState

	func physics_process(delta: float) -> void:
		var velocity = Vector2.ZERO

		if Input.is_action_pressed("ui_right"):
			velocity.x += 1
		if Input.is_action_pressed("ui_left"):
			velocity.x -= 1
		if Input.is_action_pressed("ui_accept"):
			# TODO: remove hardcoded velocity func
			var velocity_func = func(_delta): return Vector2(0, -10)
			_player.weapon.fire(velocity_func, "player")

		if velocity.length() > 0:
			velocity = velocity.normalized() * _player.speed

		_player.position += velocity * delta

	func take_damage(_damage_amount: float) -> void:
		# for now just destroy the node
		queue_free()

class FreeState:
	extends PlayerState

	func physics_process(delta: float) -> void:
		var velocity = Vector2.ZERO

		if Input.is_action_pressed("ui_right"):
			velocity.x += 1
		if Input.is_action_pressed("ui_left"):
			velocity.x -= 1
		if Input.is_action_pressed("ui_up"):
			velocity.y -= 1
		if Input.is_action_pressed("ui_down"):
			velocity.y += 1
		if Input.is_action_pressed("rotate_left"):
			_player.rotation -= 1 * delta
		if Input.is_action_pressed("rotate_right"):
			_player.rotation += 1 * delta
		if Input.is_action_pressed("ui_accept"):
			# TODO: remove hardcoded velocity func
			var velocity_func = func(_delta): return Vector2(0, -10).rotated(_player.rotation)
			_player.weapon.fire(velocity_func, "player")

		if velocity.length() > 0:
			velocity = velocity.normalized() * _player.speed

		velocity = velocity.rotated(_player.rotation)

		_player.position += velocity * delta
