//
//  ServiceRequest.h
//  Acronyms
//
//  Created by Sumitha Palanisamy on 1/6/16.
//  Copyright (c) 2016 Sumitha Palanisamy. All rights reserved.
//

#import <Foundation/Foundation.h>

//A protocol to check the status of the service request
@protocol ServiceDelegate
- (void)dataRecieved:(NSDictionary *)dataDict; // for success this will be called
- (void)dataError:(NSString*)errorStr;    // for failure this will be called
@end

@interface ServiceRequest : NSObject

@property(nonatomic,weak) id<ServiceDelegate> serviceDelegate;
- (void)getDataFromServer:(NSString*)acronym;
@end
