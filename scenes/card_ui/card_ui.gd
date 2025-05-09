class_name CardUI
extends Control

signal reparent_requested(which_card_ui: CardUI) #abych je mohla posunout mimo hand

@export var card: Card: set = _set_card
@export var char_stats: CharacterStats : set = _set_char_stats

@onready var visuals: CardVisuals = $CardVisuals
@onready var drop_point_detector = $DropPointDetector
@onready var card_state_machine: CardStateMachine = $CardStateMachine
@onready var targets: Array[Node] = []

const BASE_STYLEBOX := preload("res://scenes/card_ui/card_base_stylebox.tres")
const DRAG_STYLEBOX := preload("res://scenes/card_ui/card_dragging_stylebox.tres")
const HOVER_STYLEBOX := preload("res://scenes/card_ui/card_hover_stylebox.tres")

var original_index := 0
var parent: Control
var tween: Tween
var playable := true: set = _set_playable
var disabled := false

func _ready() -> void:
	Events.card_aim_started.connect(_on_card_drag_or_aiming_started)
	Events.card_drag_started.connect(_on_card_drag_or_aiming_started)
	Events.card_aim_ended.connect(_on_card_drag_or_aiming_ended)
	Events.card_drag_ended.connect(_on_card_drag_or_aiming_ended)
	card_state_machine.init(self)

func _input(event: InputEvent) -> void:
	card_state_machine.on_input(event)

func animate_to_position(new_position: Vector2, duration: float) -> void:
	tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self,"global_position",new_position,duration)

func play() -> void:
	if not card:
		return
	
	card.play(targets, char_stats)
	queue_free()

func _on_gui_input(event: InputEvent) -> void:
	card_state_machine.on_gui_input(event)
	
func _on_mouse_entered() -> void:
	card_state_machine.on_mouse_entered()

func _on_mouse_exited() -> void:
	card_state_machine.on_mouse_exited()
	

func _set_card(value: Card) -> void:
	if not is_node_ready():
		await ready
	
	card = value
	visuals.card = card
	


func _set_playable(value: bool) -> void:
	playable = value
	if not playable:
		visuals.cost.add_theme_color_override("font_color", Color.RED)
		visuals.icon.modulate = Color(1,1,1,0.5)
	else:
		visuals.cost.remove_theme_color_override("font_color")
		visuals.icon.modulate = Color(1,1,1,1)


func _set_char_stats(value: CharacterStats) -> void:
	char_stats = value
	char_stats.stats_changed.connect(_on_char_stats_changed)
 
func _on_drop_point_detector_area_entered(area: Area2D):
	if not targets.has(area):
		targets.append(area)


func _on_drop_point_detector_area_exited(area):
	targets.erase(area)
	
func _on_card_drag_or_aiming_started(used_card: CardUI) -> void:
	if used_card == self:
		return
	disabled = true
	#spustí se to pro všechny karty, takže pro tu co držíme to vypnu

func _on_card_drag_or_aiming_ended(_card: CardUI) -> void:
	disabled = false
	
	self.playable = char_stats.can_play_card(card)
	
func _on_char_stats_changed() -> void:
	self.playable = char_stats.can_play_card(card)
	
