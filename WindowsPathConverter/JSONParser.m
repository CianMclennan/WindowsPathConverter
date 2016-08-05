//
//  JSONParser.m
//  WindowsPathConverter
//
//  Created by Cian McLennan on 26/06/2016.
//  Copyright © 2016 Cian McLennan. All rights reserved.
//

#import "JSONParser.h"
#import "FileReadWriter.h"

@implementation JSONParser

+(NSDictionary*) dictionaryFromJSON:(NSURL*) pathURL{
    if([[NSFileManager defaultManager] fileExistsAtPath:pathURL.path]) {
        NSString* fileAsString = [FileReadWriter readTextFromURL:pathURL];
        NSError *error;
        NSDictionary* fileAsDictionary = [NSJSONSerialization JSONObjectWithData:[fileAsString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
        if(error){
            @throw [NSException exceptionWithName:@"JSONParserException" reason:@"Could not Parse path URL " userInfo:nil];
        }
        return fileAsDictionary;
    }
    @throw [NSException exceptionWithName:@"PathException" reason:[NSString stringWithFormat:@"Path does not exist at: %@", pathURL.path] userInfo:nil];
    return nil;
}

+(void) writeDictionary:(NSDictionary*) dictionary toJSONFile:(NSURL*)url{
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                       options: NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (!jsonData || error) {
        @throw [[NSException alloc] initWithName:@"JSONSaveException" reason:@"could not create json string from dictionary" userInfo:nil];
    }
    [jsonData writeToURL:url atomically:YES];
}


@end
