//
//  ASTNode.m
//  lex
//
//  Created by xiaoxliang on 2021/3/19.
//

#import "ASTNode.h"

@implementation ASTNode

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.children = [NSMutableArray array];
    }
    return self;
}

- (void)addChildren:(ASTNode *)node {
    node.parent = self;
    [self.children addObject:node];
}
@end
