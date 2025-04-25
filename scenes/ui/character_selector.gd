class_name CharacterSelector
extends Control

const RUN_SCENE = preload("res://scenes/run/run.tscn")
const ASSASSIN_STATS := preload("res://characters/assassin/assassin.tres")
const WARRIOR_STATS := preload("res://characters/warrior/warrior.tres")
const WIZARD_STATS := preload("res://characters/wizard/wizard.tres")
const BATTLE := preload("res://scenes/battle/battle.tscn")

@export var run_startup: RunStartup

@onready var title: Label = %Title
@onready var description: Label = %Description
@onready var character_portrait: TextureRect = %CharacterPortrait

var current_char: CharacterStats: set = set_current_character

func _ready() -> void:
	set_current_character(WARRIOR_STATS)


func set_current_character(new_char: CharacterStats) -> void:
	current_char = new_char 
	title.text = current_char.character_name
	description.text = current_char.description
	character_portrait.texture = current_char.portrait
	

func _on_start_button_pressed():
	run_startup.type = RunStartup.Type.NEW_RUN
	run_startup.picked_character = current_char
	get_tree().change_scene_to_packed(RUN_SCENE)

func _on_warrior_button_pressed() -> void:
	current_char = WARRIOR_STATS


func _on_wizard_button_pressed() -> void:
	current_char = WIZARD_STATS


func _on_assassin_button_pressed() -> void:
	current_char = ASSASSIN_STATS
