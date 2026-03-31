extends Area2D

const NEXT_SCENE := "res://Scenes/level2.tscn"

func _on_area_entered(area: Area2D) -> void:
	if area.name == "Hurtbox":
		print("ENTERED TRANSITION")
		get_tree().change_scene_to_file(NEXT_SCENE)
		print("HURTBOX:", area)
