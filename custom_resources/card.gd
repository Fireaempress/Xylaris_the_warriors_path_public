class_name Card
extends Resource

enum Type {ATTACK, SKILL, HEAL}
enum Rarity {COMMON, RARE, SUBLIME}
enum Target {SELF, SINGLE_ENEMY, ALL_ENEMIES, EVERYONE}

const RARITY_COLORS := {
		Card.Rarity.COMMON: Color.SKY_BLUE,
		Card.Rarity.RARE: Color.REBECCA_PURPLE,
		Card.Rarity.SUBLIME: Color.ORANGE_RED,
}

@export_group("Card Attributes")
@export var id: String
@export var type: Type
@export var target: Target
@export var cost: int
@export var rarity: Rarity


@export_group("Card Visuals")
@export var icon: Texture
@export_multiline var tooltip_text: String
@export var special_text: String

func is_single_targeted() -> bool:
	return target == Target.SINGLE_ENEMY

func _get_targets(targets: Array[Node]) -> Array[Node]:
	if not targets:
		return []
	var tree := targets[0].get_tree()
	
	match target: #case v c# basically
		Target.SELF:
			return tree.get_nodes_in_group("player")
		Target.ALL_ENEMIES:
			return tree.get_nodes_in_group("enemies")
		Target.EVERYONE:
			return tree.get_nodes_in_group("player") + tree.get_nodes_in_group("enemies")
		_:
			return []

func play(targets: Array[Node], char_stats: CharacterStats) -> void:
	Events.card_played.emit(self)
	char_stats.mana -= cost
	
	if is_single_targeted():
		apply_effects(targets)
	else:
		apply_effects(_get_targets(targets))

func apply_effects(_targets: Array[Node]) -> void:
	pass
	#virtuální metoda - každá karta si ji musí sama definovat
