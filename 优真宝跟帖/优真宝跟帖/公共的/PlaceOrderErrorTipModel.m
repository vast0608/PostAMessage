//
//  PlaceOrderErrorTipModel.m
//  Transaction
//
//  Created by 张敏华 on 16/10/10.
//  Copyright © 2016年 张敏华. All rights reserved.
//

#import "PlaceOrderErrorTipModel.h"

@implementation PlaceOrderErrorTipModel


+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"ids" : [ErrorTipIdsModel class]};
}
@end
@implementation ErrorTipIdsModel

@end


