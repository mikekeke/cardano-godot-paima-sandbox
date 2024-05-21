extends RefCounted

class_name PaimaMiddleware


var _middleware
var _endpoints
var _paima_wallet


#TODO: figure out endpoints type 
func _init(window) -> void:
	assert(window)
	print("PaimaMiddleware._init")
	_middleware = window.paima
	assert(_middleware)
	_endpoints = _middleware.endpoints
	assert(_endpoints)
#
## Login
### The func
func login():
	var godotWalletInfo = mk_wallet_info()
	prints("paima_login: godotWalletInfo: ", godotWalletInfo)
	_endpoints.userWalletLogin(godotWalletInfo).then(js_on_paima_login)
	##var vl = peps.userWalletLogin(walletInfo).then(js_set_wallet)
	#
	##console.log("vl: ", vl)
	##prints("vl: ", vl)
### Callback
var js_on_paima_login = JavaScriptBridge.create_callback(_on_paima_login)
func _on_paima_login(args):
	print("setting _paima_wallet")
	var wallet = args[0]
	_paima_wallet = wallet
	print("_paima_wallet set")
	#
## Helpers
## TODO: looks like we'll need to inject our own `cardano` object if there is no ohter wallets in browser
func mk_wallet_info():
	var pref = new_js_obj()
	pref.name = "godot"
	var info = new_js_obj()
	info.mode = 3 #todo: WalletMode.Cardano
	info.preferBatchedMode = true
	info.preference = pref
	return info
	
func new_js_obj():
	return JavaScriptBridge.create_object("Object")
