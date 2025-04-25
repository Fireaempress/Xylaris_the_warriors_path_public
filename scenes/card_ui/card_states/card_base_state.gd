extends CardState

func enter() -> void:
	if not card_ui.is_node_ready():
		await card_ui.ready #cekam dokud ui nebude ready, protoze godot udela rodice ready
							# jen pokud jsou vsechny deti ready
	if card_ui.tween and card_ui.tween.is_running():
		card_ui.tween.kill() #aby animace nedělala neplechu
	
	card_ui.visuals.panel.set("theme_override_styles/panel", card_ui.BASE_STYLEBOX)
	card_ui.reparent_requested.emit(card_ui)
	card_ui.pivot_offset = Vector2.ZERO #posune se zpatky dolu
	Events.tooltip_hide_requested.emit()
	
func on_gui_input(event: InputEvent) -> void:
	if not card_ui.playable or card_ui.disabled:
		return

	if event.is_action_pressed("left_mouse"): #do clicked state se dostaneme kliknutím :D
		card_ui.pivot_offset = card_ui.get_global_mouse_position() - card_ui.global_position 
		transition_requested.emit(self, CardState.State.CLICKED) #vyšlu signal abych poprosila o zmenu stavu
			
func on_mouse_entered() -> void:
	if not card_ui.playable or card_ui.disabled:
		return
	card_ui.visuals.panel.set("theme_override_styles/panel", card_ui.HOVER_STYLEBOX)
	Events.card_tooltip_requested.emit(card_ui.card.icon, card_ui.card.tooltip_text)

func on_mouse_exited() -> void:
	#tady byl if co je nad touto funkcí -> kdyby to dělalo neplechu, tak přidat
	card_ui.visuals.panel.set("theme_override_styles/panel", card_ui.BASE_STYLEBOX)
	Events.tooltip_hide_requested.emit()

