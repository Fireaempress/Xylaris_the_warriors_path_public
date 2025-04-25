extends Node

#Signály pro karty a pointer
signal card_drag_started(card_ui: CardUI)
signal card_drag_ended(card_ui: CardUI)
signal card_aim_started(card_ui: CardUI)
signal card_aim_ended(card_ui: CardUI)
signal card_played(card: Card)
signal card_tooltip_requested(card: Card)
signal tooltip_hide_requested
signal card_heal

#signály pro hráče
signal player_hand_drawn
signal player_hand_discarded
signal player_turn_ended
signal player_hit
signal player_died

#enemy
signal enemy_action_completed(enemy: Enemy)
signal enemy_turn_ended

#bitva
signal battle_over_screen_requested(text: String, type: BattleOverPanel.Type)
signal battle_won

#mapa
signal map_exited

#other
signal campfire_exited
signal campfire_entered
signal battle_reward_exited
signal healing

#stages
signal stage1_entered
signal stage2_entered
signal stage3_entered
signal stage4_entered
signal stage5_entered
signal game_won
