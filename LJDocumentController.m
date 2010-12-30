//
//  LJDocumentController.m
//  lumberjack
//
//  Created by Jerry Cheung on 12/29/10.
//  Copyright 2010 Jerry Cheung. All rights reserved.
//

#import "LJDocumentController.h"


@implementation LJDocumentController

// destroys existing blank document
- (id)openDocumentWithContentsOfURL:(NSURL *)absoluteURL display:(BOOL)displayDocument error:(NSError **)outError
{
  if(![[self currentDocument] fileURL]) {
    [[self currentDocument] close];
  }
  return [super openDocumentWithContentsOfURL:absoluteURL display:displayDocument error:outError];
}

@end