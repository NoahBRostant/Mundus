extends Control

var projectName = ""
var projectType = ""

var tab = preload("res://ContentTabButton.tscn")

var tabdict = []


func _ready():
	get_window().borderless = false
	get_window().title = "Mundus - World Builder"
	await get_tree().create_timer(0.1).timeout
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
	#TabCalculate()
	if Console.hasGlobalMenu == true:
		%MenuBar.hide()
		var File = DisplayServer.global_menu_add_item("File","New Article",_on_file_id_pressed(0))
	%ProjectName.text = Global.projectName
	projectType = Global.projectType
	if projectType == "DnD5e":
		$Control2/HBoxContainer/VBoxContainer/HBoxContainer/DnDLogo.show()
	elif projectType == "Pathfinder":
		$Control2/HBoxContainer/VBoxContainer/HBoxContainer/PathfinderLogo.show()
	var tablist = %ContentPanel.get_children()
	for i in tablist:
		var tempdict = {
			"title":i.title,
			"image":i.img,
			"saved":i.saved
		}
		tabdict.append(tempdict)
	print(tabdict)
	for i in tabdict:
		var instance = tab.instantiate()
		instance.title = i["title"]
		instance.img = i["image"]
		$Control2/HBoxContainer/VBoxContainer/HBoxContainer/ScrollContainer/ReorderableHBox.add_child(instance)
	Notify.send("Yay","it Works!")


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


func _on_accountoptions_button_up():
	$AccountOptions.show()


func _on_closeaccount_button_up():
	$AccountOptions.hide()


func TabCalculate():
	pass
