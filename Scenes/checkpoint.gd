extends Area2D

@export var checkpoint_id: String = "" 
var activated := false

func _ready() -> void:
	monitoring = true
	monitorable = true

func _on_body_entered(body: Node2D) -> void:
	if activated:
		return

	if body.is_in_group("player"):
		activated = true
		Global.checkpoint_position = global_position
		Global.has_checkpoint = true
		print("✅ Checkpoint ACTIVATED at:", Global.checkpoint_position)
