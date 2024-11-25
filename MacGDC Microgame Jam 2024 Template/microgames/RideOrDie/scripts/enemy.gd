extends CharacterBody2D

@onready var target = $"../Player"
var speed = 150

func _physics_process(delta):
	var direction = (target.position-position).normalized()
	velocity = direction * speed
	look_at(target.position) #This makes the enemy actually face the player

	move_and_slide()
