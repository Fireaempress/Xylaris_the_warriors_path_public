class_name Campfire
extends Control


func _on_button_pressed() -> void:
	Events.campfire_exited.emit()

func healing()-> void:
	Events.healing.emit()

@onready var pay: Button = $Pay



func _ready() -> void:
	pay.text = "Pay and heal yourself"
	

