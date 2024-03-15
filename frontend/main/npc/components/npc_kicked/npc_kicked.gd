extends Node
class_name NPC_Kicked

@export_group("Data")
@export var speed: float = 10
@export var jump_speed: float = 20
@export var gravity: float = 100

@export_group("References")
@export var npc: NPC
@export var destroy_timer: Timer


func _ready() -> void:
	destroy_timer.timeout.connect(_on_destroy_timer_timeout)
	
	set_physics_process(false)


func _physics_process(delta: float) -> void:
	npc.velocity.y -= gravity * delta
	
	var dir: Vector3 = -npc.global_transform.basis.z
	npc.velocity.x = dir.x * speed
	npc.velocity.z = dir.z * speed
	
	npc.move_and_slide()


func get_kicked() -> void:
	set_physics_process(true)
	destroy_timer.start()


func jump() -> void:
	set_physics_process(true)
	npc.velocity.y = jump_speed
	destroy_timer.start()


func _on_destroy_timer_timeout() -> void:
	npc.queue_free()
