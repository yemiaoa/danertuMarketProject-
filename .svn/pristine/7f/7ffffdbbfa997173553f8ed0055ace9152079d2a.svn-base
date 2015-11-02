//
//  CityListViewController.m
//  CityList
//
//  Created by Chen Yaoqiang on 14-3-6.
//
//

#import "CityController.h"

@interface CityController (){
    int addStatusBarHeight;
    UITextField *searchText;
    NSDictionary *gpsCity;
    UITableView *scrollV;
    NSMutableArray *searchArr;
    BOOL isSearchMode;
}

@end

@implementation CityController
@synthesize city;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = VIEWBGCOLOR;
    addStatusBarHeight = [TopNaviViewController getStatusBarHeight];
    // Custom initialization
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"cityKeyDefaults"] count] == 0) {
        self.arrayHotCity = [NSMutableArray arrayWithObjects:@"中山市", nil];
        [[NSUserDefaults standardUserDefaults] setObject:self.arrayHotCity forKey:@"cityKeyDefaults"];
    }else{
        self.arrayHotCity = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"cityKeyDefaults"]];
    }
    self.keys = [NSMutableArray array];
    self.arrayCitys = [NSMutableArray array];
    searchArr = [NSMutableArray array];
    [self getCityData];
    
    int staticViewHeight = 80;
    isSearchMode = NO;
    UIView *staticView = [[UIView alloc] initWithFrame:CGRectMake(0, addStatusBarHeight+TOPNAVIHEIGHT, MAINSCREEN_WIDTH, staticViewHeight)];
    [self.view addSubview:staticView];
    //搜索
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, 300, 30)];
    [staticView addSubview:searchView];
    searchView.backgroundColor = [UIColor whiteColor];
    searchView.layer.cornerRadius = 3;
    UITapGestureRecognizer *tapInput =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickInput)];
    [searchView addGestureRecognizer:tapInput];//---添加点击事件
    //搜索图标
    UIImageView *searchIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 20, 20)];
    [searchView addSubview:searchIcon];
    searchIcon.backgroundColor = [UIColor clearColor];
    searchIcon.image = [UIImage imageNamed:@"magnifying"];
    //索搜文字
    searchText = [[UITextField alloc] initWithFrame:CGRectMake(40, 0, 260, 30)];
    [searchView addSubview:searchText];
    searchText.backgroundColor = [UIColor whiteColor];
    searchText.font = TEXTFONT;
    searchText.delegate = self;
    searchText.placeholder = @"输入城市名或首字母查询";
    searchText.returnKeyType = UIReturnKeySearch;
    searchText.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    //-----定位城市-----
    UIView *gpsCityView = [[UIView alloc] initWithFrame:CGRectMake(10, 40, 300, 40)];
    [staticView addSubview:gpsCityView];
    
    UILabel *gpsTextLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    [gpsCityView addSubview:gpsTextLb];
    gpsTextLb.text = @"定位城市";
    gpsTextLb.font = TEXTFONT;
    gpsTextLb.backgroundColor = [UIColor clearColor];
    
    gpsCity = [self.delegate getGpsCity];
    NSLog(@"ajigjreikopkocpkfie----%@",gpsCity);
    UIButton *cityBtn = [[UIButton alloc] initWithFrame:CGRectMake(160, 5, 80, 30)];
    [gpsCityView addSubview:cityBtn];
    cityBtn.backgroundColor = TOPNAVIBGCOLOR;
    [cityBtn setTitle:[gpsCity objectForKey:@"cName"] forState:UIControlStateNormal];
    cityBtn.titleLabel.font = TEXTFONT;
    [cityBtn addTarget:self action:@selector(selectGpsCity) forControlEvents:UIControlEventTouchUpInside];
    
    
	// Do any additional setup after loading the view.
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, addStatusBarHeight+TOPNAVIHEIGHT+staticViewHeight, MAINSCREEN_WIDTH, self.view.frame.size.height-(addStatusBarHeight+TOPNAVIHEIGHT+staticViewHeight)) style:UITableViewStylePlain];
    _tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tag = 0;
    [self.view addSubview:_tableView];
    
    
}
//重新父类
-(NSString *)getTitle{
    return @"城市列表";
}
//-----输入文字
-(void)clickInput{
    [searchText becomeFirstResponder];
}
//-----输入的文字开始变化时
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //开始编辑时触发，文本字段将成为first responder
    NSLog(@"gjiorejoceoia----0----%@",textField.text);
    //[self goToSearch:textField.text];
}
//-----输入的文字开始变化时
- (void)textFieldDidEndEditing:(UITextField *)textField{
    //开始编辑时触发，文本字段将成为first responder
    NSLog(@"gjiorejoceoia----1----%@",textField.text);
    [self goToSearch:textField.text];
}
//-----返回时
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"gjiorejoceoia----2----%@",textField.text);
    [searchText resignFirstResponder];
    [self goToSearch:textField.text];
    return YES;
}
//-----文字内容改变时
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *searchStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSLog(@"gjiorejoceoia----3----(%@)--(%@)--%@--(%@)",textField.text,string,NSStringFromRange(range),searchStr);
    [self goToSearch:searchStr];
    return YES;
}
//执行搜索,
-(void)goToSearch:(NSString*)str{
    NSInteger length = str.length;
    [searchArr removeAllObjects];
    if (length > 0) {
        NSString *firstChar = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *regexAlphabet = @"[a-zA-Z]{1}";
        firstChar = [firstChar substringToIndex:1];
        //判断首字符是否为字母
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexAlphabet];
        if([pred evaluateWithObject:firstChar]){
            NSLog(@"jfiojgiojegojtoht--1--%@",firstChar);
            //是首字母搜索
            firstChar = [firstChar uppercaseString];//转大写
            NSArray *citySection = [_cities objectForKey:firstChar];
            if (citySection) {
                searchArr = [citySection mutableCopy];
            }
        }else{
            NSLog(@"jfiojgiojegojtoht--2--%@",firstChar);
            for (NSString *key in self.keys) {
                NSArray *temp = [_cities objectForKey:key];
                for (NSString *cName in temp) {
                    if ([cName hasPrefix:str]) {
                        [searchArr addObject:cName];
                    }
                }
            }
        }
        //查询模式
        isSearchMode = YES;
    }else{
        //初始显示所有城市
        isSearchMode = NO;
    }
    [_tableView reloadData];
}
//-----选择定位城市
-(void)selectGpsCity{
    [self.delegate CityController:self didSelectCity:gpsCity];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 获取城市数据
-(void)getCityData
{
    NSString *path=[[NSBundle mainBundle] pathForResource:@"citydict"
                                                   ofType:@"plist"];
    self.cities = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    
    [self.keys addObjectsFromArray:[[self.cities allKeys] sortedArrayUsingSelector:@selector(compare:)]];
    
    //添加热门城市
    NSString *strHot = @"热";
    [self.keys insertObject:strHot atIndex:0];
    [self.cities setObject:_arrayHotCity forKey:strHot];
    NSLog(@"gjpegpejinjiqpkegor-------%@",[self.cities objectForKey:@"A"]);
    
}

#pragma mark - tableView
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 20)];
    bgView.backgroundColor = [UIColor lightGrayColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, 250, 20)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:12];
    
    NSString *key = [_keys objectAtIndex:section];
    if (isSearchMode) {
        titleLabel.text = @"搜索结果";
    }else{
        if ([key rangeOfString:@"热"].location != NSNotFound) {
            titleLabel.text = @"热门城市";
        }else{
            titleLabel.text = key;
        }
    }
    [bgView addSubview:titleLabel];
    return bgView;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _keys;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count= 1;
    // Return the number of sections.
    if (isSearchMode) {
        count = 1;
    }else{
        count = [_keys count];
    }
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count= 1;
    if (isSearchMode) {
        count = [searchArr count];
    }else{
        NSString *key = [_keys objectAtIndex:section];
        NSArray *citySection = [_cities objectForKey:key];
        count = [citySection count];
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    NSString *key = [_keys objectAtIndex:indexPath.section];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.textLabel setTextColor:[UIColor blackColor]];
        cell.textLabel.font = [UIFont systemFontOfSize:18];
    }
    if (isSearchMode) {
        cell.textLabel.text = [searchArr objectAtIndex:indexPath.row];
    }else{
        cell.textLabel.text = [[_cities objectForKey:key] objectAtIndex:indexPath.row];
    }
    
    return cell;
}

//点击选择城市-------
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *selectCity ;
    if (isSearchMode) {
        selectCity = [searchArr objectAtIndex:indexPath.row];
    }else{
        NSString *key = [_keys objectAtIndex:indexPath.section];
        selectCity = [[_cities objectForKey:key] objectAtIndex:indexPath.row];
    }
    NSDictionary *cityDic = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"cId",selectCity,@"cName",@"",@"province",nil];//注意用nil结束;
    [self.delegate CityController:self didSelectCity:cityDic];
    
    //本地保存
    BOOL isHave = NO;
    for (NSString *cityName in [[NSUserDefaults standardUserDefaults] valueForKey:@"cityKeyDefaults"]) {
        if ([cityName isEqualToString:selectCity]) {
            isHave = YES;
        }
    }
    if (!isHave) {
        NSMutableArray *tempArr = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"cityKeyDefaults"]];
        [tempArr addObject:selectCity];
        [[NSUserDefaults standardUserDefaults] setValue:tempArr forKey:@"cityKeyDefaults"];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
