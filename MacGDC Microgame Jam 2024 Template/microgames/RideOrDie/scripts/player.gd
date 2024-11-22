extends CharacterBody2D

var screen_size
const SPEED = 300.0


func _ready():
	screen_size = get_viewport_rect().size
	Globals.player_pos = position

func _physics_process(delta):
	Globals.player_pos = position
	velocity = Vector2.ZERO
	if Input.is_action_pressed("keyboard_down"):
		velocity.y += 1;
	if Input.is_action_pressed("keyboard_up"):
		velocity.y -= 1;
	if Input.is_action_pressed("keyboard_left"):
		velocity.x -= 1;
	if Input.is_action_pressed("keyboard_right"):
		velocity.x += 1;
		
	# Normalizing the speed so diagonal isnt faster (can add animation after :))
	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED
		#$AnimatedSprite2D.play()
	#else:
		#$AnimatedSprite2D.stop()
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	move_and_slide()
