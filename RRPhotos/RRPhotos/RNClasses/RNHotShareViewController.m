//
//  RNExploreViewController.m
//  RRPhotos
//
//  Created by yi chen on 12-5-11.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import "RNHotShareViewController.h"
#import "RNHotShareModel.h"
#import "UIImageView+RRWebImage.h"

#define kImageHeight 76.25
#define kImageWidth 76.25 //图片的宽高
#define kImageSpace 5.0  //图片间隙

@interface RNHotShareViewController() 

//显示照片数据
- (void)displayHotSharePhotos;

@end

@implementation RNHotShareViewController

@synthesize hotShareItems = _hotShareItems;
@synthesize contentScrollView = _contentScrollView;
@synthesize parentController = _parentController;
- (void)dealloc{

	self.hotShareItems = nil;
	self.contentScrollView = nil;
	self.parentController = nil;
	[super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		
	}
    return self;
}

/*
 重载父类的创建model
 */
- (void)createModel {
	NSString *typeString = @"8";//只请求只与相册有关的数据，参考wiki文档
	
	//新鲜事类型
	RNHotShareModel *model = [[RNHotShareModel alloc]initWithTypeString:typeString];
	self.model = (RNModel *) model;
	[self.model load:YES];//加载数据
}


/*
	开始加载
 */
- (void)modelDidStartLoad:(RNModel *)model {
	
}

/*
	网络加载完成
 */
- (void)modelDidFinishLoad:(RNModel *)model{
	
	NSArray *hotShareItems = ((RNHotShareModel *)model).hotShareItems;
	if (hotShareItems) {
		///////
		NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:[hotShareItems count]];
		self.hotShareItems = array ;
		[array release];
		for (id object in hotShareItems) {
			if ([object isKindOfClass: NSDictionary.class ]) {
				RNHotShareItem *item = [RNHotShareItem hotShareItemWithDictionary:object];
				[self.hotShareItems addObject:item];
			}
		}
	}
	
	[self displayHotSharePhotos];
}	

/*
	加载照片
 */
- (void)displayHotSharePhotos{
	//计算总的滚动视图的高度
	self.contentScrollView.contentSize = CGSizeMake(PHONE_SCREEN_SIZE.width, 
													([self.hotShareItems count] / 4 + 1) * (kImageSpace + kImageHeight));
	[self.contentScrollView removeAllSubviews];
	
	NSInteger photoIndex = 0;
	for(RNHotShareItem * item in self.hotShareItems){
		CGFloat currentY = 0;
		CGFloat currentX = 0;
		
		currentY = (kImageHeight + kImageSpace ) * (int) (photoIndex / 4);
		currentX = (photoIndex % 4) * (kImageSpace + kImageWidth);
		//计算每个预览图的坐标
		CGRect r = CGRectMake(currentX, currentY, kImageWidth, kImageHeight);
		UIImageView *photoImageView = [[UIImageView alloc]initWithFrame:r];
		//视图的索引
		photoImageView.tag = photoIndex; 
		//添加点击事件
		photoImageView.userInteractionEnabled = YES;
		[photoImageView addTargetForTouch:self action:@selector(onTapPhotoImageView:)];
		
		NSURL *url = [NSURL URLWithString:item.photoUrl];
		[photoImageView setImageWithURL:url];

		[self.contentScrollView addSubview:photoImageView];
		[photoImageView release];
		photoIndex ++;
	}
}

#pragma mark - view lifecycle
- (void)loadView{
	
	[super loadView];
	self.navBar.hidden = YES; //采用系统的navbar
	
	[self.view addSubview:self.contentScrollView];
}

- (void)viewDidLoad{
	
	[super viewDidLoad];
}

- (void)viewDidUnload{
	
	[super viewDidUnload];

	self.contentScrollView = nil;

}

/*
	显示所有热门分享照片的滚动视图
 */
- (UIScrollView *)contentScrollView {
	
	if (!_contentScrollView) {
		_contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,
																		  0,
																		  PHONE_SCREEN_SIZE.width, 
																		  PHONE_SCREEN_SIZE.height)];
//		_contentScrollView.backgroundColor = [UIColor redColor];
		_contentScrollView.backgroundColor = RGBCOLOR(222, 222, 222);
	}
	
	return  _contentScrollView;
}

/*
	点击热门分享里面的一张图片,将会进入热门照片内容页
 */
- (void)onTapPhotoImageView :(id)sender{
	//取得点击事件的分享数据项
	RNHotShareItem *item = [self.hotShareItems objectAtIndex:((UITapGestureRecognizer *)sender).view.tag];
	RNHotShareContentViewController *contentViewContoller = [[RNHotShareContentViewController alloc]initWithHotShareItem:item];
	contentViewContoller.hidesBottomBarWhenPushed = YES;
	[self.parentController.navigationController pushViewController:contentViewContoller animated:YES];
	TT_RELEASE_SAFELY(contentViewContoller);
}
@end
