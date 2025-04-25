class_name SticksUI
extends HBoxContainer

@onready var icon: TextureRect = $Icon
@onready var label: Label = $Label
@export var run_stats: RunStats : set = set_run_stats

func _ready() -> void:
	label.text = "0"
	
func set_run_stats(new_value: RunStats) -> void:
	run_stats = new_value
	
	if not run_stats.sticks_changed.is_connected(_update_sticks):
		run_stats.sticks_changed.connect(_update_sticks)
		_update_sticks()


func _update_sticks() -> void:
	label.text = str(run_stats.sticks)
