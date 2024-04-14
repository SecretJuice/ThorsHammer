extends Node2D

@onready var scoreLabel: RichTextLabel = $Score
@onready var multiplierLabel: RichTextLabel = $Multiplier
@onready var newPointsLabel: RichTextLabel = $NewPoints
@onready var timerLabel: RichTextLabel = $Timer
@onready var gameTimer: Timer = $GameTimer
@onready var endCard = $EndGameCard

var score: int = 0
var multiplier: float = 1
var newPoints: int = 0

var scoreLabelContents: int = score
var newPointsLabelContents: int = newPoints

var transfering: bool = false
var is_lerping_timescale: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	gameTimer.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if transfering:
		newPointsLabelContents = lerp(newPointsLabelContents, 0, 5 * delta)
		scoreLabelContents = lerp(scoreLabelContents, score, 5 * delta)

	scoreLabel.text = str(scoreLabelContents)
	multiplierLabel.text = str(multiplier) + "x"
	newPointsLabel.text = "+" + str(newPointsLabelContents)

	timerLabel.text = str(int(gameTimer.time_left) + 1) + " sec"

	if newPointsLabelContents == 0 or Engine.get_time_scale() == 0.1:
		transfering = false
		newPointsLabel.visible = false
	else:
		newPointsLabel.visible = true

func addNewPoints(points):
	newPoints += points * multiplier
	newPointsLabelContents = newPoints

func applyPoints():
	score += newPoints
	transfering = true
	newPoints = 0

func addMultiplier(mult: float):
	multiplier += mult

	multiplier = clamp(multiplier, 1, 12)

func resetMultiplier():
	multiplier = 1

func _on_game_timer_timeout():
	endGame()

func endGame():
	gameTimer.stop()
	print("Game Over")
	Engine.set_time_scale(0.1)
	endCard.showCard(score)

	multiplierLabel.visible = false
	newPointsLabel.visible = false
	timerLabel.visible = false
	scoreLabel.visible = false

	
