clear
clc
close all

len = 21;
n = 2;
pattern = [0.25,0,0.5,0,0.25];
m2 = zeros(len,len);
load('expec');
for i = 1:len
    if i==1||i==len
        m2(i,i)=1;
    elseif i ==2 
            m2(i,1:4)=[0.5,0.25,0,0.25];
    elseif i==len-1
            m2(i,end-3:end) = [0.25,0,0.25,0.5];
    else m2(i,i-2:i+2) = pattern;
    end
end

m3 = zeros(len,len);
for i = 1:len
    if i==1||i==len
        m3(i,i)=1;
    elseif i ==2 
            m3(i,1:5)=[4,0,3,0,1]/8;
    elseif i==3
        m3(i,1:6) = [1,3,0,3,0,1]/8;
    elseif i==len-2
            m3(i,end-5:end) = [1,0,3,0,3,1]/8;
    elseif i==len-1
            m3(i,end-4:end) = [1,0,3,0,4]/8;
    else m3(i,i-3:i+3) = [1,0,3,0,3,0,1]/8;
    end
end
m2= m2 -eye(21);
m3 = m3-eye(21);

alphalist = 0:0.03:0.5;
error2list = [];

for i_alpha = 1:length(alphalist)
    alpha = alphalist(i_alpha)*expec;

V2 = zeros(len,1);
V2(1)=1;
V2(end)=-1;
V3 = V2;
% figure;
Vtrue = linspace(1,-1,21);
error2 = [];
error3 = [];
for i = 1:10
    V2 = [V2 V2(:,end)+alpha.*(m2*V2(:,end))];
    V3 = [V3 V3(:,end)+alpha.*(m3*V3(:,end))];
    subplot 221
    plot(V2(:,end))
    ylabel(['alpha=0.',num2str(alphalist(i_alpha)*100)])
    hold on
    plot(Vtrue,'k')
    hold off
    title('n=2')
    subplot 222
    
    plot(V3(:,end))
    hold on
    plot(Vtrue,'k')
    hold off
    title('n=3')
    
    error2 = [error2 mean((V2(:,end)-Vtrue').^2).^0.5];
    error3 = [error3 mean((V3(:,end)-Vtrue').^2).^0.5];
    subplot 223
    plot(error2,'r')
    title('mse')
    subplot 224
    plot(error3,'b')
%     legend({'n=2','n=3'})
    title('mse')
%     pause(0.2)
    drawnow
end
error2list(i_alpha) = error2(end);
error3list(i_alpha) = error3(end);
end
%%
figure;
plot(alphalist,error2list,'r')
hold on
plot(alphalist,error3list,'b')

ylim([0,0.55])