extends Node2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var is_open := false

func _ready():
	anim.play("closed")  # Estado inicial

func open_door():
	if is_open:
		return

	is_open = true
	anim.play("opening")

	await anim.animation_finished
	anim.play("open") # Estado final de la puerta

func _on_Area2D_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		open_door()
