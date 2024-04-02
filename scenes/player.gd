#player with input controls for movement (with action maps: (move_"up/down/left/right")) and shooting ( mouse pointer for direction and action map "shoot" for shooting)
extends KinematicBody2D

onready var game_scene = get_tree().current_scene
onready var spriteAnimator = $AnimatedSprite
onready var animation_player = $AnimationPlayer

export var move_speed : float = 500.0
var movement_direction : Vector2 = Vector2()
var shoot_dir : float = 0.0

onready var fire_point = $fire_point  #position at which bullet is instanced
export var bulletScene : PackedScene  #bullet scene used for creation
export var bulletSpeed : float = 1000.0
var can_shoot : bool = true

export var max_lives : int = 10
onready var lives_left : int = max_lives
signal on_player_damaged(dead)  #emitted each time player hit-box registers hit from enemy projectile


func set_player_rotation():
	#face to mouse pointer position and set the shoot direction along it
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
	
func set_move_animation(velocity):
	#play walking animation if velocity is high enough else stop the walking animation
	if velocity.length() > 10.0:
		spriteAnimator.play("walking")
	else:
		spriteAnimator.stop()

func play_hit_effect():
	animation_player.play("hit_effect")

func shoot():
	var bullet = bulletScene.instance()
	bullet.position = fire_point.global_position
	bullet.rotation = shoot_dir
	bullet.speed = bulletSpeed
	game_scene.call_deferred("add_child", bullet)
	
func get_lives_left():
	return lives_left
	
##--SIGNAL RECEIVERS--##
func _on_hit_box_area_entered(area):
	if(area.is_in_group("bullet")):
		on_hit_by_bullet()

func on_hit_by_bullet():
	if(lives_left <= 0):
		return
	play_hit_effect()
	lives_left = lives_left - 1
	if(lives_left <= 0):
		emit_signal("on_player_damaged", true)  #player dead
	else:
		emit_signal("on_player_damaged", false) #player still alive

func _on_ShootTimer_timeout():
	can_shoot = true
##--##--##

##--PROCESS UPDATES--##
func _physics_process(delta):
	set_player_rotation()
	set_movementdir_from_input()
	var movement = movement_direction * move_speed #move_and_slide already takes into account delta so no need to multiply by it here
	var actual_velocity = move_and_slide(movement)
	set_move_animation(actual_velocity)

func _process(delta):	
	if(can_shoot && Input.is_action_just_pressed("shoot")):
		shoot()
		can_shoot = false
##--##--##



