extends Control

var provider = AuthProvider
var Hprovider = AuthProvider
var port = 8060

func _ready():
	#get_window().size = Vector2i(576,648)
	#get_window().initial_position = Window.WINDOW_INITIAL_POSITION_ABSOLUTE
	#get_window().position = getS_window().position+Vector2i(288,0)
	#get_window().borderless = false
	#get_window().title = "Mundus - Project List"
	#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	Firebase.Auth.connect("login_succeeded", _on_FirebaseAuth_login_succeeded)
	Firebase.Auth.connect("login_failed", _on_FirebaseAuth_login_failed)
	Firebase.Auth.connect("signup_succeeded", _on_FirebaseAuth_signup_succeeded)
	Firebase.Auth.connect("signup_failed", _on_FirebaseAuth_signup_failed)


func _on_login_button_up():
	var email = %LEmail.text
	var password = %LPassword.text
	if email != "":
		Firebase.Auth.login_with_email_and_password(email,password)
	else:
		%Loginerrors.text = "[center][color=#FE8B68]You must enter your email[/color][/center]"


func _on_FirebaseAuth_login_succeeded(auth_info):
	Firebase.Auth.save_auth(auth_info)
	var empty = ""
	print("Success!")
	#get_tree().change_scene_to_file("res://SplashScreen.tscn")
	get_parent().hide()
	get_parent().get_parent().retry(auth_info, empty)

func _on_FirebaseAuth_login_failed(error_code, message):
	print("error "+ str(error_code)+": "+str(message))
	%Loginerrors.text = "[center][color=#FE8B68]"+str(error_code)+" "+str(message)+"[/color][/center]"
	get_parent().hide()
	%LPassword.text = ""
	get_parent().get_parent().retry(error_code, message)
	pass

func _on_FirebaseAuth_signup_succeeded(auth_info):
	Firebase.Auth.send_account_verification_email()
	var empty = ""
	print("Success!")
	#get_tree().change_scene_to_file("res://SplashScreen.tscn")
	get_parent().hide()
	get_parent().get_parent().retry(auth_info, empty)
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


func _on_button_button_up():
	provider = Firebase.Auth.get_GoogleProvider()
	Firebase.Auth.get_auth_localhost(provider, port)


func _on_github_button_up():
	provider = Firebase.Auth.get_GitHubProvider()
	Firebase.Auth.get_auth_localhost(provider, port)
