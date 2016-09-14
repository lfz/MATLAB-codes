function Map = PlotMap(Map)
MapImage = ones(Map.MaxHeight, Map.MaxWidth);
MapImage(1, Map.RowSpan(1, 1):Map.RowSpan(1, 2)) = 0.6;
for Row = 2:Map.MaxHeight
    MapImage(Row, Map.RowSpan(Row, 1):Map.RowSpan(Row, 2)) = 0.8;
end
MapImage(Map.FinishLine(1):Map.FinishLine(2), Map.MaxWidth) = 0.6;
hFig = figure('Position', [300 200 400 500]);
imagesc(MapImage);
caxis([0, 1]); colormap('gray');
axis('equal'); axis('off');
set(gca, 'YDir', 'normal');
Map.MapImage = MapImage;
Map.FigHandle = hFig;
end