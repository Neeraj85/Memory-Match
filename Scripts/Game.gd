extends Control

#A variable that will hold the panel image in it. 
#This variable will be used whenever the element image has to be replaced with tile image.
var panel_image = load("res://Assets/Graphics/Panel/Panel.png")

#An array with names of each of the fruit and vegetable.
var fruits = ["acron", "apple", "green apple", "banana", "cherry", "eggs", "egg", "green grape", "hearth", "pink hearth", "green leaf", "yellow leaf", "lemon", "lime", "orange", "peanut", "peer", "pineapple", "plum", "potato", "red grape", "strawberry", "walnut", "watermelon"]

#An array for the positions of each of the element, from 1 to 48. On the basis of this array each of the element(button) would be assigned a number.
var positions = []

#An array which would hold the path of each of the image, this array would be used later to assign the image to the buttons.
var textures = []

#An array which would hold the newly assigned fruit name and their both the positions.
var array_with_name_and_positions : Array

#A variable which would keep count of all the matches being made.var matches_count = 0
var matches_count = 0

#Variable for the VBox container that holds the Labels which would get dispalyed once the game is won.
@onready var victory_screen = $"HUD/Victory Screen"

#Variable with the first position of the matched fruit
var Matched_fruit_position_1

#Variable with the second position of the matched fruit
var Matched_fruit_position_2

#Variable that will hold the fruit name of the last element that was clicked.
var previous_fruit

#Variable that will hold the number of the Element which was last clicked.
var previous_element_name

#A variable for the label which is supposed to display the count of the tiles turned.
@onready var tiles_turned_label = $"HUD/HUD VBox/Label"

#A variable which is supposed to display the count of tiles correctly matched
@onready var matches = $"HUD/HUD VBox/Matches"

#A variable which will count the number of times various elements/tiles have been clicked.
var tiles_turned = 0

@onready var match = $Match

var last_check_match

# Called when the node enters the scene tree for the first time.
func _ready():
	
	#Display the number of tiles turned initially, which would be 0.
	tiles_turned_label.text = "Tiles Turned: %d" %tiles_turned
	
	#Displaying the number of matches when the game gets initialized, which is 0
	matches.text = "Pairs Matched: %d" %matches_count
	
	#Victory screen hidden at the beginning of the game.
	victory_screen.hide()
	
	#Creating an array with the name positions, this will hold values equal to total number of elements in the game.
	#The values of this array will vary according to the difficulty level selected
	if GameManager.Difficulty_value == 12:
		
		#Array which will hold values from 0 to 23
		positions = range(0, 24)
		
		#A loop that will clear the elements from 25 to 48
		for i in range(25, 49):
			get_node("Container/Element%d" %i).queue_free()
			
	elif GameManager.Difficulty_value == 18:
		
		#Array which will hold values from 0 to 35
		positions = range(0, 36)
		
		#A loop that will clear the elements from 37 to 48
		for i in range(37, 49):
			get_node("Container/Element%d" %i).queue_free()
			
	elif GameManager.Difficulty_value == 24:
		
		#Array which will hold values from 0 to 47
		positions = range(0, 48)
	
	#A loop to load textures of the fruits to an array named textures
	#Depending on the difficulty level the number of textures to be loaded.	
	#Since the file name for the images start with 1, the loop also starts with 1 and goes till +1 of the difficulty level.
	for i in range(1, GameManager.Difficulty_value+1):
		var image = load("res://Assets/Graphics/Fruits and veggies/%d.png" %i)
		
		#Each image is appended to the array named textures.
		#The values are appended because since the loop starts with 1, accessing the 0 index number would have been challenging
		textures.append(image)


	for i in range(0, GameManager.Difficulty_value):
		#Firstly two random positions are generated, using the random_position_generator function.
		#random_position_generator function takes into account the game difficulty value.
		#For game difficulty of 12, it generates 24 random positions.
		#This means the first 12 fruits in the array fruits, get assigned two positions from 1 to 24
		#Each of the fruit gets assigned two random position from 1 to 24.
		
		#A variable to hold random positions for a short while which are generated using the positions array
		#It will return a value between 1 to twice the difficulty level.
		var rand_pos1 = random_position_generator()
		
		
		#A variable to hold random positions for a short while which are generated using the positions array
		#It will return a value between 1 to twice the difficulty level.
		var rand_pos2 = random_position_generator()
		
		
		#The first button is selected whose position has been generated randomly by the function.
		var element1 = get_node("Container/Element%d" %rand_pos1)
		
		#The Second button is selected whose position has been generated randomly by the function.
		var element2 = get_node("Container/Element%d" %rand_pos2)
		
		#var element1_text = get_node("Element%d" %rand_pos1)
		#var element2_text = get_node("Element%d" %rand_pos2)
		#element1_text.my_number = rand_pos1
		#element2_text.my_number = rand_pos2
		
		#Fruit name is assigned through the fruits array.
		#Fruits array and texture array are identical.
		element1.my_fruit = fruits[i]
		element2.my_fruit = fruits[i]
		
		#The texture that corresponds to that fruit array is fed into a variable that is present inside the button script.
		#Two different buttons are fed the same texture.
		element1.my_number = textures[i]
		element2.my_number = textures[i]
		
		#A temporary array is created, this will hold the name of the fruit, its random position 1 and random position 2.
		var t_array = [fruits[i], rand_pos1, rand_pos2]
		
		#The temporary array is inserted in another array.
		array_with_name_and_positions.insert(i, t_array)
		
		
	#A for loop is used that loops from 1 to 49. It sets the icon to the icon panel.
	for i in range(1, 49):
		get_node("Container/Element%d" %i).set("icon", panel_image)

#A function for generation of the random positions for the fruits, which would later be aloted to them.
func random_position_generator():
	var position = positions[randi() % positions.size()]
	
	#As soon as a position is generated, it gets erased from the positions array, so that it doesn't get generated again.
	#Through the erase function, the specific value can be erased from the positions array
	positions.erase(position)
	
	#Since it will not generate the position from 1 to 48, but from 0 to 47, One has to be added to the return value.
	return position+1

#This function will be called whenever any element is clicked.
#The arguments of this function are the name of the fruit that is stored in that element and the number stored in that element.
func Element_clicked(fruit_name_of_current_element, element_name):
	
	#The name of the fruit is in the argument fruit_name_of_current_element.
	#The number of the element is stored in the variable element_number_of_current_element
	if fruit_name_of_current_element == previous_fruit and element_name != previous_element_name:
		last_check_match = true
		
		#It is checked whether the fruit name of current element is same as the fruit name of the previosuly clicked element.
		#It is checked whether the element number of current element is not same as the element number of the previously clicked element.
		
		#If the names of the fruits match but the element number don't match then the following code is executed.
		match_found_clear_cells(fruit_name_of_current_element)
		
		#This function is called when the fruit is same in both the elements.
		#It takes the fruit name as argument.
	
	#As preparation for the next click, the current fruit name becomes the previous fruit
	#As preparation for the next click the current element number becomes the previous element number.
	
	else:
		last_check_match = false
	
	previous_fruit = fruit_name_of_current_element
	previous_element_name = element_name
	
	

#A function for checking for victory after all the tiles have been correctly matched
func check_for_victory():
	
	#The following if statement would be checking whether all the pairs have been matched or not
	if matches_count == GameManager.Difficulty_value:
		
		#In case all the pairs have been matched, the victory screen would be displayed with a delay of 2 seconds
		await get_tree().create_timer(2.0).timeout
		
		#The victory audio would be played
		$Victory.play()
		
		#The victory screen Vbox would be displayed
		victory_screen.show()


#Function to clear the elements once a match has been confirmed through another function.
func match_found_clear_cells(fruit_to_be_cleared):
	
	#Sound to be played once there is a match
	$Match.play()
	
	#Increasing the match count by one after every correct match.
	matches_count += 1
	
	#Updating the text in HUD with the new match count.
	matches.text = "Pairs Matched: %d" %matches_count
	
	#The array is an array of arrays, each index position holds arrays with three elements, first is the name of the fruit, second is one of the position, and third is the second position
	for sub_array in array_with_name_and_positions:
		
		#The name of the fruit will be checked, and if it doesn't match then the next iteration would be run.
		#If the name of the fruit matches, then both of its positions would be checked
		if sub_array[0] == fruit_to_be_cleared:
			await get_tree().create_timer(1).timeout
			#The first position of the fruit is assigned to ele_to_be_cleared_1
			Matched_fruit_position_1 = sub_array[1]
			print(Matched_fruit_position_1)
			#get_node("Container/Element%d" %Matched_fruit_position_1).queue_free()
			#get_node("Container/Element%d" %Matched_fruit_position_1).disabled = true
			get_node("Container/Element%d" %Matched_fruit_position_1).icon = null
			#The second position of the fruit is assigned to ele_to_be_cleared_2
	
	
			Matched_fruit_position_2 = sub_array[2]
			print(Matched_fruit_position_2)
			#get_node("Container/Element%d" %Matched_fruit_position_2).queue_free()
			#get_node("Container/Element%d" %Matched_fruit_position_2).disabled = true
			get_node("Container/Element%d" %Matched_fruit_position_2).icon = null
			
	#Calling the function to check for victory after a tile has been turned
	check_for_victory()
	

#On retry button pressed from the Victory scene
func _on_retry_button_pressed():
	
	#Reload the current scene
	get_tree().reload_current_scene()


#On Main menu button being pressed from the victory scene
func _on_main_menu_pressed():
	
	#Load the opening scene of the game.
	get_tree().change_scene_to_file("res://Scenes/Opening Scene.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	


func _on_element_1_toggled(toggled_on):
	
	if toggled_on:
		
		get_node("Container/Element1").icon = get_node("Container/Element1").my_number
		
		#Playing the sound of turning tile
		$Turn.play()
		
		#Calling the Element_clicked function after every click. It will further check for a match.
		Element_clicked($Container/Element1.my_fruit, $Container/Element1.name)
			
		#Increasing the value of tiles turned by one every time a tile is clicked.
		tiles_turned += 1
		
		#Updating the label which is displaying the number of tiles that have been clicked.
		tiles_turned_label.text = "Tiles Turned: %d" %tiles_turned
		
		
		await get_tree().create_timer(1.0).timeout
		
		if not last_check_match:
			get_node("Container/Element1").set("icon", panel_image)
	
	#if not toggled_on:
		#get_node("Container/Element1").set("icon", panel_image)

func _on_element_2_toggled(toggled_on):
	
	#Increasing the value of tiles turned by one every time a tile is clicked.
	
	
	
	
	
	
	if toggled_on:

		get_node("Container/Element2").icon = get_node("Container/Element2").my_number
		
		#Playing the sound of turning tile
		$Turn.play()
	
		#Calling the Element_clicked function after every click. It will further check for a match.
		Element_clicked($Container/Element2.my_fruit, $Container/Element2.name)
	
		tiles_turned += 1
		
		#Updating the label which is displaying the number of tiles that have been clicked.
		tiles_turned_label.text = "Tiles Turned: %d" %tiles_turned
		

		await get_tree().create_timer(1.0).timeout
		
		if not last_check_match:
				get_node("Container/Element2").set("icon", panel_image)
		#
	#if not toggled_on:
		#get_node("Container/Element2").set("icon", panel_image)



func _on_element_3_toggled(toggled_on):
	
	
	
	
	
	
	
	
	
	if toggled_on:
		
		Element_clicked($Container/Element3.my_fruit, $Container/Element3.name)
		#Playing the sound of turning tile
		$Turn.play()
		
		#Increasing the value of tiles turned by one every time a tile is clicked.
		tiles_turned += 1
	
		#Updating the label which is displaying the number of tiles that have been clicked.
		tiles_turned_label.text = "Tiles Turned: %d" %tiles_turned
	
		#Calling the Element_clicked function after every click. It will further check for a match.
		
		
		get_node("Container/Element3").icon = get_node("Container/Element3").my_number
		await get_tree().create_timer(1).timeout
		
		if not last_check_match:
			get_node("Container/Element3").set("icon", panel_image)
		
	#if not toggled_on:
		#get_node("Container/Element3").set("icon", panel_image)


func _on_element_4_toggled(toggled_on):
	
	if toggled_on:
	
		Element_clicked($Container/Element4.my_fruit, $Container/Element4.name)
	
		#Playing the sound of turning tile
		$Turn.play()
		
		#Increasing the value of tiles turned by one every time a tile is clicked.
		tiles_turned += 1
	
		#Updating the label which is displaying the number of tiles that have been clicked.
		tiles_turned_label.text = "Tiles Turned: %d" %tiles_turned
	
		#Calling the Element_clicked function after every click. It will further check for a match.
		
		
		get_node("Container/Element4").icon = get_node("Container/Element4").my_number
		await get_tree().create_timer(1).timeout
		if not last_check_match:
			get_node("Container/Element4").set("icon", panel_image)
	
	#if not toggled_on:
		#get_node("Container/Element4").set("icon", panel_image)
	#

func _on_element_5_toggled(toggled_on):
	
	
	
	
	
	
	
	
	
	if toggled_on:
		
		get_node("Container/Element5").icon = get_node("Container/Element5").my_number
		
		Element_clicked($Container/Element5.my_fruit, $Container/Element5.name)	
		
		#Playing the sound of turning tile
		$Turn.play()
	
		#Increasing the value of tiles turned by one every time a tile is clicked.
		tiles_turned += 1
	
		#Updating the label which is displaying the number of tiles that have been clicked.
		tiles_turned_label.text = "Tiles Turned: %d" %tiles_turned
	
		#Calling the Element_clicked function after every click. It will further check for a match.
		
		
		await get_tree().create_timer(1).timeout
		if not last_check_match:
			get_node("Container/Element5").set("icon", panel_image)
		
	#if not toggled_on:
		#get_node("Container/Element5").set("icon", panel_image)
	
func _on_element_6_toggled(toggled_on):
	
	
	
	
	
	
	
	
	
	if toggled_on:
	
		get_node("Container/Element6").icon = get_node("Container/Element6").my_number
		
		Element_clicked($Container/Element6.my_fruit, $Container/Element6.name)
	
		#Playing the sound of turning tile
		$Turn.play()
			
		#Increasing the value of tiles turned by one every time a tile is clicked.
		tiles_turned += 1
	
		#Updating the label which is displaying the number of tiles that have been clicked.
		tiles_turned_label.text = "Tiles Turned: %d" %tiles_turned
	
		#Calling the Element_clicked function after every click. It will further check for a match.
		
		
		
		await get_tree().create_timer(1).timeout
		if not last_check_match:
			get_node("Container/Element6").set("icon", panel_image)
		
	#if not toggled_on:
		#get_node("Container/Element6").set("icon", panel_image)
	

func _on_element_7_toggled(toggled_on):
	
	
	
	
	
	
	
	
	
	if toggled_on:
	
		get_node("Container/Element7").icon = get_node("Container/Element7").my_number
	
		Element_clicked($Container/Element7.my_fruit, $Container/Element7.name)
	
		#Playing the sound of turning tile
		$Turn.play()
	
		#Increasing the value of tiles turned by one every time a tile is clicked.
		tiles_turned += 1
	
		#Updating the label which is displaying the number of tiles that have been clicked.
		tiles_turned_label.text = "Tiles Turned: %d" %tiles_turned
	
		#Calling the Element_clicked function after every click. It will further check for a match.
		
	
		
		await get_tree().create_timer(1).timeout
		toggled_on = false
		
		if not last_check_match:
			get_node("Container/Element7").set("icon", panel_image)
	

func _on_element_8_toggled(toggled_on):
	
	
	
	
	
	
	
	
	
	if toggled_on:
			
		get_node("Container/Element8").icon = get_node("Container/Element8").my_number
			
		Element_clicked($Container/Element8.my_fruit, $Container/Element8.name)
	
		#Playing the sound of turning tile
		$Turn.play()
	
		#Increasing the value of tiles turned by one every time a tile is clicked.
		tiles_turned += 1
	
		#Updating the label which is displaying the number of tiles that have been clicked.
		tiles_turned_label.text = "Tiles Turned: %d" %tiles_turned
	
		#Calling the Element_clicked function after every click. It will further check for a match.
		
	
		
		await get_tree().create_timer(1).timeout
		toggled_on = false
		
		if not last_check_match:
			get_node("Container/Element8").set("icon", panel_image)


func _on_element_9_toggled(toggled_on):
	
	
	
	
	
	
	
	
	
	if toggled_on:
		
		get_node("Container/Element9").icon = get_node("Container/Element9").my_number
		
		Element_clicked($Container/Element9.my_fruit, $Container/Element9.name)
	
		#Playing the sound of turning tile
		$Turn.play()
	
		#Increasing the value of tiles turned by one every time a tile is clicked.
		tiles_turned += 1
	
		#Updating the label which is displaying the number of tiles that have been clicked.
		tiles_turned_label.text = "Tiles Turned: %d" %tiles_turned
	
		#Calling the Element_clicked function after every click. It will further check for a match.
		
	
		
		await get_tree().create_timer(1).timeout
		toggled_on = false
		
		if not last_check_match:
			get_node("Container/Element9").set("icon", panel_image)

func _on_element_10_toggled(toggled_on):
	
	
	
	
	
	
	
	
	
	if toggled_on:
		
		Element_clicked($Container/Element10.my_fruit, $Container/Element10.name)
		
		#Playing the sound of turning tile
		$Turn.play()
	
		#Increasing the value of tiles turned by one every time a tile is clicked.
		tiles_turned += 1
	
		#Updating the label which is displaying the number of tiles that have been clicked.
		tiles_turned_label.text = "Tiles Turned: %d" %tiles_turned
	
		#Calling the Element_clicked function after every click. It will further check for a match.
		
	
		get_node("Container/Element10").icon = get_node("Container/Element10").my_number
		await get_tree().create_timer(1).timeout
		toggled_on = false
	
		if not last_check_match:
			get_node("Container/Element10").set("icon", panel_image)
		


func _on_element_11_toggled(toggled_on):
	
	
	
	
	
		
	
	if toggled_on:
	
		Element_clicked($Container/Element11.my_fruit, $Container/Element11.name)
	
		#Playing the sound of turning tile
		$Turn.play()
	
		#Increasing the value of tiles turned by one every time a tile is clicked.
		tiles_turned += 1

		#Updating the label which is displaying the number of tiles that have been clicked.
		tiles_turned_label.text = "Tiles Turned: %d" %tiles_turned

		#Calling the Element_clicked function after every click. It will further check for a match.
		

	
		get_node("Container/Element11").icon = get_node("Container/Element11").my_number
		await get_tree().create_timer(1).timeout
		toggled_on = false
	
	
		if not last_check_match:
			get_node("Container/Element11").set("icon", panel_image)


func _on_element_12_toggled(toggled_on):
	
	
	
	
	
	
	
	
	
	if toggled_on:
	
		Element_clicked($Container/Element12.my_fruit, $Container/Element12.name)
	
		#Playing the sound of turning tile
		$Turn.play()
	
		#Increasing the value of tiles turned by one every time a tile is clicked.
		tiles_turned += 1
	
		#Updating the label which is displaying the number of tiles that have been clicked.
		tiles_turned_label.text = "Tiles Turned: %d" %tiles_turned
	
		#Calling the Element_clicked function after every click. It will further check for a match.
		
	
		get_node("Container/Element12").icon = get_node("Container/Element12").my_number
		await get_tree().create_timer(1).timeout
		
		if not last_check_match:
			get_node("Container/Element12").set("icon", panel_image)


func _on_element_13_toggled(toggled_on):
	
	
	
	
	
	
	
	
	
	if toggled_on:
	
		#Playing the sound of turning tile
		$Turn.play()
	
		#Increasing the value of tiles turned by one every time a tile is clicked.
		tiles_turned += 1
	
		#Updating the label which is displaying the number of tiles that have been clicked.
		tiles_turned_label.text = "Tiles Turned: %d" %tiles_turned
	
		get_node("Container/Element13").icon = get_node("Container/Element13").my_number
	
		#Calling the Element_clicked function after every click. It will further check for a match.
		Element_clicked($Container/Element13.my_fruit, $Container/Element13.name)
	
		
		await get_tree().create_timer(1).timeout
		toggled_on = false
	
		if not last_check_match:
			get_node("Container/Element13").set("icon", panel_image)


func _on_element_14_toggled(toggled_on):
		
	
	
	
	
	
	
	
		
	if toggled_on:	
	
		#Playing the sound of turning tile
		$Turn.play()
		
		#Increasing the value of tiles turned by one every time a tile is clicked.
		tiles_turned += 1
		
		#Updating the label which is displaying the number of tiles that have been clicked.
		tiles_turned_label.text = "Tiles Turned: %d" %tiles_turned
	
		get_node("Container/Element14").icon = get_node("Container/Element14").my_number
	
		#Calling the Element_clicked function after every click. It will further check for a match.
		Element_clicked($Container/Element14.my_fruit, $Container/Element14.name)
		
		
		await get_tree().create_timer(1).timeout
		toggled_on = false
	
		if not last_check_match:
			get_node("Container/Element14").set("icon", panel_image)


func _on_element_15_toggled(toggled_on):
	
	
	
	
	if toggled_on:
		
		
		#Playing the sound of turning tile
		$Turn.play()
		
		get_node("Container/Element15").icon = get_node("Container/Element15").my_number
		
		#Calling the Element_clicked function after every click. It will further check for a match.
		Element_clicked($Container/Element15.my_fruit, $Container/Element15.name)
		
		#Increasing the value of tiles turned by one every time a tile is clicked.
		tiles_turned += 1
		
		
		#Updating the label which is displaying the number of tiles that have been clicked.
		tiles_turned_label.text = "Tiles Turned: %d" %tiles_turned
			
		
		
		await get_tree().create_timer(1).timeout
		toggled_on = false
	
		if not last_check_match:
			get_node("Container/Element15").set("icon", panel_image)


func _on_element_16_toggled(toggled_on):
	
	
	
	
	
	if toggled_on:
		
		#Playing the sound of turning tile
		$Turn.play()
	
		#Increasing the value of tiles turned by one every time a tile is clicked.
		tiles_turned += 1
	
		#Updating the label which is displaying the number of tiles that have been clicked.
		tiles_turned_label.text = "Tiles Turned: %d" %tiles_turned
	
		get_node("Container/Element16").icon = get_node("Container/Element16").my_number
		
		#Calling the Element_clicked function after every click. It will further check for a match.
		Element_clicked($Container/Element16.my_fruit, $Container/Element16.name)
		
		
		await get_tree().create_timer(1).timeout
		toggled_on = false
	
		if not last_check_match:
			get_node("Container/Element16").set("icon", panel_image)


func _on_element_17_toggled(toggled_on):
	
	
	
	
	
	if toggled_on:
	
		#Playing the sound of turning tile
		$Turn.play()
	
		#Increasing the value of tiles turned by one every time a tile is clicked.
		tiles_turned += 1
	
		#Updating the label which is displaying the number of tiles that have been clicked.
		tiles_turned_label.text = "Tiles Turned: %d" %tiles_turned
	
		get_node("Container/Element17").icon = get_node("Container/Element17").my_number
	
		#Calling the Element_clicked function after every click. It will further check for a match.
		Element_clicked($Container/Element17.my_fruit, $Container/Element17.name)
	
		
		await get_tree().create_timer(1).timeout
		toggled_on = false
	
		if not last_check_match:
			get_node("Container/Element17").set("icon", panel_image)


func _on_element_18_toggled(toggled_on):
	
	
	
	
	
	if toggled_on:
		
		#Playing the sound of turning tile
		$Turn.play()
	
		#Increasing the value of tiles turned by one every time a tile is clicked.
		tiles_turned += 1
	
		#Updating the label which is displaying the number of tiles that have been clicked.
		tiles_turned_label.text = "Tiles Turned: %d" %tiles_turned
		get_node("Container/Element18").icon = get_node("Container/Element18").my_number
		#Calling the Element_clicked function after every click. It will further check for a match.
		Element_clicked($Container/Element18.my_fruit, $Container/Element18.name)
		
		
		await get_tree().create_timer(1).timeout
		toggled_on = false
	
		if not last_check_match:
			get_node("Container/Element18").set("icon", panel_image)


func _on_element_19_toggled(toggled_on):
	
	
	
	
	
	if toggled_on:
		
		#Playing the sound of turning tile
		$Turn.play()
	
		#Increasing the value of tiles turned by one every time a tile is clicked.
		tiles_turned += 1
	
		#Updating the label which is displaying the number of tiles that have been clicked.
		tiles_turned_label.text = "Tiles Turned: %d" %tiles_turned
		get_node("Container/Element19").icon = get_node("Container/Element19").my_number
		#Calling the Element_clicked function after every click. It will further check for a match.
		Element_clicked($Container/Element19.my_fruit, $Container/Element19.name)
		
		
		await get_tree().create_timer(1).timeout
		toggled_on = false
	
		if not last_check_match:
			get_node("Container/Element19").set("icon", panel_image)


func _on_element_20_toggled(toggled_on):
	
	
	
	
	
	if toggled_on:
	
		#Playing the sound of turning tile
		$Turn.play()
	
		#Increasing the value of tiles turned by one every time a tile is clicked.
		tiles_turned += 1
	
		#Updating the label which is displaying the number of tiles that have been clicked.
		tiles_turned_label.text = "Tiles Turned: %d" %tiles_turned
		get_node("Container/Element20").icon = get_node("Container/Element20").my_number
		#Calling the Element_clicked function after every click. It will further check for a match.
		Element_clicked($Container/Element20.my_fruit, $Container/Element20.name)
	
		
		await get_tree().create_timer(1).timeout
		toggled_on = false
	
		if not last_check_match:
			get_node("Container/Element20").set("icon", panel_image)


func _on_element_21_toggled(toggled_on):
	
	
	
	
	if toggled_on:
		
		#Playing the sound of turning tile
		$Turn.play()
	
		#Increasing the value of tiles turned by one every time a tile is clicked.
		tiles_turned += 1
	
		#Updating the label which is displaying the number of tiles that have been clicked.
		tiles_turned_label.text = "Tiles Turned: %d" %tiles_turned
		get_node("Container/Element21").icon = get_node("Container/Element21").my_number
		#Calling the Element_clicked function after every click. It will further check for a match.
		Element_clicked($Container/Element21.my_fruit, $Container/Element21.name)
	
		
		
		await get_tree().create_timer(1).timeout
		toggled_on = false
	
		if not last_check_match:
			get_node("Container/Element21").set("icon", panel_image)


func _on_element_22_toggled(toggled_on):
	
	
	
	
	
	
	
	if toggled_on:
	
		#Playing the sound of turning tile
		$Turn.play()
	
		#Increasing the value of tiles turned by one every time a tile is clicked.
		tiles_turned += 1
	
		#Updating the label which is displaying the number of tiles that have been clicked.
		tiles_turned_label.text = "Tiles Turned: %d" %tiles_turned
		get_node("Container/Element22").icon = get_node("Container/Element22").my_number
		#Calling the Element_clicked function after every click. It will further check for a match.
		Element_clicked($Container/Element22.my_fruit, $Container/Element22.name)
	
		
		await get_tree().create_timer(1).timeout
		toggled_on = false
	
		if not last_check_match:
			get_node("Container/Element22").set("icon", panel_image)


func _on_element_23_toggled(toggled_on):
	
	
	
	
	
	
	if toggled_on:
		
		#Playing the sound of turning tile
		$Turn.play()
	
		#Increasing the value of tiles turned by one every time a tile is clicked.
		tiles_turned += 1
	
		#Updating the label which is displaying the number of tiles that have been clicked.
		tiles_turned_label.text = "Tiles Turned: %d" %tiles_turned
		get_node("Container/Element23").icon = get_node("Container/Element23").my_number
		#Calling the Element_clicked function after every click. It will further check for a match.
		Element_clicked($Container/Element23.my_fruit, $Container/Element23.name)
		
		
		await get_tree().create_timer(1).timeout
		toggled_on = false
	
		if not last_check_match:
			get_node("Container/Element23").set("icon", panel_image)


func _on_element_24_toggled(toggled_on):
	
	
	
	if toggled_on:
		
		#Increasing the value of tiles turned by one every time a tile is clicked.
		tiles_turned += 1
	
		#Playing the sound of turning tile
		$Turn.play()
		get_node("Container/Element24").icon = get_node("Container/Element24").my_number
		#Calling the Element_clicked function after every click. It will further check for a match.
		Element_clicked($Container/Element24.my_fruit, $Container/Element24.name)
	
		#Updating the label which is displaying the number of tiles that have been clicked.
		tiles_turned_label.text = "Tiles Turned: %d" %tiles_turned
		
		
		await get_tree().create_timer(1).timeout
		toggled_on = false
	
		if not last_check_match:
			get_node("Container/Element24").set("icon", panel_image)


func _on_element_25_toggled(toggled_on):
	
	if toggled_on:
		$Turn.play()
		tiles_turned += 1
		tiles_turned_label.text = "Tiles Turned: %d" % tiles_turned
		get_node("Container/Element25").icon = get_node("Container/Element25").my_number
		Element_clicked($Container/Element25.my_fruit, $Container/Element25.name)
		
		await get_tree().create_timer(1).timeout
		toggled_on = false
	
		if not last_check_match:
			get_node("Container/Element25").set("icon", panel_image)


func _on_element_26_toggled(toggled_on):
	
	if toggled_on:
		$Turn.play()
		tiles_turned += 1
		tiles_turned_label.text = "Tiles Turned: %d" % tiles_turned
		get_node("Container/Element26").icon = get_node("Container/Element26").my_number
		Element_clicked($Container/Element26.my_fruit, $Container/Element26.name)
		
		await get_tree().create_timer(1).timeout
		toggled_on = false
	
		if not last_check_match:
			get_node("Container/Element26").set("icon", panel_image)


func _on_element_27_toggled(toggled_on):
	
	if toggled_on:
		$Turn.play()
		tiles_turned += 1
		tiles_turned_label.text = "Tiles Turned: %d" % tiles_turned
		get_node("Container/Element27").icon = get_node("Container/Element27").my_number
		Element_clicked($Container/Element27.my_fruit, $Container/Element27.name)
		
		await get_tree().create_timer(1).timeout
		toggled_on = false
	
		if not last_check_match:
			get_node("Container/Element27").set("icon", panel_image)


func _on_element_28_toggled(toggled_on):
	
	if toggled_on:
		$Turn.play()
		tiles_turned += 1
		tiles_turned_label.text = "Tiles Turned: %d" % tiles_turned
		get_node("Container/Element28").icon = get_node("Container/Element28").my_number
		Element_clicked($Container/Element28.my_fruit, $Container/Element28.name)
		
		await get_tree().create_timer(1).timeout
		toggled_on = false
	
		if not last_check_match:
			get_node("Container/Element28").set("icon", panel_image)


func _on_element_29_toggled(toggled_on):
	
	if toggled_on:
		$Turn.play()
		tiles_turned += 1
		tiles_turned_label.text = "Tiles Turned: %d" % tiles_turned
		get_node("Container/Element29").icon = get_node("Container/Element29").my_number
		Element_clicked($Container/Element29.my_fruit, $Container/Element29.name)
		
		await get_tree().create_timer(1).timeout
		toggled_on = false
	
		if not last_check_match:
			get_node("Container/Element29").set("icon", panel_image)


func _on_element_30_toggled(toggled_on):
	
	if toggled_on:
		$Turn.play()
		tiles_turned += 1
		tiles_turned_label.text = "Tiles Turned: %d" % tiles_turned
		get_node("Container/Element30").icon = get_node("Container/Element30").my_number
		Element_clicked($Container/Element30.my_fruit, $Container/Element30.name)

		await get_tree().create_timer(1).timeout
		toggled_on = false
	
		if not last_check_match:
			get_node("Container/Element30").set("icon", panel_image)


func _on_element_31_toggled(toggled_on):
	
	if toggled_on:
		$Turn.play()
		tiles_turned += 1
		tiles_turned_label.text = "Tiles Turned: %d" % tiles_turned
		get_node("Container/Element31").icon = get_node("Container/Element31").my_number
		Element_clicked($Container/Element31.my_fruit, $Container/Element31.name)
		
		await get_tree().create_timer(1).timeout
		toggled_on = false
	
		if not last_check_match:
			get_node("Container/Element31").set("icon", panel_image)


func _on_element_32_toggled(toggled_on):
	
	if toggled_on:
		$Turn.play()
		tiles_turned += 1
		tiles_turned_label.text = "Tiles Turned: %d" % tiles_turned
		get_node("Container/Element32").icon = get_node("Container/Element32").my_number
		Element_clicked($Container/Element32.my_fruit, $Container/Element32.name)
		
		await get_tree().create_timer(1).timeout
		toggled_on = false
	
		if not last_check_match:
			get_node("Container/Element32").set("icon", panel_image)


func _on_element_33_toggled(toggled_on):
	
	if toggled_on:
		$Turn.play()
		tiles_turned += 1
		tiles_turned_label.text = "Tiles Turned: %d" % tiles_turned
		get_node("Container/Element33").icon = get_node("Container/Element33").my_number
		Element_clicked($Container/Element33.my_fruit, $Container/Element33.name)
		
		await get_tree().create_timer(1).timeout
		toggled_on = false
	
		if not last_check_match:
			get_node("Container/Element33").set("icon", panel_image)


func _on_element_34_toggled(toggled_on):
	
	if toggled_on:
		$Turn.play()
		tiles_turned += 1
		tiles_turned_label.text = "Tiles Turned: %d" % tiles_turned
		get_node("Container/Element34").icon = get_node("Container/Element34").my_number
		Element_clicked($Container/Element34.my_fruit, $Container/Element34.name)
		
		await get_tree().create_timer(1).timeout
		toggled_on = false
	
		if not last_check_match:
			get_node("Container/Element34").set("icon", panel_image)


func _on_element_35_toggled(toggled_on):
	
	if toggled_on:
		$Turn.play()
		tiles_turned += 1
		tiles_turned_label.text = "Tiles Turned: %d" % tiles_turned
		get_node("Container/Element35").icon = get_node("Container/Element35").my_number
		Element_clicked($Container/Element35.my_fruit, $Container/Element35.name)
		
		await get_tree().create_timer(1).timeout
		toggled_on = false
	
		if not last_check_match:
			get_node("Container/Element35").set("icon", panel_image)


func _on_element_36_toggled(toggled_on):
	
	if toggled_on:
		$Turn.play()
		tiles_turned += 1
		tiles_turned_label.text = "Tiles Turned: %d" % tiles_turned
		get_node("Container/Element36").icon = get_node("Container/Element36").my_number
		Element_clicked($Container/Element36.my_fruit, $Container/Element36.name)
		
		await get_tree().create_timer(1).timeout
		toggled_on = false
	
		if not last_check_match:
			get_node("Container/Element36").set("icon", panel_image)


func _on_element_37_toggled(toggled_on):
	
	if toggled_on:
		
		#Increasing the value of tiles turned by one every time a tile is clicked.
		tiles_turned += 1
	
		#Playing the sound of turning tile
		$Turn.play()
	
		get_node("Container/Element37").icon = get_node("Container/Element37").my_number
	
		#Calling the Element_clicked function after every click. It will further check for a match.
		Element_clicked($Container/Element37.my_fruit, $Container/Element37.name)
	
		#Updating the label which is displaying the number of tiles that have been clicked.
		tiles_turned_label.text = "Tiles Turned: %d" %tiles_turned

		
		await get_tree().create_timer(1).timeout
		toggled_on = false
	
		if not last_check_match:
			get_node("Container/Element37").set("icon", panel_image)


func _on_element_38_toggled(toggled_on):
	if toggled_on:
		
		#Increasing the value of tiles turned by one every time a tile is clicked.
		tiles_turned += 1
	
		#Playing the sound of turning tile
		$Turn.play()
	
		get_node("Container/Element38").icon = get_node("Container/Element38").my_number
	
		#Calling the Element_clicked function after every click. It will further check for a match.
		Element_clicked($Container/Element38.my_fruit, $Container/Element38.name)
	
		#Updating the label which is displaying the number of tiles that have been clicked.
		tiles_turned_label.text = "Tiles Turned: %d" %tiles_turned

		
		await get_tree().create_timer(1).timeout
		toggled_on = false
	
		if not last_check_match:
			get_node("Container/Element38").set("icon", panel_image)
	


func _on_element_39_toggled(toggled_on):
	
	if toggled_on:
		
		#Increasing the value of tiles turned by one every time a tile is clicked.
		tiles_turned += 1
	
		#Playing the sound of turning tile
		$Turn.play()
		
		get_node("Container/Element39").icon = get_node("Container/Element39").my_number
		
		#Calling the Element_clicked function after every click. It will further check for a match.
		Element_clicked($Container/Element39.my_fruit, $Container/Element39.name)
	
		#Updating the label which is displaying the number of tiles that have been clicked.
		tiles_turned_label.text = "Tiles Turned: %d" %tiles_turned

		
		await get_tree().create_timer(1).timeout
		toggled_on = false
	
		if not last_check_match:
			get_node("Container/Element39").set("icon", panel_image)


func _on_element_40_toggled(toggled_on):
	
	if toggled_on:

		#Increasing the value of tiles turned by one every time a tile is clicked.
		tiles_turned += 1
	
		#Playing the sound of turning tile
		$Turn.play()
	
		get_node("Container/Element40").icon = get_node("Container/Element40").my_number
	
		#Calling the Element_clicked function after every click. It will further check for a match.
		Element_clicked($Container/Element40.my_fruit, $Container/Element40.name)
	
		#Updating the label which is displaying the number of tiles that have been clicked.
		tiles_turned_label.text = "Tiles Turned: %d" %tiles_turned

		
		await get_tree().create_timer(1).timeout
		toggled_on = false
	
		if not last_check_match:
			get_node("Container/Element40").set("icon", panel_image)


func _on_element_41_toggled(toggled_on):
	
	if toggled_on:

		#Increasing the value of tiles turned by one every time a tile is clicked.
		tiles_turned += 1
	
		#Playing the sound of turning tile
		$Turn.play()
		
		get_node("Container/Element41").icon = get_node("Container/Element41").my_number
		
		#Calling the Element_clicked function after every click. It will further check for a match.
		Element_clicked($Container/Element41.my_fruit, $Container/Element41.name)
	
		#Updating the label which is displaying the number of tiles that have been clicked.
		tiles_turned_label.text = "Tiles Turned: %d" %tiles_turned

		
		await get_tree().create_timer(1).timeout
		toggled_on = false
	
		if not last_check_match:
			get_node("Container/Element41").set("icon", panel_image)


func _on_element_42_toggled(toggled_on):
	
	if toggled_on:

		#Increasing the value of tiles turned by one every time a tile is clicked.
		tiles_turned += 1
	
		#Playing the sound of turning tile
		$Turn.play()
	
		get_node("Container/Element42").icon = get_node("Container/Element42").my_number
	
		#Calling the Element_clicked function after every click. It will further check for a match.
		Element_clicked($Container/Element42.my_fruit, $Container/Element42.name)
	
		#Updating the label which is displaying the number of tiles that have been clicked.
		tiles_turned_label.text = "Tiles Turned: %d" %tiles_turned

		
		await get_tree().create_timer(1).timeout
		toggled_on = false
	
		if not last_check_match:
			get_node("Container/Element42").set("icon", panel_image)


func _on_element_43_toggled(toggled_on):
	if toggled_on:


		#Increasing the value of tiles turned by one every time a tile is clicked.
		tiles_turned += 1
	
		#Playing the sound of turning tile
		$Turn.play()
		
		get_node("Container/Element43").icon = get_node("Container/Element43").my_number
		
		#Calling the Element_clicked function after every click. It will further check for a match.
		Element_clicked($Container/Element43.my_fruit, $Container/Element43.name)
	
		#Updating the label which is displaying the number of tiles that have been clicked.
		tiles_turned_label.text = "Tiles Turned: %d" %tiles_turned


		
		await get_tree().create_timer(1).timeout
		toggled_on = false
	
		if not last_check_match:
			get_node("Container/Element43").set("icon", panel_image)


func _on_element_44_toggled(toggled_on):
	
	if toggled_on:

		#Increasing the value of tiles turned by one every time a tile is clicked.
		tiles_turned += 1
	
		#Playing the sound of turning tile
		$Turn.play()
	
		get_node("Container/Element44").icon = get_node("Container/Element44").my_number
	
		#Calling the Element_clicked function after every click. It will further check for a match.
		Element_clicked($Container/Element44.my_fruit, $Container/Element44.name)
	
		#Updating the label which is displaying the number of tiles that have been clicked.
		tiles_turned_label.text = "Tiles Turned: %d" %tiles_turned
		
		await get_tree().create_timer(1).timeout
		toggled_on = false
	
		if not last_check_match:
			get_node("Container/Element44").set("icon", panel_image)


func _on_element_45_toggled(toggled_on):
	
	if toggled_on:

		#Increasing the value of tiles turned by one every time a tile is clicked.
		tiles_turned += 1
	
		#Playing the sound of turning tile
		$Turn.play()
		
		get_node("Container/Element45").icon = get_node("Container/Element45").my_number
		
		#Calling the Element_clicked function after every click. It will further check for a match.
		Element_clicked($Container/Element45.my_fruit, $Container/Element45.name)
	
		#Updating the label which is displaying the number of tiles that have been clicked.
		tiles_turned_label.text = "Tiles Turned: %d" %tiles_turned

		
		await get_tree().create_timer(1).timeout
		toggled_on = false
	
		if not last_check_match:
			get_node("Container/Element45").set("icon", panel_image)


func _on_element_46_toggled(toggled_on):
	if toggled_on:

		#Increasing the value of tiles turned by one every time a tile is clicked.
		tiles_turned += 1
	
		#Playing the sound of turning tile
		$Turn.play()
		
		get_node("Container/Element46").icon = get_node("Container/Element46").my_number
		
		#Calling the Element_clicked function after every click. It will further check for a match.
		Element_clicked($Container/Element46.my_fruit, $Container/Element46.name)
	
		#Updating the label which is displaying the number of tiles that have been clicked.
		tiles_turned_label.text = "Tiles Turned: %d" %tiles_turned


		
		await get_tree().create_timer(1).timeout
		toggled_on = false
	
		if not last_check_match:
			get_node("Container/Element46").set("icon", panel_image)	


func _on_element_47_toggled(toggled_on):
	
	if toggled_on:
		
		tiles_turned += 1
	
		#Playing the sound of turning tile
		$Turn.play()
		
		get_node("Container/Element47").icon = get_node("Container/Element47").my_number
		
		#Calling the Element_clicked function after every click. It will further check for a match.
		Element_clicked($Container/Element47.my_fruit, $Container/Element47.name)
	
		#Updating the label which is displaying the number of tiles that have been clicked.
		tiles_turned_label.text = "Tiles Turned: %d" %tiles_turned
	

		
		await get_tree().create_timer(1).timeout
		toggled_on = false
	
		if not last_check_match:
			get_node("Container/Element47").set("icon", panel_image)


func _on_element_48_toggled(toggled_on):
	
		
	if toggled_on:

		#Increasing the value of tiles turned by one every time a tile is clicked.
		tiles_turned += 1
	
		#Playing the sound of turning tile
		$Turn.play()
		
		get_node("Container/Element48").icon = get_node("Container/Element48").my_number
		
		#Calling the Element_clicked function after every click. It will further check for a match.
		Element_clicked($Container/Element48.my_fruit, $Container/Element48.name)
	
		#Updating the label which is displaying the number of tiles that have been clicked.
		tiles_turned_label.text = "Tiles Turned: %d" %tiles_turned



		
		await get_tree().create_timer(1).timeout
		toggled_on = false
	
		if not last_check_match:
			get_node("Container/Element48").set("icon", panel_image)
