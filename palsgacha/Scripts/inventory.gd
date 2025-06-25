class_name Inventory extends Node

@onready var inventory_button : Button = %InventoryButton
@onready var next_page_button : Button = %NextPageButton
@onready var prev_page_button : Button = %PreviousPageButton
@onready var page_counter_label : Label = %PageCounter
@onready var card_spawns : Control = %CardSpawnPoints

var manager : GameManager
var owned_cards : Array[Card]
var spawn_points : Array[Control]
var open_inv := true
var starting_inv_position : int = 0
var num_pages : float = 0.0
var current_page : int = 1

func _ready() -> void:
	for spawn in card_spawns.get_children():
		spawn_points.push_back(spawn)

func add_to_inventory(card : Card) -> void:
	owned_cards.push_back(card.duplicate())

func toggle_inventory() -> void:
	if open_inv:
		inventory_button.text = "Close Inventory"
		manager.pull_button.visible = false
		next_page_button.visible = true
		page_counter_label.visible = true
		open_inv = !open_inv
		
		num_pages = ceil(owned_cards.size() / 10.0)
		page_counter_label.text = str(current_page) + "/" + str(int(num_pages))
		
		show_cards()
	else:
		inventory_button.text = "Inventory"
		manager.pull_button.visible = true
		next_page_button.visible = false
		prev_page_button.visible = false
		page_counter_label.visible = false
		open_inv = !open_inv
		starting_inv_position = 0
		current_page = 1
		
		hide_cards()

func show_cards() -> void:
	for i in range(starting_inv_position, starting_inv_position + 10):
		if i < owned_cards.size():
			get_tree().root.add_child(owned_cards[i])
			owned_cards[i].scale = Vector2(0.75, 0.75)
			owned_cards[i].position = spawn_points[i % 10].position
			owned_cards[i].position -= owned_cards[i].size / 2
	
	if current_page == num_pages:
		next_page_button.visible = false
	if owned_cards.size() == 0:
		next_page_button.visible = false
		page_counter_label.visible = false

func hide_cards() -> void:
	for c in owned_cards:
		if c.is_inside_tree():
			get_tree().root.remove_child(c)

func next_page() -> void:
	hide_cards()
	
	starting_inv_position += 10
	current_page += 1
	page_counter_label.text = str(current_page) + "/" + str(int(num_pages))
	
	if current_page == num_pages:
		next_page_button.visible = false
	if not prev_page_button.visible:
		prev_page_button.visible = true
	
	show_cards()

func prev_page() -> void:
	hide_cards()
	
	starting_inv_position -= 10
	current_page -= 1
	page_counter_label.text = str(current_page) + "/" + str(int(num_pages))
	
	if current_page == 1:
		prev_page_button.visible = false
	if not next_page_button.visible:
		next_page_button.visible = true
	
	show_cards()
