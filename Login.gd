extends Control


func _ready():
	get_window().size = Vector2i(1152,648)
	get_window().borderless = false
	get_window().title = "Mundus - Project List"
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	Firebase.Auth.connect("login_succeeded", _on_FirebaseAuth_login_succeeded)
	Firebase.Auth.connect("login_failed", _on_FirebaseAuth_login_failed)
	Firebase.Auth.connect("signup_succeeded", _on_FirebaseAuth_signup_succeeded)
	Firebase.Auth.connect("signup_failed", _on_FirebaseAuth_signup_failed)


func _on_login_button_up():
	var email = %LEmail.text
	var password = %LPassword.text
	Firebase.Auth.login_with_email_and_password(email,password)


func _on_FirebaseAuth_login_succeeded(auth_info):
	print("Success!")
	Global.loggedIn = true
	get_tree().change_scene_to_file("res://SplashScreen.tscn")

func _on_FirebaseAuth_login_failed(error_code, message):
	print("error "+ str(error_code)+": "+str(message))
	%Loginerrors.text = "[center][color=#FE8B68]"+str(error_code)+" "+str(message)+"[/color][/center]"
	pass

func _on_FirebaseAuth_signup_succeeded(auth_info):
	print("Success!")
	Global.loggedIn = true
	get_tree().change_scene_to_file("res://SplashScreen.tscn")
	pass

func _on_FirebaseAuth_signup_failed(error_code, message):
	print("error "+ str(error_code)+": "+str(message))
	%Registererrors.text = "[center][color=#FE8B68]"+str(error_code)+" "+str(message)+"[/color][/center]\n"
	pass


func _on_register_button_up():
	var email = %REmail.text
	var password = %RPassword.text
	var confirmation = %RConfirm.text
	if password == confirmation:
		Firebase.Auth.signup_with_email_and_password(email,password)
