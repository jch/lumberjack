Lumberjack = {
  debug: false,
  config: {},
  $: jQuery
};

// List of rules to process incoming lines.  Rules are run from top to 
// bottom. Rules may mutate the line being processed before the next rule
// operates on a line.  Rules may also manipulate the dom as part of the
// process.  A rule may specify that no further rules are processed if it
// matched.
//
// A rule consists of an array pair. The first element is a RegExp object 
// to match against the line.  If matched, the second element, a callback 
// function with 2 arguments is invoked with:
//    line - the line being processed
//    matches - an array of matches of null
//
// the callback function must return an array with 2 elements:
//    line' - modified or unmodifed line for the next rule to process
//    fallThrough - whether to continue processing the remaining rules
//
// See lumberjack_test.js for examples
Lumberjack.rules = [
  [/./, function(line, matches) {
    console.log("No rules specified. See lumberjack.js 'rules' for details. test: " + line);
  }]
]

Lumberjack.setup = function(config) {
  for(var k in config) {
    this.config[k] = config[k];
  }
  return this.config;
}

Lumberjack.entries = function() {
  return $('.entry');
}

// 1-indexed
Lumberjack.entryAtIndex = function(index) {
  return this.entries().filter(':nth-child(' + index + ')');
}

Lumberjack.currentEntry = function() {
  return this.entries().filter('.selected');
}

// Process a line against rules specified in Lumberjack.rules
Lumberjack.process = function(line) {
  for(var i=0; i<this.rules.length; i++) {
    var re = this.rules[i][0];
    var callback = this.rules[i][1];
    var matches = undefined;
    if(this.debug) {
      console.log("processing " + re + " : '" + line + "'");
    }
    if(matches = line.match(re)) {
      result = callback(line, matches);
      line = result[0];  // any direct manipulations to line
      fallThrough = result[1];
      if(fallThrough) {
        // do nothing and continue
      } else {
        break; // stop processing if callback is false
      }
    }
  }
};

// destination - selector or jquery object of where to prepend new entry
Lumberjack.prependEntry = function(destination) {
  var entryHtml = '<div class="entry selected">' +
                  '  <div class="content">' +
                  '   <div class="header">' +
                  '     <p class="controller_action"></p>' +
                  '     <p class="timestamp"></p>' +
                  '     <p class="host"></p>' +
                  '     <p class="method"></p>' +
                  '   </div>' +
                  '   <div class="body"></div>' +
                  '   <!-- no more pre-s -->' +
                  '  </div>' +
                  '</div>';
  var entryElement = $(entryHtml);
  $(destination || this.config['prependTo']).prepend(entryElement);
  $('.entry').removeClass('selected');
  $('.entry:first').addClass('selected');
};

// After cleaning up a line
Lumberjack.appendLineToCurrentEntry = function(destination, line) {
  this.currentEntry().find(destination).append(line);
};
