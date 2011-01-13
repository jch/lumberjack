// processing rules for rails3
Lumberjack.rails3 = {
  rules: [
    Lumberjack.rails.cleanup,

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

    Lumberjack.rails.ignoreSQLNoise,
    Lumberjack.rails.wrapInParagraph,
    Lumberjack.rails.exception,
    Lumberjack.rails.render,
    Lumberjack.rails.redirect,
    Lumberjack.rails.params,
    Lumberjack.rails.stacktrace,
    Lumberjack.rails.sql,
    Lumberjack.rails.fallthrough
  ]
}