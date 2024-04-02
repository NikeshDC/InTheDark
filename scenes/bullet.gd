#moves in straight line once created in scene and is destroyed on collision
extends Area2D

export var speed : float = 500.0

##--PROCESS UPDATES--##
func _process(delta):
	#move forward each time-step with speed
	position += transform.x * speed * delta
##--##--##

##--SIGNAL RECEIVERS--##
func _on_bullet_area_entered(area):
	queue_free()

func _on_bullet_body_entered(body):
	queue_free()
##--##--##
