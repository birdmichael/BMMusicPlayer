//
//  BMHttpManager.m
//  Calm
//
//  Created by BirdMichael on 2018/10/26.
//  Copyright © 2018 BirdMichael. All rights reserved.
//

#import "BMHttpManager.h"
#import <AFNetworking/AFNetworking.h>
#import "NSObject+YYModel.h"
#import "SVProgressHUD.h"
#import "MJExtension.h"

@interface BMHttpManager ()
@property (nonatomic, strong)AFHTTPSessionManager *httpManager;

@end

@implementation BMHttpManager


+ (instancetype)sharedInstance {
    static BMHttpManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[BMHttpManager alloc] init];
    });
    
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupManager];
    }
    return self;
}
- (void)setupManager {
    _httpManager = [AFHTTPSessionManager manager];
    _httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"application/json",@"text/html",@"text/css", nil];
}


- (void)getSleep:(void(^)(BMSleepModel *model))completion {
    [SVProgressHUD show];
    [_httpManager GET:KBMClamAppSleepModelUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        // 不要问我为什么这么写。我也很无奈
        BMSleepModel *model = [[BMSleepModel alloc] init];
        NSMutableArray *hypnosisModels = [@[] mutableCopy];
        NSArray *hypnosis = [(NSArray *)responseObject firstObject];
        for (NSDictionary *dit in hypnosis) {
            NSDictionary *itemdic = [dit[@"icc"] firstObject];
            BMItemModel *itemModel = [BMItemModel modelWithDictionary:itemdic];
            itemModel.title = dit[@"title"];
            itemModel.duration = [dit[@"duration"] integerValue];
            [hypnosisModels addObject:itemModel];
        }
        
        NSMutableArray *storiesDataModels = [@[] mutableCopy];
        NSArray *stories = [(NSArray *)responseObject objectAtIndex:1];
        for (NSDictionary *dit in stories) {
            NSDictionary *itemdic = [dit[@"icc"] firstObject];
            BMItemModel *itemModel = [BMItemModel modelWithDictionary:itemdic];
            itemModel.title = dit[@"title"];
            itemModel.duration = [dit[@"duration"] integerValue];
            [storiesDataModels addObject:itemModel];
        }
        
        NSMutableArray *musicDataModels = [@[] mutableCopy];
        NSArray *musics = [(NSArray *)responseObject objectAtIndex:2];
        for (NSDictionary *dit in musics) {
            NSDictionary *itemdic = [dit[@"icc"] firstObject];
            BMItemModel *itemModel = [BMItemModel modelWithDictionary:itemdic];
            itemModel.title = dit[@"title"];
            itemModel.duration = [dit[@"duration"] integerValue];
            [musicDataModels addObject:itemModel];
        }
        
        model.musicData = musicDataModels;
        model.storiesData = storiesDataModels;
        model.hypnosisData = hypnosisModels;
        completion(model);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"error"];
        [SVProgressHUD dismiss];
        completion(nil);
    }];
}

- (void)getASMR:(void(^)(NSArray<BMItemModel *> *modelArray))completion {
    [SVProgressHUD show];
    [_httpManager GET:KBMClamAppASMRModelUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        // 不要问我为什么这么写。我也很无奈
        
        NSMutableArray *video = [@[] mutableCopy];
        for (NSDictionary *dit in responseObject) {
            NSDictionary *itemdic = [dit[@"icc"] firstObject];
            BMItemModel *itemModel = [BMItemModel modelWithDictionary:itemdic];
            itemModel.duration = [dit[@"title"] integerValue];
            itemModel.duration = [dit[@"duration"] integerValue];
            [video addObject:itemModel];
        }
        completion(video);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"error"];
        [SVProgressHUD dismiss];
        completion(nil);
    }];
}

@end
