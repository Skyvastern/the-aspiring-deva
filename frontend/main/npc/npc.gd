extends CharacterBody3D
class_name NPC

@export var interact: NPC_Interact
@export_multiline var background_story: String
@export_enum(
	"alloy",
	"echo",
	"fable",
	"onyx",
	"nova",
	"shimmer"
) var voice: String = "onyx"
