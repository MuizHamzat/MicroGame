extends CharacterBody2D

@onready var hitbox = $hitbox
@onready var attack = $Attack

var screen_size
const SPEED = 300.0
var can_attack = true


func _ready():
	screen_size = get_viewport_rect().size

func _physics_process(delta):
	velocity = Vector2.ZERO
	if Input.is_action_pressed("keyboard_down"):
		velocity.y += 1;
	if Input.is_action_pressed("keyboard_up"):
		velocity.y -= 1;
	if Input.is_action_pressed("keyboard_left"):
		velocity.x -= 1;
	if Input.is_action_pressed("keyboard_right"):
		velocity.x += 1;
		
	# Attack
	if Input.is_action_pressed("keyboard_action") and can_attack:
		#play here animation
		can_attack = false
		attack.start()
	
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
	print("Player killed")
	queue_free()


func kill(object):
	print("Enemy has been slayed")
	object.queue_free()


func _on_attack_timeout():
	can_attack = true


func _on_hitbox_body_entered(body):
	if body.is_in_group("Enemies"):
		kill(body)
