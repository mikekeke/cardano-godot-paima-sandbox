const me = this;
        const initPreP =  async () => this.init(exe);
        const initP =  async () => initPreP().catch(e => {console.log("fail: init"); throw e;});
        const preloadFilePreP = async () => this.preloadFile(pack, pack);
        const preloadFileP = async () => preloadFilePreP().catch(e => {console.log("fail: preloadFile"); throw e;});



function _emscripten_run_script(ptr) {
 const toEval = UTF8ToString(ptr);
 console.log("to eval: ", toEval);
 eval(UTF8ToString(ptr));
}


function _godot_js_wrapper_create_cb(p_ref, p_func) {


```js
function testGetPParams() {
  let { promise, resolve, reject } = Promise.withResolvers();
  window.godot_wallet.get_pparams(resolve)
  return promise;
}
```

```
return arrest letter ready seat weird news you wave profit ritual grace cream lawsuit lend alone crisp foil joy gas caught vintage fresh modify
```

phrase_password 
wallet_password 1234
account_index 0


```js
	JavaScriptBridge.eval("""
		console.log("eval js");
		function getPparams(){
			window.get_pparams()
			console.log("await done")
			return window.cardano_pparams_res;
		};
		window.get_params_js = getPparams
		
	""", true)
```