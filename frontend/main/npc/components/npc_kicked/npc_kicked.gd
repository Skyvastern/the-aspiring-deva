extends Node
class_name NPC_Kicked

@export_group("Data")
@export var speed: float = 10
@export var gravity: float = 100

@export_group("References")
@export var npc: NPC
@export var destroy_timer: Timer
@export var character_model: CharacterModel
const ANIM_BLEND: float = 0.15

@export var timer: Timer
var timer_callback: Callable

@export_group("Audio")
@export var kick_stream: AudioStream
@export var male_scream_stream: AudioStream
@export var female_scream_stream: AudioStream
var gender: String = "male"


func _ready() -> void:
	Global.level.game_manager.npc_preparing_to_drop.connect(_on_npc_preparing_to_drop)
	timer.timeout.connect(_on_timer_timeout)
	destroy_timer.timeout.connect(_on_destroy_timer_timeout)
	
	set_physics_process(false)


func _physics_process(delta: float) -> void:
	npc.velocity.y -= gravity * delta
	
	var dir: Vector3 = -npc.global_transform.basis.z
	npc.velocity.x = dir.x * speed
	npc.velocity.z = dir.z * speed
	
	npc.move_and_slide()


func get_kicked() -> void:
	AudioManager.play_audio_one_shot(kick_stream, 0.0, 0.1)
	AudioManager.play_audio_one_shot(
		male_scream_stream if gender == "male" else female_scream_stream,
		-15 if gender == "male" else -5,
		0.0 if gender == "male" else 0.6
	)
	
	character_model.play_animation("kicked", ANIM_BLEND)
	
	set_physics_process(true)
	destroy_timer.start()


func drop() -> void:
	character_model.play_animation("drop", ANIM_BLEND)
	
	start_timer(
		4.5,
		func():
			AudioManager.play_audio_one_shot(
				male_scream_stream if gender == "male" else female_scream_stream,
				-15 if gender == "male" else -8,
				0.0 if gender == "male" else 0.5
			)
			
			speed = 4
			set_physics_process(true)
			destroy_timer.start()
	)


func _on_npc_preparing_to_drop() -> void:
	character_model.play_animation("scared", ANIM_BLEND)


func _on_destroy_timer_timeout() -> void:
	npc.queue_free()


# NOTE: Not using get_tree().create_timer().timeout as it keeps running when tree is paused
func start_timer(wait_time: float, callback: Callable) -> void:
	timer.wait_time = wait_time
	timer_callback = callback
	timer.start()


func _on_timer_timeout() -> void:
	if timer_callback:
		timer_callback.call()
