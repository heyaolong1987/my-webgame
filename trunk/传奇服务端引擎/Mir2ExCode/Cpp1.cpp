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
//������Ա��Ϣ
void company::enter_message(int num,char *n,char *h)
{
		number=num;
		strcpy(name,n);
		strcpy(headship,h);
}
//�����ְ����Ա����н
double company::technician(double time)
{
	salary=time*100;
	return salary;
}
//����нˮ
double company::manager()
{
	salary=8000;
	return salary;
}
//�������۾������н
double company::salemanager(double all_sum)
{
	salary=5000+all_sum*0.005;
	return salary;
}
//��ʾ������н
void company::display_all()
{
	cout<<setw(4)<<number<<setw(6)<<name<<setw(12)<<headship<<setw(10)<<salary<<endl;
}
//��ʾ����
void company::display_name()
{
	cout<<name;
}
void main()
{
	int i;
	int choice;//�˵�����
	int nt,ns;//����Ա����������
	int num;//��ű���
	char name[10],head[10];//��������
	double time,sum,all_sum,sala;//����Ա��ʱ,����Ա���۶�,�����۶����нˮ����
	//������Ӧ����
	company manager,sale_manager;
	company technicians[10];
	company salers[10];
a:
	cout<<"������ù�˾��ְ����Ա������:";
	cin>>nt;
	if (nt>10)
	{
		cout<<"�˶���,��������";
		goto a;
	}
b:
	cout<<"������ù�˾����Ա������:";
	cin>>ns;
	if (ns>10)
	{
		cout<<"�˶���,��������";
		goto b;
	}
	do
	{
		cout<<"ĳ��˾���ʹ������(�γ����2)�˵�"<<endl;
		cout<<"_________________________________"<<endl;
		cout<<"<1>���빫˾��Ա��Ϣ;\n";
		cout<<"<2>������н;\n";
		cout<<"<3>��ʾȫ����Ա��Ϣ;\n";
		cout<<"<0>�˳�����;\n";
		cout<<"_________________________________"<<endl;
		cout<<"��ѡ��:"<<endl;
		cin>>choice;
		switch(choice)
		{
		case 1://���빫˾��Ա��Ϣ
			cout<<"�����뾭����Ϣ:"<<endl;
			strcpy(head,"����");
			cout<<"���:";
			cin>>num;
			cout<<num;
			cout<<"����:";
			cin>>name;
			manager.enter_message(num,name,head);
			cout<<"���������۾�����Ϣ:"<<endl;
			strcpy(head,"���۾���");
			cout<<"���:";
			cin>>name;
			sale_manager.enter_message(num,name,head);
			cout<<"�����뼼����Ա��Ϣ:"<<endl;
			for(i=1;i<=nt;i++)
			{
				cout<<"��"<<i<<"λ���:";
				cin>>num;
				cout<<"����:";
				cin>>name;
				strcpy(head,"��ְ����Ա");
				technicians[i].enter_message(num,name,head);
			}
			cout<<"����������Ա��Ϣ:"<<endl;
			for(i=1;i<=ns;i++)
			{
				cout<<"��"<<i<<"λ���:";
				cin>>num;
				cout<<"����:";
				cin>>name;
				strcpy(head,"����Ա");
				salers[i].enter_message(num,name,head);
			}
			break;
		case 2:
			//����нˮ
			sala=manager.manager();
			//��ְ����Ա��н
			cout<<"�����ְ����Ա����нˮ,������ÿλ����Ա�ļ�ְ��ʱ"<<endl;
			for(i=1;i<=nt;i++)
			{
				technicians[i].display_name();
				cout<<"�Ĺ�ʱ(��Сʱ��)Ϊ:";
				cin>>time;
				technicians[i].technician(time);
				cout<<"������нΪ:"<<technicians[i].technician(time)<<"Ԫ"<<endl;
			}
				//��������Ա�����۾������н
				all_sum=0;
				cout<<"��������Ա����нˮ,������ÿλ����Ա�����۶�"<<endl;
				for(i=1;i<=ns;i++)
				{
					salers[i].display_name();
					cout<<"�����۶�Ϊ:";
					cin>>sum;
					salers[i].saler(sum);
					cout<<"����нˮΪ:"<<salers[i].saler(sum)<<"Ԫ"<<endl;
					all_sum+=sum;

				}
				sale_manager.salemanager(all_sum);
				cout<<"���۾�����Ͻ���ŵ������۶�Ϊ:"<<all_sum<<endl;
				cout<<"���۾�������нΪ:"<<sale_manager.salemanager(all_sum)<<endl;
				break;
		case 3:
			cout<<"��˾ȫ����Ա��Ϣ:"<<endl;
			cout<<setw(4)<<"���"<<setw(6)<<"����"<<setw(12)<<"ְ��"<<setw(10)<<"����нˮ"<<endl;
			cout<<"________________________________________________"<<endl;
			manager.display_all();
			sale_manager.display_all();
			for(i=1;i<=nt;i++){technicians[i].display_all();}
			for(i=1;i<=ns;i++){salers[i].display_all();}
			break;
			}

		}while(choice!=0);

}