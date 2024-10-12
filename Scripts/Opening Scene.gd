extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Game.tscn")


func _on_easy_pressed():
	GameManager.Difficulty_value = 12
	


func _on_medium_pressed():
	GameManager.Difficulty_value = 18


func _on_hard_pressed():
	GameManager.Difficulty_value = 24
