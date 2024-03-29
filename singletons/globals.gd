extends Node

var current_level_idx: int
var current_level: Level
var shop_inventory
const VERSION_NUMBER = "v0.101"

func _ready():
	reset()

func reset():
	var attack_speed_upgrade = ShopItem.new()
	attack_speed_upgrade.display_text = "Attack speed +10%"
	attack_speed_upgrade.description = "Shoot faster. Who can hate that?"
	attack_speed_upgrade.base_price = 100
	attack_speed_upgrade.stock = 3
	attack_speed_upgrade.max_stock = 3
	attack_speed_upgrade.price_multiplier = 1.5
	attack_speed_upgrade.apply_upgrade = func(): PlayerVariables.gun_cooldown *= .9

	var movement_speed_upgrade = ShopItem.new()
	movement_speed_upgrade.display_text = "Movement speed +20%"
	movement_speed_upgrade.description = "Gotta go fast!"
	movement_speed_upgrade.base_price = 100
	movement_speed_upgrade.stock = 2
	movement_speed_upgrade.max_stock = 2
	movement_speed_upgrade.price_multiplier = 1.5
	movement_speed_upgrade.apply_upgrade = func(): PlayerVariables.speed *= 1.20

	var piercing_shot_upgrade = ShopItem.new()
	piercing_shot_upgrade.display_text = "Piercing shots +1"
	piercing_shot_upgrade.description = "Destroy two ships with one laser!"
	piercing_shot_upgrade.base_price = 100
	piercing_shot_upgrade.stock = 1
	piercing_shot_upgrade.max_stock = 1
	piercing_shot_upgrade.price_multiplier = 5
	piercing_shot_upgrade.apply_upgrade = func(): PlayerVariables.gun_penetrations += 1

	# var gatling_gun_upgrade = ShopItem.new()
	# gatling_gun_upgrade.display_text = "Gatling Gun"
	# gatling_gun_upgrade.description = "Now that's just plain fun."
	# gatling_gun_upgrade.base_price = 2000
	# gatling_gun_upgrade.stock = 1
	# gatling_gun_upgrade.max_stock = 1
	# gatling_gun_upgrade.price_multiplier = 10
	# gatling_gun_upgrade.apply_upgrade = func(): PlayerVariables.has_gatling_gun = true

	shop_inventory = {
		"attack_speed_upgrade": attack_speed_upgrade,
		"movement_speed_upgrade": movement_speed_upgrade,
		# "piercing_shot_upgrade": piercing_shot_upgrade,
		# "gatling_gun_upgrade": gatling_gun_upgrade,
	}

	if is_instance_valid(current_level):
		current_level.queue_free()
	current_level = null
	current_level_idx = 0

func save():
	var save_data = {
		"singleton_name": "Globals",
		"current_level_idx": current_level_idx,
		"shop_stock": {
			"attack_speed_upgrade": shop_inventory["attack_speed_upgrade"].stock,
			"movement_speed_upgrade": shop_inventory["movement_speed_upgrade"].stock,
			#"piercing_shot_upgrade": shop_inventory["piercing_shot_upgrade"].stock,
			# "gatling_gun_upgrade": gatling_gun_upgrade.stock,
		},
		"version": VERSION_NUMBER,
	}

	return save_data
