function  newTitles = changeSampleName(sampleTitles,origSamples)
%parameters [first last add]

hFig = figure(...
    'Toolbar','none',...
    'position',[500 400 500 340],...
    'Units','normalized',...
    'NumberTitle','off',...
    'Name','Change Sample Name',...                 %Have the word keep above the test fields, and change it to Preview, reset, changes all the sample names to orginal even in the file
    'MenuBar','none',...
    'Resize','on',...
    'Renderer','zbuffer',...
    'DockControls','off',...
    'Color',[1 1 1]);

keepText = uicontrol('Parent',hFig,'Style','text','Units','pixels','position',[207 280 100 20],'String','Keep: ','FontSize',16,'BackgroundColor',...
    [1 1 1],'HorizontalAlignment','left');
set(keepText,'Units','normalized');
%setappdata(keepText,'original',sampleTitles)
firstText = uicontrol('Parent',hFig,'Style','text','Units','pixels','position',[200 245 50 20],'String','First','FontSize',...
    16,'BackgroundColor',[1 1 1]);
set(firstText,'Units','normalized');
firstTextBox = uicontrol('Parent',hFig,'Style','edit','Units','pixels','position',[280 240 70 30],'BackgroundColor',[1 1 1],...
    'callback',@call_firstText,'HorizontalAlignment','left','FontSize',15);
set(firstTextBox,'Units','normalized');
characterText1 = uicontrol('Parent',hFig,'Style','text','Units','pixels','position',[370 245 100 20],'String','characters',...
    'FontSize',16,'BackgroundColor',[1 1 1]);
set(characterText1,'Units','normalized');
lastText = uicontrol('Parent',hFig,'Style','text','Units','pixels','position',[200 200 50 20],'String','Last','FontSize',...
    16,'BackgroundColor',[1 1 1]);
set(lastText,'Units','normalized');
lastTextBox = uicontrol('Parent',hFig,'Style','edit','Units','pixels','position',[280 195 70 30],'BackgroundColor',[1 1 1],...
    'callback',@call_lastText,'HorizontalAlignment','left','FontSize',15);
set(lastTextBox,'Units','normalized');
characterText2 = uicontrol('Parent',hFig,'Style','text','Units','pixels','position',[370 200 100 20],...
    'String','characters','FontSize',16,'BackgroundColor',[1 1 1]);
set(characterText2,'Units','normalized');
%preview = uicontrol('Parent',hFig,'Style','text','Units','pixels','position',[20 95 170 30],'String',sampleTitle,...
    %'FontSize',13,'HorizontalAlignment','left');
%set(preview,'Units','normalized');
reset = uicontrol('Parent',hFig,'Style','pushbutton','Units','pixels','position',[10 10 120 20],'String','Revert to original names',...
    'callback',@call_reset);
set(reset,'Units','normalized');
apply = uicontrol('Parent',hFig,'Style','pushbutton','Units','pixels','position',[285 35 80 20],'String','Apply',...
    'callback',@call_apply);
set(apply,'Units','normalized');
adder = uicontrol('Parent',hFig,'Style','text','Units','pixels','position',[200 155 50 20],'String','Add',...
    'BackgroundColor',[1 1 1],'FontSize',16);
set(adder,'Units','normalized')
addBox = uicontrol('Parent',hFig,'Style','edit','Units','pixels','position',[280 150 100 30],'BackgroundColor',[1 1 1],...
    'callback',@call_addBox,'HorizontalAlignment','left','FontSize',15);
set(addBox,'Units','normalized')
lb = uicontrol('Parent',hFig,'Style','listbox','Units','pixels','position',[20 75 150 200]);
listboxTitles = [sampleTitles 'All Samples'];
set(lb,'String',listboxTitles)
set(lb,'Max',length(listboxTitles)+1,'Min',0)
set(lb,'Units','normalized');
textSelect = uicontrol('Parent',hFig,'Style','text','Units','pixels','position',[20 280 175 20],'String','Select the titles to rename:',...
    'BackgroundColor',[1 1 1],'HorizontalAlignment','left','FontSize',13);
set(textSelect,'Units','normalized');
finishButton = uicontrol('Parent',hFig,'Style','pushbutton','Units','pixels','position',[415 10 80 20],'String','Finish',...
    'callback',@call_Finish);
set(finishButton,'Units','normalized');
removeText = uicontrol('Parent',hFig,'Style','text','Units','pixels','position',[207 120 100 20],'String','Remove:',...
    'BackgroundColor',[1 1 1],'FontSize',16,'HorizontalAlignment','left');
set(removeText,'Units','normalized');
removeTextBox = uicontrol('Parent',hFig,'Style','edit','Units','pixels','position',[280 80 100 30],'BackgroundColor',[1 1 1],'callback',...
    @call_removeText);
set(removeTextBox,'Units','normalized');



uiwait

newTitles = getappdata(apply,'newTitles');
assignin('base','newTitles',newTitles);
close(hFig)



            
        
     
    
%% Call back for remove text box
    function call_removeText(hObject,eventdata,h)
        val = get(removeTextBox,'String');
        if isempty(val) | isequal(val,'0')
            setappdata(removeText,'remove',0);
            return;
        else
            setappdata(removeText,'remove',val);
        end
    end
    
%% Call back for finish button
    function call_Finish(hObject,eventdata,h)
        if ~isappdata(firstText,'first') && ~isappdata(lastText,'last') && ~isappdata(addBox,'add') && ~isappdata(removeText,'remove')
            setappdata(apply,'newTitles',origSamples)
        end
        uiresume
    end

%% Call back for first text box
    function call_firstText(hObject,eventdata,h)
        
        %selected is a vector of selected indeces
        val = get(firstTextBox,'String')
        if isempty(val) | isequal(val,'0')
            setappdata(firstText,'first',0);
            return;
        else
            val = str2num(val);
            setappdata(firstText,'first',val);
        end
        
        
        
    end
%% Call back for last text box
    function call_lastText(hObject,eventdata,h)
        
        val = get(lastTextBox,'String');
        if isempty(val) | isequal(val,'0')
            setappdata(lastText,'last',0);
            return;
        else
            val = str2num(val)
            setappdata(lastText,'last',val)
        end
    end
%% Call back for add box
    function call_addBox(hObject,eventdata,h)
        val = get(addBox,'String')
        if isempty(val) | isequal(val,'0')
            setappdata(addBox,'add',0)
        else
            setappdata(addBox,'add',val)
        end
    end
            

%% Call back for reset button
    function call_reset(hObject,eventdata,h);
        
        sampleTitles = origSamples;
        set(lb,'String',origSamples)
        if isappdata(firstText,'first')
            rmappdata(firstText,'first')
        end
        if isappdata(lastText,'last')
            rmappdata(lastText,'last')
        end
        if isappdata(addBox,'add')
            rmappdata(addBox,'add')
        end
        set(firstTextBox,'String','');
        set(lastTextBox,'String','');
        set(addBox,'String','');
        set(removeTextBox,'String','');
        
        
        %%%%% THIS IS WHERE YOU STOPPED WORKING %%%%%
        
        %{
        set(preview,'String',sampleTitle);
        setappdata(firstText,'currentTitle','');
        setappdata(lastText,'currentTitle','');
        setappdata(addBox,'currentTitle','');
        
        %}
    end
%% Call back for first Text box
%{
    function call_firstText(hObject,eventdata,h)
        
        val = get(firstTextBox,'String');
        if isempty(val) | isequal(val,'0')
            setappdata(firstText,'first',0);
            return;
        elseif str2num(val) >length(sampleTitle)
            return;
        else
            val = str2num(val);
            setappdata(firstText,'first',val);
            previewTitle = sampleTitle(1:val);
            setappdata(firstText,'currentTitle',previewTitle);
            
        end
        if ~isappdata(lastText,'currentTitle') & ~isappdata(addBox,'currentTitle')
            set(preview,'String',previewTitle);
        elseif isappdata(lastText,'currentTitle') & ~isappdata(addBox,'currentTitle')
            current = getappdata(lastText,'currentTitle');
            total = [previewTitle current];
            set(preview,'String',total);
        elseif isappdata(addBox,'currentTitle') & ~isappdata(lastText,'currentTitle')
            current = getappdata(addBox,'currentTitle');
            total = [previewTitle current];
            set(preview,'String',total);
        else
            current1 = getappdata(lastText,'currentTitle');
            current2 = getappdata(addBox,'currentTitle');
            total = [previewTitle current1 current2];
            set(preview,'String',total);
        end
        
        %fill in
    end
%}
%% Call back for last Text box
%{
    function call_lastText(hObject,eventdata,h)
        
        val = get(lastTextBox,'String');
        if isempty(val) | isequal(val,'0')
            setappdata(lastText,'last',0);
            return;
        elseif str2num(val) > length(sampleTitle)
            return;
        else
            val = str2num(val);
            setappdata(lastText,'last',val);
            previewTitle = sampleTitle(length(sampleTitle)-val+1:end);
            setappdata(lastText,'currentTitle',previewTitle);
            
        end
        
        if ~isappdata(firstText,'currentTitle') & ~isappdata(addBox,'currentTitle')
            set(preview,'String',previewTitle);
        elseif isappdata(firstText,'currentTitle') & ~isappdata(addBox,'currentTitle')
            current = getappdata(firstText,'currentTitle');
            total = [current previewTitle];
            set(preview,'String',total);
        elseif isappdata(addBox,'currentTitle') & ~isappdata(firstText,'currentTitle')
            current = getappdata(addBox,'currentTitle');
            total = [previewTitle current];
            set(preview,'String',total);
        else
            current1 = getappdata(firstText,'currentTitle');
            current2 = getappdata(addBox,'currentTile');
            total = [current1 previewTitle current2];
            set(preview,'String',total);
        end
            
        
            
        %fill in
    end
%}
%% Call back for add Text Box
%{
    function call_addBox(hObject,eventdata,h)
        
        chars = get(addBox,'String');
        if isempty(chars) | isequal(chars,'0')
            setappdata(addBox,'add',0);
            return;
        else
            setappdata(addBox,'add',chars);
            previewTitle = chars;
            setappdata(addBox,'currentTitle',previewTitle);
            
        end
            
        if ~isappdata(lastText,'currentTitle') & ~isappdata(firstText,'currentTitle')
            total = [sampleTitle previewTitle]
            set(preview,'String',total);
        elseif isappdata(lastText,'currentTitle') & ~isappdata(firstText,'currentTitle')
            current = getappdata(lastText,'currentTitle');
            total = [current previewTitle];
            set(preview,'String',total);
        elseif isappdata(firstText,'currentTitle') & ~isappdata(lastText,'currentTitle')
            current = getappdata(firstText,'currentTitle');
            total = [current previewTitle];
            set(preview,'String',total);
        else
            current1 = getappdata(firstText,'currentTitle');
            current2 = getappdata(lastText,'currentTitle');
            total = [current1 current2 previewTitle];
            set(preview,'String',total);
        end
        
        %fill in
    end
%}

%% Call back for apply button
    function call_apply(hObject,eventdata,h)
        contents = cellstr(get(lb,'String')); %returns listbox1 contents as cell array
        selected = get(lb,'Value'); %returns selected item from listbox1
        class(selected)
        if any((length(sampleTitles)+1)==selected)
            selected = [];
            for i = 1:length(sampleTitles)
                selected = [selected i];
            end
        end
        selected
        if isappdata(firstText,'first')
            firstChars = getappdata(firstText,'first');
        else
            firstChars = 0;
        end
        if isappdata(lastText,'last')
            lastChars = getappdata(lastText,'last');
        else
            lastChars = 0;
        end
        if isappdata(addBox,'add')
            addChars = getappdata(addBox,'add');
        else
            addChars = '';
        end
        if isappdata(removeText,'remove')
            removeChars = getappdata(removeText,'remove');
        else
            removeChars = '';
        end
        
        if firstChars == 0 && lastChars == 0 && isequal(addChars,'') && isequal(removeChars,'')
            setappdata(apply,'newTitles',sampleTitles)
        else
            for i =1:length(selected)
                name = sampleTitles(selected(i));
                name = char(name);
                if ~isequal(removeChars,'')
                    k = strfind(name,removeChars);
                    
                    if k ~= 1
                        name(k:length(removeChars)+k-1) = '';
                        
                    elseif isequal(k, []);
                        name = name;
                    else
                        name(k:length(removeChars)) = '';
                        
                    end
                    
                end
                   
                if ~isequal(firstChars,0)
                    firstChunk = name(1:firstChars);
                else
                    firstChunk = '';
                end
                if ~isequal(lastChars,0)
                    lastChunk = name(length(name)-lastChars+1:end);
                else
                    lastChunk = '';
                end
%                 if isequal(firstChunk,'') && isequal(lastChunk,'') && isequal(addChars,'')
%                     name = cellstr(name);
%                     sampleTitles(selected(i)) = name;
%                 end
                if isequal(firstChunk,'') && isequal(lastChunk,'') && ~isequal(addChars,'')
                    final = [name addChars];
                    final = cellstr(final);
                    sampleTitles(selected(i)) = final;
                elseif isequal(firstChunk,'') && isequal(lastChunk,'') && isequal(addChars,'')
                    name = cellstr(name);
                    sampleTitles(selected(i)) = name;
                else
                    final = [firstChunk lastChunk addChars];
                    final = cellstr(final);
                    sampleTitles(selected(i)) = final;
                end
                %mutiple possibilities
                %need to figure out which ones are appropriate
                
                
            end
            samplesChanged = sampleTitles;
            set(lb,'String',[samplesChanged 'All Samples']);
            
            setappdata(apply,'newTitles',samplesChanged);
            samplesChanged
        end
        
            
        
        %This is going to go in the finish button now.
        %uiresume
        
    end
        
        

end




    

