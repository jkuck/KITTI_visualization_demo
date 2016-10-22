function drawBox2D(h,object,color)

% set styles for occlusion and truncation
%occ_col    = {'g','y','r','w'};
trun_style = {'-','--'};

% draw regular objects
if ~strcmp(object.type,'DontCare')
%if ((~strcmp(object.type,'DontCare')) & object.score>2.0)%jdk edit
%  fprintf('Hello! :)\n');
  % show rectangular bounding boxes
  pos = [object.x1,object.y1,object.x2-object.x1+1,object.y2-object.y1+1];
  trc = double(object.truncation>0.1)+1;
%  rectangle('Position',pos,'EdgeColor',occ_col{object.occlusion+1},...
%            'LineWidth',3,'LineStyle',trun_style{trc},'parent',h(1).axes)
  rectangle('Position',pos,'EdgeColor',color,... %jdk edit, remove occlusion colorings
            'LineWidth',3,'LineStyle',trun_style{trc},'parent',h(1).axes) %jdk edit, remove occlusion colorings
  rectangle('Position',pos,'EdgeColor','b', 'parent', h(1).axes)

  % draw label
  label_text = sprintf('%s - %d\n%1.1f rad',object.type,object.id,object.alpha);
  x = (object.x1+object.x2)/2;
  y = object.y1;
%  text(x,max(y-5,40),label_text,'color',occ_col{object.occlusion+1},...
  text(x,max(y-5,40),label_text,'color',color,... %jdk edit, remove occlusion colorings
       'BackgroundColor','k','HorizontalAlignment','center',...
       'VerticalAlignment','bottom','FontWeight','bold',...
       'FontSize',12,'parent',h(1).axes);
     
% draw don't care regions
else
  
  % draw dotted rectangle
  pos = [object.x1,object.y1,object.x2-object.x1+1,object.y2-object.y1+1];
  rectangle('Position',pos,'EdgeColor','c',...
            'LineWidth',2,'LineStyle','-','parent',h(1).axes)
end
