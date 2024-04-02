#main game scene manager
extends Node

onready var player = $"%player"

onready var scoreText = $UI/scoreText/value
onready var lives_leftText = $UI/lives_leftText/value
onready var game_overText = $UI/game_overText

onready var nav2d := $"Navigation2D"
#onready var line_2d = $Line2D #for debug purpose only

var player_score : int = 0

##--INITIALIZE--##
func _ready():
	game_overText.set_visible(false)
	scoreText.text = str(player_score)
	lives_leftText.text = str(player.get_lives_left())
##--##--##

func get_navigation_path(startpos : Vector2, endpos : Vector2):
	var path = nav2d.get_simple_path(startpos, endpos)
	#line_2d.points = path
	return path

##--SIGNAL RECEIVERS--##
func _on_player_on_player_damaged(dead):
	lives_leftText.text = str(player.get_lives_left())
	if(dead):
		game_overText.set_visible(true)
		player.queue_free()

func _on_enemy_died(enemy_node):
	player_score = player_score + 1
	scoreText.text = str(player_score)
	enemy_node.queue_free()

func _on_restartButton_button_down():
	get_tree().reload_current_scene()
	##--##--##


	
