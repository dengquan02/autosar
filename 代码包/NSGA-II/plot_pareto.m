function  plot_pareto
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
x1=5:0.1:40;
y1 = 10./x1;
x2=15:0.1:50;
y2 = 10./(x2-10) +0.3;
plot(x1,y1,'b','Linewidth',2);
hold on;
plot(x2,y2,'y','Linewidth',2);

plot(10,1,'k*');
% plot(11,10/11,'k*');
plot(20,0.5,'k*');
plot(18.5,10/8.5 +0.3,'k*');

text(10,1.1,'X1','FontSize',15,'FontName','Times New Roman','FontWeight','bold' );
% text(11,10/11 +0.1,'s2','FontSize',12,'FontName','Times New Roman','FontWeight','bold' );
text(20,0.6,'X2','FontSize',15,'FontName','Times New Roman','FontWeight','bold' )
text(18.5,10/8.5 +0.4,'X3','FontSize',15,'FontName','Times New Roman','FontWeight','bold' )
text(35,10/35-0.1,'Pareto Front','FontSize',15,'FontName','Times New Roman','FontWeight','bold' )

set(gca,'xtick',[],'xticklabel',[])
set(gca,'ytick',[],'yticklabel',[])
% title('Pareto Front','FontSize',14,'FontName','Times New Roman','FontWeight','bold' );
xlabel('F1','FontSize',14,'FontName','Times New Roman','FontWeight','bold' )
ylabel('F2','FontSize',14,'FontName','Times New Roman','FontWeight','bold' )
set(0,'defaultfigurecolor','w')
end

