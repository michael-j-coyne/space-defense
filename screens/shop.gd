class_name Shop extends Sprite2D

var inventory = Globals.shop_inventory

signal continue_pressed

func _ready() -> void:
	populate_shop()
	$ContinueButton.grab_focus()

func has_item(item_name: String):
	return item_name in inventory

func get_item(item_name: String):
	return inventory[item_name]

func get_price(item_name):
	if has_item(item_name):
		var item = get_item(item_name)
		assert(item.max_stock >= item.stock)

		var price = item.base_price
		# Increase price as stock gets lower
		var price_multiplier = 1
		if item.price_multiplier:
			price_multiplier = item.price_multiplier

		price *= (1 + price_multiplier * (item.max_stock - item.stock))
		return price
	return 0

func can_purchase(item_name, currency):
	if has_item(item_name) and get_item(item_name).stock > 0 and currency >= get_price(item_name):
		return true
	return false

func purchase_item(item_name, currency):
	if can_purchase(item_name, currency):
		PlayerVariables.money -= get_price(item_name)
		get_item(item_name).stock -= 1

		# TODO: Add the item to the player's inventory here

		return true
	return false

func generate_item_buttons() -> Array[VBoxContainer]:
	var result: Array[VBoxContainer] = []

	for item_name in inventory.keys():
		var item = get_item(item_name)

		if item.stock < 1:
			continue

		var shop_item = load("res://scenes/components/shop_item_button.tscn").instantiate()
		var price = get_price(item_name)
		var btn = shop_item.get_button()

		btn.pressed.connect(func(): _on_ItemButton_pressed(item_name))

		# Disable and "grey out" item if out of stock
		if not can_purchase(item_name, PlayerVariables.money):
			btn.disabled = true
			btn.focus_mode = Control.FOCUS_NONE

		shop_item.set_item_name(item.display_text)
		shop_item.set_price(price)
		shop_item.set_description(item.description)
		result.append(shop_item)

	return result

func connect_focus(item_buttons: Array):
	var focusable_items = item_buttons.filter(func(i_btn): return not i_btn.get_button().disabled)

	if not focusable_items or focusable_items.size() == 0:
		$ContinueButton.focus_next = $ContinueButton.get_path()
		$ContinueButton.focus_previous = $ContinueButton.get_path()
		return

	for i in range(0, focusable_items.size() - 1):
		var item = focusable_items[i]
		var next_item = focusable_items[i + 1]
		item.get_button().focus_next = next_item.get_button().get_path()
		next_item.get_button().focus_previous = item.get_button().get_path()

	$ContinueButton.focus_next = focusable_items[0].get_button().get_path()
	$ContinueButton.focus_previous = focusable_items[-1].get_button().get_path()
	focusable_items[-1].get_button().focus_next = $ContinueButton.get_path()
	focusable_items[0].get_button().focus_previous = $ContinueButton.get_path()

func populate_shop():
	var shop_items := generate_item_buttons()
	shop_items.map(func(item): $GridContainer.add_child(item))
	connect_focus(shop_items)
	$ContinueButton.grab_focus()

func _on_ItemButton_pressed(item_name):
	var currency_amount = PlayerVariables.money
	if purchase_item(item_name, currency_amount):

		# TODO: Don't apply upgrade here.
		# Apply the upgrade
		get_item(item_name).apply_upgrade.call()

		# Update UI
		for node in $GridContainer.get_children():
			node.queue_free()
		populate_shop()

	else:
		print("Cannot purchase item.")

func _on_continue_pressed() -> void:
	continue_pressed.emit()
