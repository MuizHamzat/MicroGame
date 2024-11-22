extends Area2D
signal collect

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	hide()
	collect.emit()
	
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)


func _on_collect():
	print("You WIN!")
