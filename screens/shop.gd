class_name Shop extends Sprite2D

var inventory = Globals.shop_inventory

signal continue_pressed

func _ready() -> void:
	populate_shop()
	$Button.grab_focus()

func get_price(item_name):
	if item_name in inventory:
		var item = inventory[item_name]
		# Fail early!
		assert(item.max_stock >= item.stock)

		var price = item.base_price
		# Increase price as stock gets lower
		# NOTE: we probably want to extract the function that calculates item price
		var price_multiplier = 1
		if item.price_multiplier:
			price_multiplier = item.price_multiplier

		price *= (1 + price_multiplier * (item.max_stock - item.stock))
		return price
	return 0

func can_purchase(item_name, currency):
	# We should grey-out items that we cannot purchase
	if item_name in inventory and inventory[item_name].stock > 0 and currency >= get_price(item_name):
		return true
	return false

# NOTE: perhaps this should return the purchased item
func purchase_item(item_name, currency):
	if can_purchase(item_name, currency):
		PlayerVariables.money -= get_price(item_name)
		inventory[item_name].stock -= 1

		return true
	return false

# extract loop into its own function
# return a list of shop buttons from that func

# in populate_shop, add each button from the list to the grid

func generate_item_buttons() -> Array[VBoxContainer]:
	var result: Array[VBoxContainer] = []

	for item_name in inventory.keys():
		var item = inventory[item_name]

		if item.stock < 1:
			continue

		var shop_item = load("res://scenes/components/shop_item_button.tscn").instantiate()
		var price = get_price(item_name)

		shop_item.get_button().pressed.connect(func(): _on_ItemButton_pressed(item_name))

		# Disable and "grey out" item if out of stock
		if not can_purchase(item_name, PlayerVariables.money):
			shop_item.get_button().disabled = true
			shop_item.get_button().focus_mode = Control.FOCUS_NONE

		shop_item.set_item_name(item.display_text)
		shop_item.set_price(price)
		shop_item.set_description(item.description)
		result.append(shop_item)

	return result

func populate_shop():
	var shop_items := generate_item_buttons()
	shop_items.map(func(item): $GridContainer.add_child(item))

func _on_ItemButton_pressed(item_name):
	var currency_amount = PlayerVariables.money
	if purchase_item(item_name, currency_amount):

		# Apply the upgrade
		inventory[item_name].apply_upgrade.call()

		# Update UI
		for node in $GridContainer.get_children():
			node.queue_free()
		populate_shop()

	else:
		print("Cannot purchase item.")

func _on_continue_pressed() -> void:
	continue_pressed.emit()
