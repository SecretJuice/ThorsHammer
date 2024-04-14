extends Node2D
var playerFollower: Node2D
var hammer: Node2D

var distance = 100

# Called when the node enters the scene tree for the first time.
func _ready():
    playerFollower = get_parent()
    hammer = get_node("../../Hammer")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    #### MOUSE CONTROL
    # var mouse_position = get_global_mouse_position()

    # var vector = Vector2(0,0) 
    # vector = mouse_position - playerFollower.global_position

    # # vector /= distance

    # if vector.length() > distance:
    #     vector = playerFollower.global_position + vector.normalized() * distance
    # else:
    #     vector = mouse_position

    # global_position = global_position.lerp(vector, 4 * delta)

    #### HAMMER CONTROL
    # var vector: Vector2

    # vector = (playerFollower.global_position + hammer.global_position) / 2

    # var distance = playerFollower.global_position.distance_to(hammer.global_position)

    # global_position = global_position.lerp(vector, 4 * delta)
    

    #### PLAYER CENTERED
    global_position = global_position.lerp(playerFollower.global_position, 4 * delta)
