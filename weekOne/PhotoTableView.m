
//
//  PhotoTableView.m
//  weekOne
//
//  Created by WeiSheng Su on 1/25/15.
//  Copyright (c) 2015 Wilson. All rights reserved.
//

#import "PhotoTableView.h"
#import "PhotoCell.h"
#import "UIImageView+AFNetworking.h"
#import "PhotoDetailView.h"
#import "SVProgressHUD.h"

#define rottentomatoesAPI @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=gp4ydtwdzqv8nmj43pzpfn8y"

@interface PhotoTableView ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (weak, nonatomic) IBOutlet UILabel *errorLabel;


@end

@implementation PhotoTableView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //make error Label


    [self onRefresh];
    self.refreshControl = [[UIRefreshControl alloc]init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Updating Movies"];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 128;
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PhotoCell" bundle:nil] forCellReuseIdentifier:@"PhotoCell"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
static float progress = 0.0f;
- (void) onRefresh{


    NSURL *url = [NSURL URLWithString:rottentomatoesAPI];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    progress = 0.0f;
    [SVProgressHUD showProgress:0 status:@"Loading"];
    [self performSelector:@selector(increaseProgress) withObject:nil afterDelay:0.3f];


    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if(connectionError){
            NSLog(@"no interenet");
            [self.refreshControl endRefreshing];
            self.errorLabel.text = @"Network Error";


        }else{
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            self.movies = responseDictionary[@"movies"];
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
            NSLog(@"data refreshed");
            self.errorLabel.text = @"";



        }

        
        //NSLog(@"response: %@",responseDictionary);
    }];
}

- (void)increaseProgress {
    progress+=1.0f;
    [SVProgressHUD showProgress:progress status:@"Loading"];
    
    if(progress < 1.0f)
        [self performSelector:@selector(increaseProgress) withObject:nil afterDelay:0.3f];
    else
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.4f];
}


- (void)dismiss {
    [SVProgressHUD dismiss];
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.names.count;
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell *cell = [[UITableViewCell alloc]init ];
    
    PhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoCell"];

//    cell.textLabel.text = self.names[indexPath.row];
//    cell.textLabel.text = [NSString stringWithFormat:@"This is row %d", indexPath.row];
    NSDictionary *movie = self.movies[indexPath.row];
    cell.photoCellTitle.text = movie[@"title"];
    cell.photoCellDescription.text = movie[@"synopsis"];
    
    [cell.posterView setImageWithURL:[NSURL URLWithString:[movie valueForKeyPath:@"posters.thumbnail"]]];
    
    self.title = @"Movies";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PhotoDetailView *vc = [[PhotoDetailView alloc]init];

    vc.movie = self.movies[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
