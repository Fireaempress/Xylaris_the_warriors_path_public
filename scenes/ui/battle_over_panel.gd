class_name BattleOverPanel
extends Panel

enum Type {WIN, LOSE}

@onready var label: Label = %Label
@onready var continue_button: Button = %ContinueButton
@onready var restart_button: Button = %RestartButton
const MAIN_MENU = preload("res://scenes/ui/main_menu.tscn")

func _ready() -> void:
	continue_button.pressed.connect(func(): Events.battle_won.emit())
	#restart_button.pressed.connect(get_tree().reload_current_scene)
	restart_button.pressed.connect(get_tree().change_scene_to_packed.bind(MAIN_MENU))
	#kajawashere
	Events.battle_over_screen_requested.connect(show_screen)


func show_screen(text: String, type: Type) -> void:
	label.text = text
	continue_button.visible = type == Type.WIN
	restart_button.visible = type == Type.LOSE
	show()
	get_tree().paused = true
