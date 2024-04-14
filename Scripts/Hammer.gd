extends Node2D

var player
var arrow
var arrowScale
var distance = 20

var hammerCharge = 0.0
var chargeSpeed = 1

var canThrow = true
var hammerHeld = true
var summoning = false

var hammerVelocity = Vector2.ZERO
var hammerThrowForce = 2000
var hammerDamping = 5
var summonForce = 2500

var scoreKeeper: Node2D = null

func _ready():
    player = get_node("../Player")
    arrow = get_node("HammerArrow")
    arrowScale = arrow.scale
    scoreKeeper = get_node("../PlayerFollower/ScoreKeeper")

func _process(delta):
    # global_position = global_position.lerp(player.global_position, 10 * delta)
    chargeHammer(delta)

    if hammerHeld:
        var vector = Vector2(0,0) 
        vector = global_position - player.global_position

        # vector /= distance

        if vector.length() > distance + 1:
            global_position = player.global_position + vector.normalized() * distance
        else:
            vector = player.global_position
            global_position = global_position.lerp(vector, 8 * delta)
    
    else:

        var damp = hammerDamping

        if summoning:
            damp = 4

        position += hammerVelocity * delta
        hammerVelocity = hammerVelocity.lerp(Vector2.ZERO, damp * delta)

    if summoning:
        summonHammer(delta)


func chargeHammer(delta):
    if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and canThrow:
        hammerCharge = clamp(hammerCharge + chargeSpeed * delta, 0.0, 1.0)
        arrow.visible = true
        arrow.scale = arrowScale * hammerCharge

        var direction_to_cursor = (get_global_mouse_position() - global_position).normalized()
        var opposite_direction = -direction_to_cursor

        arrow.look_at(global_position + opposite_direction)
    else:
        if hammerCharge > 0.0:
            throwHammer()

        arrow.visible = false
        hammerCharge = 0

func throwHammer():

    if hammerHeld == true:
        hammerHeld = false
    else:
        summoning = true

    var direction_to_cursor = (get_global_mouse_position() - global_position).normalized()
    var opposite_direction = -direction_to_cursor

    hammerVelocity = opposite_direction * hammerThrowForce * hammerCharge
    
func summonHammer(delta):
    canThrow = false
    
    var direction_to_player = (player.global_position - global_position).normalized()
    
    # hammerVelocity += direction_to_player * (summonForce) / (player.global_position.distance_to(global_position) * 0.01)
    hammerVelocity += direction_to_player * (summonForce) * delta


func _on_body_entered(body:Node2D):
    if body.is_in_group("Player"):
        if summoning:
            summoning = false
            canThrow = true
            hammerHeld = true
            scoreKeeper.applyPoints()
    
    

func _on_area_entered(area:Area2D):
    if area.is_in_group("Enemy"):
        if not hammerHeld:
            area.get_parent().getHurt(hammerVelocity, hammerThrowForce)