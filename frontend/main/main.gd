extends Node
class_name Main

@export var audio_record: AudioRecord
@export var npc_speak: NPC_Speak


func _enter_tree() -> void:
	Global.main = self
