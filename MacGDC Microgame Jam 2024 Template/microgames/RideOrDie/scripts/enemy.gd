extends CharacterBody2D

@onready var target = $"../Player"
var target_alive = true
var speed = 150

signal kill

func _physics_process(delta):
	if target_alive:
		var direction = (target.position-position).normalized()
		velocity = direction * speed
		look_at(target.position) #This makes the enemy actually face the player
	else:
		velocity = Vector2.ZERO
	

	move_and_slide()
	



func _on_kill_zone_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.kill()
		kill.emit()
		target_alive = false
	
	# Must be deferred as we can't change physics properties on a physics callback.
	#$"../Player".set_deferred("disabled", true)
