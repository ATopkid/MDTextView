//
//  ASTUtils.h
//  lex
//
//  Created by xiaoxliang on 2021/3/18.
//

#import <Foundation/Foundation.h>

@class Token;
@class ASTNode;

@interface ASTUtils : NSObject

+ (ASTNode *)parseHyperlinksS:(NSMutableArray<Token *> *)a;

@end
