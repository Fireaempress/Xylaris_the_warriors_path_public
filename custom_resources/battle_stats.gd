class_name BattleStats
extends Resource

@export_range(0,5) var battle_lvl: int
@export var stick_reward_min: int
@export var stick_reward_max: int
@export var enemies: PackedScene

var sticks_reward: int 

	

func roll_stick_reward() -> void:
	sticks_reward = randf_range(stick_reward_min,stick_reward_max)
