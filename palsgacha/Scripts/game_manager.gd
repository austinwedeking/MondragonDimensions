class_name GameManager extends Node

@export var card : PackedScene

@onready var pull_button : Button = %PullButton
@onready var inventory : Inventory = %Inventory

var card_inst : Card
var timer : Timer

func _ready() -> void:
	inventory.manager = self

func pull() -> void:
	pull_button.visible = false
	inventory.inventory_button.visible = false
	card_inst = card.instantiate()
	
	var rand_rarity = randi_range(0, Util.all_cards.size() - 1)
	print(rand_rarity)
	var result_rarity : Array = Util.all_cards[rand_rarity]
	print(result_rarity)
	var rand_card = randi_range(0, result_rarity.size() - 1)
	print(rand_card)
	var result_card : Dictionary
	
	match rand_rarity:
		0:
			result_card = Util.one_star[rand_card]
		1:
			result_card = Util.two_star[rand_card]
		2:
			result_card = Util.three_star[rand_card]
		3:
			result_card = Util.four_star[rand_card]
		4:
			result_card = Util.five_star[rand_card]
	
	if card_inst != null:
		add_child(card_inst)
		
		card_inst.image.texture = result_card.values().front()
		card_inst.card_name.text = str(result_card.keys().front())
		card_inst.rarity.text = str(rand_rarity + 1)
		
		inventory.add_to_inventory(card_inst)
	
	timer = Timer.new()
	timer.timeout.connect(despawn_card)
	timer.autostart = false
	add_child(timer)
	timer.start(3.0)

func despawn_card() -> void:
	if card_inst != null:
		card_inst.queue_free()
	
	if timer != null:
		timer.queue_free()
	
	pull_button.visible = true
	inventory.inventory_button.visible = true
