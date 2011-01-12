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
// cleanup sql color marks
  [/./, function(line, matches){
    var s = decodeURI(line);
    s = s.replace(/%23/, "#"); // decodeURI didn't get
    return [s, true];
  }],

  [/^Started /, function(line, matches) {
    Lumberjack.setType('rails3');
    Lumberjack.process(line); // reprocess the line
    return ["", false];
  }],

  [/^Processing /, function(line, matches) {
    Lumberjack.setType('rails2');
    Lumberjack.process(line); // reprocess the line
    return ["", false];
  }]

  // [/./, function(line, matches) {
  //   console.log("No rules specified. See lumberjack.js 'rules' for details. test: " + line);
  // }]
]

Lumberjack.setup = function(config) {
  for(var k in config) {
    this.config[k] = config[k];
  }
  return this.config;
}

Lumberjack.setType = function(logType) {
  Lumberjack.rules = Lumberjack[logType].rules;
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

Lumberjack.currentEntryEmpty = function() {
  // rails 3 controller_action isn't filled in immediately
  return this.currentEntry().find('.method').text() != "" ||
         this.currentEntry().find('.body').children().length > 0;
}

// Process a line against rules specified in Lumberjack.rules
Lumberjack.process = function(line) {
  for(var i=0; i<this.rules.length; i++) {
    var re = this.rules[i][0];
    var callback = this.rules[i][1];
    var matches = undefined;
    if(this.config.debug) {
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
  console.log("prependEntry");
  var entryHtml = '<div class="entry selected box">' +
                  '  <div class="content">' +
                  '   <div class="header">' +
                  '     <p class="controller_action"></p>' +
                  '     <div class="subdetails">' +
                  '       <p class="timestamp"></p>' +
                  '       <p class="method"></p>' +
                  '       <p class="host"></p>' +
                  '     </div>' +
                  '   </div>' +
                  '   <div class="body"></div>' +
                  '  </div>' +
                  '</div>';
  var entryElement = $(entryHtml);
  $(destination || this.config['prependTo']).append(entryElement);
  $('.entry').removeClass('selected');
  $('.entry:last').addClass('selected');
};

// After cleaning up a line
Lumberjack.appendLineToCurrentEntry = function(destination, line) {
  this.currentEntry().find(destination).append(line);
};
