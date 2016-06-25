//
//  SISnippet.m
//  SnippetImport
//
//  Created by chengj on 16/6/25.
//  Copyright © 2016年 chengj. All rights reserved.
//

#import "SISnippet.h"
#import "ACCodeSnippetSerialization.h"

@interface SISnippet ()
@property (nonatomic, copy) NSDictionary *backingSnippet;
@end

@implementation SISnippet


- (instancetype)initWithContentsOfFile:(NSString *)filePath {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.backingSnippet = [self transformSnippetToXcodeFormatAtPath:filePath];
    return self;
    
}

- (instancetype)initWithDictionary:(NSDictionary *)snippetDic {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.backingSnippet = snippetDic;
    return self;
    
}
- (BOOL)save {
    if (!self.backingSnippet) {
        return NO;
    }
    NSString *fileName = [self.backingSnippet[@"IDECodeSnippetIdentifier"] stringByAppendingPathExtension:@"codesnippet"];
    NSString *filePath = [@"Library/Developer/Xcode/UserData/CodeSnippets" stringByAppendingPathComponent:fileName];
    filePath = [NSHomeDirectory() stringByAppendingPathComponent:filePath];
    return [self.backingSnippet writeToFile:filePath atomically:NO];
}
#pragma mark - Private Methods
- (NSDictionary *)transformSnippetToXcodeFormatAtPath:(NSString *)snippetFilePath {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSData *snippetContent = [fm contentsAtPath:snippetFilePath];
    NSError *parseError;
    NSDictionary *snippet = [ACCodeSnippetSerialization dictionaryWithData:snippetContent
                                                                   options:0
                                                                    format:ACCodeSnippetSerializationFormatC
                                                                     error:&parseError];
    if (parseError) {
        printf("Parse file failed at %s error : %s", [snippetFilePath cStringUsingEncoding:NSUTF8StringEncoding], [parseError.description cStringUsingEncoding:NSUTF8StringEncoding]);
        return nil;
    } else {
        NSMutableDictionary *xcodeSnippet = [NSMutableDictionary new];
        // Set default keys
        xcodeSnippet[@"IDECodeSnippetLanguage"] = @"Xcode.SourceCodeLanguage.Objective-C";
        xcodeSnippet[@"IDECodeSnippetUserSnippet"] = @YES;
        xcodeSnippet[@"IDECodeSnippetVersion"] = @2;
        xcodeSnippet[@"IDECodeSnippetIdentifier"] = [NSUUID UUID].UUIDString;
        NSString *shortcut = [[snippetFilePath lastPathComponent]
                              stringByDeletingPathExtension];
        xcodeSnippet[@"IDECodeSnippetCompletionPrefix"] = shortcut;
        
        [xcodeSnippet setValuesForKeysWithDictionary:snippet];
        return xcodeSnippet.copy;
    }
}

#pragma mark - Getters and Setters
- (NSDictionary *)snippet {
    return self.backingSnippet.copy;
}
@end
