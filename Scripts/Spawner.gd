extends Node2D


@onready var timer = $Timer
@onready var player = get_node("../Player")

@export var radius: int = 500

@export var enemy_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	_on_timer_timeout()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():

	if player.global_position.distance_to(global_position) <= radius * 2:
		return
	
	var pos = global_position + Vector2(cos(randf_range(-2*PI, 2*PI)) * radius, sin(randf_range(-2*PI, 2*PI)) * radius)

	print(pos)

	var enemy = enemy_scene.instantiate()
	
	enemy.global_position = pos
	call_deferred("add_sibling", enemy)
