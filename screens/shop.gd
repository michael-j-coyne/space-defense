class_name Shop extends Sprite2D

var inventory = Globals.shop_inventory

signal continue_pressed

func _ready() -> void:
	populate_shop()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		continue_pressed.emit()

func get_price(item_name):
	if item_name in inventory:
		var item = inventory[item_name]
		# Fail early!
		assert(item["max_stock"] >= item["stock"])

		var price = item["base_price"]
		# Increase price as stock gets lower
		# NOTE: we probably want to extract the function that calculates item price
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
		PlayerVariables.money -= get_price(item_name)
		inventory[item_name]["stock"] -= 1

		return true
	return false

func populate_shop():
	for item_name in inventory.keys():
		var item = inventory[item_name]
		var item_button := Button.new()
		var price = get_price(item_name)

		var button_text = "{display_text} - ${price}".format(
			{
				"display_text": item["display_text"],
			 	"price": str(price)
			}
		)

		item_button.text = button_text


		item_button.pressed.connect(func(): _on_ItemButton_pressed(item_name))
		# NOTE: magic number for font size here, but its probably fine.
		item_button.add_theme_font_size_override("font_size", 35)
		item_button.alignment = HORIZONTAL_ALIGNMENT_LEFT

		# Disable and "grey out" item if out of stock
		if item["stock"] < 1:
			item_button.disabled = true

		var description = RichTextLabel.new()
		description.text = item["description"]
		description.text += " | Stock: " + str(item["stock"])

		description.fit_content = true
		description.custom_minimum_size=Vector2(400, 0)
		description.add_theme_font_size_override("normal_font_size", 20)

		var container = VBoxContainer.new()
		container.add_child(item_button)
		container.add_child(description)

		$GridContainer.add_child(container)

func _on_ItemButton_pressed(item_name):
	var currency_amount = PlayerVariables.money
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
