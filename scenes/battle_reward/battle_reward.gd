class_name BattleReward
extends Control

const CARD_REWARDS = preload("res://scenes/ui/card_rewards.tscn")
const REWARD_BUTTON = preload("res://scenes/ui/reward_button.tscn")
const CARD_ICON := preload("res://art1/smallcards.png")
const CARD_TEXT := "Add new card"
const STICK_ICON := preload("res://art1/stick_final.png")
const STICK_TEXT := "Take %s sticks"

@export var run_stats: RunStats
@export var character_stats: CharacterStats
#@export var run: Run


@onready var rewards: VBoxContainer = %Rewards


var card_reward_total_weight := 0
var card_rarity_weights := {
	Card.Rarity.COMMON: 0,
	Card.Rarity.RARE: 0,
	Card.Rarity.SUBLIME: 0
	
}

func _ready() -> void:
	for node: Node in rewards.get_children():
		node.queue_free() #delete placeholders
	
	#add_card_reward()

func _on_back_button_pressed():
	#if run.wins < 5:
	Events.battle_reward_exited.emit()
	#else:
		#Events.game_won.emit()	

func add_card_reward() -> void:
	var card_reward := REWARD_BUTTON.instantiate() as RewardButton
	card_reward.reward_icon = CARD_ICON
	card_reward.reward_text = CARD_TEXT
	card_reward.pressed.connect(_show_card_rewards)
	rewards.add_child.call_deferred(card_reward)
	
func add_sticks_reward(amount: int) -> void:
	var sticks_reward := REWARD_BUTTON.instantiate() as RewardButton
	sticks_reward.reward_icon = STICK_ICON
	sticks_reward.reward_text = STICK_TEXT % amount
	sticks_reward.pressed.connect(_on_sticks_reward_taken.bind(amount))
	rewards.add_child.call_deferred(sticks_reward)
	
func _show_card_rewards() -> void:
	if not character_stats or not run_stats:
		
		return
	
	var card_rewards := CARD_REWARDS.instantiate() as CardRewards
	add_child(card_rewards)
	card_rewards.card_reward_selected.connect(_on_card_reward_taken)
	
	var card_reward_array: Array[Card] = []
	var available_cards: Array[Card] = character_stats.draftable_cards.cards.duplicate(true)
	
	for i in run_stats.card_rewards:
		_setup_card_chances()
		var roll := randf_range(0, card_reward_total_weight)
		
		for rarity: Card.Rarity in card_rarity_weights:
			if card_rarity_weights[rarity] > roll:
				_modify_weights(rarity)
				var picked_card := _get_random_available_card(available_cards, rarity)
				card_reward_array.append(picked_card)
				available_cards.erase(picked_card)
				break

	card_rewards.rewards = card_reward_array
	card_rewards.show()

func _setup_card_chances() -> void:
	card_reward_total_weight = run_stats.common_weight + run_stats.rare_weight + run_stats.sublime_weight
	card_rarity_weights[Card.Rarity.COMMON] = run_stats.common_weight
	card_rarity_weights[Card.Rarity.RARE] = run_stats.common_weight + run_stats.rare_weight
	card_rarity_weights[Card.Rarity.SUBLIME] = card_reward_total_weight


func _modify_weights(rarity_rolled: Card.Rarity) -> void:
	if rarity_rolled == Card.Rarity.SUBLIME:
		run_stats.sublime_weight = RunStats.BASE_SUBLIME_WEIGHT
	else:
		run_stats.sublime_weight = clampf(run_stats.sublime_weight + 0.3, run_stats.BASE_SUBLIME_WEIGHT, 5)
#přidám pravděpodobnost na sublime, pokud nepadne

func _get_random_available_card(available_cards: Array[Card], with_rarity: Card.Rarity) -> Card:
	var all_possible_cards := available_cards.filter(
		func(card: Card):
			return card.rarity == with_rarity
			# vyberu karty jen s tou raritou kterou rollnu
	)
	return all_possible_cards.pick_random()

func _on_card_reward_taken(card: Card) -> void:
	if not character_stats or not card:
		return
	
	character_stats.deck.add_card(card)
	
func _on_sticks_reward_taken(amount: int) -> void:
	if not run_stats:
		return
	run_stats.sticks += amount
