extends Node2D

const SPEED := 60
const MAX_HEALTH := 6
const HIT_TIME := 0.25  

var direction := -1
var health := MAX_HEALTH
var is_hit := false
var hit_timer := 0.0

@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var animated_sprite = $AnimatedSprite2D


func _process(delta: float) -> void:
	if is_hit:
		hit_timer -= delta
		if hit_timer <= 0:
			is_hit = false
			animated_sprite.play("run")
		return  
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true

	elif ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false

	position.x += direction * SPEED * delta
	animated_sprite.play("run")

func take_damage(amount: int) -> void:
	if is_hit:
		return  
	health -= amount
	_start_hit()

	if health <= 0:
		die()


func _start_hit():
	is_hit = true
	hit_timer = HIT_TIME

	if animated_sprite.sprite_frames.has_animation("hit"):
		animated_sprite.play("hit")

func _on_AttackArea_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(1)  

func _on_killzone_area_entered(area: Area2D):
	if area.is_in_group("player_attack"):
		take_damage(1)

func die() -> void:
	print("Enemy died")
	queue_free()
