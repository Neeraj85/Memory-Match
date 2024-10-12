extends GridContainer

var fruits = ["acron", "apple", "green apple", "banana", "cherry", "eggs", "egg", "green grape", "hearth", "pink hearth", "green leaf", "yellow leaf", "lemon", "lime", "orange", "peanut", "peer", "pineapple", "plum", "potato", "red grape", "strawberry", "walnut", "watermelon"]
var positions = []
var fruit_position_one
var fruit_position_two
var textures = []
var dict : Array
var previous_fruit : String
var ele_to_be_cleared_1
var ele_to_be_cleared_2
var boxes_clicked = 0
var my_number
var previous_number
@onready var label = $"HUD/HUD VBox/Label"
@onready var matches = $"HUD/HUD VBox/Matches"
var matches_count = 0
@onready var victory_screen = $"HUD/Victory Screen"


# Called when the node enters the scene tree for the first time.
func _ready():
	victory_screen.hide()
	for i in range(GameManager.Difficulty_value *2):
		positions.append(i)
	if GameManager.Difficulty_value == 12:
		for i in range(25, 49):
			get_node("Element%d" %i).queue_free()
	
	if GameManager.Difficulty_value == 18:
		for i in range(37, 49):
			get_node("Element%d" %i).queue_free()
	#dict = {"Fruit" : "Apple",
			#"position one" : random_position_generator(),
			#"position two" : random_position_generator()}
				
	# Load textures into the array
	for i in range(1, GameManager.Difficulty_value+1):
		textures.append(load("res://Assets/Graphics/Fruits and veggies/%d.png" %i))
	# Loop through the buttons and assign textures
	for i in range(0, GameManager.Difficulty_value):
		var rand_pos1 = random_position_generator()
		var rand_pos2 = random_position_generator()
		var element1 = get_node("Element%d/Fruit" %rand_pos1)
		var element2 = get_node("Element%d/Fruit" %rand_pos2)
		var element1_text = get_node("Element%d" %rand_pos1)
		var element2_text = get_node("Element%d" %rand_pos2)
		element1_text.my_number = rand_pos1
		element2_text.my_number = rand_pos2
		element1_text.my_fruit = fruits[i]
		element2_text.my_fruit = fruits[i]
		var t_array = [fruits[i], rand_pos1, rand_pos2]
		dict.insert(i, t_array)
		#dict.append(fruits[i], rand_pos1, rand_pos2)
		#dict(i).append(rand_pos1)
		#dict[i].append(rand_pos2)
		#
		#{"Fruit" : fruits[i],
				#"Position One" : rand_pos1,
				#"Position Two" : rand_pos2}
		if element1 and element2:
			element1.set("texture", textures[i])  # Assign the texture to the button
			element2.set("texture", textures[i])

func random_position_generator():
	var position = positions[randi() % positions.size()]
	positions.erase(position)
	return position+1
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	label.text = "Tiles Turned: %d" %boxes_clicked
	matches.text = "Pairs Matched: %d" %matches_count
	
		
	
func check_for_victory():
	if matches_count == GameManager.Difficulty_value:
		await get_tree().create_timer(2.0).timeout
		$Victory.play()
		victory_screen.show()

func update_fruit(fruit_name, my_number):
	if fruit_name == previous_fruit and my_number != previous_number:
		match_found_clear_cells(fruit_name)
	previous_fruit = fruit_name
	previous_number = my_number
	check_for_victory()

func match_found_clear_cells(fruit_to_be_cleared):
	$Match.play()
	matches_count += 1
	for eles in dict:
		if eles[0] == fruit_to_be_cleared:
			ele_to_be_cleared_1 = eles[1]
			ele_to_be_cleared_2 = eles[2]
	await get_tree().create_timer(1.0).timeout
	get_node("Element%d/Background" %ele_to_be_cleared_1).set("texture", null)
	get_node("Element%d/Fruit" %ele_to_be_cleared_1).set("texture", null)
	get_node("Element%d/Curtain" %ele_to_be_cleared_1).set("texture", null)
	get_node("Element%d/Background" %ele_to_be_cleared_2).set("texture", null)
	get_node("Element%d/Fruit" %ele_to_be_cleared_2).set("texture", null)
	get_node("Element%d/Curtain" %ele_to_be_cleared_2).set("texture", null)
	get_node("Element%d" %ele_to_be_cleared_1).disabled = true
	get_node("Element%d" %ele_to_be_cleared_2).disabled = true
	
	


func _on_retry_button_pressed():
	get_tree().reload_current_scene()


func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/Opening Scene.tscn")
