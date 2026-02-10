extends Area2D

@export var next_scene_path: String = "res://Scenes/Level2.tscn"

func _on_portal_area_entered(area: Area2D) -> void:
	# Prevent enemies or hitboxes from triggering
	var player = area.get_parent()
	if player == null:
		return

	if player.is_in_group("player"):
		get_tree().change_scene_to_file(next_scene_path)


func _on_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
	
