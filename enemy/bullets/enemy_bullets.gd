extends Area2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y += 400 * delta


func _on_area_entered(area: Area2D) -> void:
	area.queue_free()
	queue_free()
