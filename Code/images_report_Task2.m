%Images produced for the report
%bear next to women in a pool -example 1
blending('Images Report/source.jpg','Images Report/target.jpg','Images Report/output_freehand.png',1,false)

%bear next to women in a pool - example 2
blending('Images Report/source.jpg','Images Report/target.jpg','output_rect.png',1,true)

%test localization destination image
blending('Images Report/source.jpg','Images Report/grid.PNG','Images Report/output_testLocalDestination.png',1,false)

%limitation
blending('Images Report/rainbow.jpg','Images Report/sky.jpeg','Images Report/output_limit.png',1,false)