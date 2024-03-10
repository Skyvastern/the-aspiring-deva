extends ColorRect
class_name Flash

@export var animation_player: AnimationPlayer


func _enter_tree() -> void:
	Global.flash = self


func flash_in() -> void:
	animation_player.play("flash_in")


func flash_out() -> void:
	animation_player.play("flash_out")
