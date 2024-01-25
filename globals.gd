extends Node

var current_level: Level
var shop_inventory

func _ready():
	reset()

func reset():
	shop_inventory = {
		"attack_speed_upgrade": {
			"display_text": "Attack speed +50%",
			"description": "Shoot faster. Who can hate that?",
			"base_price": 300,
			"stock": 2,
			"max_stock": 2,
			"price_multiplier": 5,
			"apply_upgrade": func(): PlayerVariables.gun_cooldown *= .5
		},
		"movement_speed_upgrade": {
			"display_text": "Movement Speed +50%",
			"description": "\"Gotta go fast!\"",
			"base_price": 300,
			"stock": 2,
			"max_stock": 2,
			"price_multiplier": 5,
			"apply_upgrade": func(): PlayerVariables.speed *= 1.5
		},
		"piercing_shot_upgrade": {
			"display_text": "Piercing shots +1",
			"description": "Destroy two ships with one laser!",
			"base_price": 300,
			"stock": 3,
			"max_stock": 3,
			"apply_upgrade": func(): PlayerVariables.gun_penetrations += 1
		},
		"gatling_gun_upgrade": {
			"display_text": "Gatling Gun",
			"description": "Now that's just plain fun.",
			"base_price": 2000,
			"stock": 1,
			"max_stock": 1,
			"apply_upgrade": func(): PlayerVariables.has_gatling_gun = true
		},
	}

	current_level = null
