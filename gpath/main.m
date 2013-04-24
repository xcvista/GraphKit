//
//  main.m
//  gpath
//
//  Created by Maxthon Chan on 12-5-28.
//  Copyright (c) 2012年 Donghua University. All rights reserved.
//

#import "main.h"
#import "help.h"

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        NSString *input_file;
        NSString *source_point, *dest_point;
        GKMode mode = unknown;
        
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
                    else if (!strcmp(argv[i], "--to"))
                    {
                        i++;
                        dest_point = [NSString stringWithCString:argv[i] encoding:[NSString defaultCStringEncoding]];
                    }
                    else if (!strcmp(argv[i], "--verbose"))
                    {
                        //verbose_path = YES;
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
                            case 't':
                                i++;
                                dest_point = [NSString stringWithCString:argv[i] encoding:[NSString defaultCStringEncoding]];
                                break;
                            case 'v':
                                //verbose_path = YES;
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
                if (i == 1)
                {
                    if (!strcmp(argv[1], "shortest-path"))
                    {
                        mode = short_path;
                    }
                    else if (!strcmp(argv[1], "max-flow"))
                    {
                        mode = max_flow;
                    }
                    else
                    {
                        fprintf(stderr, "ERROR: Unrecognized mode: %s.\n", argv[1]);
                        exit(EXIT_FAILURE);
                    }
                }
                else
                {
                    input_file = [NSString stringWithCString:argv[i] encoding:[NSString defaultCStringEncoding]];
                }
            }
        }
        
        if (!input_file.length || !source_point.length || !dest_point.length || !mode)
        {
            fprintf(stderr, "ERROR: Insufficient parameters.\n");
            exit(EXIT_FAILURE);
        }
        
        GKGraph *input_graph;
        
        input_graph = [NSKeyedUnarchiver unarchiveObjectWithFile:[input_file stringByExpandingTildeInPath]];
        
        GKPoint *from = [input_graph pointWithName:source_point];
        GKPoint *to = [input_graph pointWithName:dest_point];
        
        switch (mode)
        {
            case max_flow:
                fprintf(stderr, "Maximal flow not implmented yet.\n");
                exit(EXIT_FAILURE);
                break;
            case short_path:
            {
                NSArray *path = [input_graph shortestPathFromPoint:from toPoint:to];
                GKPower dist = 0;
                const char *prev = [from.name cStringUsingEncoding:[NSString defaultCStringEncoding]];
                if (path) {
                    printf("Path: %s\n", prev);
                    for (GKBorder *b in path)
                    {
                        dist += b.power;
                        const char *curr = [b.to.name cStringUsingEncoding:[NSString defaultCStringEncoding]];
                        printf("%s -%.2lf-> %s\n", prev, b.power, curr);
                        prev = curr;
                    }
                    printf("Distance: %.2lf\n", dist);
                }
                else
                {
                    printf("No path found.\n");
                }
            }
            default:
                break;
        }
        
        exit(EXIT_SUCCESS);
    }
}

