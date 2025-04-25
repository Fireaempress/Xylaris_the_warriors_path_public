class_name Map
extends Node2D


@onready var one: Button = %One
@onready var two:Button = %Two
@onready var three: Button = %Three
@onready var campfire:Button = %Campfire
@onready var four:Button = %Four
@onready var five:Button = %Five




var map_data: Array[Array]
var stages_climbed: int


func show_map() -> void:
	show()
	

func hide_map() -> void:
	hide()


func _on_one_pressed():
	Events.stage1_entered.emit()
	one.disabled = true
	two.disabled = false

func _on_two_pressed():
	Events.stage2_entered.emit()
	three.disabled = false
	campfire.disabled = false
	two.disabled = true

func _on_campfire_pressed():
	Events.campfire_entered.emit()

func _on_three_pressed():
	Events.stage3_entered.emit()
	four.disabled = false
	three.disabled = true

func _on_four_pressed():
	Events.stage4_entered.emit()
	five.disabled = false
	four.disabled = true

func _on_five_pressed():
	Events.stage5_entered.emit()
