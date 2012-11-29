//
//  main.m
//  gdlc
//
//  Created by Maxthon Chan on 12-5-26.
//  Copyright (c) 2012年 Donghua University. All rights reserved.
//

#import "main.h"
#import "help.h"

int main(int argc, const char **argv)
{
    @autoreleasepool
    {
        //Defining vars
        NSString *input_file;
        NSString *output_file;
        
        NSData *input_data;
        NSString *input_content;
        NSArray *input_lines;
        
        BOOL verbose = NO;
        BOOL json = NO;
        
        GKGraph *output_object;
        
        //Constants for schmentics
        NSCharacterSet *tokens = [NSCharacterSet characterSetWithCharactersInString:@"<>.-"];
        NSCharacterSet *comments = [NSCharacterSet characterSetWithCharactersInString:@"#;"];
        // NSCharacterSet *reserved = [NSCharacterSet characterSetWithCharactersInString:@"@$"];
        NSCharacterSet *power = [NSCharacterSet characterSetWithCharactersInString:@":"];
        
        //Read arguments
        for (int i = 1; i < argc; i++)
        {
            if (*argv[i] == '-')
            {
                if (*(argv[i] + 1) == '-')
                {
                    if (!strcmp(argv[i], "--output"))
                    {
                        i++;
                        output_file = [NSString stringWithCString:argv[i] encoding:[NSString defaultCStringEncoding]];
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
                    else if (!strcmp(argv[i], "--version"))
                    {
                        version(argv[0], YES, EXIT_SUCCESS);
                    }
                    else if (!strcmp(argv[i], "--verbose"))
                    {
                        verbose = YES;
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
                        switch (*p) {
                            case 'o':
                                i++;
                                output_file = [NSString stringWithCString:argv[i] encoding:[NSString defaultCStringEncoding]];
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
                            case 'v':
                                verbose = YES;
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
        
        if ((!input_file.length) || (!output_file.length))
        {
            fprintf(stderr, "ERROR: Insufficent parameters.\n");
            exit(EXIT_FAILURE);
        }
        
        //Parse file names
        input_file = [input_file stringByExpandingTildeInPath];
        output_file = [output_file stringByExpandingTildeInPath];
        
        //Read the input
        input_data = [NSData dataWithContentsOfFile:input_file];
        input_content = [[NSString alloc] initWithData:input_data encoding:[NSString defaultCStringEncoding]];
        
        //Prepare for parsing
        input_lines = [input_content componentsSeparatedByString:@"\n"];
        output_object = [[GKGraph alloc] init];
        
        for (NSString *input_line in input_lines)
        {
            //The pointer should not be const
            NSString *input = input_line;
            
            //Filter off comments
            NSRange comment_begin = [input rangeOfCharacterFromSet:comments options:0];
            if (comment_begin.location != NSNotFound)
                input = [input substringToIndex:comment_begin.location];
            
            //Filter off trailing blanks
            input = [input stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            //Fetch the power
            GKPower p = 1;
            NSRange power_end = [input rangeOfCharacterFromSet:power options:0];
            if (power_end.location != NSNotFound)
            {
                p = [[input substringToIndex:power_end.location] doubleValue];
                input = [input substringFromIndex:power_end.location + power_end.length];
            }
            
            //Strip off blanks
            input = [input stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            NSString *name_previous = @"";
            GKOperator operator_previous = GKOperatorPoint;
            
            while (input.length)
            {
                NSRange operator_next_loc = [input rangeOfCharacterFromSet:tokens];
                if (operator_next_loc.location != NSNotFound)
                {
                    GKOperator op = [input characterAtIndex:operator_next_loc.location];
                    NSString *name = [[input substringToIndex:operator_next_loc.location] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    switch (operator_previous)
                    {
                        case GKOperatorConnet:
                            [output_object connectPoint:[output_object pointWithName:name_previous]
                                              withPoint:[output_object pointWithName:name]
                                              withPower:p];
                            break;
                            
                        case GKOperatorFrom:
                            [output_object connectFromPoint:[output_object pointWithName:name_previous]
                                                    toPoint:[output_object pointWithName:name]
                                                  withPower:p];
                            break;
                            
                        case GKOperatorTo:
                            [output_object connectFromPoint:[output_object pointWithName:name]
                                                    toPoint:[output_object pointWithName:name_previous]
                                                  withPower:p];
                            
                        default:
                            break;
                    }
                    if (op == GKOperatorPoint)
                    {
                        [output_object pointWithName:name];
                    }
                    name_previous = name;
                    operator_previous = op;
                    input = [[input substringFromIndex:operator_next_loc.location + operator_next_loc.length] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                }
                else
                {
                    NSString *name = [input stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    switch (operator_previous)
                    {
                        case GKOperatorConnet:
                            [output_object connectPoint:[output_object pointWithName:name_previous]
                                              withPoint:[output_object pointWithName:name]
                                              withPower:p];
                            break;
                            
                        case GKOperatorFrom:
                            [output_object connectFromPoint:[output_object pointWithName:name_previous]
                                                    toPoint:[output_object pointWithName:name]
                                                  withPower:p];
                            break;
                            
                        case GKOperatorTo:
                            [output_object connectFromPoint:[output_object pointWithName:name]
                                                    toPoint:[output_object pointWithName:name_previous]
                                                  withPower:p];
                            
                        default:
                            break;
                    }
                    name_previous = name;
                    operator_previous = GKOperatorPoint;
                    input = @"";
                }
            }
        }
        
        //Write the archive
        if (json)
        {
            [[NSJSONSerialization dataWithJSONObject:output_object.archive options:NSJSONWritingPrettyPrinted error:NULL] writeToFile:output_file atomically:YES];
        }
        else
        {
            [[NSPropertyListSerialization dataFromPropertyList:output_object.archive format:NSPropertyListXMLFormat_v1_0 errorDescription:NULL] writeToFile:output_file atomically:YES];
        }
        
        exit(EXIT_SUCCESS);
    }
}
