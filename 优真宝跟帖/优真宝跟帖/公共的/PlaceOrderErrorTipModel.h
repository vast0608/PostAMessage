//
//  PlaceOrderErrorTipModel.h
//  Transaction
//
//  Created by 张敏华 on 16/10/10.
//  Copyright © 2016年 张敏华. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ErrorTipIdsModel;
@interface PlaceOrderErrorTipModel : NSObject

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, strong) NSArray<ErrorTipIdsModel *> *ids;

@end
@interface ErrorTipIdsModel : NSObject

@property (nonatomic, copy) NSString *goods_sku_id;

@property (nonatomic, copy) NSString *goods_id;

@end

