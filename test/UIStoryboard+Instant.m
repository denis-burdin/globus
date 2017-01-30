//
//  UIStoryboard+Instant.m

#import "UIStoryboard+Instant.h"


@implementation UIStoryboard(Instant)

+ (UIViewController*)firstEnter
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"InitialScreen" bundle:nil];
    
    return [storyboard instantiateViewControllerWithIdentifier:@"firstNavigation"];
}

@end
