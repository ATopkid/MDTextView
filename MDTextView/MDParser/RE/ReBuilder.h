//
//  reBuilder.h
//  lex
//
//  Created by xiaoxliang on 2021/3/15.
//

#import <Foundation/Foundation.h>
#import "Token.h"

@interface ReBuilder : NSObject

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSNumber *> *re2Pattern;

- (NSString *)convertToSuffixRe:(NSString *)re tokenType:(TokenType)tokenType;
@end
