#import "MASShortcutView+Bindings.h"
#import "MASDictionaryTransformer.h"

@implementation MASShortcutView (Bindings)

- (NSString*) associatedUserDefaultsKey
{
    NSDictionary<NSBindingInfoKey,id>* bindingInfo = [self infoForBinding:MASShortcutBinding];
    if (bindingInfo != nil) {
        NSString *keyPath = [bindingInfo objectForKey:NSObservedKeyPathKey];
        NSString *key = [keyPath stringByReplacingOccurrencesOfString:@"values." withString:@""];
        return key;
    } else {
        return nil;
    }
}

- (void) setAssociatedUserDefaultsKey: (NSString*) newKey withTransformer: (NSValueTransformer*) transformer
{
    // Break previous binding if the new binding is nil
    if (newKey == nil) {
        [self unbind:MASShortcutBinding];
        return;
    }

    NSDictionary *options = transformer ?
        @{NSValueTransformerBindingOption:transformer} :
        nil;

    [self bind:MASShortcutBinding
        toObject:[NSUserDefaultsController sharedUserDefaultsController]
        withKeyPath:[@"values." stringByAppendingString:newKey]
        options:options];
}

- (void) setAssociatedUserDefaultsKey: (NSString*) newKey withTransformerName: (NSString*) transformerName
{
    [self setAssociatedUserDefaultsKey:newKey withTransformer:[NSValueTransformer valueTransformerForName:transformerName]];
}

- (void) setAssociatedUserDefaultsKey: (NSString*) newKey
{
    [self setAssociatedUserDefaultsKey:newKey withTransformerName:MASDictionaryTransformerName];
}

@end
