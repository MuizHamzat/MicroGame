extends Area2D
signal collect

@onready var gold_enemy = $"../GoldEnemy"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Makes the coin stick to the enemy
	pass
	#if ():
		#position = gold_enemy.position


func _on_body_entered(body):
	if body.is_in_group("Player"):
		collect.emit()
		Globals.coin_collected = true;
		
		# Play animation
		
		# Must be deferred as we can't change physics properties on a physics callback.
		#$CollisionShape2D.set_deferred("disabled", true)
		queue_free()
