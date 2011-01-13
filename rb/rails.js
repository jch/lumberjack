// rule components common to rails2 and rails3
Lumberjack.rails = {
  cleanup: [/./, function(line, matches){
    // cleanup sql color marks
    var s = decodeURI(line);
    s = s.replace(/%23/, "#"); // decodeURI didn't get
    //s = s.replace(/^\s+/, "&nbsp;&nbsp;&nbsp;&nbsp;");
    s = s.replace(/\s+$/, "\n");
    s = s.replace(/\[4;36;1m/, "");
    s = s.replace(/\[0m   \[0;1m/, "\t");
    s = s.replace(/\[4;35;1m/, "");
    s = s.replace(/\[0m   \[0m/, "\t");
    s = s.replace(/\[0m/, "");

    return [s, true];
  }],

  ignoreSQLNoise: [/client_min_messages|SET NAMES 'utf8'|SET SQL_AUTO_IS_NULL/, function(line, matches) {
    return ["", false];
  }],

  wrapInParagraph: [/./, function(line, matches) {
    var myLine = jQuery("<p>").append(line);
    if(line.match(/^\s+/)) {
      myLine.addClass('indent');
    }
    return [myLine.outerHTML(), true];
  }],

  exception: [/.*?Error/, function(line, matches) {
    var myLine = $(line).addClass('error').outerHTML();
    return [myLine, true];
  }],

  render: [/.*?Render/, function(line, matches) {
    var myLine = $(line).addClass('render').outerHTML();
    return [myLine, true];
  }],

  redirect: [/.*?Redirect/, function(line, matches) {
    var myLine = $(line).addClass('redirect').outerHTML();
    return [myLine, true];
  }],

  params: [/.*?Param/, function(line, matches) {
    var reAction = /,? ?"action"=&gt;"(.*?)",? ?/;
    var reController = /,? ?"controller"=&gt;"(.*?)",? ?/;
    line = line.replace(reAction, "");
    line = line.replace(reController, "");
    var myLine = $(line).addClass('params').outerHTML();
    return [myLine, true];
  }],

  stacktrace: [/vendor\/|\.rvm|bundler_gems/, function(line, matches) {
    var myLine = $(line).addClass('stacktrace').outerHTML();
    return [myLine, true];
  }],

  sql: [/(.*?)SELECT/, function(line, matches) {
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

  fallthrough: [/./, function(line, matches) {
    Lumberjack.appendLineToCurrentEntry('.body', line);
    return ["", false];
  }]
}