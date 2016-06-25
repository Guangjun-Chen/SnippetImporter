# SnippetImporter
## What is this
This is a Mac Command Line tool to help import the snippet clone from [mattt](https://github.com/Xcode-Snippets/Objective-C) or other place.
## Why I making this
The reason why I makeing this is that I don't want to import other programmers' good snippets one by one(boring). And the **ACCodeSnippetRepositoryPlugin** can't be used in Xcode 7 and the most important reason is that I can't fix it because I haven't learn about how the plugin is loaded and run. 
## Snippet Format
The format of the snippet must be as the fllow:

```
---
title: "dispatch_async Pattern for Background Processing"
summary: "Dispatch to do work in the background, and then to the main queue with the results"
completion-scope: Function or Method
---
dispatch_async(dispatch_get_global_queue(<#dispatch_queue_priority_t priority#>, <#unsigned long flags#>), ^(void) {

    <#code#>




    dispatch_async(dispatch_get_main_queue(), ^(void) {

        <#code#>

    });

});
```

##Usage
The usage of this tool is 
`SnippetImporter SnippetDirectoryFullPath/SnippetFileFullPath`

##Todo
1. Add Snippets Synchronization to Github and make it become a Xcode plugin (If I can't fix **ACCodeSnippetRepositoryPlugin**)
2. Fix the **ACCodeSnippetRepositoryPlugin**,  make it available in Xcode 7/8 (Which is killing the repository😀)

