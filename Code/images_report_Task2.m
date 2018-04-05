%Images produced for the report
%bear next to women in a pool -example 1
blending('images/source.jpg','images/target.jpg','images/output_freehand.png',1,false)

%bear next to women in a pool - example 2
blending('images/source.jpg','images/target.jpg','output_rect.png',1,true)

%test localization destination image
blending('images/source.jpg','images/grid.PNG','images/output_testLocalDestination.png',1,false)

%limitation
blending('images/rainbow.jpg','images/sky.jpeg','images/output_limit.png',1,false)