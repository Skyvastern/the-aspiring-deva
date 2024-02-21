extends Node
class_name NPC_Interact

var _history: Array
@export_multiline var background_story: String
@export var npc: NPC
@export var screens: Node
@export var ui: Control
@export var audio_record_auto_scene: PackedScene


func _ready() -> void:
	_setup()


func _process(_delta: float) -> void:
	if screens.get_child_count() > 0:
		return
	
	if Input.is_action_just_pressed("interact"):
		ui.visible = false
		
		var audio_record_auto: AudioRecordAuto = audio_record_auto_scene.instantiate()
		screens.add_child(audio_record_auto)
		
		Global.active_npc = npc


func _setup() -> void:
	_history.append({
		"role": "system",
		"content": background_story
	})


func get_history() -> Array:
	return _history


func add_player_message(message: String) -> void:
	_history.append({
		"role": "user",
		"content": message
	})


func add_npc_message(message: String) -> void:
	_history.append({
		"role": "assistant",
		"content": message
	})
