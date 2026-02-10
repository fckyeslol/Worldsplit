extends Node2D

const SPEED := 60
const MAX_HEALTH := 6

var direction := -1
var health := MAX_HEALTH
var is_attacking := false   

@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var animated_sprite = $AnimatedSprite2D


func _process(delta: float) -> void:
	
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true

	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false

	position.x += direction * SPEED * delta


func take_damage(amount: int) -> void:
	health -= amount
	print("Enemy hit! Remaining HP:", health)

	
	if animated_sprite.sprite_frames.has_animation("hit"):
		animated_sprite.play("hit")

	if health <= 0:
		die()

func _on_AttackArea_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(10)  

func die() -> void:
	print("Enemy died")
	queue_free()


func _on_killzone_area_entered(area: Area2D):
	if area.is_in_group("player_attack"):
		take_damage(1)
