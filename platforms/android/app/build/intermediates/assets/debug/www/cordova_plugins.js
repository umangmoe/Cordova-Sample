cordova.define('cordova/plugin_list', function(require, exports, module) {
module.exports = [
  {
    "id": "cordova-plugin-moengage.MoECordova",
    "file": "plugins/cordova-plugin-moengage/www/MoECordova.js",
    "pluginId": "cordova-plugin-moengage",
    "clobbers": [
      "MoECordova"
    ]
  }
];
module.exports.metadata = 
// TOP OF METADATA
{
  "cordova-plugin-whitelist": "1.3.3",
  "cordova-plugin-moengage": "3.0.0",
  "cordova-moengage-fcm-dependency": "0.0.1",
  "cordova-moengage-fcm-listeners": "0.0.1"
};
// BOTTOM OF METADATA
});