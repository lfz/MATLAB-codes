function Q = ExtractQ(s, a, QTable, Q_init)
Ind = find((QTable.s == s) & (QTable.a == a), 1, 'first');
if isempty(Ind)
    Q = Q_init;
else
    Q = QTable.Val(Ind);
end
end