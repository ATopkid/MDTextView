#import "MDCtFrameBuilder.h"
#import "MDViewFrameRef.h"
#import "MDCtFrameToken.h"
#import "MDCtFrameTokenHyperlinks.h"
#import "CTFrameParserConfig.h"

@implementation MDCtFrameBuilder

+ (MDViewFrameRef *)parseContent:(NSString *)string config:(CTFrameParserConfig *)config tokens:(NSArray<MDCtFrameToken *> *)tokens{
    
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:string];
    
    NSMutableArray *hyperlinks = [NSMutableArray array];
    for (MDCtFrameToken *token in tokens) {
        if (token.type == MDCtFrameTokenTypeHyperlinks) {
            [hyperlinks addObject:token];
            [content addAttribute:(id)kCTForegroundColorAttributeName value:(id)token.color.CGColor range:token.range];
        }
    }
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(config.edgeInsets.left, config.edgeInsets.top, config.width, config.height));
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)content);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter,
                                 CFRangeMake(0, [content length]), path, NULL);
    
    CFRelease(path);
    CFRelease(framesetter);
    
    MDViewFrameRef *mdViewFrameRef = [MDViewFrameRef new];
    mdViewFrameRef.ctFrame = frame;
    mdViewFrameRef.hyperlinks = hyperlinks;
    mdViewFrameRef.edgeInsets = config.edgeInsets;
    
    return mdViewFrameRef;
}

@end
