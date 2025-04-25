class_name RunStats
extends Resource

signal sticks_changed

const BASE_CARD_REWARDS := 3
const BASE_COMMON_WEIGHT := 6.0
const BASE_RARE_WEIGHT := 3.7
const BASE_SUBLIME_WEIGHT := 0.3

@export_group("Rewards")
@export var card_rewards = BASE_CARD_REWARDS
@export_range(0, 10) var common_weight := BASE_COMMON_WEIGHT
@export_range(0, 10) var rare_weight := BASE_RARE_WEIGHT
@export_range(0, 10) var sublime_weight := BASE_SUBLIME_WEIGHT
@export var sticks := 0: set = set_sticks

func reset_weights() -> void:
	common_weight = BASE_COMMON_WEIGHT
	rare_weight = BASE_RARE_WEIGHT
	sublime_weight = BASE_SUBLIME_WEIGHT
#weight se zvetsi pokud ji nedostanu
#kdyz ji dostanu tak musim reset

func set_sticks(new_amount: int) -> void:
	sticks = new_amount
	sticks_changed.emit()
