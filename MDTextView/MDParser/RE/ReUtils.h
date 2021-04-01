//
//  ReUtils.h
//  lex
//
//  Created by xiaoxliang on 2021/3/15.
//

#import <Foundation/Foundation.h>
#import "Token.h"

@interface ReUtils : NSObject

+ (NSMutableString *)standardizeRe:(NSString *)re;
+ (TokenType)rePattern2TokenType:(NSString *)re;

@end
