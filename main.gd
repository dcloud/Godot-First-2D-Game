extends Node

@export var mob_scene: PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$DeathSound.play()
	$HUD.show_game_over()
	$Music.stop()

func new_game():
	# Remove old creeps before starting new game
	get_tree().call_group("mobs", "queue_free")
	# Reset score, show message, start timer
	score = 0
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$Music.play()


func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()


func _on_mob_timer_timeout():
	# Create a mob instance
	var mob = mob_scene.instantiate()

	# Choose a random location on MobPath
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	mob.position = mob_spawn_location.position

	# Add some randomness to the direction
	direction += randf_range(-PI /4, PI / 4)
	mob.rotation = direction

	# Choose mob velocity
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# spawn mob by adding to scene
	add_child(mob)
