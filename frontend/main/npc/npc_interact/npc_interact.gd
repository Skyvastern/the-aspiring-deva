extends Control
class_name NPC_Interact

@export_group("UI")
@export var screens: Control
@export var selection_ui: Control
@export var kick_prompt: HBoxContainer

@export_group("References")
@export var npc: NPC
@export var audio_record_scene: PackedScene
@export var audio_record_auto_scene: PackedScene


func _process(_delta: float) -> void:
	if screens.get_child_count() > 0:
		return
	
	if Input.is_action_just_pressed("interact"):
		open_interaction_screen("quick")
	
	elif Input.is_action_just_pressed("interact_detailed"):
		open_interaction_screen("detailed")
	
	elif kick_prompt.visible and Input.is_action_just_pressed("kick"):
		npc_kicked()


func setup(new_npc: NPC, is_ready_to_jump: bool) -> void:
	npc = new_npc
	kick_prompt.visible = is_ready_to_jump


func open_interaction_screen(choice: String) -> void:
	if choice == "quick":
		selection_ui.visible = false
		
		var audio_record_auto: AudioRecordAuto = audio_record_auto_scene.instantiate()
		screens.add_child(audio_record_auto)
		
		Global.active_npc = npc
	
	elif choice == "detailed":
		selection_ui.visible = false
		
		var audio_record: AudioRecord = audio_record_scene.instantiate()
		screens.add_child(audio_record)
		
		Global.active_npc = npc


func close_interaction_screen() -> void:
	selection_ui.visible = true
	Global.active_npc = null


func npc_kicked() -> void:
	Global.disable_interactability(npc)
	npc.get_kicked()
