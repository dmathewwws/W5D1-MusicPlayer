//
//  MasterViewController.m
//  W5D1-MusicPlayer
//
//  Created by Daniel Mathews on 2015-02-12.
//  Copyright (c) 2015 com.lighthouse-labs. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface MasterViewController (){
    MPMusicPlayerController *musicPlayer;
    NSArray *collections;
}

@property NSMutableArray *objects;

@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    musicPlayer = [MPMusicPlayerController systemMusicPlayer];
    MPMediaQuery *everything = [MPMediaQuery podcastsQuery];
    collections = [everything items];
    
//    UIBarButtonItem *addButton = [[UIBarButtonItem allocxx] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
//    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender {
    if (!self.objects) {
        self.objects = [[NSMutableArray alloc] init];
    }
    [self.objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return collections.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MediaEntry" forIndexPath:indexPath];
    
    MPMediaItem *entity= [collections objectAtIndex:indexPath.row];
    
    NSString *title = [entity valueForProperty:MPMediaItemPropertyTitle];
    [cell.textLabel setText:title];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // Navigation logic may go here. Create and push another view controller.
    MPMediaItem *entity= [collections objectAtIndex:indexPath.row];
    
    MPMediaItemCollection *collection = [[MPMediaItemCollection alloc] initWithItems:collections];
    
    [musicPlayer setQueueWithItemCollection:collection];
    [musicPlayer setNowPlayingItem:entity];
    
    [musicPlayer prepareToPlay];
    [musicPlayer play];
}

@end
