cordova.define("org.pbernasconi.activityIndicator.ActivityIndicator", function(require, exports, module) { var ActivityIndicator = {
  // 1. type    @string
  // 2. dim     @bool
  // 3. text    @string
  // 4. detail  @string
    show: function (type, dim, text, detail) {

    	text = text || "Please wait...";
      detail = detail || '';

        cordova.exec(null, null, "ActivityIndicator", "show", [type, dim, text, detail]);
    },
    hide: function () {
        cordova.exec(null, null, "ActivityIndicator", "hide", []);
    }
};

module.exports = ActivityIndicator;
});
