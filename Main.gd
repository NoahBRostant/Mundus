extends Control

var projectName = ""
var projectType = ""

func _ready():
	get_window().borderless = false
	get_window().title = "Mundus - World Builder"
	await get_tree().create_timer(0.1).timeout
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
	%ProjectName.text = Global.projectName
	projectType = Global.projectType
	if projectType == "DnD5e":
		$Control2/HBoxContainer/VBoxContainer/HBoxContainer/DnDLogo.show()
	elif projectType == "Pathfinder":
		$Control2/HBoxContainer/VBoxContainer/HBoxContainer/PathfinderLogo.show()


func _on_file_id_pressed(id):
	if id == 0:
		pass
	elif id == 1:
		pass
	elif id == 2:
		pass
	elif id == 3:
		pass
	elif id == 4:
		pass
	elif id == 5:
		pass
	elif id == 6:
		pass
	elif id == 7:
		pass
	elif id == 8:
		pass
	elif id == 9:
		pass
	elif id == 10:
		get_tree().change_scene_to_file("res://ProjectList.tscn")
	elif id == 11:
		get_tree().quit()
