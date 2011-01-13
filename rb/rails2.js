// processing rules for rails2
Lumberjack.rails2 = {
  rules: [
    Lumberjack.rails.cleanup,

    [/Processing (\w+#\w+)/, function(line, matches) {
      var extras = line.match(/\(for (.*?) at (.*?)\) \[(.*?)\]/);
      Lumberjack.appendLineToCurrentEntry('.controller_action', matches[1]);
      Lumberjack.appendLineToCurrentEntry('.host', extras[1]);
      Lumberjack.appendLineToCurrentEntry('.timestamp', extras[2]);
      Lumberjack.appendLineToCurrentEntry('.method', extras[3]);
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