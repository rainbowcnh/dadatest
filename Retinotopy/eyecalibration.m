function eyecalibration(win,gray,white,black)
% function eyecalibration(win,gray,white,black)

% eye tracker calibration Screen
screenRect = Screen('rect',win);
Screen('FillRect',win, gray);
rectw = CenterRect([0 0 12 12], screenRect);
rectb = CenterRect([0 0 8 8], screenRect);
[x y] = ndgrid([-300 0 300],[-225 0 225]);
Screen('TextSize',win,16); 
for i = 1:length(x(:))
	rw = OffsetRect(rectw,x(i),y(i));
	rb = OffsetRect(rectb,x(i),y(i));
	Screen('FillOval',win, white, rw);
	Screen('FillOval',win, black, rb);
	Screen('DrawText',win, num2str(i), rw(1)-10, rw(2)-10, white);
end
Screen('flip',win);
[junk junk2 click] = GetMouse(win); 
while ~any(click)
	[junk junk2 click] = GetMouse(win); 
end