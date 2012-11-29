//
//  help.m
//  GraphFunhouse
//
//  Created by Maxthon Chan on 12-5-27.
//  Copyright (c) 2012年 Donghua University. All rights reserved.
//

#import "help.h"

void help(const char *argv0, BOOL do_exit, int exit_value)
{
    version(argv0, NO, exit_value);
    fprintf(stderr, "Usage:    %s shortest-path [-j | -p] input-file -f from-point -t to-point\n"
                    "          %s max-flow      [-j | -p] input-file -f from-point -t to-point"
                    "\n",
            [[[NSString stringWithCString:argv0 encoding:[NSString defaultCStringEncoding]] lastPathComponent] cStringUsingEncoding:[NSString defaultCStringEncoding]],
            [[[NSString stringWithCString:argv0 encoding:[NSString defaultCStringEncoding]] lastPathComponent] cStringUsingEncoding:[NSString defaultCStringEncoding]]);
    if (do_exit)
    {
        copyright();
        exit(exit_value);
    }
}

void help_full(const char *argv0, BOOL do_exit, int exit_value)
{
    help(argv0, NO, exit_value);
    fprintf(stderr, "Synposis: %s will compute the shortest path (shortest-path) or\n"
                    "          maximal (max-flow) flow bandwidth from a given point to another.\n"
                    "\n",
            [[[NSString stringWithCString:argv0 encoding:[NSString defaultCStringEncoding]] lastPathComponent] cStringUsingEncoding:[NSString defaultCStringEncoding]]);
    fprintf(stderr, "Options:  -f, --from:    Indicate the source point.\n"
                    "          -h, --help:    Display this help message.\n"
                    "          -j, --json:    Input JSON file.\n"
                    "          -p, --plist:   Input Apple Property List file.\n"
                    "          -t, --to:      Indicate the destination point.\n"
                    "          -v, --verbose: Print debug information to standard error.\n"
                    "          -V, --version: Display the version information.\n"
                    "\n");
    if (do_exit)
    {
        copyright();
        exit(exit_value);
    }
}

void version(const char *argv0, BOOL do_exit, int exit_value)
{
    fprintf(stderr, "%s: Graph Descriptor path finder, Version: 1.0.1 (20121127)\n"
                    "\n",
            [[[NSString stringWithCString:argv0 encoding:[NSString defaultCStringEncoding]] lastPathComponent] cStringUsingEncoding:[NSString defaultCStringEncoding]]);
    if (do_exit)
    {
        copyright();
        exit(exit_value);
    }
}

void copyright(void)
{
    fprintf(stderr, "Copyright (c) 2012 Maxthon Chan, Some Rights Reserved.\n"
                    "This software is Free Software. You may obtain, use, modify and\n"
                    "redistribute this software freely.\n");
}