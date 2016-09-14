function Map = GenerateMap(SimID)
switch SimID
    case 1
        MaxHeight = 32;
        RowSpan = zeros(MaxHeight, 2);
        RowSpan(1:3, :) = repmat([4, 9], [3, 1]);
        RowSpan(4:10, :) = repmat([3, 9], [7, 1]);
        RowSpan(11:18, :) = repmat([2, 9], [8, 1]);
        RowSpan(19:25, :) = repmat([1, 9], [7, 1]);
        RowSpan(26, :) = [1, 10];
        RowSpan(27:28, :) = repmat([1, 17], [2, 1]);
        RowSpan(29, :) = [2, 17];
        RowSpan(30:31, :) = repmat([3, 17], [2, 1]);
        RowSpan(32, :) = [4, 17];
        MaxWidth = max(RowSpan(:, 2));
        FinishLine = [27, 32];
    case 2
        MaxHeight = 30;
        RowSpan = zeros(MaxHeight, 2);
        RowSpan(1:3, :) = repmat([1, 23], [3, 1]);
        RowSpan(4:17, 1) = 2:15;
        RowSpan(4:17, 2) = 23;
        RowSpan(18:21, 1) = 15;
        RowSpan(18, 2) = 24;
        RowSpan(19, 2) = 26;
        RowSpan(20, 2) = 27;
        RowSpan(21, 2) = 30;
        RowSpan(22:24, 1) = 14:-1:12;
        RowSpan(25:27, 1) = 12;
        RowSpan(28:30, 1) = [13, 14, 17];
        RowSpan(22:30, 2) = 32;
        MaxWidth = max(RowSpan(:, 2));
        FinishLine = [22, 30];
end
Map = struct('MaxHeight', MaxHeight, 'MaxWidth', MaxWidth, 'FinishLine', FinishLine, 'RowSpan', RowSpan);
end