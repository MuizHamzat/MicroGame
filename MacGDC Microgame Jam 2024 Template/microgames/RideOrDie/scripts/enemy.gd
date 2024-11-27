extends CharacterBody2D

class_name Enemy

@onready var sprite = $AnimatedSprite2D

@onready var target

@export var speed = 100
var game_over = false

signal kill

func _physics_process(_delta):
	if not game_over:
		var direction = (target.position-position).normalized()
		velocity = direction * speed
		if target.position.x < position.x:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
	else:
		velocity = Vector2.ZERO
	

	move_and_slide()
	

func set_player(player_node: CharacterBody2D):
	target = player_node


func _on_kill_zone_body_entered(body):
	if body.is_in_group("Player"):
		body.death()
		kill.emit()
	
	# Must be deferred as we can't change physics properties on a physics callback.
	#$"../Player".set_deferred("disabled", true)
	
