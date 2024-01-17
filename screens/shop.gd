class_name Shop extends Sprite2D

var inventory = Globals.shop_inventory

signal continue_pressed

func _ready() -> void:
	populate_shop()

func get_price(item_name):
	if item_name in inventory:
		var item = inventory[item_name]
		# Fail early!
		assert(item["max_stock"] >= item["stock"])

		var price = item["base_price"]
		# Increase price as stock gets lower
		price *= (1 + (item["max_stock"] - item["stock"]))
		return price
	return 0

func can_purchase(item_name, currency):
	# We should grey-out items that we cannot purchase
	if item_name in inventory and inventory[item_name]["stock"] > 0 and currency >= get_price(item_name):
		return true
	return false

# NOTE: perhaps this should return the purchased item
func purchase_item(item_name, currency):
	if can_purchase(item_name, currency):
		currency -= get_price(item_name)
		inventory[item_name]["stock"] -= 1

		return true
	return false

func populate_shop():
	for item in inventory.keys():
		var item_button := Button.new()
		var price = get_price(item)
		item_button.text =  \
			inventory[item]["display_text"] \
			+ " - Price: $" + str(price) \
			+ " Stock: " + str(inventory[item]["stock"])
		item_button.pressed.connect(func(): _on_ItemButton_pressed(item)  )
		item_button.add_theme_font_size_override("font_size", 35)
		$GridContainer.add_child(item_button)

func _on_ItemButton_pressed(item_name):
	# TODO: actually use currency
	var currency_amount = 10000
	if purchase_item(item_name, currency_amount):

		# Apply the upgrade
		inventory[item_name]["apply_upgrade"].call()

		# Update UI
		for node in $GridContainer.get_children():
			node.queue_free()
		populate_shop()
	else:
		print("Cannot purchase item.")

func _on_continue_pressed() -> void:
	continue_pressed.emit()
