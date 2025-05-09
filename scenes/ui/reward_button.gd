class_name RewardButton
extends Button

@export var reward_icon: Texture : set = set_reward_icon
@export var reward_text: String : set = set_reward_text

@onready var custom_icon: TextureRect = %CustomIcon
@onready var custom_text: Label = %CustomText



func set_reward_icon(icon: Texture) -> void:
	reward_icon = icon
	if not is_node_ready():
		await ready
	
	custom_icon.texture = reward_icon

func set_reward_text(text: String)-> void:
	reward_text = text
	
	if not is_node_ready():
		await ready
	
	custom_text.text = reward_text
	

func _on_pressed() -> void:
	queue_free()
