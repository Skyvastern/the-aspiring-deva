extends Control
class_name HUD


func _ready() -> void:
	Global.level.pause_menu.game_paused.connect(_on_game_paused)
	Global.active_npc_updated.connect(_on_active_npc_updated)


func _on_game_paused(paused: bool) -> void:
	if paused:
		visible = false
	elif paused == false and Global.active_npc != null:
		visible = false
	else:
		visible = true


func _on_active_npc_updated(npc: NPC) -> void:
	visible = npc == null
