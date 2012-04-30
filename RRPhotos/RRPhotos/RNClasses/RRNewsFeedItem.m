//
//  RRNewsFeedItem.m
//  RRPhotos
//
//  Created by yi chen on 12-4-13.
//  Copyright (c) 2012年 renren. All rights reserved.
//
#import "RRNewsFeedItem.h"

#define kFeedAbstractLength 35

#pragma -mark //////RRNewsFeedItem///////////////////////////////////

@implementation RRNewsFeedItem

@synthesize feedId = _feedId;
@synthesize sourceId = _sourceId;
@synthesize feedType = _feedType;
@synthesize updateTime = _updateTime;
@synthesize userId = _userId;
@synthesize userName = _userName;
@synthesize headUrl = _headUrl;
@synthesize prefix = _prefix;
@synthesize content = _content;
@synthesize title = _title;
@synthesize titleUrl = _titleUrl;
@synthesize originType = _originType;
@synthesize originTitle = _originTitle;
@synthesize originIconUrl = _originIconUrl;
@synthesize originPageId = _originPageId;
@synthesize originUrl = _originUrl;
@synthesize decription = _description;
@synthesize commentCount = _commentCount;
@synthesize attachments = _attachments;
@synthesize pageImageUrl = _pageImageUrl;
- (void)dealloc{
	self.feedId = nil;
	self.sourceId = nil;
	//
	self.updateTime = nil;
	self.userId = nil;
	self.userName = nil;
	self.headUrl = nil;
	self.prefix = nil;
	self.content = nil;
	self.title = nil;
	self.titleUrl = nil;
	//
	self.originTitle = nil;
	self.originIconUrl = nil;
	self.originPageId = nil;
	self.originUrl = nil;
	self.decription = nil;
	self.commentCount = nil;
	self.attachments = nil;
	self.pageImageUrl = nil;
	
	[super dealloc];
}

+ (id)newsfeedWithDictionary:(NSDictionary*) dictionary{
	RRNewsfeedType myFeedType = [[dictionary objectForKey:@"type"] intValue];
	switch (myFeedType) {
		case RRItemTypeAlbumShared:
		case RRItemTypePhotoUploadForPage:
        case RRItemTypeAlbumSharedForPage:
		case RRItemTypePhotoSharedForPage:
		case RRItemTypePhotoShared:
		case RRItemTypePhotoUploadOne:
		case RRItemTypePhotoUploadMore: { //目前支持照片的新鲜事
			RRNewsfeedPhotoItem* newsfeed = [[[RRNewsfeedPhotoItem alloc] initWithDictionary:dictionary] autorelease];
			return newsfeed;
		}break;
			
		default:
			break;
	}
	return nil;

}

//初始化方法
- (id)initWithDictionary:(NSDictionary*) dictionary
{
	if (self = [super init]) {
		NSLog(@"原始数据 ------------- %@",dictionary);
		self.feedId = [dictionary objectForKey:@"id"];
		self.sourceId = [dictionary objectForKey:@"source_id"];
		self.sourceId = [dictionary objectForKey:@"source_id"];
		self.feedType = [[dictionary objectForKey:@"type"] intValue];
		self.userId = [dictionary objectForKey:@"user_id"];
		self.titleUrl = [dictionary objectForKey:@"url"];
		self.userName = [NSString preParseER:[dictionary objectForKey:@"user_name"]];
		self.title = [dictionary objectForKey:@"title"];
		self.prefix = [dictionary objectForKey:@"prefix"];

		self.updateTime = [NSDate dateWithTimeIntervalSince1970:[[dictionary objectForKey:@"time"] doubleValue]/1000];
		self.commentCount = [dictionary objectForKey:@"comment_count"] ;
		
		self.originTitle = [dictionary objectForKey:@"origin_title"];
        self.originPageId = [dictionary objectForKey:@"origin_page_id"];
        self.originUrl = [dictionary objectForKey:@"origin_url"];
        self.originIconUrl = [dictionary objectForKey:@"orgin_img"]; 
		
		NSString* message = [NSString preParseER:[dictionary objectForKey:@"content"] ];
		if (message && ![message isMemberOfClass:[NSNull class]]) {
			message = [message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			self.content = message;
		} else {
			self.content = nil;
		}
        
		self.headUrl = [dictionary objectForKey:@"head_url"];
        if (![self.headUrl hasPrefix:@"http:"]) {
            self.headUrl = nil;
        } 		
		
		       
	}
	
	return self;
}

/*
	返回第一个附件
 */
- (RRAttachment*)firstAttachment {
	if (!_attachments || 0 == _attachments.count) {
		return nil;
	} else {
		return [_attachments objectAtIndex:0];
	}
}

/*
	返回最后一个附件
 */
- (RRAttachment*)lastAttachment {
	return [_attachments lastObject];
}

/*
	新鲜事摘要
 */
- (NSArray *)feedAbstract {
	NSString *s1 = [NSString stringWithFormat:@"%@ %@%@",self.userName,self.prefix,self.title];
	if ([s1 length] > kFeedAbstractLength) {
		s1 = [NSString stringWithFormat:@"%@...",[s1 substringToIndex:kFeedAbstractLength]];
	}
	
	return [NSArray arrayWithObjects:s1,[self.updateTime formatRelativeTime],nil];
}

@end


#pragma -mark //////////RRNewsfeedPhotoItem/////////////////////
/*
	照片新鲜事
 */
@implementation RRNewsfeedPhotoItem
@synthesize aid;

- (id)initWithDictionary:(NSDictionary*) dictionary {
	if (self = [super initWithDictionary:dictionary]) {
		// Attachment
		NSArray* jAttachments = [dictionary objectForKey:@"attachement_list"];
		NSMutableArray* attachments = [[[NSMutableArray alloc] initWithCapacity:jAttachments.count] autorelease];
		for (NSDictionary* jAttachment in jAttachments) {
			RRAttachment* attachment = [RRAttachment attachmentWithDictionary:jAttachment];
			[attachments addObject:attachment ];
		}
		self.attachments = attachments;
		self.sourceId = [dictionary objectForKey:@"source_id"];
		
	}
	
	return self;
}
- (NSArray *)feedAbstract {
	if (self.feedType == RRItemTypePhotoUploadOne || self.feedType == RRItemTypePhotoUploadMore || self.feedType == RRItemTypeBlogPublishForPage) {
		NSString *s1 = [NSString stringWithFormat:@"%@ %@@",self.userName,self.prefix,self.title];
		if ([s1 length] > kFeedAbstractLength) {
			s1 = [NSString stringWithFormat:@"%@...",[s1 substringToIndex:kFeedAbstractLength]];
		}
        
		return [NSArray arrayWithObjects:s1,[self.updateTime formatRelativeTime ],nil];
	}
	return [super feedAbstract];
	return nil;
}


- (NSNumber *) aid {
	return super.sourceId;
}

//- (NSNumber *) sourceId {
//	
//	RRAttachment *attachment = [self firstAttachment];
//	if (attachment.mediaId) {
//        return attachment.mediaId;
//	}
//	return super.sourceId;// 这个是aid，mediaId是pid
//}
//- (NSNumber *) sourceId {
//	return _sourceId;
//}

@end

#pragma -mark ///////////RRAttachment////////////////////////////////////
/*
	表示新鲜事中包含的媒体内容附件，例如照片，视频
 */
@implementation RRAttachment

@synthesize mediaId = _mediaId;
@synthesize mediaType = _mediaType;
@synthesize digest = _digest;
@synthesize href = _href;
@synthesize main_url = _main_url;


+ (id)attachmentWithDictionary:(NSDictionary*) dictionary {
	RRAttachment* attachment = [[[RRAttachment alloc] initWithDictionary:dictionary] autorelease];
	return attachment;
}

- (id)initWithDictionary:(NSDictionary*) dictionary
{
	if (self = [super init]) {
        
		self.mediaId = [dictionary objectForKey:@"media_id"];
		self.mediaType = [dictionary objectForKey:@"type"];
		self.digest = [dictionary objectForKey:@"digest"];
		self.href = [dictionary objectForKey:@"url"];
		self.main_url = [dictionary objectForKey:@"main_url"];
        //		self.ownerId = [dictionary objectForKey:@"owner_id"];
        //		// 有些接口返回的数据类型是字符串.
        //		if ([self.ownerId isKindOfClass:[NSString class]]) {
        //			NSString* ownerIdStr = (NSString*) self.ownerId;
        //			self.ownerId = [ownerIdStr stringToNumber];
        //		}
        //		
        //		self.ownerName = [NSString preParseER:[dictionary objectForKey:@"owner_name"]];
	}
	return self;
}
- (void) dealloc {
	
	TT_RELEASE_SAFELY(_mediaId);
	TT_RELEASE_SAFELY(_mediaType);
	TT_RELEASE_SAFELY(_digest);
	TT_RELEASE_SAFELY(_href);
    TT_RELEASE_SAFELY(_main_url);
    //	TT_RELEASE_SAFELY(_ownerId);
    //	TT_RELEASE_SAFELY(_ownerName);
	
	[super dealloc];
}

@end


