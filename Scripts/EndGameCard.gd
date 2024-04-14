extends Node2D

@onready var finalScoreLabel: RichTextLabel = $FinalScore
@onready var gameOverLabel: RichTextLabel = $Title
@onready var newHighScoreLabel: RichTextLabel = $HighScore


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func showCard(score: int):
	visible = true

	finalScoreLabel.text = str(score)




func _on_button_pressed():
	Engine.set_time_scale(1)
	get_tree().change_scene_to_file("res://Scenes/scene.tscn")


