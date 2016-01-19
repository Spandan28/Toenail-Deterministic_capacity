data = xlsread('Minitab.xls','Sheet1','B1:D41');
plot(1,data(1:5,2),'*k'); hold on;
plot(2,data(6:10,2),'*k')
plot(3,data(11:15,2),'*k')
plot(4,data(16:20,2),'*k')
plot(5,data(21:25,2),'*k')
plot(6,data(26:30,2),'*k')
plot(7,data(31:35,2),'*k')
plot(8,data(36:40,2),'*k')
plot(1,data(1:5,3),'or'); hold on;
plot(2,data(6:10,3),'or')
plot(3,data(11:15,3),'or')
plot(4,data(16:20,3),'or')
plot(5,data(21:25,3),'or')
plot(6,data(26:30,3),'or')
plot(7,data(31:35,3),'or')
plot(8,data(36:40,3),'or')