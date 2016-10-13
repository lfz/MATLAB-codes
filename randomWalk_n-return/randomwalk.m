clear
clc
close all 

len = 21;


state = 11;
history = [];
for i = 1:1000
while not(state==1 || state==len)
    state = state+randi(2)*2-3;
    history = [history,state];
end
state = 11;
end
stat = tabulate(history);
expec = stat(:,3);
save('expec','expec')
