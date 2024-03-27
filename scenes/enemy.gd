extends KinematicBody2D

onready var player = $"../player"
onready var playerAnimator = $AnimatedSprite
onready var gameScene = $".."

export var speed = 100.0
var movement_direction = Vector2()
var shoot_dir = 0
export var player_follow_range = 100
export var player_spot_range = 500
var player_spotted = false

export var max_hit_count = 3
var hit_count = 0
signal died(enemy_node)
var is_dead = false

onready var fire_point = $fire_point
export var bulletScene : PackedScene
export var bulletSpeed = 1000
var is_reloading = false

func face_to_player():
	look_at(player.position)
	shoot_dir = global_rotation
	
func set_movement_dir_from_navigation():
	var path = gameScene.get_navigation_path(position, player.position)
	if(path and path.size() > 1):
		movement_direction = path[1] - position
		movement_direction = movement_direction.normalized()
	
func chase_player():
	if(self.position.distance_to(player.position) > player_follow_range):
		set_movement_dir_from_navigation()
		var movement = movement_direction * speed
		var actual_velocity = move_and_slide(movement)
		set_animation(actual_velocity)
	else:
		set_animation(Vector2(0,0))
		
func set_animation(velocity):
	if velocity.length() > 10.0:
		playerAnimator.play("walking")
	else:
		playerAnimator.stop()
		
func check_for_player():
	var direction_to_player = player.position - position
	if(direction_to_player.length() < player_spot_range):
		player_spotted = true

func _physics_process(_delta):	
	if(not is_instance_valid(player)):
		return
	if(not is_dead and player_spotted and player):
		face_to_player()
		chase_player()

func _process(delta):	
	if(not is_instance_valid(player)):
		return
	check_for_player()
	if(not is_dead and not is_reloading and player_spotted and player):
		shoot()
		is_reloading = true

func reload():
	is_reloading = false

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
	hit_count = hit_count + 1
	if(hit_count >= max_hit_count):
		emit_signal("died", self)
		is_dead = true

func _on_ShootTimer_timeout():
	reload()


