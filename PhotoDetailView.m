//
//  PhotoDetailView.m
//  weekOne
//
//  Created by WeiSheng Su on 1/26/15.
//  Copyright (c) 2015 Wilson. All rights reserved.
//

#import "PhotoDetailView.h"
#import "UIImageView+AFNetworking.h"

@interface PhotoDetailView ()
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UIScrollView *detailScrollView;
@property (nonatomic, strong) NSString *origPosterLink;


@end

@implementation PhotoDetailView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.movie[@"title"];


    // Do any additional setup after loading the view from its nib.
//    self.titleLabel.text = self.movie[@"title"];
//    self.descriptionLabel.text = self.movie[@"synopsis"];
    self.origPosterLink = [self.movie valueForKeyPath:@"posters.thumbnail"];
    self.origPosterLink = [self.origPosterLink stringByReplacingOccurrencesOfString:@"tmb" withString:@"ori"];
    
    
    NSLog(@"original Poster Link: %@",self.origPosterLink);
    [self.posterView setImageWithURL:[NSURL URLWithString:self.origPosterLink]];
    
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 300, 320, self.view.frame.size.height)];
    
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.alpha = 0.9;
    [self.detailScrollView addSubview:contentView];

    UILabel *descLabel =[[UILabel alloc] initWithFrame:CGRectMake(10, 30, 300, 30)];
    UILabel *titleLabel =[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 20)];
    titleLabel.text = [NSString stringWithFormat:@"%@ (%@)", self.movie[@"title"],self.movie[@"year"]];
    descLabel.text = self.movie[@"synopsis"];
    descLabel.numberOfLines = 0;

    [descLabel sizeToFit];
    [contentView addSubview:titleLabel];
    [contentView addSubview:descLabel];

    
    
    float scrollHeight = 300 + contentView.frame.size.height - self.navigationController.toolbar.frame.size.height;
    [self.detailScrollView setContentSize: CGSizeMake(320, scrollHeight)];



    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
