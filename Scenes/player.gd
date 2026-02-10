extends CharacterBody2D


const MAX_HEALTH := 100
var current_health := MAX_HEALTH

# =============== MOVEMENT CONSTANTS ===============
const SPEED := 160.0
const JUMP_VELOCITY := -300.0
const GRAVITY := 1000.0

# =============== ROLL CONSTANTS ===============
const ROLL_SPEED := 250.0
const ROLL_TIME := 0.35
const ROLL_ANIMATION := "roll"
const ROLL_COOLDOWN := 0.5
const MAX_STAMINA := 100.0
const STAMINA_REGEN := 20.0
const ROLL_STAMINA_COST := 25.0

# =============== ATTACK CONSTANTS ===============
const ATTACK_TIME := 0.25
const ATTACK_COOLDOWN := 0.35
const ATTACK_OFFSET := 18.0   # hitbox forward distance

# =============== STATE VARIABLES ===============
var is_rolling := false
var roll_timer := 0.0
var roll_cooldown := 0.0
var current_stamina := MAX_STAMINA

var is_attacking := false
var attack_timer := 0.0
var attack_cooldown := 0.0

# =============== NODES ===============
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var stamina_bar: ProgressBar = $"../UI/StaminaBar"
@onready var attack_area: Area2D = $AttackArea
@onready var attack_shape: CollisionShape2D = $AttackArea/CollisionShape2D
@onready var hammer: AnimatedSprite2D = $hammer
@onready var health_bar: ProgressBar = $"../UI/HealthBar"

func _ready() -> void:
	print("Available animations: ", animated_sprite.sprite_frames.get_animation_names())

	# Initialize stamina bar
	if stamina_bar:
		stamina_bar.min_value = 0.0
		stamina_bar.max_value = MAX_STAMINA
		stamina_bar.value = current_stamina

	# Attack hitbox starts off
	attack_area.monitoring = false
	attack_shape.disabled = true
	
	
	if health_bar:
		health_bar.min_value = 0
		health_bar.max_value = MAX_HEALTH
		health_bar.value = current_health

func _physics_process(delta: float) -> void:

	# ================= STAMINA & COOLDOWNS =================
	if roll_cooldown > 0.0: roll_cooldown -= delta
	if attack_cooldown > 0.0: attack_cooldown -= delta

	if not is_rolling and current_stamina < MAX_STAMINA:
		current_stamina = min(MAX_STAMINA, current_stamina + STAMINA_REGEN * delta)

	_update_stamina_bar()

	# ================= ROLL STATE =================
	if is_rolling:
		roll_timer -= delta

		var facing := -1.0 if animated_sprite.flip_h else 1.0
		velocity.x = facing * ROLL_SPEED

		if animated_sprite.animation != ROLL_ANIMATION:
			animated_sprite.play(ROLL_ANIMATION)

		if roll_timer <= 0.0: is_rolling = false

		move_and_slide()
		return

	# ================= ATTACK STATE =================
	if is_attacking:
		attack_timer -= delta
		if attack_timer <= 0.0:
			_end_attack()


	# ================= NORMAL MOVEMENT =================
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	var direction := Input.get_action_strength("move_right") - Input.get_action_strength("move_left")

	if direction > 0:
		animated_sprite.flip_h = false
		hammer.flip_h = false

	elif direction < 0:
		animated_sprite.flip_h = true
		hammer.flip_h = true


	velocity.x = direction * SPEED

	# Jump
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY

	# Roll
	if Input.is_action_just_pressed("roll") \
			and is_on_floor() \
			and roll_cooldown <= 0.0 \
			and current_stamina >= ROLL_STAMINA_COST:
		_start_roll()

	# Attack
	if Input.is_action_just_pressed("attack") \
			and not is_attacking \
			and attack_cooldown <= 0.0:
		_start_attack()

	# Animations
	if not is_attacking:
		if not is_on_floor(): animated_sprite.play("jump")
		elif abs(velocity.x) > 10: animated_sprite.play("run")
		else: animated_sprite.play("idle")

	move_and_slide()


# ==========================================================
#                       ROLL LOGIC
# ==========================================================
func _start_roll() -> void:
	is_rolling = true
	roll_timer = ROLL_TIME
	roll_cooldown = ROLL_COOLDOWN

	current_stamina = max(0.0, current_stamina - ROLL_STAMINA_COST)

	var facing := -1.0 if animated_sprite.flip_h else 1.0
	velocity.x = facing * ROLL_SPEED

	animated_sprite.play(ROLL_ANIMATION)
	
func take_damage(amount: int) -> void:
	current_health -= amount
	current_health = max(0, current_health)
	_update_health_bar()
	print("Player HP:", current_health)
	if current_health <= 0:
		_player_die()
		
func _update_health_bar() -> void:
	if health_bar == null:
		return

	health_bar.value = current_health
	var ratio := current_health / MAX_HEALTH

	if ratio > 0.6:
		health_bar.modulate = Color(0.0, 1.0, 0.0)   # green
	elif ratio > 0.3:
		health_bar.modulate = Color(1.0, 1.0, 0.0)   # yellow
	else:
		health_bar.modulate = Color(1.0, 0.0, 0.0)   # red

func _player_die() -> void:
	print("PLAYER DIED")
	queue_free()   # or respawn logic later

func _on_Hurtbox_body_entered(body):
	if body.is_in_group("enemies"):
		take_damage(10)

# ==========================================================
#                       ATTACK LOGIC
# ==========================================================
func _start_attack() -> void:
	is_attacking = true
	attack_timer = ATTACK_TIME
	attack_cooldown = ATTACK_COOLDOWN

	# Enable hitbox
	attack_area.monitoring = true
	attack_shape.disabled = false

	# Position hitbox
	attack_area.position.x = ATTACK_OFFSET if not animated_sprite.flip_h else -ATTACK_OFFSET

	# Show hammer and flip it
	hammer.visible = true
	hammer.flip_h = animated_sprite.flip_h

	# PLAY HAMMER ATTACK ANIMATION (NOT CHARACTER!)
	hammer.play("attack")


func _end_attack() -> void:
	is_attacking = false

	# Disable hitbox
	attack_area.monitoring = false
	attack_shape.disabled = true

	# Hide hammer
	hammer.visible = false



# ==========================================================
#                     DAMAGE OUTPUT
# ==========================================================
func _on_attack_area_body_entered(body: Node2D) -> void:
	if body == self:
		return
	if body.has_method("take_damage"):
		body.take_damage(1)


# ==========================================================
#                     STAMINA BAR LOGIC
# ==========================================================
func _update_stamina_bar() -> void:
	if stamina_bar == null:
		return

	stamina_bar.value = current_stamina

	var ratio := current_stamina / MAX_STAMINA

	if ratio > 0.6:
		stamina_bar.modulate = Color(0.0, 1.0, 0.0)  # green
	elif ratio > 0.3:
		stamina_bar.modulate = Color(1.0, 1.0, 0.0)  # yellow
	else:
		stamina_bar.modulate = Color(1.0, 0.0, 0.0)  # red


func _on_attack_area_area_entered(area: Area2D) -> void:
	var enemy := area.get_parent()

	if enemy == self:
		return

	if enemy.has_method("take_damage"):
		enemy.take_damage(1)   # 1 hit


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy_attack"):
		take_damage(20)
