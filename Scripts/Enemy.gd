extends CharacterBody2D

@export var hurtSound: AudioStream = null
var deathSoundsPaths: Array[String] = ["deathsound-01.mp3", "deathsound-02.mp3", "deathsound-03.mp3"
	, "deathsound-04.mp3", "deathsound-05.mp3", "deathsound-06.mp3"]

var scoreKeeper: Node2D = null

var player
var audioManager

@export var health:float = 750
var living:bool = true

# var velocity: Vector2 = Vector2.ZERO

@export var speed: float  = 100
var involneralble = false

@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D
@onready var sprite: Sprite2D = $EnemySprite
@onready var deadSprite: Sprite2D = $DeadSprite

var involn_timer = 0
var involn_time = 0.5
# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("../Player")
	audioManager = get_node("../AudioManager")
	scoreKeeper = get_node("../PlayerFollower/ScoreKeeper")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):

	var dir: Vector2 = to_local(nav_agent.get_next_path_position()).normalized()


	if not involneralble and living:
		velocity = velocity.lerp(dir * speed, 4 * delta)
	else:
		velocity = velocity.lerp(Vector2.ZERO, 4 * delta)

	# global_position += velocity * delta

	move_and_slide()
	_process_physics_collisions()
	animate_sprite(delta)

func make_path():
	nav_agent.target_position = player.global_position


func _process_physics_collisions():

	if not living:
		return

	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)

		if collision.get_collider().is_in_group("Player"):
			var dir = global_position.direction_to(collision.get_collider().global_position)
			collision.get_collider().hurt(dir)
			

func _process(delta):
	involn_timer -= delta

	if involn_timer <= 0:
		involneralble = false


func getHurt(hammerVel: Vector2, hammerThrowForce: float):

	if not involneralble and living:

		involneralble = true
		involn_timer = involn_time

		var hitForce: float = (hammerVel.length() / hammerThrowForce) * 1000

		print(hitForce)

		velocity += hammerVel.normalized() * hitForce

		audioManager.play_sound(hurtSound)

		scoreKeeper.addMultiplier(0.5)
		scoreKeeper.addNewPoints((int)(hitForce))
		takeDamage(hitForce)

func takeDamage(damage: float):
	health -= damage
	if health <= 0:
		die()

func die():
	living = false
	set_collisions_enabled(self, false)
	z_index = -1
	sprite.visible = false
	deadSprite.visible = true

	var path = "res://Audio/" + deathSoundsPaths[randi() % deathSoundsPaths.size()]
	audioManager.play_from_path(path)

func hurtPlayer():
	player.hurt()

func _on_timer_timeout():
	make_path()

func animate_sprite(delta):

	var amplitude = 4
	var frequency = 8

	if not involneralble and living:

		var displacement = amplitude * sin(frequency * (float)(Time.get_ticks_msec()) / 1000)

		sprite.rotation_degrees = displacement
		sprite.position.y = displacement
		sprite.position.x = displacement
	else:

		sprite.position = sprite.position.lerp(Vector2.ZERO, 4 * delta)
		sprite.rotation = lerp(sprite.rotation, (float)(0), 8 * delta)
	
func set_collisions_enabled(node, enabled):
	if enabled:
		if node.has_meta("col_mask"):
			node.collision_mask = node.get_meta("col_mask")
			node.collision_layer = node.get_meta("col_layer")
	else:
			node.set_meta("col_mask", node.collision_mask)
			node.set_meta("col_layer", node.collision_layer)
			node.collision_mask = 0
			node.collision_layer = 0