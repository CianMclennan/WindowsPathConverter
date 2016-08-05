//
//  JSONParser.h
//  WindowsPathConverter
//
//  Created by Cian McLennan on 26/06/2016.
//  Copyright © 2016 Cian McLennan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONParser : NSObject

+(NSDictionary*) dictionaryFromJSON:(NSURL*) pathURL;
// throws JSONSaveException
+(void) writeDictionary:(NSDictionary*) dictionary toJSONFile:(NSURL*)url;

@end
