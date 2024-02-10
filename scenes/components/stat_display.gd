extends Node2D

@export var attack_speed_val: Label
@export var move_speed_val: Label



var gun_cooldown: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not PlayerVariables:
		return

	if PlayerVariables.gun_cooldown:
		attack_speed_val.text = "%.2f shots / sec" % (1.0 / PlayerVariables.gun_cooldown)
		gun_cooldown = PlayerVariables.gun_cooldown

func stat_upgrade_effect(difference, target):
	var l = Label.new()
	#l.text = "%.2f" % difference
	l.text = "AAAAAAAAAAAAAAAAAAAA"
	#var g_pos = Vector2(0, 0)

	#print("size is ", size.x)
	#g_pos.x = $StatDisplay.global_position.x + $StatDisplay.size.x
	#g_pos.y = target.global_position.y

	#print("g pos is ", g_pos)

	#l.global_position = g_pos
	#l.position = Vector2(0, 500)
	#print("l.global = ", l.global_position)
	l.position = target.position
	l.position.x += $StatDisplay.size.x / 2
	add_child(l)

func _on_shop_item_purchased(item: ShopItem):
	if item.name == "attack_speed_upgrade":
		var difference = (1.0 / PlayerVariables.gun_cooldown) - (1.0 / gun_cooldown)
		gun_cooldown = PlayerVariables.gun_cooldown
		attack_speed_val.text = "%.2f shots / sec" % (1.0 / PlayerVariables.gun_cooldown)
		# TODO: make sure rounding is the same so that
		# the increase in the value matches the printed difference
		stat_upgrade_effect(difference, attack_speed_val)
		stat_upgrade_effect(difference, move_speed_val)
