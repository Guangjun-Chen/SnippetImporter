//
//  main.m
//  SnippetImporter
//
//  Created by chengj on 16/6/25.
//  Copyright © 2016年 chengj. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <mach-o/dyld.h>
#import "SISnippet.h"

NSString *getExecutablePath() {
    char path[512];
    unsigned size = 512;
    _NSGetExecutablePath(path, &size);
    path[size] = '\0';
    return [NSString stringWithCString:path encoding:NSUTF8StringEncoding];
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSString *directoryPath;
        NSArray *directoryContents;
        NSString *filePath = [NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding];
        NSFileManager *fm = [NSFileManager defaultManager];
        if (argc == 1) {
            // User does not specify any arguments, so get all .m files at the execution path
            NSString *executablePath = getExecutablePath();
            directoryPath = [executablePath stringByDeletingLastPathComponent];
        } else if (argc == 2) {
            // Get all the .m files which is in the argv[2] path
            BOOL isDirectory;
            BOOL isFileExist = [fm fileExistsAtPath:filePath isDirectory:&isDirectory];
            if (!isFileExist) {
                printf("File is not exist at path : %s", argv[1]);
                return 0;
            }
            if (isDirectory) {
                directoryPath = filePath;
            } else {
                directoryPath = [filePath stringByDeletingLastPathComponent];
                directoryContents = @[[filePath lastPathComponent]];
            }
        } else {
            printf("Usage is \'SnippetImport SnippetDirectoryFullPath/SnippetFileFullPath\'");
            return 0;
        }
        if (directoryPath) {
            if (!directoryContents) {
                NSError *getContentsOfDirectoryError;
                directoryContents = [fm contentsOfDirectoryAtPath:directoryPath error:&getContentsOfDirectoryError];
                if (getContentsOfDirectoryError) {
                    printf("Get Directory Contents Failed at path : %s ; error : %s", argv[1], [getContentsOfDirectoryError.description cStringUsingEncoding:NSUTF8StringEncoding]);
                    return 0;
                }
            }
            // Get all .m files
            // equal to Regular Expression ^.*\\.m$
            directoryContents = [directoryContents filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF ENDSWITH[cd] \'.m\'"]];
            for (NSString *fileName in directoryContents) {
                SISnippet *snippet = [[SISnippet alloc] initWithContentsOfFile:[filePath stringByAppendingPathComponent:fileName]];
                if (snippet.save) {
                    NSLog(@"Saved snippet %@ as %@", fileName, [snippet.snippetDic[kIdentifierKey] stringByAppendingPathExtension:@"xcodesnippet"]);
                } else {
                    NSLog(@"Failed to save snippet %@", fileName);
                }
            }
        }
    }
    return 0;
}
