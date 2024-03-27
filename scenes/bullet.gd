extends Area2D

export var speed = 500

func _process(delta):
	position += transform.x * speed * delta


func _on_bullet_area_entered(area):
	queue_free()


func _on_bullet_body_entered(body):
	queue_free()
