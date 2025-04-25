class_name Battle
extends Node2D

@export var battle_stats: BattleStats
@export var char_stats: CharacterStats


@onready var battle_ui: BattleUI = $BattleUI
@onready var player_handler: PlayerHandler = $PlayerHandler 
@onready var player: Player = $Player 
@onready var enemy_handler: EnemyHandler = $EnemyHandler

#var warrior: CharacterStats = preload("res://characters/warrior/warrior.tres")
func _ready() -> void:
	#debug placeholder
		#var new_stats: CharacterStats = char_stats.create_instance()
		#battle_ui.char_stats = new_stats
		#player.stats = new_stats
		#start_battle(new_stats)
		#battle_ui.initialize_card_pile_ui()
	
	
	enemy_handler.child_order_changed.connect(_on_enemies_child_order_changed)
	Events.enemy_turn_ended.connect(_on_enemy_turn_ended)
	
	
	Events.player_turn_ended.connect(player_handler.end_turn)
	Events.player_hand_discarded.connect(enemy_handler.start_turn)
	Events.player_died.connect(_on_player_died)
	
	

func start_battle() -> void:
	get_tree().paused = false
	
	battle_ui.char_stats = char_stats
	player.stats = char_stats
	enemy_handler.setup_enemies(battle_stats)
	enemy_handler.reset_enemy_actions()
	
	player_handler.start_battle(char_stats)
	battle_ui.initialize_card_pile_ui()
	

func _on_enemy_turn_ended() -> void:
	player_handler.start_turn()
	enemy_handler.reset_enemy_actions()

 
func _on_enemies_child_order_changed() -> void:
	if enemy_handler.get_child_count() == 0:
		Events.battle_over_screen_requested.emit("Victory!", BattleOverPanel.Type.WIN)

func _on_player_died() -> void:
	Events.battle_over_screen_requested.emit("Game Over :(", BattleOverPanel.Type.LOSE)
