function [MaxCarPark, MaxCarMove, Q_coeff, Q_const] = ProblemParameter(SimID)
FileName = sprintf('ProblemParameter_%d.mat', SimID);
if exist(FileName, 'file')
    load(FileName);
else
    display(sprintf('Constructing coefficients for calculating Q(n1, n2, a) in simulation %d...', SimID));
    switch SimID
        case 1
            MaxCarPark = 20;
            MaxCarMove = 5;
            ReturnTraffic = [3, 2];
            RentTraffic = [3, 4];
            RentPrice = 10;
            MoveCost = 2;
            gamma = 0.9;
            
            PoissRange = 3;
            Q_coeff = cell([MaxCarPark + 1, MaxCarPark + 1, 2 * MaxCarMove + 1]);
            Q_const = NaN([MaxCarPark + 1, MaxCarPark + 1, 2 * MaxCarMove + 1]);
            P = sum(poisscdf(round(ReturnTraffic(1) * PoissRange), ReturnTraffic(1))) ...
                * sum(poisscdf(round(RentTraffic(1) * PoissRange), RentTraffic(1))) ...
                * sum(poisscdf(round(ReturnTraffic(2) * PoissRange), ReturnTraffic(2))) ...
                * sum(poisscdf(round(RentTraffic(2) * PoissRange), RentTraffic(2)));
            tStart = tic;
            for n1 = 0:MaxCarPark
                for n2 = 0:MaxCarPark
                    for a = max([-n2, -MaxCarPark + n1, -MaxCarMove]):min([n1, MaxCarPark - n2, MaxCarMove])
                        Q_coeff{n1 + 1, n2 + 1, a + MaxCarMove + 1} = zeros(1, (MaxCarPark + 1)^2);
                        Q_const(n1 + 1, n2 + 1, a + MaxCarMove + 1) = 0;
                        n1_night = n1 - a;
                        n2_night = n2 + a;
                        for i1 = 0:round(ReturnTraffic(1) * PoissRange)
                            for o1 = 0:round(RentTraffic(1) * PoissRange)
                                for i2 = 0:round(ReturnTraffic(2) * PoissRange)
                                    for o2 = 0:round(RentTraffic(2) * PoissRange)
                                        p = poisspdf(i1, ReturnTraffic(1)) * poisspdf(o1, RentTraffic(1)) * poisspdf(i2, ReturnTraffic(2)) * poisspdf(o2, RentTraffic(2));
                                        
                                        r = -abs(a) * MoveCost;
                                        n1_new = n1_night + i1;
                                        r = r + RentPrice * min([n1_new, o1]);
                                        n1_new = min([n1_new - min([n1_new, o1]), MaxCarPark]);
                                        n2_new = n2_night + i2;
                                        r = r + RentPrice * min([n2_new, o2]);
                                        n2_new = min([n2_new - min([n2_new, o2]), MaxCarPark]);
                                        
                                        Q_coeff{n1 + 1, n2 + 1, a + MaxCarMove + 1}(sub2ind([MaxCarPark + 1, MaxCarPark + 1], n1_new + 1, n2_new + 1)) = ...
                                            Q_coeff{n1 + 1, n2 + 1, a + MaxCarMove + 1}(sub2ind([MaxCarPark + 1, MaxCarPark + 1], n1_new + 1, n2_new + 1)) + p * gamma;
                                        Q_const(n1 + 1, n2 + 1, a + MaxCarMove + 1) = Q_const(n1 + 1, n2 + 1, a + MaxCarMove + 1) + p * r;
                                    end
                                end
                            end
                        end
                        Q_coeff{n1 + 1, n2 + 1, a + MaxCarMove + 1} = Q_coeff{n1 + 1, n2 + 1, a + MaxCarMove + 1} / P;
                        Q_const(n1 + 1, n2 + 1, a + MaxCarMove + 1) = Q_const(n1 + 1, n2 + 1, a + MaxCarMove + 1) / P;
                    end
                    tElapse = toc(tStart);
                    display(sprintf('Coefficients of Q(%d,%d,:) constructed, elapsed time: %.2fs.', n1, n2, tElapse));
                end
            end
            save(FileName, 'MaxCarPark', 'MaxCarMove', 'ReturnTraffic', 'RentTraffic', 'RentPrice', 'MoveCost', 'gamma', 'PoissRange', 'Q_coeff', 'Q_const');
        case 2
            MaxCarPark = 20;
            MaxCarMove = 5;
            ReturnTraffic = [3, 2];
            RentTraffic = [3, 4];
            RentPrice = 10;
            MoveCost = 2;
            ParkingLotSize = 10;
            ParkingFee = 4;
            gamma = 0.9;
            
            PoissRange = 3;
            Q_coeff = cell([MaxCarPark + 1, MaxCarPark + 1, 2 * MaxCarMove + 1]);
            Q_const = NaN([MaxCarPark + 1, MaxCarPark + 1, 2 * MaxCarMove + 1]);
            P = sum(poisscdf(round(ReturnTraffic(1) * PoissRange), ReturnTraffic(1))) ...
                * sum(poisscdf(round(RentTraffic(1) * PoissRange), RentTraffic(1))) ...
                * sum(poisscdf(round(ReturnTraffic(2) * PoissRange), ReturnTraffic(2))) ...
                * sum(poisscdf(round(RentTraffic(2) * PoissRange), RentTraffic(2)));
            tStart = tic;
            for n1 = 0:MaxCarPark
                for n2 = 0:MaxCarPark
                    for a = max([-n2, -MaxCarPark + n1, -MaxCarMove]):min([n1, MaxCarPark - n2, MaxCarMove])
                        Q_coeff{n1 + 1, n2 + 1, a + MaxCarMove + 1} = zeros(1, (MaxCarPark + 1)^2);
                        Q_const(n1 + 1, n2 + 1, a + MaxCarMove + 1) = 0;
                        n1_night = n1 - a;
                        n2_night = n2 + a;
                        for i1 = 0:round(ReturnTraffic(1) * PoissRange)
                            for o1 = 0:round(RentTraffic(1) * PoissRange)
                                for i2 = 0:round(ReturnTraffic(2) * PoissRange)
                                    for o2 = 0:round(RentTraffic(2) * PoissRange)
                                        p = poisspdf(i1, ReturnTraffic(1)) * poisspdf(o1, RentTraffic(1)) * poisspdf(i2, ReturnTraffic(2)) * poisspdf(o2, RentTraffic(2));
                                        
                                        if a > 0
                                            r = -(a - 1) * MoveCost;
                                        else
                                            r = a * MoveCost;
                                        end
                                        if n1_night > ParkingLotSize
                                            r = r - ParkingFee;
                                        end
                                        if n2_night > ParkingLotSize
                                            r = r - ParkingFee;
                                        end
                                        n1_new = n1_night + i1;
                                        r = r + RentPrice * min([n1_new, o1]);
                                        n1_new = min([n1_new - min([n1_new, o1]), MaxCarPark]);
                                        n2_new = n2_night + i2;
                                        r = r + RentPrice * min([n2_new, o2]);
                                        n2_new = min([n2_new - min([n2_new, o2]), MaxCarPark]);
                                        
                                        Q_coeff{n1 + 1, n2 + 1, a + MaxCarMove + 1}(sub2ind([MaxCarPark + 1, MaxCarPark + 1], n1_new + 1, n2_new + 1)) = ...
                                            Q_coeff{n1 + 1, n2 + 1, a + MaxCarMove + 1}(sub2ind([MaxCarPark + 1, MaxCarPark + 1], n1_new + 1, n2_new + 1)) + p * gamma;
                                        Q_const(n1 + 1, n2 + 1, a + MaxCarMove + 1) = Q_const(n1 + 1, n2 + 1, a + MaxCarMove + 1) + p * r;
                                    end
                                end
                            end
                        end
                        Q_coeff{n1 + 1, n2 + 1, a + MaxCarMove + 1} = Q_coeff{n1 + 1, n2 + 1, a + MaxCarMove + 1} / P;
                        Q_const(n1 + 1, n2 + 1, a + MaxCarMove + 1) = Q_const(n1 + 1, n2 + 1, a + MaxCarMove + 1) / P;
                    end
                    tElapse = toc(tStart);
                    display(sprintf('Coefficients of Q(%d,%d,:) constructed, elapsed time: %.2fs.', n1, n2, tElapse));
                end
            end
            save(FileName, 'MaxCarPark', 'MaxCarMove', 'ReturnTraffic', 'RentTraffic', 'RentPrice', 'MoveCost', 'ParkingLotSize', 'ParkingFee', 'gamma', 'PoissRange', 'Q_coeff', 'Q_const');
    end
end
end