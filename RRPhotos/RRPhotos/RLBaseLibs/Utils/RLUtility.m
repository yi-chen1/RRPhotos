//
//  RLUtility.m
//  RRSpring
//
//  Created by renren-inc on 12-2-21.
//  Copyright (c) 2012年 Renn. All rights reserved.
//

#import "RLUtility.h"

@implementation RLUtility

///////////////////////////////////////////////////////////////////////////////////////////////////
+(id)convertAsacIItoUTF8Array:(NSArray*)dictionary{
	NSMutableArray* result=[[[NSMutableArray alloc]initWithCapacity:0]autorelease];
	
	for (int i=0; i<[dictionary count]; i++) {
		id value=[dictionary objectAtIndex:i];
		if([value isKindOfClass:[NSString class]]){
			NSString *str=(NSString*)value;
			
			NSData *asciiData = [str dataUsingEncoding:NSMacOSRomanStringEncoding allowLossyConversion:YES];
			
			NSString *tempUTF8 = [[[NSString alloc] initWithData:asciiData encoding:NSUTF8StringEncoding]autorelease];
			
			[result addObject:tempUTF8];
		}else if([value isKindOfClass:[NSDictionary class]]){
			NSDictionary* tempDictionary=[self convertAsacIItoUTF8:value];
			[result addObject:tempDictionary];
		}else if([value isKindOfClass:[NSArray class]]){
			NSArray* tempArray=[self convertAsacIItoUTF8Array:value];
			
			[result addObject:tempArray];
		}else {
			[result addObject:value];
		}
		
	}
	return result;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+(id)convertAsacIItoUTF8:(NSDictionary*)dictionary{
	NSMutableDictionary* result=[[[NSMutableDictionary alloc]initWithCapacity:0]autorelease];
	NSArray* keyArray=[dictionary allKeys];
	for (int i=0; i<[keyArray count]; i++) {
		id value=[dictionary objectForKey:[keyArray objectAtIndex:i]];
		if([value isKindOfClass:[NSString class]]){
			NSString *str=(NSString*)value;
			
			NSData *asciiData = [str dataUsingEncoding:NSMacOSRomanStringEncoding allowLossyConversion:YES];
			
			NSString *tempUTF8 = [[[NSString alloc] initWithData:asciiData encoding:NSUTF8StringEncoding]autorelease];
			
			[result setObject:tempUTF8 forKey:[keyArray objectAtIndex:i]];
			
		}else if([value isKindOfClass:[NSDictionary class]]){
			NSDictionary* tempDictionary=[self convertAsacIItoUTF8:value];
			[result setObject:tempDictionary forKey:[keyArray objectAtIndex:i]];
		}else if([value isKindOfClass:[NSArray class]]){
			NSArray* tempArray=[self convertAsacIItoUTF8Array:value];
			
			//NSDictionary* tempDictionary=[self convertAsacIItoUTF8:value];
			[result setObject:tempArray forKey:[keyArray objectAtIndex:i]];
		}else {
			[result setObject:value forKey:[keyArray objectAtIndex:i]];
		}
		
	}
	return result;
}

@end
