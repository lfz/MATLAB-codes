function QTable = UpdateQ(s, a, delta, QTable, Q_init)
Ind = find((QTable.s == s) & (QTable.a == a), 1, 'first');
if isempty(Ind)
    QTable.s = [QTable.s; s];
    QTable.a = [QTable.a; a];
    QTable.Val = [QTable.Val; Q_init + delta];
else
    QTable.Val(Ind) = QTable.Val(Ind) + delta;
end
end