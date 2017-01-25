function map = myColourMap()

%colour map for the categories grades green to red
% red = 1:-1/256:0;
% green = 0:1/256:1;
% blue = zeros(1, length(green));


red = 30/256:1/289:1;
green = 74/256:1/360:1;
blue = 120/256:-1/545:0;
map = [red', green', blue'];