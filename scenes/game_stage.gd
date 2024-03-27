extends Node

onready var player = $player

onready var scoreText = $UI/scoreText/value
onready var lives_leftText = $UI/lives_leftText/value
onready var game_overText = $UI/game_overText

var player_score = 0

func _ready():
	game_overText.set_visible(false)
	scoreText.text = str(player_score)
	lives_leftText.text = str(player.get_lives_left())

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
