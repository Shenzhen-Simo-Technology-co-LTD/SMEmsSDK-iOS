//
//  GLCRC.h
//  SmartHeater
//
//  Created by GrayLand on 2020/4/3.
//  Copyright © 2020 GrayLand119. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLCRC : NSObject
+ (uint8_t)crc8:(uint8_t)crc payload:(NSData *)payload length:(UInt16)length;
@end

NS_ASSUME_NONNULL_END
