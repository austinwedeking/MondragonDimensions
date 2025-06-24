class_name Inventory extends Node

@onready var inventory_button : Button = %InventoryButton

var manager : GameManager
var owned_cards : Array[Card]
var open_inv := true

func add_to_inventory(card : Card) -> void:
	owned_cards.push_back(card.duplicate())

func toggle_inventory() -> void:
	if open_inv:
		inventory_button.text = "Close Inventory"
		manager.pull_button.visible = false
		open_inv = !open_inv
		show_cards()
	else:
		inventory_button.text = "Inventory"
		manager.pull_button.visible = true
		open_inv = !open_inv
		hide_cards()

func show_cards() -> void:
	for c in owned_cards:
		get_tree().root.add_child(c)

func hide_cards() -> void:
	for c in owned_cards:
		get_tree().root.remove_child(c)
