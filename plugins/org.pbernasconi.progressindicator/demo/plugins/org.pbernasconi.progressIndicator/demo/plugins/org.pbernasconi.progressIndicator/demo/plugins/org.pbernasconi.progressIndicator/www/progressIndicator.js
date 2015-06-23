var ProgressIndicator = {
  show: function (type, dim, label, detail) {
    dim = dim || false;
    label = label || "Please wait...";
    detail = detail || '';

    cordova.exec(null, null, "ProgressIndicator", "show", [type, dim, label, detail]);
  },


  showSimple: function (dim) {
    dim = dim || false;
    cordova.exec(null, null, "ProgressIndicator", "showSimple", [dim]);

  },

  showSimpleWithLabel: function (dim, label) {
    dim = dim || false;
    label = label || "Please wait...";

    cordova.exec(null, null, "ProgressIndicator", "showSimpleWithLabel", [dim, label]);
  },

  showSimpleWithLabelDetail: function (dim, label, detail) {
    dim = dim || false;
    label = label || "Please wait...";
    detail = detail || "Loading";

    cordova.exec(null, null, "ProgressIndicator", "showSimpleWithLabelDetail", [dim, label, detail]);
  },

  showDeterminate: function (dim, timeout) {
    dim = dim || false;
    timeout = timeout || 50000;
    cordova.exec(null, null, "ProgressIndicator", "showDeterminate", [dim, timeout]);
  },

  showDeterminateWithLabel: function (dim, timeout, label) {
    dim = dim || false;
    timeout = timeout || 50000;
    label = label || "Please wait...";

    cordova.exec(null, null, "ProgressIndicator", "showDeterminateWithLabel", [dim, timeout, label]);
  },

  showAnnular: function (dim, timeout) {
    dim = dim || false;
    timeout = timeout || 50000;
    cordova.exec(null, null, "ProgressIndicator", "showDeterminateAnnular", [dim, timeout]);
  },

  showAnnularWithLabel: function (dim, timeout, label) {
    dim = dim || false;
    timeout = timeout || 50000;
    label = label || "Please wait...";

    cordova.exec(null, null, "ProgressIndicator", "showDeterminateAnnularWithLabel", [dim, timeout, label]);
  },

  showBar: function (dim, timeout) {
    dim = dim || false;
    timeout = timeout || 50000;

    cordova.exec(null, null, "ProgressIndicator", "showDeterminateBar", [dim, timeout]);
  },

  showBarWithLabel: function (dim, timeout, label) {
    dim = dim || false;
    timeout = timeout || 50000;
    label = label || "Please wait...";

    cordova.exec(null, null, "ProgressIndicator", "showDeterminateBarWithLabel", [dim, timeout, label]);
  },


  showSuccess: function (dim, label) {
    dim = dim || false;
    label = label || "Success";

    cordova.exec(null, null, "ProgressIndicator", "showSuccess", [dim, label]);
  },

  showText: function (dim, label, position) {
    dim = dim || false;
    label = label || "Success";
    position = position || "bottom";

    cordova.exec(null, null, "ProgressIndicator", "showText", [dim, label, position]);
  },


  hide: function () {
    cordova.exec(null, null, "ProgressIndicator", "hide", []);
  }
};

module.exports = ProgressIndicator;