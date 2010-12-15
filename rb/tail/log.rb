framework 'cocoa'

class Log
  attr_accessor :path
  attr_accessor :file
  attr_accessor :offset
  
  def initialize(path = "../design.html")
    @path = path
    @file = NSFileHandle.fileHandleForReadingAtPath(@path)
    @offset = @file.seekToEndOfFile - 500
    @offset = 0 if @offset < 0
    @file.seekToFileOffset(@offset)
    #NSNotificationCenter.defaultCenter.addObserver(self, selector: "handleData:", name: NSFileHandleReadToEndOfFileCompletionNotification, object: @file)
    NSNotificationCenter.defaultCenter.addObserver(self, selector: "handleData:", name:nil, object:nil)
  end
  
  def handleData(notification)
    NSLog "=== in handleData"
    NSLog notification.name
    NSLog notification.object
    NSLog notification.userInfo
    
    if notification.userInfo["NSFileHandleError"]
      NSLog "error reading file #{@path}"
    else
      data = notification.userInfo[NSFileHandleNotificationDataItem]
      NSLog data.description
    end
    @offset = notification.object.offsetInFile
    sleep 2
    checkFile
  end
  
  def checkFile
    NSLog "=== in checkFile"
    @file = NSFileHandle.fileHandleForReadingAtPath(@path)
    @file.seekToFileOffset(@offset)
    # readInBackgroundAndNotify for incremental
    @file.readToEndOfFileInBackgroundAndNotify
  end
  
  # Important: The notification center does not retain its observers, therefore,
  # you must ensure that you unregister observers (using removeObserver: or
  # removeObserver:name:object:) before they are deallocated. (If you don't, you
  # will generate a runtime error if the center sends a message to a freed
  # object.)
end