extends Card

func apply_effects(targets: Array[Node]) -> void:
	var block := BlockEffect.new()
	block.amount = 4
	block.execute(targets)

