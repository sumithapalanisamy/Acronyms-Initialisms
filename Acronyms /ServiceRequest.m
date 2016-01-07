//
//  ServiceRequest.m
//  Acronyms
//
//  Created by Sumitha Palanisamy on 1/6/16.
//  Copyright (c) 2016 Sumitha Palanisamy. All rights reserved.
//

#import "ServiceRequest.h"
#import "AFNetworking.h"

static NSString * const URLString = @"http://www.nactem.ac.uk/software/acromine/dictionary.py?";

@implementation ServiceRequest

//To get acronym related data from server
- (void)getDataFromServer:(NSString*)acronym
{
    NSString *stringURL = [NSString stringWithFormat:@"%@sf=%@", URLString, acronym];
    NSURL *url = [NSURL URLWithString:stringURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError* error;
        NSDictionary* jsonData = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                 options:kNilOptions
                                                                   error:&error];
    
        [self.serviceDelegate dataRecieved:jsonData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.serviceDelegate dataError:[error localizedDescription]];
    }];
    
    [operation start];
}

@end
