extends CharacterBody2D

@onready var hitbox = $hitbox/CollisionShape2D #$hitbox/CollisionPolygon2D
#@onready var invincible_mode = $hitbox/CollisionShape2D
@onready var attackCooldown = $AttackCooldown
@onready var attackDuration = $AttackDuration
@onready var sprite = $AnimatedSprite2D

var screen_size
var player_border = Vector2(30,20)
const SPEED = 300.0
var game_over = false
var last_direction = "right"

signal player_death
signal enemy_killed
signal gold_killed

func _ready():
	screen_size = get_viewport_rect().size
	hitbox.disabled = true
	#invincible_mode.disabled = true
	

func _physics_process(delta):
	velocity = Vector2.ZERO
	#setAttackDirection(last_direction)
	if not game_over:
		if Input.is_action_pressed("keyboard_down"):
			velocity.y += 1;
			rotation_degrees = 180
			last_direction = "down"
			sprite.animation = "idle_down"
		if Input.is_action_pressed("keyboard_up"):
			velocity.y -= 1;
			rotation_degrees = 0
			last_direction = "up"
			sprite.animation = "idle_up"
		if Input.is_action_pressed("keyboard_left"):
			velocity.x -= 1;
			rotation_degrees = -90
			last_direction = "left"
			sprite.flip_h = true
			sprite.animation = "idle_side"
		if Input.is_action_pressed("keyboard_right"):
			velocity.x += 1;
			rotation_degrees = 90
			last_direction = "right"
			sprite.flip_h = false
			sprite.animation = "idle_side"
			


		# Attack
		if Input.is_action_pressed("keyboard_action") and attackCooldown.is_stopped():
			#play here animation
			hitbox.disabled = false
			#Start cooldown and duration timer
			attackCooldown.start()
			attackDuration.start()
		
		# Normalizing the speed so diagonal isnt faster (can add animation after :))
		if velocity.length() > 0:
			velocity = velocity.normalized() * SPEED
			#$AnimatedSprite2D.play()
		#else:
			#$AnimatedSprite2D.stop()
	
	position += velocity * delta
	position = position.clamp(Vector2(0,160) + player_border, screen_size - player_border)
	move_and_slide()

func death():
	#Emit death signal to let other nodes know player is dead (namely enemies)
	player_death.emit()
	queue_free()
	pass


func kill(object):
	object.queue_free()


# This sets the hitbox to face up down left or right
@warning_ignore("shadowed_variable")
func setAttackDirection(last_direction: String) -> void:
	match last_direction:
		"up":
			hitbox.rotation_degrees = 0
		"right":
			hitbox.rotation_degrees = 90
		"down":
			hitbox.rotation_degrees = 180
		"left":
			hitbox.rotation_degrees = 270


func _on_hitbox_body_entered(body):
	if body.is_in_group("Enemies"):
		enemy_killed.emit()
		kill(body)
	
	if body.is_in_group("Gold Enemy"):
		print("Gold enemy hit")
		gold_killed.emit()
		kill(body)


func _on_attack_duration_timeout():
	hitbox.set_deferred("disabled", true)


func _on_attack_cooldown_timeout() -> void:
	pass
