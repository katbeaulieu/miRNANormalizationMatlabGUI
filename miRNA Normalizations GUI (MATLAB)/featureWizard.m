function  together = featureWizard     %eventually will need to have the dataset passed to it

fwFig = figure('position',[400 225 675 450],...
    'Units','normalized','NumberTitle','off',...
    'Name','Feature Wizard',...
    'MenuBar','none','Resize','on',...
    'Renderer','zbuffer',...
    'DockControls','off',...
    'Color',[1 1 1]);


%% First page of wizard
nextButton = uicontrol('Parent',fwFig,'style','pushbutton','Units','pixels','position',[560 15 100 35],...
    'String','Next','callback',@call_nextButton,'Enable','off');
set(nextButton,'Units','normalized');
previewTable = uitable('Parent',fwFig,'Units','pixels','position',[35 100 600 275],...
    'CellSelectionCallback',@(src,evnt)set(src,'UserData',evnt.Indices));
set(previewTable,'Units','normalized');
loadText = uicontrol('Parent',fwFig,'style','text','Units','pixels','position',[35 385 150 30],...
    'String','Please load clinical data','HorizontalAlignment','left','BackgroundColor',...
    [1 1 1],'FontSize',13);
set(loadText,'Units','normalized');
browseButton = uicontrol('Parent',fwFig,'Units','pixels','position',[560 390 100 30],...
    'String','Browse','Style','pushbutton','callback',@call_browseButton);
set(browseButton,'Units','normalized');
setappdata(browseButton,'page',1);


selectTextClass = uicontrol('Parent',fwFig,'style','text','Units','pixels','position',[35 385 450 30],...
    'String','Please select the column heading for the sample names and hit done','HorizontalAlignment',...
    'left','BackgroundColor',[1 1 1],'FontSize',13,'Visible','off');
set(selectTextClass,'Units','normalized');

%% Third page of wizard
finishButton = uicontrol('Parent',fwFig,'style','pushbutton','Units','pixels','position',...
    [560 15 100 35],'String','Finish','callback',@call_finishButton,'Visible','off');
set(finishButton,'Units','normalized');
finalPageText = uicontrol('Parent',fwFig,'Style','text','Units','pixels','position',[35 385 450 30],...
    'String','Please select the column heading the class names and hit done','HorizontalAlignment',...
    'left','BackgroundCOlor',[1 1 1],'FontSize',13,'Visible','off');
set(finalPageText,'Units','normalized');
uiwait

colSample = getappdata(nextButton,'colSample');
colClass = getappdata(nextButton,'colClass');
tbdata = get(previewTable,'data')
colS = tbdata(:,colSample);
colC = tbdata(:,colClass);
together = [colS colC];
assignin('base','together',together);
close(fwFig)


%% call back for finish button
    function call_finishButton(hObject,eventdata,h)
        selection = get(previewTable,'UserData');
        col = selection(1,2);
        setappdata(nextButton,'colClass',col);
        uiresume
        %fill in
    end


%% call back for next button
    function call_nextButton(hObject,eventdata,h)
        set(browseButton,'Visible','off');
        set(loadText,'Visible','off');
        set(selectTextClass,'Visible','on');
        page = getappdata(browseButton,'page')
        if page == 1
            page = page+1;
            setappdata(browseButton,'page',page);
        else
            page = page + 1;
            setappdata(browseButton,'page',page);
            selection = get(previewTable,'UserData');
            col = selection(1,2);
            setappdata(nextButton,'colSample',col);
            set(finishButton,'Visible','on');
            set(selectTextClass,'Visible','off');
            set(finalPageText,'Visible','on');
            set(nextButton,'Visible','off');
            
        end
        %fill in
    end

%% call back for browse button
    function call_browseButton(hObject,eventdata,h)
        [file,dirname]=uigetfile({'*.*'});%{'*.xls';'*.xlsx';'*.tsv';'*.txt';'*.normalized_results';'*.mirna.quantification.txt'});
        if isequal(dirname,0)
            return;
        end
        data = importFeatureWizard(dirname,file);
        assignin('base','data',data);
        set(previewTable,'data',data);
        set(nextButton,'Enable','on');
       
    end




end



