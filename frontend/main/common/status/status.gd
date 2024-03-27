extends Control
class_name Status

@export_group("UI")
@export var loader: TextureRect
@export var status_message: Label
@export var error_message: Label

@export_group("Extras")
@export var starting_status_message: String = "Status"


func _ready() -> void:
	status_message.text = starting_status_message


func show_status(message: String) -> void:
	loader.visible = true
	error_message.visible = false
	
	status_message.text = message
	status_message.visible = true


func hide_status() -> void:
	loader.visible = false
	status_message.visible = false
	error_message.visible = false


func show_error(message: String) -> void:
	loader.visible = false
	status_message.visible = false
	
	error_message.text = message
	error_message.visible = true
