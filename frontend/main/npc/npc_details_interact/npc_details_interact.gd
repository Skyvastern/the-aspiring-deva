extends Control
class_name NPC_Details_Interact


@export_group("References")
@export var animation_player: AnimationPlayer
@export var npc_details_panel_scene: PackedScene
var npc_details_panel: NPC_Details_Panel


func _ready() -> void:
	Global.level.game_manager.next_npc_coming.connect(_show_prompt_for_few_seconds)


func _process(_delta: float) -> void:
	if not npc_details_panel and not is_instance_valid(npc_details_panel) and Input.is_action_pressed("npc_details"):
		npc_details_panel = npc_details_panel_scene.instantiate()
		add_child(npc_details_panel)
		
		var details: Dictionary = Global.level.game_manager.get_current_npc_data()
		npc_details_panel.update_ui(
			details["name"],
			details["age"],
			details["background_story"]
		)
		
		animation_player.play("invisible")
	
	if npc_details_panel and is_instance_valid(npc_details_panel) and Input.is_action_just_released("npc_details"):
		npc_details_panel.queue_free()


func _show_prompt_for_few_seconds() -> void:
	animation_player.play("notify")
