extends EnemyAction

@export var attack := 15
@export var hp_threshold := 5

var already_used := false

func is_performable() -> bool:
	if not enemy or already_used:
		return false
	
	var is_low := enemy.stats.health <= hp_threshold
	already_used = is_low
	
	return is_low

func perform_action() -> void:
	if not enemy or not target:
		return
	var tween := create_tween().set_trans(Tween.TRANS_QUINT)
	var start := enemy.global_position
	var end := target.global_position + Vector2.RIGHT*400 + Vector2.UP*200
	var attack_effect := DamageEffect.new()
	var target_array : Array[Node] = [target]
	attack_effect.amount = attack
	
	tween.tween_property(enemy, "global_position", end, 0.4)
	tween.tween_callback(attack_effect.execute.bind(target_array))
	tween.tween_interval(0.25)
	tween.tween_property(enemy, "global_position", start, 0.4)
	tween.finished.connect(
		func():
			Events.enemy_action_completed.emit(enemy)
			
	)

