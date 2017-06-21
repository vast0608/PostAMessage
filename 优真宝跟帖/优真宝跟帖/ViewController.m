//
//  ViewController.m
//  优真宝跟帖
//
//  Created by 上海烨历网络科技有限公司 on 2017/5/11.
//  Copyright © 2017年 上海烨历网络科技有限公司. All rights reserved.
//

#import "ViewController.h"
#import "NetWorkingManager.h"

@implementation ViewController{
    NSTimer *timer;//定时器
    NSInteger foolPage;//帖子详情页码
    //NSButton *starButton;//开始按钮
    NSInteger timeSpace;//时间间隔
}
- (IBAction)popupbutton:(id)sender {
    
    NSInteger i = [_poppibutton indexOfSelectedItem];
    timeSpace = [@[@"5",@"10",@"15",@"20"][i] integerValue];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *itemTitles = [NSArray arrayWithObjects:@"5",@"10",@"15",@"20",nil];
    [_poppibutton addItemsWithTitles:itemTitles];
    
    _endButton.enabled = NO;
    _beginButton.enabled = YES;
    _pinglun.stringValue = @"评论未开始";
    _pinglun.textColor = [NSColor lightGrayColor];
    _biaotai.stringValue = @"表态未开始";
    _biaotai.textColor = [NSColor lightGrayColor];
}
- (void)setContentArray:(NSArray *)content {
//    _contentArray = content;
//    [self setSelectionIndex:@0];
}
- (IBAction)begin:(id)sender {
    if (timeSpace==0) {
        timeSpace=5;
    }

    _beginButton.enabled = NO;
    _poppibutton.enabled = NO;
    _endButton.enabled = YES;
    NSLog(@"计时器开始");
    //每一秒执行一次
    timer = [NSTimer scheduledTimerWithTimeInterval:timeSpace
                                             target:self
                                           selector:@selector(timerFireMethod:)
                                           userInfo:nil
                                            repeats:YES];
    //设置计时器的优先级，否则放在tableView中，计时器将会停止。
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    _pinglun.stringValue = @"评论等待中。。。";
    _pinglun.textColor = [NSColor lightGrayColor];
    
    _biaotai.stringValue = @"表态等待中。。。";
    _biaotai.textColor = [NSColor lightGrayColor];
    
}
- (IBAction)end:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [timer invalidate];
        timer=nil;
        
        _beginButton.enabled = YES;
        _endButton.enabled = NO;
        _poppibutton.enabled = YES;
        _pinglun.stringValue = @"评论已结束";
        _pinglun.textColor = [NSColor lightGrayColor];
        _biaotai.stringValue = @"表态已结束";
        _biaotai.textColor = [NSColor lightGrayColor];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            for (int i=0; i<2; i++) {
                [timer invalidate];
                timer=nil;
                
                _beginButton.enabled = YES;
                _endButton.enabled = NO;
                _poppibutton.enabled = YES;
                _pinglun.stringValue = @"评论已结束";
                _pinglun.textColor = [NSColor lightGrayColor];
                _biaotai.stringValue = @"表态已结束";
                _biaotai.textColor = [NSColor lightGrayColor];
                NSLog(@"计时器终结");
            }
            
        });
        
        NSLog(@"计时器终结");
    });
}

- (void)timerFireMethod:(NSTimer *)theTimer//计时器开始
{
    //读取text文件
    NSString *BundleID = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    NSString *filePath;
    if ([BundleID isEqualToString:@"com.shyl.posts"]) {
        filePath = [[NSBundle mainBundle] pathForResource:@"users.ghost" ofType:@"txt"];
    }else {
        filePath = [[NSBundle mainBundle] pathForResource:@"users.ghost.dev" ofType:@"txt"];
    }
    NSString *dataFile = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSArray *dataarr = [dataFile componentsSeparatedByString:@"),"];//把文件分成数组
    int x = arc4random() % dataarr.count;//随机数
    NSString *string = [dataarr[x] stringByAppendingString:@")"];//随机取值
    //获取id
    NSRange startRange1 = [string rangeOfString:@"("];
    NSRange endRange1 = [string rangeOfString:@","];
    NSRange range1 = NSMakeRange(startRange1.location + startRange1.length, endRange1.location - startRange1.location - startRange1.length);
    NSString *result1 = [string substringWithRange:range1];
    //获取token
    NSRange startRange2 = [string rangeOfString:@"'$"];
    NSRange endRange2 = [string rangeOfString:@"')"];
    NSRange range2 = NSMakeRange(startRange2.location + startRange2.length, endRange2.location - startRange2.location - startRange2.length);
    NSString *result2 = [string substringWithRange:range2];
    NSString *result20 = [NSString stringWithFormat:@"$%@",result2];
    
    [self getHttpUserID:result1 UserToken:result20];
}
-(void)getHttpUserID:(NSString *)userID UserToken:(NSString *)userToken{//板块
    [NetWorkingManager GETURLSplice:[NSString stringWithFormat:@"/forums"] UserID:userID UserToken:userToken Parameters:@"2" HTTPHeaderKey:nil HTTPHeaderValue:nil completionHandler:^(id responseObjectmodel, NSError *error) {
        if (error) {
            NSLog(@"-----获取板块出错--------");
        }else{
            NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:responseObjectmodel options:NSJSONReadingAllowFragments error:&error];
            //NSLog(@"---------%@",jsonObject);
            NSMutableArray *muArr = [NSMutableArray new];
            NSMutableArray *muArr1 = [NSMutableArray new];
            for (int i=0; i<jsonObject.count; i++) {
                if (![[jsonObject[i] objectForKey:@"alias"] isEqualToString:@"feedback"]) {
                    [muArr addObject:[jsonObject[i] objectForKey:@"id"]];
                    [muArr1 addObject:[jsonObject[i] objectForKey:@"name"]];
                }
            }
            //NSLog(@"-----板块==%@--------",muArr1[3]);
            
            [self getPostsHttp:muArr[1] UserID:userID UserToken:userToken];
        }
    }];
}
-(void)getPostsHttp:(NSString *)idstr UserID:(NSString *)userID UserToken:(NSString *)userToken{//主题列表
    [NetWorkingManager GETURLSplice:[NSString stringWithFormat:@"/forums/%@/posts?page=%@",idstr,@"1"] UserID:userID UserToken:userToken Parameters:@"2" HTTPHeaderKey:nil HTTPHeaderValue:nil completionHandler:^(id responseObjectmodel, NSError *error) {
        if (error) {
            NSLog(@"-----获取列表出错--------");
        }else{
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:responseObjectmodel options:NSJSONReadingAllowFragments error:&error];
            NSString *page = [jsonObject objectForKey:@"last_page"];

            NSInteger postsPage = arc4random() % ([page integerValue]+1);//随机数
            if (postsPage>10) {
                postsPage = arc4random() % 10;//随机数
            }
            [NetWorkingManager GETURLSplice:[NSString stringWithFormat:@"/forums/%@/posts?page=%ld",idstr,(long)postsPage] UserID:userID UserToken:userToken Parameters:@"2" HTTPHeaderKey:nil HTTPHeaderValue:nil completionHandler:^(id responseObjectmodel, NSError *error) {
                if (error) {
                }else{
                    NSDictionary *modelObjects = [NSJSONSerialization JSONObjectWithData:responseObjectmodel options:NSJSONReadingAllowFragments error:&error];
                    
                    NSArray *dataArr = [modelObjects objectForKey:@"data"];

                    if (dataArr.count!=0) {//如果列表不为0，就继续
                        int x = arc4random() % dataArr.count;//随机数
                        
                        NSString *postsIdStr = [dataArr[x] objectForKey:@"id"];
                        
                        [self getDetailHTTPFormsID:idstr postsID:postsIdStr UserID:userID UserToken:userToken];
                        //NSLog(@"-----主题列表ID=%@--------",postsIdStr);
                    }else{
                        NSLog(@"---该板块列表没有主题");
                    }
                    
                }
                
            }];
            
        }
    }];
    
}
-(void)getDetailHTTPFormsID:(NSString *)formsID postsID:(NSString *)postsID UserID:(NSString *)userID UserToken:(NSString *)userToken{//帖子详情
    [NetWorkingManager GETURLSplice:[NSString stringWithFormat:@"/forums/%@/posts/%@?page=%@",formsID,postsID,@"1"] UserID:userID UserToken:userToken Parameters:@"2" HTTPHeaderKey:nil HTTPHeaderValue:nil completionHandler:^(id responseObjectmodel, NSError *error) {
        if (error) {
            NSLog(@"-----获取帖子详情出错--------");
        }else{
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:responseObjectmodel options:NSJSONReadingAllowFragments error:&error];
            NSString *page = [jsonObject objectForKey:@"last_page"];
            NSInteger postsPage = arc4random() % ([page integerValue]+1);//随机数
            [NetWorkingManager GETURLSplice:[NSString stringWithFormat:@"/forums/%@/posts/%@?page=%ld",formsID,postsID,(long)postsPage] UserID:userID UserToken:userToken Parameters:@"2" HTTPHeaderKey:nil HTTPHeaderValue:nil completionHandler:^(id responseObjectmodel, NSError *error) {
                if (error) {
                }else{
                    NSDictionary *modelObjects = [NSJSONSerialization JSONObjectWithData:responseObjectmodel options:NSJSONReadingAllowFragments error:&error];
                    NSArray *dataArr = [modelObjects objectForKey:@"data"];
                    //跟帖
                    int x = arc4random() % dataArr.count;//随机数
                    NSString *foolID;
                    if (x==0||dataArr.count==1) {
                        foolID = @"0";
                    }else{
                        if (dataArr.count%5==0) {
                            foolID = [dataArr[x]  objectForKey:@"id"];
                        }else{
                            foolID = @"0";
                        }
                        
                    }
                    //NSLog(@"-----板块ID=%@-----主题列表ID=%@-----楼层ID=%@---",formsID,postsID,foolID);
                    [self SubmitCommentFormsID:formsID postsID:postsID floorID:foolID UserID:userID UserToken:userToken];
                    
                    //点赞或不攒
                    int y = arc4random() % dataArr.count;//随机数
                    if (x!=0||dataArr.count!=1) {
                        [self ZanOrBuZanFormsID:formsID postsID:postsID floorID:[dataArr[y]  objectForKey:@"id"] UserID:userID UserToken:userToken];
                    }
                    
                }
            }];

        }

    }];
    
}
- (void)SubmitCommentFormsID:(NSString *)formsID postsID:(NSString *)postsID floorID:(NSString *)floorID  UserID:(NSString *)userID UserToken:(NSString *)userToken {//评论
    
    //读取text文件
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"users.short" ofType:@"txt"];
    NSString *dataFile = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSArray *dataarr = [dataFile componentsSeparatedByString:@"）"];//把文件分成数组
    int x = arc4random() % dataarr.count;//随机数
    NSString *string = [dataarr[x] stringByReplacingOccurrencesOfString:@"\n（" withString:@""];

    NSArray *bodysTextValue = @[floorID,string];
    NSArray *bodysTextKey = @[@"quote_id",@"content"];
    
    [NetWorkingManager POSTURLSplice:[NSString stringWithFormat:@"/forums/%@/posts/%@",formsID,postsID] UserID:userID UserToken:userToken Parameters:@"2" BodysTextKey:bodysTextKey BodysTextValue:bodysTextValue BodysImageKey:nil BodysImageValue:nil completionHandler:^(id responseObjectmodel, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                NSLog(@"---评论失败");
                _pinglun.stringValue = @"评论失败";
                _pinglun.textColor = [NSColor redColor];
            }else{
                NSLog(@"---评论成功");
                _pinglun.stringValue = @"评论成功";
                _pinglun.textColor = [NSColor greenColor];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                _pinglun.textColor = [NSColor lightGrayColor];
                _pinglun.stringValue = @"评论等待中。。。";
            });
        });
        
        
        
    }];
}
-(void)ZanOrBuZanFormsID:(NSString *)formsID postsID:(NSString *)postsID floorID:(NSString *)floorID  UserID:(NSString *)userID UserToken:(NSString *)userToken {//赞或不攒
    int x = arc4random() % 2;//随机数
    NSString *urlStr;
    if (x==0) {//不攒
        urlStr = [NSString stringWithFormat:@"/forums/%@/posts/%@/floors/%@/dislike",formsID,postsID,floorID];
    }else{//赞
        urlStr = [NSString stringWithFormat:@"/forums/%@/posts/%@/floors/%@/like",formsID,postsID,floorID];
    }
    
    [NetWorkingManager POSTURLSplice:urlStr UserID:userID UserToken:userToken Parameters:@"2" BodysTextKey:nil BodysTextValue:nil BodysImageKey:nil BodysImageValue:nil completionHandler:^(id responseObjectmodel, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                NSLog(@"~~~表态失败");
                _biaotai.stringValue = @"表态失败";
                _biaotai.textColor = [NSColor redColor];
            }else{
                NSLog(@"~~~表态成功");
                _biaotai.stringValue = @"表态成功";
                _biaotai.textColor = [NSColor greenColor];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                _biaotai.stringValue = @"表态等待中。。。";
                _biaotai.textColor = [NSColor lightGrayColor];
            });
        });
        
        
    }];
}
@end
