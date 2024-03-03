#import "Hyprspace.h"
#import "ClockView.h"
#import "UserView.h"
#import "GNUstepGUI/GSTheme.h"

@implementation MyDelegate : NSObject
- (void) dealloc
{
  RELEASE (topBar);
  [super dealloc];
}

- (NSColor *) backgroundColor
{
  NSColor *color = [[GSTheme theme] menuItemBackgroundColor];
  return color;
}
- (NSColor *) transparentColor
{
  NSColor *color = [NSColor colorWithCalibratedRed: 0.992 green: 0.992 blue: 0.992 alpha: 0.0];
  return color;
}

-(id) init
{
  if ((self = [super init]) != nil)
    {
	// Register for a notification
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(desktopEventHandler:)
                                                   name:@"NSWorkspaceDidLaunchApplicationNotification"
                                                   object:nil];
       
    }

  return self;
}

- (void)desktopEventHandler:(NSNotification *)notification {
    // Handle the notification here
    NSLog(@"Received notification: %@", notification.name);
    NSLog(@"Received notification: %@", notification.object);
}

-(void) createTopBar
{
  const CGFloat menuBarHeight = [[GSTheme theme] menuBarHeight];
  NSRect rect;
  NSSize stringSize;
  NSColor *color;
  //NSSize logoSize;
  //NSImage *logo=nil;
  //NSPopUpButton *logoButton;
  //NSMenu *buttonMenu;
  //NSMenuItemCell * cell=nil;
  NSButton *label;
  NSFont *menuFont=[NSFont menuBarFontOfSize:0];
  NSMutableDictionary *attributes ;
  attributes = [NSMutableDictionary new];
  [attributes setObject:menuFont
		 forKey:NSFontAttributeName];
  screenFrame = [[NSScreen mainScreen] frame];
  screenSize = screenFrame.size;
  color = [self backgroundColor];
  /*
   // Creation of the popup menu
  logo = [[NSImage alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"Logo.tiff" ofType:nil] ];
   
  logoSize = logo.size;
  logoButton= [[NSPopUpButton alloc] initWithFrame:NSMakeRect(11,0,logoSize.width+10,menuBarHeight)];
  [logoButton setBezelStyle: NSRegularSquareBezelStyle];
  [logoButton setTitle: @""];
  [logoButton setImage: logo];
  [logoButton setPullsDown: YES];
  [logoButton setBordered: NO];//FixMe : this doesn't work with my popup button.
  buttonMenu =  [logoButton menu];
  NSMenuItem *menuItem = [logoButton itemAtIndex: 0];
  [menuItem setImage: logo];

  cell = [[NSMenuItemCell alloc] init]; 
  [cell setMenuItem: menuItem];
  [cell setImagePosition: NSImageLeft];  // FixMe : it seems that popup buttons can't use this to put the image at the left of the title.

  [buttonMenu addItemWithTitle:_(@"Launch xterm")
  			action: @selector (launchXterm:)
  		 keyEquivalent: @""];
  [buttonMenu addItemWithTitle:_(@"Quit")
			action: @selector (terminate:)
		 keyEquivalent: @"q  "];
  */
  
  // Creation of the label
  NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString: @"Hyprspace" ];
  [titleString setAttributes:attributes range:NSMakeRange(0,[titleString length])]; 
  stringSize=[titleString size];
  label = [[NSButton alloc] initWithFrame:
			      NSMakeRect (16,menuBarHeight/2 - stringSize.height/2,stringSize.width,stringSize.height)];
			      //NSMakeRect (screenSize.width/2-stringSize.width/2,menuBarHeight/2 - stringSize.height/2,stringSize.width,stringSize.height)];
  [label setFont: menuFont];
  [label setBordered: NO];
  [label setTitle: @"Hyprspace"];
 
  //Creation of the UserView
  UserView *userView = [[UserView alloc] initWithOrigin: screenSize.width - RIGHTPADDING
						 height: menuBarHeight];
  NSMutableArray *users = [userView users];
  NSLog(@"Users : %@", users);

 // Creation of the clock 
  ClockView *clockView = [[ClockView alloc] initWithOrigin: screenSize.width - PADDING - RIGHTPADDING - [userView width]
						    height: menuBarHeight];
  
  //Creation of the topBar 
  rect = NSMakeRect (0, screenSize.height-menuBarHeight, screenSize.width, menuBarHeight);
  topBar = [[NSWindow alloc] initWithContentRect: rect
				  styleMask: NSBorderlessWindowMask
				    backing: NSBackingStoreBuffered
				      defer:NO];
  [topBar setTitle: @"Hyprspace"];
  [topBar setBackgroundColor:color];
  [topBar setAlphaValue: 0.5];
  [topBar setLevel:NSTornOffMenuWindowLevel-1];
  [topBar setCanHide:NO];
  [topBar setHidesOnDeactivate:NO];

  


  // Add subviews
  // [[topBar contentView] addSubview: logoButton];
  [[topBar contentView] addSubview: label];
  [[topBar contentView] addSubview: [userView userButton]];
  [[topBar contentView] addSubview: [clockView clockButton]];
  //[logoButton release];
  //[logo release];
  [label release];
  [titleString release];
  [clockView release];
  [userView release];
  //[cell release];
}


- (void) applicationWillFinishLaunching:(NSNotification *)not
{
  [self createTopBar];
}

- (void) applicationDidFinishLaunching:(NSNotification *)not
{
  [topBar orderFront: self];
}

@end
