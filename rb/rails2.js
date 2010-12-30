// processing rules for rails2
Lumberjack.rules = [
  // cleanup sql color marks
  [/./, function(line, matches){
    var s = decodeURI(line);
    s = s.replace(/%23/, "#"); // decodeURI didn't get
    s = s.replace(/^\s+/, "");
    s = s.replace(/\s+$/, "\n");
    s = s.replace(/\[4;36;1m/, "");
    s = s.replace(/\[0m   \[0;1m/, "\t");
    s = s.replace(/\[4;35;1m/, "");
    s = s.replace(/\[0m   \[0m/, "\t");
    s = s.replace(/\[0m/, "");

    return [s, true];
  }],

  // start new entry
  [/Processing (\w+#\w+)/, function(line, matches) {
    extras = line.match(/\(for (.*?) at (.*?)\) \[(.*?)\]/);
    // create a new entry if the last one isn't blank
    if(Lumberjack.currentEntryEmpty()) {
      Lumberjack.prependEntry();
    }
    Lumberjack.appendLineToCurrentEntry('.controller_action', matches[1]);
    Lumberjack.appendLineToCurrentEntry('.host', extras[1]);
    Lumberjack.appendLineToCurrentEntry('.timestamp', extras[2]);
    Lumberjack.appendLineToCurrentEntry('.method', extras[3]);
    return ["", false];
  }],

  /* ignore sql noise */
  [/client_min_messages/, function(line, matches) { return ["", false]; }],
  [/SET NAMES 'utf8'/, function(line, matches) { return ["", false]; }],
  [/SET SQL_AUTO_IS_NULL/, function(line, matches) { return ["", false]; }],

  // wrap all lines in a p
  [/./, function(line, matches) {
    var myLine = jQuery("<p>").append(line).outerHTML();
    return [myLine, true];
  }],
  
  // error lines should have class error
  [/.*?Error/, function(line, matches) {
    var myLine = $(line).addClass('error').outerHTML();
    return [myLine, true];
  }],

  // render lines should have class render
  [/.*?Render/, function(line, matches) {
    var myLine = $(line).addClass('render').outerHTML();
    return [myLine, true];
  }],

  // redirect lines should have class render
  [/.*?Redirect/, function(line, matches) {
    var myLine = $(line).addClass('redirect').outerHTML();
    return [myLine, true];
  }],
  
  // params lines should have class params
  [/.*?Param/, function(line, matches) {
    var myLine = $(line).addClass('params').outerHTML();
    return [myLine, true];
  }],
  
  // stacktrace lines: vendor/, .rvm, bundler_gems
  [/vendor\/|\.rvm|bundler_gems/, function(line, matches) {
    var myLine = $(line).addClass('stacktrace').outerHTML();
    return [myLine, true];
  }],

  // default rule
  [/./, function(line, matches) {
    Lumberjack.appendLineToCurrentEntry('.body', line);
    return ["", false];
  }]
];