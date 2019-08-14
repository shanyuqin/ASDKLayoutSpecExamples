//
//  LayoutExampleNodes.m
//  Texture
//
//  Copyright (c) Facebook, Inc. and its affiliates.  All rights reserved.
//  Changes after 4/13/2017 are: Copyright (c) Pinterest, Inc.  All rights reserved.
//  Licensed under Apache 2.0: http://www.apache.org/licenses/LICENSE-2.0
//

#import "LayoutExampleNodes.h"

#import <AsyncDisplayKit/UIImage+ASConvenience.h>

#import "Utilities.h"

@interface HeaderWithRightAndLeftItems ()
@property (nonatomic, strong) ASTextNode *usernameNode;
@property (nonatomic, strong) ASTextNode *postLocationNode;
@property (nonatomic, strong) ASTextNode *postTimeNode;
@end

@interface PhotoWithInsetTextOverlay ()
@property (nonatomic, strong) ASNetworkImageNode *photoNode;
@property (nonatomic, strong) ASTextNode *titleNode;
@end

@interface PhotoWithOutsetIconOverlay ()
@property (nonatomic, strong) ASNetworkImageNode *photoNode;
@property (nonatomic, strong) ASNetworkImageNode *iconNode;
@end

@interface FlexibleSeparatorSurroundingContent ()
@property (nonatomic, strong) ASImageNode *topSeparator;
@property (nonatomic, strong) ASImageNode *bottomSeparator;
@property (nonatomic, strong) ASTextNode *textNode;
@end

@interface BackGroundSample ()

@property (nonatomic, strong) ASDisplayNode * backNode;
@property (nonatomic, strong) ASDisplayNode * foreNode;

@end

@implementation HeaderWithRightAndLeftItems

+ (NSString *)title
{
  return @"Header with left and right justified text";
}

+ (NSString *)descriptionTitle
{
  return @"try rotating me!";
}

- (instancetype)init
{
  self = [super init];
  
  if (self) {
    _usernameNode = [[ASTextNode alloc] init];
    _usernameNode.attributedText = [NSAttributedString attributedStringWithString:@"hannahmbanana"
                                                                         fontSize:20
                                                                            color:[UIColor darkBlueColor]];
    _usernameNode.maximumNumberOfLines = 1;
    _usernameNode.truncationMode = NSLineBreakByTruncatingTail;
    
    _postLocationNode = [[ASTextNode alloc] init];
    _postLocationNode.maximumNumberOfLines = 1;
    _postLocationNode.attributedText = [NSAttributedString attributedStringWithString:@"Sunset Beach, San Fransisco, CA"
                                                                             fontSize:20
                                                                                color:[UIColor lightBlueColor]];
    _postLocationNode.maximumNumberOfLines = 1;
    _postLocationNode.truncationMode = NSLineBreakByTruncatingTail;
    
    _postTimeNode = [[ASTextNode alloc] init];
    _postTimeNode.attributedText = [NSAttributedString attributedStringWithString:@"30m"
                                                                         fontSize:20
                                                                            color:[UIColor lightGrayColor]];
    _postLocationNode.maximumNumberOfLines = 1;
    _postLocationNode.truncationMode = NSLineBreakByTruncatingTail;
  }
  
  return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{

  ASStackLayoutSpec *nameLocationStack = [ASStackLayoutSpec verticalStackLayoutSpec];
  nameLocationStack.style.flexShrink = 1.0;
  nameLocationStack.style.flexGrow = 1.0;
  
  if (_postLocationNode.attributedText) {
    nameLocationStack.children = @[_usernameNode, _postLocationNode];
  } else {
    nameLocationStack.children = @[_usernameNode];
  }
  
  ASStackLayoutSpec *headerStackSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                               spacing:40
                                                                        justifyContent:ASStackLayoutJustifyContentStart
                                                                            alignItems:ASStackLayoutAlignItemsCenter
                                                                              children:@[nameLocationStack, _postTimeNode]];
  
  return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, 10, 0, 10) child:headerStackSpec];
}

@end


@implementation PhotoWithInsetTextOverlay

+ (NSString *)title
{
  return @"Photo with inset text overlay";
}

+ (NSString *)descriptionTitle
{
  return @"try rotating me!";
}

- (instancetype)init
{
  self = [super init];
  
  if (self) {
    self.backgroundColor = [UIColor clearColor];
    
    _photoNode = [[ASNetworkImageNode alloc] init];
    _photoNode.URL = [NSURL URLWithString:@"http://texturegroup.org/static/images/layout-examples-photo-with-inset-text-overlay-photo.png"];
    _photoNode.willDisplayNodeContentWithRenderingContext = ^(CGContextRef context, id drawParameters) {
      CGRect bounds = CGContextGetClipBoundingBox(context);
      [[UIBezierPath bezierPathWithRoundedRect:bounds cornerRadius:10] addClip];
    };
    
    _titleNode = [[ASTextNode alloc] init];
    _titleNode.maximumNumberOfLines = 2;
    _titleNode.truncationMode = NSLineBreakByTruncatingTail;
    _titleNode.truncationAttributedText = [NSAttributedString attributedStringWithString:@"..." fontSize:16 color:[UIColor whiteColor]];
    _titleNode.attributedText = [NSAttributedString attributedStringWithString:@"family fall hikes" fontSize:16 color:[UIColor whiteColor]];
  }
  
  return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
  CGFloat photoDimension = constrainedSize.max.width / 2.0;
  _photoNode.style.preferredSize = CGSizeMake(photoDimension, photoDimension);

  // INFINITY is used to make the inset unbounded
  UIEdgeInsets insets = UIEdgeInsetsMake(INFINITY, 12, 12, 12);
  ASInsetLayoutSpec *textInsetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:insets child:_titleNode];
  
  return [ASOverlayLayoutSpec overlayLayoutSpecWithChild:_photoNode overlay:textInsetSpec];;
}

@end


@implementation PhotoWithOutsetIconOverlay

+ (NSString *)title
{
  return @"Photo with outset icon overlay";
}

- (instancetype)init
{
  self = [super init];
  
  if (self) {
    _photoNode = [[ASNetworkImageNode alloc] init];
    _photoNode.URL = [NSURL URLWithString:@"http://texturegroup.org/static/images/layout-examples-photo-with-outset-icon-overlay-photo.png"];
    
    _iconNode = [[ASNetworkImageNode alloc] init];
    _iconNode.URL = [NSURL URLWithString:@"http://texturegroup.org/static/images/layout-examples-photo-with-outset-icon-overlay-icon.png"];
    
    [_iconNode setImageModificationBlock:^UIImage *(UIImage *image) {   // FIXME: in framework autocomplete for setImageModificationBlock line seems broken
      CGSize profileImageSize = CGSizeMake(60, 60);
      return [image makeCircularImageWithSize:profileImageSize withBorderWidth:10];
    }];
  }
  
  return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
  _iconNode.style.preferredSize = CGSizeMake(40, 40);
  _iconNode.style.layoutPosition = CGPointMake(150, 0);
  
  _photoNode.style.preferredSize = CGSizeMake(150, 150);
  _photoNode.style.layoutPosition = CGPointMake(40 / 2.0, 40 / 2.0);
  
  ASAbsoluteLayoutSpec *absoluteSpec = [ASAbsoluteLayoutSpec absoluteLayoutSpecWithChildren:@[_photoNode, _iconNode]];
  
  // ASAbsoluteLayoutSpec's .sizing property recreates the behavior of ASDK Layout API 1.0's "ASStaticLayoutSpec"
  absoluteSpec.sizing = ASAbsoluteLayoutSpecSizingSizeToFit;
  
  return absoluteSpec;
}



@end


@implementation FlexibleSeparatorSurroundingContent

+ (NSString *)title
{
  return @"Top and bottom cell separator lines";
}

+ (NSString *)descriptionTitle
{
  return @"try rotating me!";
}

- (instancetype)init
{
  self = [super init];
  
  if (self) {
    self.backgroundColor = [UIColor whiteColor];

    _topSeparator = [[ASImageNode alloc] init];
    _topSeparator.image = [UIImage as_resizableRoundedImageWithCornerRadius:1.0 cornerColor:[UIColor blackColor] fillColor:[UIColor blackColor]];
    
    _textNode = [[ASTextNode alloc] init];
    _textNode.attributedText = [NSAttributedString attributedStringWithString:@"this is a long text node"
                                                                     fontSize:16
                                                                        color:[UIColor blackColor]];
      _textNode.backgroundColor = [UIColor redColor];
    _bottomSeparator = [[ASImageNode alloc] init];
    _bottomSeparator.image = [UIImage as_resizableRoundedImageWithCornerRadius:10 cornerColor:[UIColor redColor] fillColor:[UIColor yellowColor] borderColor:[UIColor clearColor] borderWidth:0];
  }
  
  return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
  _topSeparator.style.flexGrow = 0.0;
  _bottomSeparator.style.flexGrow = 0.0;
//    _bottomSeparator.style.height = ASDimensionMake(40);
  _textNode.style.alignSelf = ASStackLayoutAlignSelfCenter;
  
  ASStackLayoutSpec *verticalStackSpec = [ASStackLayoutSpec verticalStackLayoutSpec];
  verticalStackSpec.spacing = 20;
  verticalStackSpec.justifyContent = ASStackLayoutJustifyContentCenter;
  verticalStackSpec.children = @[_topSeparator, _textNode, _bottomSeparator];

  return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(60, 0, 60, 0) child:verticalStackSpec];
}

@end

@interface CornerLayoutExample ()
@property (nonatomic, strong) ASImageNode *dotNode;
@property (nonatomic, strong) ASImageNode *photoNode1;
@property (nonatomic, strong) ASTextNode *badgeTextNode;
@property (nonatomic, strong) ASImageNode *badgeImageNode;
@property (nonatomic, strong) ASImageNode *photoNode2;
@end

@implementation CornerLayoutExample

static CGFloat const kSampleAvatarSize = 100;
static CGFloat const kSampleIconSize = 26;
static CGFloat const kSampleBadgeCornerRadius = 12;

+ (NSString *)title
{
    return @"Declarative way for Corner image Layout";
}

+ (NSString *)descriptionTitle
{
    return nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        UIImage *avatarImage = [self avatarImageWithSize:CGSizeMake(kSampleAvatarSize, kSampleAvatarSize)];
        UIImage *cornerImage = [self cornerImageWithSize:CGSizeMake(kSampleIconSize, kSampleIconSize)];
        
        NSAttributedString *numberText = [NSAttributedString attributedStringWithString:@" 999+ " fontSize:20 color:UIColor.whiteColor];
        
        _dotNode = [ASImageNode new];
        _dotNode.image = cornerImage;
        
        _photoNode1 = [ASImageNode new];
        _photoNode1.image = avatarImage;
        
        _badgeTextNode = [ASTextNode new];
        _badgeTextNode.attributedText = numberText;
        
        _badgeImageNode = [ASImageNode new];
        _badgeImageNode.image = [UIImage as_resizableRoundedImageWithCornerRadius:kSampleBadgeCornerRadius
                                                                      cornerColor:UIColor.clearColor
                                                                        fillColor:UIColor.redColor];
        
        _photoNode2 = [ASImageNode new];
        _photoNode2.image = avatarImage;
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    
    ASBackgroundLayoutSpec *badgeSpec = [ASBackgroundLayoutSpec backgroundLayoutSpecWithChild:_badgeTextNode
                                                                                   background:_badgeImageNode];
    
    ASCornerLayoutSpec *cornerSpec1 = [ASCornerLayoutSpec cornerLayoutSpecWithChild:_photoNode1 corner:_dotNode location:ASCornerLayoutLocationTopRight];
    cornerSpec1.offset = CGPointMake(-3, 3);
    
    ASCornerLayoutSpec *cornerSpec2 = [ASCornerLayoutSpec cornerLayoutSpecWithChild:_photoNode2 corner:badgeSpec location:ASCornerLayoutLocationTopRight];
    
    self.photoNode.style.preferredSize = CGSizeMake(kSampleAvatarSize, kSampleAvatarSize);
    self.iconNode.style.preferredSize = CGSizeMake(kSampleIconSize, kSampleIconSize);
    
    ASCornerLayoutSpec *cornerSpec3 = [ASCornerLayoutSpec cornerLayoutSpecWithChild:self.photoNode corner:self.iconNode location:ASCornerLayoutLocationTopRight];
    
    ASStackLayoutSpec *stackSpec = [ASStackLayoutSpec verticalStackLayoutSpec];
    stackSpec.spacing = 40;
    stackSpec.children = @[cornerSpec1, cornerSpec2, cornerSpec3];
    
    return stackSpec;
}

- (UIImage *)avatarImageWithSize:(CGSize)size
{
    return [UIImage imageWithSize:size fillColor:UIColor.lightGrayColor shapeBlock:^UIBezierPath *{
        CGRect rect = (CGRect){ CGPointZero, size };
        return [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:MIN(size.width, size.height) / 20];
    }];
}

- (UIImage *)cornerImageWithSize:(CGSize)size
{
    return [UIImage imageWithSize:size fillColor:UIColor.redColor shapeBlock:^UIBezierPath *{
        return [UIBezierPath bezierPathWithOvalInRect:(CGRect){ CGPointZero, size }];
    }];
}

@end


@interface UserProfileSample ()
@property (nonatomic, strong) ASImageNode *badgeNode;
@property (nonatomic, strong) ASImageNode *avatarNode;
@property (nonatomic, strong) ASTextNode *usernameNode;
@property (nonatomic, strong) ASTextNode *subtitleNode;
@property (nonatomic, assign) CGFloat photoSizeValue;
@property (nonatomic, assign) CGFloat iconSizeValue;

@property (nonatomic, strong) ASButtonNode * buttonNode;
@end

@implementation UserProfileSample

+ (NSString *)title
{
    return @"Common user profile layout.";
}

+ (NSString *)descriptionTitle
{
    return @"For corner image layout and text truncation.";
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _photoSizeValue = 44;
        _iconSizeValue = 15;
        
        CGSize iconSize = CGSizeMake(_iconSizeValue, _iconSizeValue);
        CGSize photoSize = CGSizeMake(_photoSizeValue, _photoSizeValue);
        
        _badgeNode = [ASImageNode new];
        _badgeNode.style.preferredSize = iconSize;
        _badgeNode.image = [UIImage imageWithSize:iconSize fillColor:UIColor.redColor shapeBlock:^UIBezierPath *{
            return [UIBezierPath bezierPathWithOvalInRect:(CGRect){ CGPointZero, iconSize }];
        }];
        
        _avatarNode = [ASImageNode new];
        _avatarNode.style.preferredSize = photoSize;
        _avatarNode.image = [UIImage imageWithSize:photoSize fillColor:UIColor.lightGrayColor shapeBlock:^UIBezierPath *{
            return [UIBezierPath bezierPathWithOvalInRect:(CGRect){ CGPointZero, photoSize }];
        }];
        
        _usernameNode = [ASTextNode new];
        _usernameNode.backgroundColor = [UIColor redColor];
        _usernameNode.attributedText = [NSAttributedString attributedStringWithString:@"Hello World" fontSize:17 color:UIColor.blackColor];
        _usernameNode.maximumNumberOfLines = 2;
        _usernameNode.style.flexGrow = 0.0;
        _usernameNode.style.flexGrow = 0.0;
        
        _subtitleNode = [ASTextNode new];
        _subtitleNode.backgroundColor = [UIColor greenColor];
        _subtitleNode.attributedText = [NSAttributedString attributedStringWithString:@"This is a long long subtitle, with a long long appended string." fontSize:14 color:UIColor.lightGrayColor];
        _subtitleNode.maximumNumberOfLines = 1;
        
        _buttonNode = [ASButtonNode new];
        _buttonNode.backgroundColor = [UIColor redColor];
        [_buttonNode setTitle:@"变化" withFont:[UIFont boldSystemFontOfSize:15] withColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _buttonNode.style.preferredSize = CGSizeMake(80, 40);
        [_buttonNode addTarget:self action:@selector(changeLines:) forControlEvents:ASControlNodeEventTouchUpInside];
    }
    return self;
}

- (void)changeLines:(ASButtonNode *)btnNode {
    if (_subtitleNode.maximumNumberOfLines == 1) {
        _subtitleNode.maximumNumberOfLines = 2;
    }else {
        _subtitleNode.maximumNumberOfLines = 1;
    }
    [UIView animateWithDuration:1 animations:^{
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    // Apply avatar with badge
    // Normally, avatar's box size is the only photo size and it will not include the badge size.
    // Otherwise, use includeCornerForSizeCalculation property to increase the box's size if needed.
    ASCornerLayoutSpec *avatarBox = [ASCornerLayoutSpec new];
    avatarBox.child = _avatarNode;
    avatarBox.corner = _badgeNode;
    avatarBox.cornerLocation = ASCornerLayoutLocationBottomRight;
    avatarBox.offset = CGPointMake(-6, -6);
    
    ASStackLayoutSpec *textBox = [ASStackLayoutSpec verticalStackLayoutSpec];
    textBox.justifyContent = ASStackLayoutJustifyContentSpaceAround;
    textBox.spacing = 8;
    textBox.children = @[_usernameNode, _subtitleNode];
    
//    ASStackLayoutSpec *profileBox = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:10 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStart children:@[avatarBox,textBox]];
    
    ASStackLayoutSpec *profileBox = [ASStackLayoutSpec horizontalStackLayoutSpec];
    profileBox.spacing = 10;
//    profileBox.justifyContent = ASStackLayoutJustifyContentSpaceAround;
    profileBox.alignItems = ASStackLayoutAlignItemsStart;
    profileBox.children = @[avatarBox,textBox];
    
    // Apply text truncation.
    NSArray *elems = @[_usernameNode, _subtitleNode, textBox, profileBox];
    for (id <ASLayoutElement> elem in elems) {
        elem.style.flexShrink = 1;
    }
    
    
    ASStackLayoutSpec *allBox = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                                 spacing:40
                                                                          justifyContent:ASStackLayoutJustifyContentSpaceAround
                                                                              alignItems:ASStackLayoutAlignItemsCenter
                                                                                children:@[profileBox, _buttonNode]];
    
    ASInsetLayoutSpec *profileInsetBox = [ASInsetLayoutSpec new];
    profileInsetBox.insets = UIEdgeInsetsMake(120, 20, INFINITY, 20);
    profileInsetBox.child = allBox;
   
    
    return profileInsetBox;
}

@end

@implementation LayoutExampleNode

+ (NSString *)title
{
  NSAssert(NO, @"All layout example nodes must provide a title!");
  return nil;
}

+ (NSString *)descriptionTitle
{
  return nil;
}

- (instancetype)init
{
  self = [super init];
  if (self) {
    self.automaticallyManagesSubnodes = YES;
    self.backgroundColor = [UIColor whiteColor];
  }
  return self;
}

@end


@implementation BackGroundSample

+ (NSString *)title
{
    return @"BackGroundSample";
}

+ (NSString *)descriptionTitle
{
    return nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.automaticallyManagesSubnodes = YES;
        self.backNode = [[ASDisplayNode alloc] init];
        self.foreNode = [[ASDisplayNode alloc] init];
//        [self addSubnode:self.foreNode];
//        [self addSubnode:self.backNode];
        
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    self.backNode.style.maxHeight = ASDimensionMake(150);
    ASInsetLayoutSpec *insetLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(100, 15, INFINITY, 15) child:self.backNode];
    
  
    
    ASOverlayLayoutSpec *backgroundLayout = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:self.foreNode overlay:insetLayout];

    return backgroundLayout;
}

- (void)layout {
    [super layout];
    self.backNode.backgroundColor = [UIColor redColor];
    self.foreNode.backgroundColor = [UIColor greenColor];
}


@end

@interface TestSample ()


@property (nonatomic, strong) ASDisplayNode * node1;
@property (nonatomic, strong) ASDisplayNode * node2;
@property (nonatomic, strong) ASDisplayNode * node3;
@property (nonatomic, strong) ASDisplayNode * node4;
@property (nonatomic, strong) ASDisplayNode * node5;

@end

@implementation TestSample

+ (NSString *)title
{
    return @"TestSample";
}

+ (NSString *)descriptionTitle
{
    return @"演示 ASAbsoluteLayoutSpec 的使用";
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.automaticallyManagesSubnodes = YES;
        self.node1 = [[ASDisplayNode alloc] init];
        self.node2 = [[ASDisplayNode alloc] init];
        self.node3 = [[ASDisplayNode alloc] init];
        self.node4 = [[ASDisplayNode alloc] init];
        self.node5 = [[ASDisplayNode alloc] init];
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    self.node1.style.height = ASDimensionMake(156);
    
    self.node2.style.preferredSize = CGSizeMake(60, 30);
    self.node2.style.layoutPosition = CGPointMake(14, 80);
    
    self.node3.style.height = ASDimensionMake(37);
    
    self.node4.style.preferredSize = CGSizeMake(80,40);
    self.node5.style.preferredSize = CGSizeMake(40,50);
    
    self.node4.style.spacingBefore = 14;
    self.node5.style.spacingAfter = 14;
    
    
    
    ASAbsoluteLayoutSpec * absoluteLayoutSpec = [ASAbsoluteLayoutSpec absoluteLayoutSpecWithChildren:@[self.node2]];
    
    ASOverlayLayoutSpec *overlay = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:self.node1 overlay:absoluteLayoutSpec];
    
    ASInsetLayoutSpec *inset = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, 14, 0, 14) child:self.node3];
    
    inset.style.spacingBefore = 13.0;
    inset.style.spacingAfter = 25.0;
    
    ASStackLayoutSpec *bottom = [ASStackLayoutSpec horizontalStackLayoutSpec];
    bottom.alignItems = ASStackLayoutAlignItemsCenter;
    bottom.justifyContent = ASStackLayoutJustifyContentSpaceBetween;
    bottom.children = @[self.node4,self.node5];
//    bottom.style.width = ASDimensionMake(constrainedSize.max.width);
    bottom.style.spacingAfter = 30;
    
    
    ASStackLayoutSpec *all = [ASStackLayoutSpec verticalStackLayoutSpec];
    all.alignItems = ASStackLayoutAlignItemsStretch;
    all.justifyContent = ASStackLayoutJustifyContentStart;
    all.children = @[overlay,inset,bottom];
    
    
    return all;
    
    
}

- (void)layout {
    [super layout];
    self.node1.backgroundColor = [UIColor lightGrayColor];
    self.node2.backgroundColor = [UIColor redColor];
    self.node3.backgroundColor = [UIColor lightGrayColor];
    self.node4.backgroundColor = [UIColor lightGrayColor];
    self.node5.backgroundColor = [UIColor lightGrayColor];
}

@end

@interface Test2Sample ()


@property (nonatomic, strong) ASDisplayNode * node1;
@property (nonatomic, strong) ASDisplayNode * node2;
@property (nonatomic, strong) ASDisplayNode * node3;
@property (nonatomic, strong) ASDisplayNode * node4;
@property (nonatomic, strong) ASDisplayNode * node5;

@end

@implementation Test2Sample

+ (NSString *)title
{
    return @"Test2Sample";
}

+ (NSString *)descriptionTitle
{
    return @"演示 flexGrow 的用法";
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.automaticallyManagesSubnodes = YES;
        self.node1 = [[ASDisplayNode alloc] init];
        self.node2 = [[ASDisplayNode alloc] init];
        self.node3 = [[ASDisplayNode alloc] init];
        self.node4 = [[ASDisplayNode alloc] init];
        self.node5 = [[ASDisplayNode alloc] init];
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
   
    
    
    return nil;
}

- (void)layout {
    [super layout];
    self.node1.backgroundColor = [UIColor lightGrayColor];
    self.node2.backgroundColor = [UIColor lightGrayColor];
    self.node3.backgroundColor = [UIColor lightGrayColor];
    self.node4.backgroundColor = [UIColor lightGrayColor];
    
}

@end

