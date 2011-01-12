// processing rules for rails3
Lumberjack.rails3 = {
  rules: [
    // cleanup sql color marks
    [/./, function(line, matches){
      var s = decodeURI(line);
      console.log("+++" + s + "+++");
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
    [/Started ([A-Z]+) /, function(line, matches) {
      var extras = line.match(/for (.*?) at (.*)/);
      Lumberjack.appendLineToCurrentEntry('.host', extras[1]);
      Lumberjack.appendLineToCurrentEntry('.timestamp', extras[2]);
      Lumberjack.appendLineToCurrentEntry('.method', matches[1]);
      return ["", false];
    }],

    [/Processing by (\w+#\w+) as (.*)/, function(line, matches) {
      var extras = line.match(/\(for (.*?) at (.*?)\) \[(.*?)\]/);
      if(Lumberjack.currentEntry().find('.controller_action').text() != "") {
        // poorly formatted log, log it inline
        return [line, true];
      } else {
        Lumberjack.appendLineToCurrentEntry('.controller_action', matches[1] + "<br/>");
      }
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
  
    // params lines should have class params and remove controller and action
    [/.*?Param/, function(line, matches) {
      line = line.replace(/,? ?"action"=&gt;".*?",? ?/, "");
      line = line.replace(/,? ?"controller"=&gt;".*?",? ?/, "");
      var myLine = $(line).addClass('params').outerHTML();
    
      return [myLine, true];
    }],
  
    // stacktrace lines: vendor/, .rvm, bundler_gems
    [/vendor\/|\.rvm|bundler_gems/, function(line, matches) {
      var myLine = $(line).addClass('stacktrace').outerHTML();
      return [myLine, true];
    }],
  
    // SQL lines should be split up and prettified
    [/(.*?)SELECT/, function(line, matches) {
      var sql = $("<div>").addClass('sql')
      var content = $("<div>").addClass('content');
      sql.append($("<p>").addClass("header").append(matches[1]));
      sql.append(content);
    
      // UPDATE | DELETE | SHOW | SELECT ...
      if (m = line.match(/(SELECT .*?)FROM/)) {
        content.append($("<p>").append(m[1]));
      }

      // FROM ...
      //   AND ... | ...
      if (m = (line.match(/(FROM .*) (WHERE)?/))) {
        content.append($("<p>").append(m[1].replace(/WHERE.*/, "")));
      }
      // WHERE ...
      //   AND ... | ...
      if (m = line.match(/(WHERE.*) (ORDER BY)?/)) {
        content.append($("<p>").append(m[1].replace(/ORDER BY.*/, "")));
      }
      // ORDER BY ...
      // LIMIT ...
      if (m = line.match(/(ORDER BY.*)/)) {
        content.append($("<p>").append(m[1]));
      }
      return [sql.outerHTML(), true];
    }],

    // default rule
    [/./, function(line, matches) {
      Lumberjack.appendLineToCurrentEntry('.body', line);
      return ["", false];
    }]
  ]
}