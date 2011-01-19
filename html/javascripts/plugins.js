// autoload required JS files
var scriptNames = [
  "rails.js",
  "rails2.js",
  "rails3.js",
];

var head = document.getElementsByTagName('head')[0];
for (var i=0; i<scriptNames.length; i++) {
  var scriptElement = document.createElement('script');
  scriptElement.src = "javascripts/" + scriptNames[i];
  scriptElement.type = "text/javascript";
  head.appendChild(scriptElement);
}