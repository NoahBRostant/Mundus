extends Button

var toggleOptions = false
var projectFileName = ""
var projectName = ""
var projectType = ""
var projectMadeDate = ""
var projectModDate = ""
var projectDescription = ""
var projectThumbnail = ""

var toggle = false

func _ready():
	print(projectThumbnail)
	var image_path = "user:///saves/"+projectFileName+"/Thumbnail.jpg"
	var image = Image.new()
	var error = image.load(image_path)
	if error != OK:
		image_path = "user:///saves/"+projectFileName+"/Thumbnail.png"
		error = image.load(image_path)
		if error != OK:
			$TextureRect3.show()
	image.load(image_path)
	var image_texture = ImageTexture.new()
	image_texture.set_image(image)
	%ProjectThumbnail.texture = image_texture
	if projectType == "DnD5e":
		$DnDLogo.show()
	elif projectType == "Pathfinder":
		$PathfinderLogo.show()

func _on_texture_button_button_up():
	if toggleOptions == false:
		$Panel2.show()
		toggleOptions = true
	else:
		$Panel2.hide()
		toggleOptions = false

func OpenProject():
	var items = get_parent().get_children()
	for i in items:
		i.toggle = false
		i.get_node("Panel4").hide()
	Console.projectSelected = self
	$Panel4.show()
	toggle = true
	Global.projectName = Console.projectSelected.projectName
	Global.projectType = Console.projectSelected.projectType
	Global.projectFileName = Console.projectSelected.projectFileName
	Console.debug = 'Successfuly Loaded "'+Global.projectName+'"'
	Console.ECode = "0000"
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")

func DeleteProject():
	Console.projectSelected = null
	get_parent().remove_child(self)
	var list = []
	var dir = DirAccess.open("user:///saves/"+projectFileName)
	if dir:
		dir.list_dir_begin()
		_add_dir_contents(dir, list)
	print(list)
	for i in list:
		dir.remove(i)
	var dir2 = DirAccess.open("user:///saves")
	dir2.remove(projectFileName)


func _add_dir_contents(dir: DirAccess, list: Array,):
	var file_name = dir.get_next()

	while (file_name != ""):
		var path = dir.get_current_dir() + "/" + file_name

		if dir.current_is_dir():
			print("Found directory: "+path)
			var subDir = DirAccess.open(path)
			subDir.list_dir_begin()
			list.append(path)
			_add_dir_contents(subDir, list)
		else:
			print("Found directory: "+path)
			list.append(path)
		file_name = dir.get_next()

	dir.list_dir_end()


func _on_button_2_button_up():
	$Panel2.hide()
	toggleOptions = false


func _on_button_button_up():
	$Panel2.hide()
	toggleOptions = false


func _on_button_down():
	pass


func _on_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if event.double_click:
			OpenProject()
		else:
			if toggle == false:
				var items = get_parent().get_children()
				for i in items:
					i.toggle = false
					i.get_node("Panel4").hide()
				Console.projectSelected = self
				$Panel4.show()
				toggle = true
			else:
				$Panel4.hide()
				toggle = false
				Console.projectSelected = null
