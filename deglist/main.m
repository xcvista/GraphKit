//
//  main.m
//  deglist
//
//  Created by Maxthon Chan on 12-5-27.
//  Copyright (c) 2012年 Donghua University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GraphKit/GraphKit.h>
#import "help.h"

int main(int argc, const char **argv)
{
    @autoreleasepool
    {
        NSString *input_file;
        
        for (int i = 1; i < argc; i++) {
            if (!strncmp(argv[i], "-V", 2) || !strcmp(argv[i], "--version"))
            {
                version(argv[0], YES, EXIT_SUCCESS);
            }
            else if (!strncmp(argv[i], "-h", 2) || !strcmp(argv[1], "--help"))
            {
                help_full(argv[0], YES, EXIT_SUCCESS);
            }
            else
            {
                input_file = [NSString stringWithCString:argv[i] encoding:NSUTF8StringEncoding];
            }
        }
        
        if (!input_file.length)
        {
            help(argv[0], YES, EXIT_FAILURE);
        }
        
        GKGraph *input_graph = [NSKeyedUnarchiver unarchiveObjectWithFile:[input_file stringByExpandingTildeInPath]];
        
        for (GKPoint *point in input_graph.points)
        {
            NSArray *inb = point.incomingBorders;
            NSArray *oub = point.outgoingBorders;
            GKPower inp = 0, oup = 0;
            for (GKBorder *b in inb)
                inp += b.power;
            for (GKBorder *b in oub)
                oup += b.power;
            printf("%4s in:%3lu, % 7.2lf; out:%3lu, % 7.2lf.\n", [point.name cStringUsingEncoding:[NSString defaultCStringEncoding]], inb.count, inp, oub.count, oup);
        }
        exit(EXIT_SUCCESS);
    }
}