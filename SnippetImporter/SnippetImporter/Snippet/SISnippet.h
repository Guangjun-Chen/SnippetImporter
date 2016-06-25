//
//  SISnippet.h
//  SnippetImport
//
//  Created by chengj on 16/6/25.
//  Copyright © 2016年 chengj. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kCompletionPrefixKey @"IDECodeSnippetCompletionPrefix"
#define kContentKey          @"IDECodeSnippetContents"
#define kIdentifierKey       @"IDECodeSnippetIdentifier"
#define kLanguageKey         @"IDECodeSnippetLanguage"
#define kSummaryKey          @"IDECodeSnippetSummary"
#define kTitleKey            @"IDECodeSnippetTitle"
#define kScopeKey            @"scope"

@interface SISnippet : NSObject

@property (nonatomic, copy, readonly) NSDictionary *snippetDic;

- (instancetype)initWithContentsOfFile:(NSString *)filePath;
- (BOOL)save;
@end
