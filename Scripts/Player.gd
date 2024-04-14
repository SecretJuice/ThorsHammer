extends CharacterBody2D

var speed = 300

var invulnerable = false
var invuln_time = .75
var invuln_timer = 0

var dir = Vector2(0, 0)

var bob = 0

var scoreKeeper: Node2D = null

@onready var sprite: Sprite2D = $PlayerSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Player")
	scoreKeeper = get_node("../PlayerFollower/ScoreKeeper")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if invuln_timer > 0:
		invuln_timer -= delta
		if invuln_timer <= 0:
			invulnerable = false

	# animate_sprite(delta)


func _physics_process(delta):
	dir = Vector2(0, 0)

	if Input.is_key_pressed(KEY_D):
		# Move as long as the key/button is pressed.
		dir.x += 1
	if Input.is_key_pressed(KEY_A):
		# Move as long as the key/button is pressed.
		dir.x -= 1
	if Input.is_key_pressed(KEY_W):
		# Move as long as the key/button is pressed.
		dir.y -= 1
	if Input.is_key_pressed(KEY_S):
		# Move as long as the key/button is pressed.
		dir.y += 1
	
	dir = dir.normalized() * speed
	velocity = velocity.lerp(dir, 6 * delta)

	animate_sprite(delta)

	move_and_slide()

func animate_sprite(delta):

	var amplitude = 4
	var frequency = 15

	if dir != Vector2.ZERO:

		var displacement = amplitude * sin(frequency * (float)(Time.get_ticks_msec()) / 1000)

		sprite.rotation_degrees = displacement
		sprite.position.y = displacement
		sprite.position.x = displacement
	else:

		sprite.position = sprite.position.lerp(Vector2.ZERO, 4 * delta)
		sprite.rotation = lerp(sprite.rotation, (float)(0), 8 * delta)

func hurt(direction: Vector2):

	if not invulnerable:
		invuln_timer = invuln_time

		invulnerable = true

		velocity += direction.normalized() * 650
		scoreKeeper.resetMultiplier()
		print("PLAYER OUCH")

