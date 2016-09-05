function Q = QExpectation(n1, n2, a, V, Q_coeff, Q_const, MaxCarMove)
Q = Q_coeff{n1 + 1, n2 + 1, a + MaxCarMove + 1} * V(:) + Q_const(n1 + 1, n2 + 1, a + MaxCarMove + 1);
end