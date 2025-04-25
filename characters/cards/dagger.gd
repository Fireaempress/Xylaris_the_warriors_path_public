extends Card
 
func apply_effects(targets: Array[Node]):
	var damage_effect := DamageEffect.new()
	damage_effect.amount = 10
	damage_effect.execute(targets)

