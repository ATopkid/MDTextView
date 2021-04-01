//
//  ASTNode.h
//  lex
//
//  Created by xiaoxliang on 2021/3/19.
//

#import <Foundation/Foundation.h>
#import "Token.h"

@interface ASTNode : NSObject

@property (nonatomic, assign) TokenType tokenType;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) NSMutableArray<ASTNode *> *children;
@property (nonatomic, strong) ASTNode *parent;

- (void)addChildren:(ASTNode *)node;

@end
