extends Control

var newProject = preload("res://Scenes/NewProjectPanel.tscn")
var projectItem = preload("res://Scenes/ProjectItem.tscn")
var items
var oldProject
var dellength = -1

func _ready():
	get_window().borderless = false
	get_window().size = Vector2i(1152,648)
	get_window().title = "Mundus - Project List"
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	$VBoxContainer/HBoxContainer/Panel4/Label2.text = "Mundus_"+Console.verState+"_v"+Console.version
	await ClearList()
	await PopulateList()
	items = %ProjectGrid.get_children()
	oldProject = Console.projectSelected


func _process(_delta):
	if Console.projectSelected == null:
		$VBoxContainer/HBoxContainer/Panel4/VBoxContainer/Panel/VBoxContainer/Button.disabled = true
		$VBoxContainer/HBoxContainer/Panel4/VBoxContainer/Panel/VBoxContainer/Button2.disabled = true
		$VBoxContainer/HBoxContainer/Panel4/VBoxContainer/Panel/VBoxContainer/Button3.disabled = true
		$VBoxContainer/HBoxContainer/Panel4/VBoxContainer/Panel/VBoxContainer/Button4.disabled = true
		$VBoxContainer/HBoxContainer/Panel4/VBoxContainer/Panel/VBoxContainer/Button5.disabled = true
	else:
		$VBoxContainer/HBoxContainer/Panel4/VBoxContainer/Panel/VBoxContainer/Button.disabled = false
		$VBoxContainer/HBoxContainer/Panel4/VBoxContainer/Panel/VBoxContainer/Button2.disabled = false
		#$VBoxContainer/HBoxContainer/Panel4/VBoxContainer/Panel/VBoxContainer/Button3.disabled = false
		#$VBoxContainer/HBoxContainer/Panel4/VBoxContainer/Panel/VBoxContainer/Button4.disabled = false
		$VBoxContainer/HBoxContainer/Panel4/VBoxContainer/Panel/VBoxContainer/Button5.disabled = false
	if oldProject != Console.projectSelected:
		change_info()


func ClearList():
	var children = %ProjectGrid.get_children()
	print(children)
	for i in children:
		%ProjectGrid.remove_child(i)

func PopulateList():
	for i in Console.Projects:
		var instance = projectItem.instantiate()
		instance.get_node("%ProjectName").text = i.split(",")[1]
		instance.get_node("%ProjectModDate").text = i.split(",")[5]
		instance.projectName =  i.split(",")[1]
		instance.projectFileName =  i.split(",")[0]
		instance.projectType =  i.split(",")[3]
		instance.projectMadeDate =  i.split(",")[2]
		instance.projectModDate =  i.split(",")[5]
		%ProjectGrid.add_child(instance)


func _on_button_button_down():
	var instance = newProject.instantiate()
	self.add_child(instance)


func _on_line_edit_text_changed(new_text):
	if new_text != "":
		for i in items:
			if new_text.to_lower() in i.projectName.to_lower() or new_text.similarity(i.projectName) > 0.3:
				i.show()
			else:
				i.hide()
	else:
		for i in items:
			i.show()


func _on_button_3_button_down():
	var tween = get_tree().create_tween()
	tween.tween_property($VBoxContainer/HBoxContainer/Panel3/Panel, "position", Vector2(0,get_parent().size.y+32), 0.5).set_trans(Tween.TRANS_LINEAR)
	Console.projectSelected = null
	await ClearList()
	await PopulateList()
	$VBoxContainer/HBoxContainer/Panel3/Panel.position = Vector2(0,-64)


func _on_open_button_down():
	Console.projectSelected.OpenProject()


func _on_delete_button_down():
	$DeletePanel/Panel/VBoxContainer/LineEdit.placeholder_text = 'Write "'+Console.projectSelected.projectName+'" to confirm deletion'
	$DeletePanel/Panel/VBoxContainer/LineEdit/Label.text = Console.projectSelected.projectName
	$DeletePanel/Panel/VBoxContainer/LineEdit.text = ""
	$DeletePanel.show()

func _on_rename_button_down():
	$RenamePanel.show()

func _on_renamepanelclose_button_down():
	$RenamePanel.hide()
	$RenamePanel/Panel/VBoxContainer/LineEdit.text = ""

func _on_renamepaneldone_button_down():
	Console.projectSelected.projectName = $RenamePanel/Panel/VBoxContainer/LineEdit.text
	$RenamePanel.hide()
	$RenamePanel/Panel/VBoxContainer/LineEdit.text = ""
	oldProject = null
	Console.projectSelected.get_node("%ProjectName").text = Console.projectSelected.projectName


func change_info():
	if Console.projectSelected != null:
		%ProjectInfo.text = "Name: "+str(Console.projectSelected.projectName)+"\nRuleset: "+str(Console.projectSelected.projectType)+"\nDate Created: "+str(Console.projectSelected.projectMadeDate)+"\nModified On: "+str(Console.projectSelected.projectModDate)+"\nTags: "
	else:
		%ProjectInfo.text = "Name:\nRuleset:\nDate Created:\nModified On:\nTags: "
	oldProject = Console.projectSelected


func _on_button_button_up():
	$AccountOptions.show()


func _on_closeaccount_button_up():
	$AccountOptions.hide()


func _on_Import_button_up():
	$NativeFileDialog.show()


func _on_native_file_dialog_dir_selected(dir):
	await SearchProjects(dir)
	await ClearList()
	PopulateList()

func SearchProjects(dir):
	var error = true
	var files = []
	var directories = []
	dir = DirAccess.open(dir)

	if dir:
		dir.list_dir_begin()
		_add_dir_contents(dir, files, directories)
	else:
		await get_tree().create_timer(0.5).timeout
	print(files)
	for i in files:
		if "data.save" in i:
			var f = FileAccess.open(i,FileAccess.READ)
			Console.Projects.append(f.get_line())
			#dir.copy_absolute(dir.get_current_dir()+"/data.save", "user://saves/data.save")
			error = false
	if error == true:
		return(error)


func _add_dir_contents(dir: DirAccess, files: Array, directories: Array):
	var file_name = dir.get_next()

	while (file_name != ""):
		var path = dir.get_current_dir() + "/" + file_name

		if dir.current_is_dir():
			print("Found directory: "+path)
			#$VBoxContainer/RichTextLabel.append_text("\n[color="+CWhite+"]Found directory: "+path+"[/color]")
			var subDir = DirAccess.open(path)
			subDir.list_dir_begin()
			directories.append(path)
			_add_dir_contents(subDir, files, directories)
		else:
			print("Found File: "+path)
			files.append(path)

		file_name = dir.get_next()

	dir.list_dir_end()

func copy_folder(source_path: String, dest_path: String) -> void:
	var source_dir = DirAccess.open(source_path)
	#if source_dir != OK:
		#print("Source directory not found")
		#return

	source_dir.list_dir_begin()
	var filename = source_dir.get_next()
	while filename != "":
		if not source_dir.current_is_dir():
			var source_file =+ filename
			var dest_file =+ filename
			var err = source_dir.copy(source_file, dest_file)
			if err != OK:
				print("Failed to copy file: " + filename)
		filename = source_dir.get_next()
	source_dir.list_dir_end()


func _on_deleteconfirm_button_down() -> void:
	if $DeletePanel/Panel/VBoxContainer/LineEdit.text == Console.projectSelected.projectName:
		Console.projectSelected.DeleteProject()
		$DeletePanel.hide()
		


func _on_deleteconfirm_text_submitted(new_text: String) -> void:
	if $DeletePanel/Panel/VBoxContainer/LineEdit.text == Console.projectSelected.projectName:
		Console.projectSelected.DeleteProject()
		$DeletePanel.hide()

func _on_deleteconfirm_text_changed(new_text: String) -> void:
	if new_text.length() == Console.projectSelected.projectName.length():
		$DeletePanel/Panel/VBoxContainer/LineEdit/Label.visible_characters = 0
		$DeletePanel/Panel/VBoxContainer/LineEdit.add_theme_color_override("font_color",Color8(230,230,230))
	elif new_text.length() != 0 and new_text.length() < Console.projectSelected.projectName.length():
		$DeletePanel/Panel/VBoxContainer/LineEdit/Label.visible_characters = Console.projectSelected.projectName.length()-new_text.length()
		$DeletePanel/Panel/VBoxContainer/LineEdit.add_theme_color_override("font_color",Color8(230,230,230))
	elif new_text.length() == 0 or new_text.length() > Console.projectSelected.projectName.length():
		$DeletePanel/Panel/VBoxContainer/LineEdit/Label.visible_characters = 0
		$DeletePanel/Panel/VBoxContainer/LineEdit.add_theme_color_override("font_color",Color8(207,59,58))

func _on_deletecancel_button_down() -> void:
	$DeletePanel.hide()
