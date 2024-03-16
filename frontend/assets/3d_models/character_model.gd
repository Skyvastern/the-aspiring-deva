extends Node3D
class_name CharacterModel

@export var animation_player: AnimationPlayer


func play_animation(anim_name: String, blend: float = -1, speed: float = 1) -> void:
	animation_player.play(anim_name, blend, speed)
