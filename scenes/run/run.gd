class_name Run
extends Node


const BATTLE_SCENE := preload("res://scenes/battle/battle.tscn")
const BATTLE_REWARD_SCENE := preload("res://scenes/battle_reward/battle_reward.tscn")
const CAMPFIRE_SCENE := preload("res://scenes/campfire/campfire.tscn")
const WON := preload("res://scenes/won/won.tscn")
#const MAP_SCENE := preload("res://scenes/map/map.tscn")

const BATTLE_ONE := preload("res://battles/level1.tres")
const BATTLE_TWO := preload("res://battles/level2.tres")
const BATTLE_THREE := preload("res://battles/level3.tres")
const BATTLE_FOUR := preload("res://battles/level4.tres")
const BATTLE_FIVE := preload("res://battles/level5.tres")


@export var run_startup: RunStartup
@onready var map: Map = $Map
@onready var current_view: Node = $CurrentView
@onready var deck_button: CardPileButton = %DeckButton
@onready var deck_view: CardPileView = %DeckView



@onready var map_button: Button = %MapButton
@onready var battle_button: Button = %BattleButton
@onready var shop_button: Button = %ShopButton
@onready var treasure_button: Button = %TreasureButton
@onready var rewards_button: Button = %RewardsButton
@onready var campfire_button: Button = %CampfireButton
@onready var stats_ui: HBoxContainer = %Stats
@onready var top_bar: CanvasLayer = %TopBar
@onready var sticks_ui: SticksUI = %SticksUI




var character: CharacterStats
var stats: RunStats
var this_round: BattleStats
var wins = 0

func _ready()-> void:
	
	if not run_startup:
		return
	
	match run_startup.type:
		RunStartup.Type.NEW_RUN:
			
			character = run_startup.picked_character.create_instance()
			stats_ui.block.hide()
			
			_start_run()
		RunStartup.Type.CONTINUED_RUN:
			print(":)")
			 
func _start_run() -> void:
	stats = RunStats.new()
	_setup_event_connections()
	_setup_top_bar()
	

func _on_battle_room_entered(level: BattleStats) -> void:
	var battle_scene: Battle = _change_view(BATTLE_SCENE) as Battle
	battle_scene.char_stats = character
	battle_scene.battle_stats = level
	this_round = level
	top_bar.hide()
	
	#debug
	#battle_scene.battle_stats = preload("res://battles/level1.tres")
	battle_scene.start_battle()

	
	
func _change_view(scene: PackedScene) -> Node:
	if current_view.get_child_count() > 0:
		current_view.get_child(0).queue_free()
	
	get_tree().paused = false
	var new_view := scene.instantiate()
	current_view.add_child(new_view)
	map.hide_map()
	return new_view
	
func _show_map() -> void:
	if current_view.get_child_count() > 0:
		current_view.get_child(0).queue_free()
		stats_ui.health_label.text = str(character.health)
		top_bar.show()
	map.show_map()

func _setup_top_bar() -> void:
	deck_button.card_pile = character.deck
	deck_view.card_pile = character.deck
	deck_button.pressed.connect(deck_view.show_current_view.bind("Deck"))
	#stats_ui.block_label.text = str(character.block)
	stats_ui.health_label.text = str(character.health)
	sticks_ui.label.text = str(stats.sticks)

func _setup_event_connections() -> void:
	Events.battle_won.connect(_on_battle_won)
	Events.battle_reward_exited.connect(_show_map)
	map_button.pressed.connect(_show_map)
	rewards_button.pressed.connect(_change_view.bind(BATTLE_REWARD_SCENE))
	Events.stage1_entered.connect(_on_battle_room_entered.bind(BATTLE_ONE))
	Events.stage2_entered.connect(_on_battle_room_entered.bind(BATTLE_TWO))
	Events.stage3_entered.connect(_on_battle_room_entered.bind(BATTLE_THREE))
	Events.stage4_entered.connect(_on_battle_room_entered.bind(BATTLE_FOUR))
	Events.stage5_entered.connect(_on_battle_room_entered.bind(BATTLE_FIVE))
	Events.campfire_exited.connect(_show_map)
	Events.healing.connect(healing)
	#debug
	
	#Events.map_exited.connect(_on_map_exited)
	#Events.shop_exited.connect(_show_map)
	#Events.treasure_room_exited.connect(_show_map)
	#Events.stage1_entered.connect(_on_battle_one_entered)
	
	#battle_button.pressed.connect(_change_view.bind(BATTLE_SCENE))
	campfire_button.pressed.connect(_change_view.bind(CAMPFIRE_SCENE))
	Events.campfire_entered.connect(_change_view.bind(CAMPFIRE_SCENE))
	#shop_button.pressed.connect(_change_view.bind(SHOP_SCENE))
	#treasure_button.pressed.connect(_change_view.bind(TREASURE_SCENE))


func _on_battle_won() -> void:
	var reward_scene := _change_view(BATTLE_REWARD_SCENE) as BattleReward
	reward_scene.run_stats = stats
	reward_scene.character_stats = character
	reward_scene.add_card_reward()
	this_round.roll_stick_reward()
	reward_scene.add_sticks_reward(this_round.sticks_reward)
	sticks_ui.set_run_stats(stats)
	sticks_ui.label.text = str(stats.sticks)
	wins += 1
	if wins == 5:
		_change_view(WON)

func healing() -> void:
	var sticks = stats.sticks
	var max = character.max_health
	var heal = max - character.health
	if heal >= sticks:
		stats.set_sticks(0)
		#character.health += sticks
		character.heal(sticks)
	else:
		character.heal(heal)
		stats.set_sticks(sticks-heal)
	_setup_top_bar()
	
	
	
	



