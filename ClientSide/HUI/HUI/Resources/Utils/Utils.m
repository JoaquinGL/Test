//
//  Utils.m
//  HUI
//
//  Created by Joaquin Giraldez on 3/12/15.
//  Copyright © 2015 Giraldez Lopez SL. All rights reserved.
//

#import "Utils.h"




@implementation Utils


+ (void) fadeIn: (UIView* )view completion:(void (^)(BOOL finished))completion{

    
    [UIView animateWithDuration: 0.3
                     animations:^{
                         view.alpha = 1.0;
                     }
                     completion:completion
     ];
    
}

+ (void) fadeOut: (UIView* )view completion:(void (^)(BOOL finished))completion{
    
    [UIView animateWithDuration: 0.3
                     animations:^{
                         view.alpha = 0.0;
                     }
                     completion:completion
     ];
    
}

+ (void) resizeLabel:( UILabel* )label
            withText:( NSString* )text
            withFont:( UIFont* )font
           withWidth:( CGFloat )width {


    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{ NSFontAttributeName: font}];
    
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){width, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    
    CGSize size = rect.size;
    
    [label setFrame: CGRectMake(label.frame.origin.x, label.frame.origin.y, size.width, size.height)];
}


+(void) scrollToBottomAnimate:(UITextView *)textView completion:(void (^)(BOOL finished))completion{
    [UIView animateWithDuration: 0.5
                     animations:^{
                         [textView scrollRangeToVisible:NSMakeRange(textView.text.length - 1, 1)];
                     }
                     completion:completion
     ];

}

+ (NSString* )viewToDevice:(NSString* )view{
    
    if (IS_STANDARD_IPHONE_6 || IS_ZOOMED_IPHONE_6){
        view = [NSString stringWithFormat:@"%@%@", view, @"_2x" ];
    }else if (IS_STANDARD_IPHONE_6_PLUS || IS_ZOOMED_IPHONE_6_PLUS){
        view = [NSString stringWithFormat:@"%@%@", view, @"_3x" ];
    }else if (! IS_IPHONE_5){
        view = [NSString stringWithFormat:@"%@%@", view, @"_1x" ];
    }
    
    return view;
}


@end
