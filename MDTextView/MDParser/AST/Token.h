//
//  Token.h
//  lex
//
//  Created by xiaoxliang on 2021/3/16.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TokenType) {
    TokenTypeUnknow = 0,
    TokenTypeSentence = 1,
    TokenTypeMdtag = 2,
};

@interface Token : NSObject

@property (nonatomic, assign) TokenType type;
@property (nonatomic, copy) NSString *value;

- (instancetype)initWithType:(TokenType)type value:(NSString *)value;
@end
