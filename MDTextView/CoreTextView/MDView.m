#import "MDView.h"
#import "MDViewFrameRef.h"
#import "MDCtFrameToken.h"
#import "MDCtFrameTokenHyperlinks.h"

@implementation MDView

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CTFrameDraw(self.frameRef.ctFrame, context);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self onCreate];
    }
    return self;
}

- (void)onCreate {
    UIGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureDetected:)];
    [self addGestureRecognizer:tapRecognizer];
}

- (void)tapGestureDetected:(UIGestureRecognizer *)recognizer {
    CGPoint point = [recognizer locationInView:self];
    MDCtFrameTokenHyperlinks *linkToken = [self touchTokenInPoint:point];
    if (self.delegate && [self.delegate respondsToSelector:@selector(mdView:didClickHyperlinks:)]) {
        if (linkToken.url.length) {
            [self.delegate mdView:self didClickHyperlinks:linkToken.url];
        }
    }
}

- (MDCtFrameTokenHyperlinks *)touchTokenInPoint:(CGPoint)point {
    
    CFIndex index = [self touchIdxInPoint:point];
    if (index < 0) {
        return nil;
    }
    MDCtFrameTokenHyperlinks *linkToken = [self linkAtIndex:index];
    return linkToken;
}

- (CFIndex)touchIdxInPoint:(CGPoint)point {
    CTFrameRef ctFrame = self.frameRef.ctFrame;
    CFArrayRef lines = CTFrameGetLines(ctFrame);
    if (!lines) {
        return -1;
    }
    CFIndex count = CFArrayGetCount(lines);
    CGPoint origins[count];
    CTFrameGetLineOrigins(ctFrame, CFRangeMake(0,0), origins);
    
    CGAffineTransform transform =  CGAffineTransformMakeTranslation(0, self.bounds.size.height);
    transform = CGAffineTransformScale(transform, 1, -1);
    
    CFIndex idx = -1;
    for (int i = 0; i < count; i++) {
        CGPoint linePoint = origins[i];
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CGRect flippedRect = [self getLineBounds:line point:linePoint];
        CGRect rect = CGRectApplyAffineTransform(flippedRect, transform);

        if (CGRectContainsPoint(rect, point)) {
            CGPoint relativePoint = CGPointMake(point.x-CGRectGetMinX(rect),
                                                point.y-CGRectGetMinY(rect));
            idx = CTLineGetStringIndexForPosition(line, relativePoint);
            break;;
        }
    }
    
    //以1开始算的
    return idx - 1;
}

- (CGRect)getLineBounds:(CTLineRef)line point:(CGPoint)point {
    UIEdgeInsets insets = self.frameRef.edgeInsets;
    CGFloat ascent = 0.0f;
    CGFloat descent = 0.0f;
    CGFloat leading = 0.0f;
    CGFloat width = (CGFloat)CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    CGFloat height = ascent + descent;
    return CGRectMake(point.x + insets.left, point.y - descent + insets.top, width, height);
}

- (MDCtFrameTokenHyperlinks *)linkAtIndex:(CFIndex)i {
    MDCtFrameTokenHyperlinks *result;
    for (MDCtFrameTokenHyperlinks *link in self.frameRef.hyperlinks) {
        if (NSLocationInRange(i, link.range)) {
            result = link;
            break;
        }
    }
    return result;
}

@end
