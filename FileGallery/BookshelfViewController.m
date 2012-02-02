//
//  BookshelfViewController.m
//  AppSlate
//
//  Created by 김 태한 on 12. 1. 18..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "BookshelfViewController.h"
#import "FileCell.h"

@interface BookshelfViewController ()

@end

@implementation BookshelfViewController

@synthesize gridView=_gridView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.gridView = [[AQGridView alloc] initWithFrame:CGRectMake(0, 0, 640, 640)];
        self.view = self.gridView;
        self.gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.gridView.autoresizesSubviews = YES;
        self.gridView.delegate = self;
        self.gridView.dataSource = self;
        
    }
    _imageNames = [[NSMutableArray alloc] initWithCapacity:6];

#ifdef TARGET_IPHONE_SIMULATOR
    documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
#else
    documentsPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#endif
    NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:documentsPath];

    NSString *file;
    while (file = [dirEnum nextObject]) {
        NSDictionary *attr = [dirEnum fileAttributes];
        if( [[attr objectForKey:@"NSFileType"] isEqualToString:NSFileTypeDirectory] ){
            NSLog(@"%@",file);
            [_imageNames addObject:file]; // add name.
        }

        [dirEnum skipDescendants];  // do not recursion.
    }
    return self;
}

- (void)loadView
{
    // Implement loadView to create a view hierarchy programmatically, without using a nib.
}

- (void) viewDidLoad
{
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.view setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor]];
}

-(void) viewDidAppear:(BOOL)animated
{
    [self.gridView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Grid View Data Source

- (NSUInteger) numberOfItemsInGridView: (AQGridView *) aGridView
{
    return ( [_imageNames count] );
}

- (AQGridViewCell *) gridView: (AQGridView *) aGridView cellForItemAtIndex: (NSUInteger) index
{
    AQGridViewCell * cell = nil;

    FileCell *plainCell = (FileCell*)[aGridView dequeueReusableCellWithIdentifier:@"PlainCell"];
    if ( plainCell == nil )
    {
        plainCell = [[FileCell alloc] initWithFrame: CGRectMake(0.0, 0.0, 200.0, 150.0)
                                                 reuseIdentifier:@"PlainCell"];
        plainCell.selectionGlowColor = [UIColor blueColor];
    }

    plainCell.image = [UIImage imageWithContentsOfFile:[documentsPath stringByAppendingFormat:@"/%@/Face.png",[_imageNames objectAtIndex:index]]];
    plainCell.title = [_imageNames objectAtIndex:index];

    cell = plainCell;

    return cell;
}

- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) aGridView
{
    return ( CGSizeMake(224.0, 168.0) );
}

-(void) setParentController:(id) obj
{
    pObj = obj;
}

#pragma mark - GridView Delegate

- (void) gridView: (AQGridView *) gridView didSelectItemAtIndex: (NSUInteger) index
{
    NSLog(@"Icon selected: %d", index);

    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_FILELOAD
                                                        object:[documentsPath stringByAppendingFormat:@"/%@/Contents.obj",[_imageNames objectAtIndex:index]]];
    [pObj dismissModalViewControllerAnimated:YES];
}

@end