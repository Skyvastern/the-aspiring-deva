extends Node
class_name NPC

var _history: Array
@export_multiline var background_story: String
@export var audio_record_auto_scene: PackedScene


func _ready() -> void:
	_setup()


func _setup() -> void:
	_history.append({
		"role": "system",
		"content": background_story
	})


func _process(_delta: float) -> void:
	if get_child_count() > 0:
		return
	
	if Input.is_action_just_pressed("ui_accept"):
		var audio_record_auto: AudioRecordAuto = audio_record_auto_scene.instantiate()
		add_child(audio_record_auto)
		
		Global.active_npc = self


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
