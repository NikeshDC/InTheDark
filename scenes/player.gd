extends KinematicBody2D

onready var playerAnimator = $AnimatedSprite

export var speed = 100.0
var movement_direction = Vector2()
var shoot_dir = 0

onready var fire_point = $fire_point
export var bulletScene : PackedScene
export var bulletSpeed = 1000
var can_shoot = true

export var max_lives = 10
var lives_left = max_lives
signal on_player_damaged(dead)

func get_lives_left():
	return lives_left

func set_player_rotation():
	look_at(get_global_mouse_position())
	shoot_dir = global_rotation
	
func set_movementdir_from_input():
	movement_direction.x = 0
	movement_direction.y = 0
	if(Input.is_action_pressed("move_up")):
		movement_direction.y -= 1
	if(Input.is_action_pressed("move_down")):
		movement_direction.y += 1
	if(Input.is_action_pressed("move_right")):
		movement_direction.x += 1
	if(Input.is_action_pressed("move_left")):
		movement_direction.x -= 1
	movement_direction = movement_direction.normalized()
	
func set_animation(velocity):
	if velocity.length() > 10.0:
		playerAnimator.play("walking")
	else:
		playerAnimator.stop()

func _physics_process(_delta):
	set_player_rotation()
	set_movementdir_from_input()
	var movement = movement_direction * speed
	var actual_velocity = move_and_slide(movement)
	set_animation(actual_velocity)


func _process(delta):	
	if(can_shoot && Input.is_action_just_pressed("shoot")):
		shoot()
		can_shoot = false

func reload():
	can_shoot = true

func shoot():
	var bullet = bulletScene.instance()
	bullet.position = fire_point.global_position
	bullet.rotation = shoot_dir
	bullet.speed = bulletSpeed
	get_tree().get_root().call_deferred("add_child", bullet)


func _on_hit_box_area_entered(area):
	if(area.is_in_group("bullet")):
		on_hit_by_bullet()

func on_hit_by_bullet():
	if(lives_left <= 0):
		return
	lives_left = lives_left - 1
	if(lives_left <= 0):
		emit_signal("on_player_damaged", true)  #player dead
	else:
		emit_signal("on_player_damaged", false) #player still alive

func _on_ShootTimer_timeout():
	reload()


