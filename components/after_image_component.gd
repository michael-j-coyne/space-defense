class_name AfterImageComponent extends Node2D

## The time between afterimage creation
@export var frequency := 0.5

## How long it takes the afterimage to fade out completely
@export var fadeout_time := 0.125

## The sprite to create an afterimage of
@export var sprite: Sprite2D

func _ready():
	$Timer.wait_time = frequency
	$Timer.connect("timeout", create_afterimage)
	$Timer.start()

func create_afterimage():
	var afterimage = AfterImage.new(
		sprite.duplicate(),
		get_parent().global_position,
		get_parent().scale,
		fadeout_time
	)

	if Globals.current_level:
		Globals.current_level.add_child(afterimage)
	else:
		get_node("/root").add_child(afterimage)
