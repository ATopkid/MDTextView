#import "ASTTokenUtils.h"
#import "ASTNode.h"
#import "MDCtFrameTokenHyperlinks.h"

@implementation ASTTokenUtils

+ (MDCtFrameTokenHyperlinks *)frameTokenWithNode:(ASTNode *)root {
    NSMutableString *allContent = [NSMutableString string];
    NSMutableString *url = [NSMutableString string];
    NSMutableString *linkContent = [NSMutableString string];
    ASTNode *curNode = [root.children firstObject];
    
    while (curNode) {
        if (curNode == [curNode.parent.children lastObject] && !curNode.children.count) {
            break;
        }
        //是markdown标识符
        if ([curNode.value isEqualToString:@"["]) {
            for (ASTNode *n in curNode.children) {
                if ([n.value isEqualToString:@"("] && n.children.count > 0) {
                } else {
                    [linkContent appendString:n.value];
                }
                curNode = n;
            }
            //remove ']'
            [linkContent deleteCharactersInRange:NSMakeRange(linkContent.length - 1, 1)];
            [allContent appendString:linkContent];
            
            if ([curNode.value isEqualToString:@"("]) {
                BOOL isBracketsEnd = NO;
                for (ASTNode *n in curNode.children) {
                    if (isBracketsEnd) {
                        [allContent appendString:n.value];
                    } else {
                        [url appendString:n.value];
                        if ([n.value isEqualToString:@")"]) {
                            isBracketsEnd = YES;
                            continue;;
                        }
                    }
                    curNode = n;
                }
                //remove ')'
                [url deleteCharactersInRange:NSMakeRange(url.length - 1, 1)];
            }
        } else {
            for (ASTNode *n in curNode.parent.children) {
                if (n.value.length) {
                    if ([n.value isEqualToString:@"["]) {
                        curNode = n;
                        break;;
                    }
                    [allContent appendString:n.value];
                    curNode = n;
                }
            }
        }
    }
    
    MDCtFrameTokenHyperlinks *linkToken = [MDCtFrameTokenHyperlinks new];
    linkToken.linkContent = linkContent;
    linkToken.allContent = allContent;
    linkToken.url = url;
    linkToken.range = [allContent rangeOfString:linkContent];
    linkToken.color = [UIColor blueColor];
    
    return linkToken;
}

@end
