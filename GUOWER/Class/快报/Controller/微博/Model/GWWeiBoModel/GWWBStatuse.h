//
//	GWWBStatuse.h
//
//	Create by ourslook on 24/7/2018
//	Copyright © 2018. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>
#import "GWWBAnnotation.h"
#import "GWWBCommentManageInfo.h"
#import "GWWBUser.h"
#import "GWWBVisible.h"

@interface GWWBStatuse : NSObject

/** cellCollectionViewHeight */
@property (nonatomic, assign) CGFloat collectionViewHeight;
/** cellHeight */
@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, strong) NSArray * annotations;
@property (nonatomic, assign) NSInteger attitudes_count;
@property (nonatomic, assign) NSInteger biz_feature;
@property (nonatomic, strong) NSArray * bizIds;
@property (nonatomic, assign) BOOL can_edit;
@property (nonatomic, strong) NSString * cardid;
@property (nonatomic, strong) GWWBCommentManageInfo * comment_manage_info;
@property (nonatomic, assign) NSInteger comments_count;
@property (nonatomic, assign) NSInteger content_auth;
@property (nonatomic, strong) NSString * created_at;
@property (nonatomic, strong) NSArray * darwin_tags;
@property (nonatomic, assign) BOOL favorited;
@property (nonatomic, strong) NSObject * geo;
@property (nonatomic, strong) NSString * gif_ids;
@property (nonatomic, assign) NSInteger has_action_type_card;
@property (nonatomic, assign) NSInteger hide_flag;
@property (nonatomic, strong) NSArray * hot_weibo_tags;
@property (nonatomic, assign) NSInteger id_field;
@property (nonatomic, strong) NSString * idstr;
@property (nonatomic, strong) NSString * in_reply_to_screenName;
@property (nonatomic, strong) NSString * in_reply_to_statusId;
@property (nonatomic, strong) NSString * in_reply_to_userId;
@property (nonatomic, assign) BOOL is_long_text;
@property (nonatomic, assign) BOOL is_imported_topic;
@property (nonatomic, assign) BOOL is_paid;
@property (nonatomic, assign) NSInteger is_show_bulletin;
@property (nonatomic, assign) NSInteger mblog_vip_type;
@property (nonatomic, assign) NSInteger mblogtype;
@property (nonatomic, strong) NSString * mid;
@property (nonatomic, assign) NSInteger mlevel;
@property (nonatomic, assign) NSInteger more_info_type;
@property (nonatomic, assign) NSInteger pending_approval_count;
@property (nonatomic, strong) NSArray * pic_urls;
@property (nonatomic, assign) NSInteger positive_recom_flag;
@property (nonatomic, assign) NSInteger reposts_count;
@property (nonatomic, strong) NSString * rid;
@property (nonatomic, strong) NSString * source;
@property (nonatomic, assign) NSInteger source_allowclick;
@property (nonatomic, assign) NSInteger source_type;
@property (nonatomic, assign) BOOL sync_mblog;
@property (nonatomic, strong) NSString * text;
@property (nonatomic, assign) NSInteger text_length;
@property (nonatomic, strong) NSArray * text_tag_tips;
@property (nonatomic, strong) NSString * topic_id;
@property (nonatomic, assign) BOOL truncated;
@property (nonatomic, strong) GWWBUser * user;
@property (nonatomic, assign) NSInteger user_type;
@property (nonatomic, strong) GWWBVisible * visible;
@end
