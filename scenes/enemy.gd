#enemy with movement and pathfinding to chase player once player is spotted and engages projectile shooting mechanics once within range
extends KinematicBody2D

onready var player = null
onready var spriteAnimator = $AnimatedSprite
onready var animationPlayer = $AnimationPlayer
onready var navigation_path_timer = $NavigationPathTimer
onready var game_scene = get_tree().current_scene

export var move_speed : float = 100.0
export var firing_range : float = 50.0
var path_to_player = null
var movement_direction : Vector2 = Vector2()
var shoot_dir : float = 0  #angle (with respect to game_scene) along which to shoot
var player_spotted : bool = false
var player_in_firing_range : bool = false

export var max_hit_count : int = 3 #the number of hits required for enemy to be dead
var hit_count : int = 0
signal died(enemy_node)
var is_dead : bool = false

onready var fire_point : Node2D = $fire_point #point from where the projectile is shot
export var projectileScene : PackedScene #scene used to instantiate the projectile
export var projectileSpeed : float = 500 #the speed of fired projectile
var can_shoot : bool = true

#faces towards player and sets shooting direction towards the player
func face_to_player():
	look_at(player.position)
	shoot_dir = global_rotation	
	
#move towards the player
func chase_player():
	#follow the player until certain distance (i.e. firing_range) from player
	if(self.position.distance_to(player.position) > firing_range):
		player_in_firing_range = false
		set_movement_dir_from_navigation_path()
		var movement = movement_direction * move_speed
		var actual_velocity = move_and_slide(movement)
		set_move_animation(actual_velocity)
	else:
		player_in_firing_range = true
		set_move_animation(Vector2(0,0)) #resets the walking animation
		
#sets the current movement direction based on built-in pathfinding to reach the player
func set_movement_dir_from_navigation_path():
	#move towards the next waypoint on the path from the current position to the player
	if(path_to_player and path_to_player.size() > 1):
		movement_direction = path_to_player[1] - position
		movement_direction = movement_direction.normalized()
		
func set_navigation_path():
	if(not is_instance_valid(player)):
		return
	path_to_player = game_scene.get_navigation_path(global_position, player.global_position)
		
func set_move_animation(velocity):
	#if has considerable velocity then play walking animation else stop the walking animation
	if velocity.length() > 10.0:
		spriteAnimator.play("walking")
	else:
		spriteAnimator.stop()
		
func play_hit_animation():
		animationPlayer.play("hit_effect")
		
#shoot the projectile towards player
func shoot():
	var projectile = projectileScene.instance()
	projectile.position = fire_point.global_position
	projectile.rotation = shoot_dir
	projectile.speed = projectileSpeed
	game_scene.call_deferred("add_child", projectile)
	
func handle_hit_by_bullet():
	play_hit_animation()
	hit_count = hit_count + 1
	if(hit_count >= max_hit_count):
		emit_signal("died", self)
		is_dead = true

##--SIGNAL RECEIVERS--##
func _on_player_detection_region_area_entered(area):
	if(area.is_in_group("player")):
		player_spotted = true
		player = area.get_node("..")
		set_navigation_path()
		navigation_path_timer.start() #start the next timer for finding navigation path

func _on_hit_box_area_entered(area):
	if(area.is_in_group("bullet")):
		handle_hit_by_bullet()

func _on_ShootTimer_timeout():
	can_shoot = true

func _on_NavigationPathTimer_timeout():
	if(player_spotted):
		set_navigation_path()
		navigation_path_timer.start() #start the next timer for finding navigation path
##--##--##


##----PROCESS UPDATES----##
func _process(delta):	
	#check if player instance has not been destroyed (which happens in game over) as null check is not enough
	if(not is_instance_valid(player)):
		return
	if(not is_dead and can_shoot and player_spotted and player_in_firing_range):
		shoot()
		can_shoot = false
		
func _physics_process(_delta):	
	if(not is_instance_valid(player)):
		return
	if(not is_dead and player_spotted):
		face_to_player()
		#print("process")
		chase_player()
##--##--##

##--INITIALIZE--##
func _ready():
	self.connect("died", game_scene, "_on_enemy_died")



