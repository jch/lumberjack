// processing rules for rails3
Lumberjack.rails3 = {
  rules: [
    Lumberjack.rails.cleanup,

    // start new entry
    [/Started ([A-Z]+) /, function(line, matches) {
      var extras = line.match(/ "(.*)\/.*?" for (.*?) at (.*)/);
      Lumberjack.appendLineToCurrentEntry('.host', extras[2]);
      Lumberjack.appendLineToCurrentEntry('.timestamp', extras[3]);
      Lumberjack.appendLineToCurrentEntry('.method', matches[1]);
      var link = $('<a>').attr('href', Lumberjack.config.projectRoot + 'app/controllers' + extras[1] + '_controller.rb');
      Lumberjack.appendLineToCurrentEntry('.controller_action', link);
      return ["", false];
    }],

    [/Processing by (\w+#\w+) as (.*)/, function(line, matches) {
      var extras = line.match(/\(for (.*?) at (.*?)\) \[(.*?)\]/);
      if(Lumberjack.currentEntry().find('.controller_action').text() != "") {
        // poorly formatted log, log it inline
        return [line, true];
      } else {
        Lumberjack.appendLineToCurrentEntry('.controller_action a', matches[1] + "<br/>");
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