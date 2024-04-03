#main game scene manager
extends Node

onready var player = $"%player"

onready var scoreText = $UI/scoreText/value
onready var lives_leftText = $UI/lives_leftText/value
onready var game_overText = $UI/game_overText

onready var nav2d := $"Navigation2D"
#onready var line_2d = $Line2D #for debug purpose only

onready var enemy_spawner = $EnemySpawner
export var enemy_spawn_threshold : int = 3 #after how many enemies are left should new ones be spawned
export var enemy_spawn_min : int = 1 #at minimum how many enemies should be spawned at a time
export var enemy_spawn_max : int = 5 #at maximum how many enemies should be spawned at a time

var player_score : int = 0
var enemies_left : int

##--INITIALIZE--##
func _ready():
	game_overText.set_visible(false)
	scoreText.text = str(player_score)
	lives_leftText.text = str(player.get_lives_left())
	enemies_left = enemy_spawner.spawn_all()
##--##--##

func get_navigation_path(startpos : Vector2, endpos : Vector2):
	var path = nav2d.get_simple_path(startpos, endpos)
	#line_2d.points = path
	return path

func spawn_new_enemies():
	for i in range(enemy_spawn_min + (randi() % (enemy_spawn_max - enemy_spawn_min))):
		enemy_spawner.spawn_random()
		enemies_left += 1

##--SIGNAL RECEIVERS--##
func _on_player_on_player_damaged(dead):
	lives_leftText.text = str(player.get_lives_left())
	if(dead):
		game_overText.set_visible(true)
		player.queue_free()

func _on_enemy_died(enemy_node):
	player_score += 1
	scoreText.text = str(player_score)
	enemy_node.queue_free()
	enemies_left -= 1

func _on_restartButton_button_down():
	get_tree().reload_current_scene()
	
func _on_SpawnTimer_timeout():
	if(enemies_left <= enemy_spawn_threshold):
		spawn_new_enemies()
##--##--##


	



