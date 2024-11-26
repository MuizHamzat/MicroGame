extends CharacterBody2D

@onready var hitbox = $hitbox
@onready var attackCooldown = $AttackCooldown
@onready var attackDuration = $AttackDuration

var screen_size
const SPEED = 300.0
var game_over = false

signal player_death

func _ready():
	screen_size = get_viewport_rect().size
	$hitbox/CollisionShape2D.disabled = true

func _physics_process(delta):
	velocity = Vector2.ZERO
	if not game_over:
		if Input.is_action_pressed("keyboard_down"):
			velocity.y += 1;
		if Input.is_action_pressed("keyboard_up"):
			velocity.y -= 1;
		if Input.is_action_pressed("keyboard_left"):
			velocity.x -= 1;
		if Input.is_action_pressed("keyboard_right"):
			velocity.x += 1;
			
		# Attack
		if Input.is_action_pressed("keyboard_action") and attackCooldown.is_stopped():
			#play here animation
			$hitbox/CollisionShape2D.disabled = false
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
	position = position.clamp(Vector2.ZERO, screen_size)
	move_and_slide()

func death():
	#Emit death signal to let other nodes know player is dead (namely enemies)
	player_death.emit()
	queue_free()


func kill(object):
	object.queue_free()



func _on_hitbox_body_entered(body):
	if body.is_in_group("Enemies"):
		kill(body)


func _on_attack_duration_timeout():
	$hitbox/CollisionShape2D.set_deferred("disabled", true)
