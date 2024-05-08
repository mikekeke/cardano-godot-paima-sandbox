// TODO: maybe it should be done from GDScript?
function initCip30Godot() {
  window.cardano.godot = cip30Godot;
  console.log("initCip30Godot done");
}

const cip30Godot = {
  name: "godot",
  icon: null,
  enable: enableGodotCardano,
  callbacks: new Object()

}

async function enableGodotCardano() {
  console.log("(enableGodotCardano) Enabling CIP-30 godot")
  return cip30ApiGodot
}

const cip30ApiGodot = {
  name: "godot",
  getUsedAddresses: () => wrapCb(window.cardano.godot.callbacks.get_used_addresses),
  getUnusedAddresses: () => wrapCb(window.cardano.godot.callbacks.get_unused_addresses),
  signData: (address, message) => wrapSignCb(
    window.cardano.godot.callbacks.sign_data,
    address,
    message
  ),
}

function wrapCb(cb) {
  let { promise, resolve, reject } = Promise.withResolvers();
  cb(resolve);
  return promise;
}

function wrapSignCb(cb, address, message) {
  let { promise, resolve, reject } = Promise.withResolvers();
  cb(resolve, address, message);
  return promise;
}

// const signDataBytes = new TextEncoder().encode("paima data")
// const MY_NAMI_USED_ADDRESS = "012c2dad3e1d19d3e1764f96d4a3033ae6978a57936fd2a6cca3ce4033d7cc83ef07d1d2e23017d3d1df6e9d4410d8b5ec3f71378ccc7e5d88"

// const TX = "86a40081825820fb03abe73ddca76bc2f4a4fd18fde3b8e7844d7d1e3049042b4ed0875e7a6e04010182a200581d61abde0f5259efacac08c88bd8c951eaad7b15d898a2a482f0ba3b7f16011a069db9c0a200581d6180f9e2c88e6c817008f3a812ed889b4a4da8e0bd103f86e7335422aa011a34fad460021a00023be00e81581c80f9e2c88e6c817008f3a812ed889b4a4da8e0bd103f86e7335422aa9fff8080f5f6";

// const sig = {
//   signature: "845846a2012767616464726573735839012c2dad3e1d19d3e1764f96d4a3033ae6978a57936fd2a6cca3ce4033d7cc83ef07d1d2e23017d3d1df6e9d4410d8b5ec3f71378ccc7e5d88a166686173686564f443aa112258400fcba5736523380e16ced0f8a81a9cfdbabf0220c3fb3bcdf7d469655e8b7b12d11c232b0d4da1c7bc033c49056e481bfde8b9cec4e51e04f51c2f0c739de708",
//   key: "a4010103272006215820eafb118d61ccbd59a67d397640a3ed1fb0916cc21a5baabb1cbe8f4a7461bd3b"
// }

async function testNami() {
  let namiApi = await window.cardano.nami.enable();
  let addr = await namiApi.getUsedAddresses().then(addrs => addrs[0]);
  console.log("addr: ", addr)
  try {

    let signRes = await namiApi.signData(addr, "aa1122")
    console.log("sign res: ", signRes)
  } catch (e) {
    console.error(e)
  }
}