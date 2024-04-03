extends Node

export var enemy_scene : PackedScene
export var spawn_point_group = "spawn_point"
var spawn_points = []

onready var game_scene = get_tree().current_scene

##--INITIALIZE--##
func _ready():
	for child in get_children():
		if(child.is_in_group(spawn_point_group)):
			spawn_points.append(child.global_position)
##--##--##

func spawn_enemy_at(global_pos : Vector2):
	var enemy = enemy_scene.instance()
	enemy.global_position = global_pos
	game_scene.call_deferred("add_child", enemy)
	return enemy

#spawn enemy instance at all spawn locations (one at each)
func spawn_all(return_spawned_enemies : bool = false):
	if(return_spawned_enemies):
		var enemies = []
		for spoint in spawn_points:
			enemies.append(spawn_enemy_at(spoint))
		return enemies
	else:
		for spoint in spawn_points:
			spawn_enemy_at(spoint)
	return spawn_points.size()
	

#spawns enemy instance randomly at one point from among the spawn points
func spawn_random():
	var random_spawn_point = spawn_points[ randi() % spawn_points.size()] 
	return spawn_enemy_at(random_spawn_point)
