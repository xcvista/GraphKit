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
    fprintf(stderr, "Usage:    %s [-Vhjp] input-file\n"
                    "\n",
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
    fprintf(stderr, "Synposis: %s lists all points in a given graph compiled with\n"
                    "          gdlc with their in and out degrees.\n"
                    "\n",
            [[[NSString stringWithCString:argv0 encoding:[NSString defaultCStringEncoding]] lastPathComponent] cStringUsingEncoding:[NSString defaultCStringEncoding]]);
    fprintf(stderr, "Options:  -h, --help:    Display this help message.\n"
                    "          -j, --json:    Output JSON file.\n"
                    "          -V, --version: Display version information.\n"
                    "\n");
    if (do_exit)
    {
        copyright();
        exit(exit_value);
    }
}

void version(const char *argv0, BOOL do_exit, int exit_value)
{
    fprintf(stderr, "%s: Graph Descriptor Language point degree list,\n"
                    "Version: 1.0.1 (20121126)\n"
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