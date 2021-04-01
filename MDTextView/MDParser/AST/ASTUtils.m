//
//  ASTUtils.m
//  lex
//
//  Created by xiaoxliang on 2021/3/18.
//

#import "ASTUtils.h"
#import "Token.h"
#import "ASTNode.h"

static NSMutableArray<Token *> *tokens;
static NSInteger tokenIndex;
static ASTNode *curNode;
static NSMutableArray<ASTNode *> *nodeStack;

@implementation ASTUtils

+ (void)initialize
{
    tokenIndex = 0;
    tokens = [NSMutableArray array];
    curNode = nil;
    nodeStack = [NSMutableArray array];
}

+ (Token *)nextToken {
    if (tokenIndex >= tokens.count) {
        return nil;
    }
    return tokens[tokenIndex];
}

+ (void)reset {
    tokenIndex = 0;
    [tokens removeAllObjects];
    curNode = nil;
    [nodeStack removeAllObjects];
}

+ (ASTNode *)parseHyperlinksS:(NSMutableArray<Token *> *)a {
    ASTNode *root = [ASTNode new];
    curNode = root;
    
    tokens = [a mutableCopy];
    Token *token = [self nextToken];
    switch (token.type) {
        case TokenTypeSentence: {
            [self parseHyperlinksText];
            [self parseHyperlinksSuffixS];
        }
            break;
        default:
            [self parseHyperlinksSuffixS];
            break;
    }
    
    if (nodeStack.count > 0) {
        root = nil;
    }
    [self reset];
    
    return root;
}

+ (void)parseHyperlinksText {
    Token *token = [self nextToken];
    
    if (token.type == TokenTypeSentence) {
        [self addToCurNodeChildren:token];
        NSLog(@"%@", token.value);
        tokenIndex++;
    }
    
}

+ (void)parseHyperlinksSuffixS {
    
    Token *token = [self nextToken];
    if (token.type == TokenTypeMdtag) {
        NSLog(@"%@", token.value);
        [self parseHyperlinksMdTag];
        [self parseHyperlinksText];
        [self parseHyperlinksSuffixS];
    }
}

+ (void)parseHyperlinksMdTag {
    Token *token = [self nextToken];
    
    [self parseHyperlinksMdTagStart];
    [self parseHyperlinksMdTagEnd];
}

+ (void)parseHyperlinksMdTagStart {
    Token *token = [self nextToken];

    if ([token.value isEqualToString:@"["] || [token.value isEqualToString:@"("]) {
        NSLog(@"%@", token.value);
        tokenIndex++;
        ASTNode *newNode;
        NSLog(@"---%lu", (unsigned long)nodeStack.count);
        if (!nodeStack.count && [token.value isEqualToString:@"["]) {
            newNode = [self addToCurNodeChildrenAndSwitchCurNode:token];
        } else if (!nodeStack.count && [token.value isEqualToString:@"("]) {
            newNode = [self addToCurNodeChildrenAndSwitchCurNode:token];
        } else {
            newNode = [self addToCurNodeChildren:token];
        }
        [nodeStack addObject:newNode];
    }
}

+ (void)parseHyperlinksMdTagEnd {
    Token *token = [self nextToken];

    if ([token.value isEqualToString:@"]"] || [token.value isEqualToString:@")"]) {
        NSLog(@"%@", token.value);
        tokenIndex++;
        [self addToCurNodeChildren:token];
        [nodeStack removeLastObject];
    }
}

+ (void)parseHyperlinksLetter {
    Token *token = [self nextToken];
    
    if (token.type == TokenTypeSentence) {
        [self addToCurNodeChildren:token];
        NSLog(@"%@", token.value);
        tokenIndex++;
    }
}

#pragma mark -

+ (ASTNode *)addToCurNodeChildren:(Token *)token {
    ASTNode *node = [ASTNode new];
    node.tokenType = token.type;
    node.value = token.value;
    [curNode addChildren:node];
    return node;
}

+ (ASTNode *)addToCurNodeChildrenAndSwitchCurNode:(Token *)token {
    ASTNode *newNode = [self addToCurNodeChildren:token];
    curNode = newNode;
    return newNode;
}
@end
