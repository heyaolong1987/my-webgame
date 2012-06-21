#include<iostream.h>
#include<string.h>
#include<iomanip.h>

class company
{
private:
	int number;
	char name[10],headship[10];
	double salary;
public:
	void enter_message(int,char *,char *);
	double manager();
	double technician(double);
	double saler(double);
	double salemanager(double);
	void display_all();
	void display_name();
};
//输入人员信息
void company::enter_message(int num,char *n,char *h)
{
		number=num;
		strcpy(name,n);
		strcpy(headship,h);
}
//计算兼职技术员的月薪
double company::technician(double time)
{
	salary=time*100;
	return salary;
}
//经理薪水
double company::manager()
{
	salary=8000;
	return salary;
}
//计算销售经理的月薪
double company::salemanager(double all_sum)
{
	salary=5000+all_sum*0.005;
	return salary;
}
//显示当月月薪
void company::display_all()
{
	cout<<setw(4)<<number<<setw(6)<<name<<setw(12)<<headship<<setw(10)<<salary<<endl;
}
//显示姓名
void company::display_name()
{
	cout<<name;
}
void main()
{
	int i;
	int choice;//菜单变量
	int nt,ns;//技术员及销售人数
	int num;//编号变量
	char name[10],head[10];//姓名变量
	double time,sum,all_sum,sala;//技术员工时,销售员销售额,总销售额及经理薪水变量
	//定义相应对象
	company manager,sale_manager;
	company technicians[10];
	company salers[10];
a:
	cout<<"请输入该公司兼职技术员的人数:";
	cin>>nt;
	if (nt>10)
	{
		cout<<"人多了,请重输入";
		goto a;
	}
b:
	cout<<"请输入该公司销售员的人数:";
	cin>>ns;
	if (ns>10)
	{
		cout<<"人多了,请重输入";
		goto b;
	}
	do
	{
		cout<<"某公司工资管理程序(课程设计2)菜单"<<endl;
		cout<<"_________________________________"<<endl;
		cout<<"<1>输入公司人员信息;\n";
		cout<<"<2>计算月薪;\n";
		cout<<"<3>显示全体人员信息;\n";
		cout<<"<0>退出程序;\n";
		cout<<"_________________________________"<<endl;
		cout<<"请选择:"<<endl;
		cin>>choice;
		switch(choice)
		{
		case 1://输入公司人员信息
			cout<<"请输入经理信息:"<<endl;
			strcpy(head,"经理");
			cout<<"编号:";
			cin>>num;
			cout<<num;
			cout<<"姓名:";
			cin>>name;
			manager.enter_message(num,name,head);
			cout<<"请输入销售经理信息:"<<endl;
			strcpy(head,"销售经理");
			cout<<"编号:";
			cin>>name;
			sale_manager.enter_message(num,name,head);
			cout<<"请输入技术人员信息:"<<endl;
			for(i=1;i<=nt;i++)
			{
				cout<<"第"<<i<<"位编号:";
				cin>>num;
				cout<<"姓名:";
				cin>>name;
				strcpy(head,"兼职技术员");
				technicians[i].enter_message(num,name,head);
			}
			cout<<"请输入销售员信息:"<<endl;
			for(i=1;i<=ns;i++)
			{
				cout<<"第"<<i<<"位编号:";
				cin>>num;
				cout<<"姓名:";
				cin>>name;
				strcpy(head,"销售员");
				salers[i].enter_message(num,name,head);
			}
			break;
		case 2:
			//经理薪水
			sala=manager.manager();
			//兼职技术员月薪
			cout<<"计算兼职技术员当月薪水,请输入每位技术员的兼职工时"<<endl;
			for(i=1;i<=nt;i++)
			{
				technicians[i].display_name();
				cout<<"的工时(按小时计)为:";
				cin>>time;
				technicians[i].technician(time);
				cout<<"当月月薪为:"<<technicians[i].technician(time)<<"元"<<endl;
			}
				//计算销售员及销售经理的月薪
				all_sum=0;
				cout<<"计算销售员当月薪水,请输入每位销售员的销售额"<<endl;
				for(i=1;i<=ns;i++)
				{
					salers[i].display_name();
					cout<<"的销售额为:";
					cin>>sum;
					salers[i].saler(sum);
					cout<<"当月薪水为:"<<salers[i].saler(sum)<<"元"<<endl;
					all_sum+=sum;

				}
				sale_manager.salemanager(all_sum);
				cout<<"销售经理所辖部门当月销售额为:"<<all_sum<<endl;
				cout<<"销售经理当月月薪为:"<<sale_manager.salemanager(all_sum)<<endl;
				break;
		case 3:
			cout<<"公司全体人员信息:"<<endl;
			cout<<setw(4)<<"编号"<<setw(6)<<"姓名"<<setw(12)<<"职务"<<setw(10)<<"当月薪水"<<endl;
			cout<<"________________________________________________"<<endl;
			manager.display_all();
			sale_manager.display_all();
			for(i=1;i<=nt;i++){technicians[i].display_all();}
			for(i=1;i<=ns;i++){salers[i].display_all();}
			break;
			}

		}while(choice!=0);

}