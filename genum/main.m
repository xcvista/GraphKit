//
//  main.m
//  genum
//
//  Created by Maxthon Chan on 12-11-27.
//  Copyright (c) 2012年 Donghua University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GraphKit/GraphKit.h>
#import "help.h"
#import "enum.h"

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        NSString *input_file;
        NSString *source_point;
        BOOL json = NO;
        BOOL reverse = NO;
        
        for (int i = 1; i < argc; i++)
        {
            if (*argv[i] == '-') //switch
            {
                if (*(argv[i] + 1) == '-') // -- full switch
                {
                    if (!strcmp(argv[i], "--from"))
                    {
                        i++;
                        source_point = [NSString stringWithCString:argv[i] encoding:[NSString defaultCStringEncoding]];
                    }
                    else if (!strcmp(argv[i], "--help"))
                    {
                        help_full(argv[0], YES, EXIT_SUCCESS);
                    }
                    else if (!strcmp(argv[i], "--json"))
                    {
                        json = YES;
                    }
                    else if (!strcmp(argv[i], "--plist"))
                    {
                        json = NO;
                    }
                    else if (!strcmp(argv[i], "--reverse"))
                    {
                        reverse = YES;
                    }
                    else if (!strcmp(argv[i], "--version"))
                    {
                        version(argv[0], YES, EXIT_SUCCESS);
                    }
                    else
                    {
                        fprintf(stderr, "ERROR: Unrecognized switch: %s.\n", argv[i]);
                        exit(EXIT_FAILURE);
                    }
                }
                else
                {
                    for (char *p = (char *)(argv[i] + 1); *p; p++)
                    {
                        switch (*p)
                        {
                            case 'f':
                                i++;
                                source_point = [NSString stringWithCString:argv[i] encoding:[NSString defaultCStringEncoding]];
                                break;
                            case 'h':
                                help_full(argv[0], YES, EXIT_SUCCESS);
                                break;
                            case 'j':
                                json = YES;
                                break;
                            case 'p':
                                json = NO;
                                break;
                            case 'r':
                                reverse = YES;
                                break;
                            case 'V':
                                version(argv[0], YES, EXIT_SUCCESS);
                                break;
                            default:
                                fprintf(stderr, "ERROR: Unrecognized switch: -%c.\n", *p);
                                exit(EXIT_FAILURE);
                                break;
                        }
                    }
                }
            }
            else
            {
                input_file = [NSString stringWithCString:argv[i] encoding:[NSString defaultCStringEncoding]];
            }
        }
        
        if (!input_file.length || !source_point.length)
        {
            fprintf(stderr, "ERROR: Insufficient parameters.\n");
            exit(EXIT_FAILURE);
        }
        
        GKGraph *input_graph;
        NSDictionary *input_plist;
        
        if (json)
        {
            input_plist = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:[input_file stringByExpandingTildeInPath]] options:0 error:NULL];
        }
        else
        {
            input_plist = [NSDictionary dictionaryWithContentsOfFile:[input_file stringByExpandingTildeInPath]];
        }
        
        input_graph = [[GKGraph alloc] initFromArchive:input_plist];
        
        GKPoint *from = [input_graph pointWithName:source_point];
        
        if (reverse)
            widthSearch(input_graph, from);
        else
            depthSearch(input_graph, from);

    }
    return 0;
}

