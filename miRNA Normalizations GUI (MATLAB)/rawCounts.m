function rawCounts(data,varargin)

% load the data on the graph with quantile default of 1
% add the second option from y menus and make it negative to all menus
% add -10 and +10 to x axis, change xlimit
% clear button, rename to hide quantile, make it a toggle button, has two
% stages, show or hide
% for boxplot, as soon as the boxplot is loaded, load with actual sample
% names
% make listbox smaller and explain with a heading: Show boxplot for indv
% smaples, hold control and shift to select multiple
% add a line in the listbox with an option for all samples, make it the
% first line
len = length(varargin)
%possible lengths are 1 or 3
if len == 1
    technique = varargin{1};
elseif len == 3
    technique = varargin{1};
    numiRNA = (varargin{2});
    orig = (varargin{3});
end
    


numTabs = 2;
    tabLabels = {'General Stats';'Boxplot'};
    if size(tabLabels,1) ~= numTabs
        uiwait(errordlg('Number of tabs and tab labels must be the same','Setup Error','modal'));
        return;
    end
    set(0,'Units','pixels')
    %screenSize = get(0,'ScreenSize');
    %MaxMonitorX = screenSize(3);
    %MaxMonitorY = screenSize(4);
    MaxMonitorX = 1400;
    MaxMonitorY = 900;
    
    %Set the figure window size values
    MainFigScale = .6;          % Change this value to adjust the figure size
    MaxWindowX = round(MaxMonitorX*MainFigScale)-50;
    MaxWindowY = round(MaxMonitorY*MainFigScale)-20;
    XBorder = (MaxMonitorX-MaxWindowX)/2+50;
    YBorder = (MaxMonitorY-MaxWindowY)/2+50;
    TabOffset = 0;              % This value offsets the tabs inside the figure.
    ButtonHeight = 40;
    PanelWidth = MaxWindowX-2*TabOffset+4;
    PanelHeight = MaxWindowY-ButtonHeight-2*TabOffset;
    ButtonWidth = round((PanelWidth-numTabs)/numTabs);
    
    white = [1 1 1];
    BGColor = 0.9*white;
    
    hTabFig = figure(...
            'Toolbar', 'none',...
            'Position',[ XBorder, YBorder, MaxWindowX, MaxWindowY ],... % XBorder, YBorder, MaxWindowX, MaxWindowY 
            'Units','normalized',...
            'NumberTitle', 'off',...
            'Name', 'Raw Counts',...
            'MenuBar', 'none',...
            'Resize', 'on',...
            'Renderer','zbuffer',... %this is so that when you plot a bar graph, the lines dont go over when you zoom in
            'DockControls', 'off',...
            'Color', white);
    
        
        %   Define a cell array for panel and pushbutton handles, pushbuttons labels and other data
    %   rows are for each tab + two additional rows for other data
    %   columns are uipanel handles, selection pushbutton handles, and tab label strings - 3 columns.
            TabHandles = cell(numTabs,3);
            TabHandles(:,3) = tabLabels(:,1);
    %   Add additional rows for other data
            TabHandles{numTabs+1,1} = hTabFig;         % Main figure handle
            TabHandles{numTabs+1,2} = PanelWidth;      % Width of tab panel
            TabHandles{numTabs+1,3} = PanelHeight;     % Height of tab panel
            TabHandles{numTabs+2,1} = 0;               % Handle to default tab 2 content(set later)
            TabHandles{numTabs+2,2} = white;           % Selected tab Color
            TabHandles{numTabs+2,3} = BGColor;         % Background color
            
            
            %   Build the Tabs
        for TabNumber = 1:numTabs
        % create a UIPanel   
            TabHandles{TabNumber,1} = uipanel('Units', 'pixels', ...
                'Visible', 'off', ...
                'Backgroundcolor', white, ...
                'BorderWidth',1, ...
                'Position', [TabOffset TabOffset ...
                PanelWidth PanelHeight]);

        % create a selection pushbutton
            TabHandles{TabNumber,2} = uicontrol('Style', 'pushbutton',...
                'Units', 'pixels', ...
                'BackgroundColor', BGColor, ...
                'Position', [TabOffset+(TabNumber-1)*ButtonWidth PanelHeight+TabOffset...
                    ButtonWidth ButtonHeight], ...          
                'String', TabHandles{TabNumber,3},...
                'HorizontalAlignment', 'center',...
                'FontName', 'arial',...
                'FontWeight', 'bold',...
                'FontSize', 10,...
                'Units','normalized');

        end
        set(TabHandles{1,1},'Units','normalized')
        set(TabHandles{2,1},'Units','normalized')
        set(TabHandles{3,1},'Units','normalized')
       

  
    %%  Tab 1 Layout
    
    
        %%%%%%%%STOP %%%%%%% Bring changes over to filteredCounts and
        %%%%%%%%normalizedCounts
        totalsAxes = axes('Parent',TabHandles{1,1},'Units','pixels','position',[40 185 215 225],'Tag','totalsAxes');
        set(totalsAxes,'Units','normalized')
        dcm = datacursormode(hTabFig);
        datacursormode on;
        set(dcm, 'updatefcn',@myfunction);
        quantileAxes = axes('Parent',TabHandles{1,1},'Units','pixels','position',[300 185 215 225],'Tag','quantileAxes');
        set(quantileAxes,'Units','normalized');
        nonZeroAxes = axes('Parent',TabHandles{1,1},'Units','pixels','position',[550 185 215 225],'Tag','nonZeroAxes');
        set(nonZeroAxes,'Units','normalized');
        titleTotal = uicontrol('Parent',TabHandles{1,1},'Units','pixels','position',[40 430 100 20],'Style','text','String','Totals',...
            'BackgroundColor',[1 1 1],'HorizontalAlignment','left','FontSize',13);
        set(titleTotal,'Units','normalized');
        titleQuantile = uicontrol('Parent',TabHandles{1,1},'Units','pixels','position',[300 430 150 20],'Style','text','String',...
            'Interquantile Range','BackgroundColor',[1 1 1],'HorizontalAlignment','left','FontSize',13);
        set(titleQuantile,'Units','normalized');
        titleNonZero = uicontrol('Parent',TabHandles{1,1},'Units','pixels','position',[550 430 175 20],'Style','text','String',...
            'Number of miRNA above 0','BackgroundColor',[1 1 1],'HorizontalAlignment','left','FontSize',13);
        set(titleNonZero,'Units','normalized');
        menuStrings = {'1','2.5','5','25','50','75','95','97.5','99'};
        quantileMenu1 = uicontrol('Parent',TabHandles{1,1},'Units','pixels','position',[100 115 75 30],'Style','popupmenu',...
            'String',menuStrings,'callback',@callback_quantileMenu1);
        set(quantileMenu1,'Units','normalized');
        quantileMenu2 = uicontrol('Parent',TabHandles{1,1},'Units','pixels','position',[360 115 75 30],'Style','popupmenu',...
            'String',menuStrings,'callback',@callback_quantileMenu2);
        set(quantileMenu2,'Units','normalized');
        quantileMenu3 = uicontrol('Parent',TabHandles{1,1},'Units','pixels','position',[615 115 75 30],'Style','popupmenu',...
            'String',menuStrings,'callback',@callback_quantileMenu3);
        set(quantileMenu3,'Units','normalized');
        showString1 = uicontrol('Parent',TabHandles{1,1},'Units','pixels','position',[40 125 50 20],'Style','text',...
            'String','Showing','BackgroundColor',[1 1 1],'HorizontalAlignment','left','FontSize',13);
        set(showString1,'Units','normalized');
        showString2 = uicontrol('Parent',TabHandles{1,1},'Units','pixels','position',[300 125 50 20],'Style','text',...
            'String','Showing','BackgroundColor',[1 1 1],'HorizontalAlignment','left','FontSize',13);
        set(showString2,'Units','normalized');
        showString3 = uicontrol('Parent',TabHandles{1,1},'Units','pixels','position',[555 125 50 20],'Style','text',...
            'String','Showing','BackgroundColor',[1 1 1],'HorizontalAlignment','left','FontSize',13);
        set(showString3,'Units','normalized');
        quantileString1 = uicontrol('Parent',TabHandles{1,1},'Units','pixels','position',[185 125 75 20],'Style','text',...
            'String','quantile','BackgroundColor',[1 1 1],'HorizontalAlignment','left','FontSize',13);
        set(quantileString1,'Units','normalized')
        quantileString2 = uicontrol('Parent',TabHandles{1,1},'Units','pixels','position',[440 125 75 20],'Style','text',...
            'String','quantile','BackgroundColor',[1 1 1],'HorizontalAlignment','left','FontSize',13);
        set(quantileString2,'Units','normalized');
        quantileString3 = uicontrol('Parent',TabHandles{1,1},'Units','pixels','position',[700 125 75 20],'Style','text',...
            'String','quantile','BackgroundColor',[1 1 1],'HorizontalAlignment','left','FontSize',13);
        set(quantileString3,'Units','normalized');
        minTotalMenu = uicontrol('Parent',TabHandles{1,1},'Units','pixels','position',[135 80 75 20],'Style','popupmenu','String','Menu',...
            'callback',@call_minTotalMenu);
        set(minTotalMenu,'Units','normalized');
        maxTotalMenu = uicontrol('Parent',TabHandles{1,1},'Units','pixels','position',[135 50 75 20],'Style','popupmenu','String','Menu',...
            'callback',@call_maxTotalMenu);
        set(maxTotalMenu,'Units','normalized');
        minIQRMenu = uicontrol('Parent',TabHandles{1,1},'Units','pixels','position',[395 80 75 20],'Style','popupmenu','String','Menu',...
            'callback',@call_minIQRMenu);
        set(minIQRMenu,'Units','normalized');
        maxIQRMenu = uicontrol('Parent',TabHandles{1,1},'Units','pixels','position',[395 50 75 20],'Style','popupmenu','String','Menu',...
            'callback',@call_maxIQRMenu);
        set(maxIQRMenu,'Units','normalized');
        minNonZeroMenu = uicontrol('Parent',TabHandles{1,1},'Units','pixels','position',[650 80 75 20],'Style','popupmenu','String','Menu',...
            'callback',@callback_minNonZeroMenu);
        set(minNonZeroMenu,'Units','normalized');
        maxNonZeroMenu = uicontrol('Parent',TabHandles{1,1},'Units','pixels','position',[650 50 75 20],'Style','popupmenu',...
            'String','Menu','callback',@callback_maxNonZeroMenu);
        set(maxNonZeroMenu,'Units','normalized');
        minNonZeroText = uicontrol('Parent',TabHandles{1,1},'Units','pixels','position',[565 80 75 20],'Style','text','String',...
            'Min Y Value','BackgroundColor',[1 1 1],'FontSize',13,'HorizontalAlignment','left');
        set(minNonZeroText,'Units','normalized');
        maxNonZeroText = uicontrol('Parent',TabHandles{1,1},'Units','pixels','position',[565 50 75 20],'Style','text','String',...
            'Max Y Value','BackgroundColor',[1 1 1],'FontSize',13,'HorizontalAlignment','left');
        set(maxNonZeroText,'Units','normalized');
        minTotalText = uicontrol('Parent',TabHandles{1,1},'Units','pixels','position',[50 80 75 20],'Style','text','String',...
            'Min Y Value','BackgroundColor',[1 1 1],'FontSize',13,'HorizontalAlignment','left');
        set(minTotalText,'Units','normalized');
        maxTotalText = uicontrol('Parent',TabHandles{1,1},'Units','pixels','position',[50 50 80 20],'Style','text','String',...
            'Max Y Value','BackgroundColor',[1 1 1],'FontSize',13,'HorizontalAlignment','left');
        set(maxTotalText,'Units','normalized');
        minIQRText = uicontrol('Parent',TabHandles{1,1},'Units','pixels','position',[310 80 75 20],'Style','text','String',...
            'Min Y Value','BackgroundColor',[1 1 1],'FontSize',13,'HorizontalAlignment','left');
        set(minIQRText,'Units','normalized');
        maxIQRText = uicontrol('Parent',TabHandles{1,1},'Units','pixels','position',[310 50 75 20],'Style','text','String',...
            'Max Y Value','BackgroundColor',[1 1 1],'FontSize',13,'HorizontalAlignment','left');
        set(maxIQRText,'Units','normalized');
        %saveGraph = uicontrol('Parent',TabHandles{1,1},'Units','pixels','position',[670 10 100 20],'Style','pushbutton',...
         %   'String','Save Graphs','BackgroundColor',[0.4 0.4 1],'callback',@saveGraphs);
        %set(saveGraph,'Units','normalized');
        aboveText = uicontrol('Parent',TabHandles{1,1},'Units','pixels','position',[555 103 50 20],'Style','text',...
            'BackgroundColor',[1 1 1],'HorizontalAlignment','left','String','Above:','FontSize',12);
        set(aboveText,'Units','normalized');
        changeAboveString = uicontrol('Parent',TabHandles{1,1},'Units','pixels','position',[600 103 100 20],'Style','text',...
            'BackgroundColor',[1 1 1],'HorizontalAlignment','left','String','','FontSize',12);
        set(changeAboveString,'Units','normalized');
        belowText = uicontrol('Parent',TabHandles{1,1},'Units','pixels','position',[655 103 50 20],'Style','text',...
            'BackgroundColor',[1 1 1],'HorizontalAlignment','left','String','Below:','FontSize',12);
        set(belowText,'Units','normalized');
        changeBelowString = uicontrol('Parent',TabHandles{1,1},'Units','pixels','position',[700 103 70 20],'Style','text',...
            'BackgroundColor',[1 1 1],'HorizontalAlignment','left','String','','FontSize',12);
        set(changeBelowString,'Units','normalized');
        export1 = uicontrol('Parent',TabHandles{1,1},'Units','pixels','position',[70 15 100 20],'Style','pushbutton',...
            'String','Export','BackgroundColor',[0.4 0.4 1],'callback',@call_export1);
        set(export1,'Units','normalized');
        export2 = uicontrol('Parent',TabHandles{1,1},'Units','pixels','position',[335 15 100 20],'Style','pushbutton',...
            'String','Export','BackgroundColor',[0.4 0.4 1],'callback',@call_export2);
        set(export2,'Units','normalized');
        export3 = uicontrol('Parent',TabHandles{1,1},'Units','pixels','position',[595 15 100 20],'Style','pushbutton',....
            'String','Export','BackgroundColor',[0.4 0.4 1],'callback',@call_export3);
        set(export3,'Units','normalized');

        
        plotData = cell2mat(data(2:end,2:end));
        
        sums = [];
        sums = nansum(plotData,1);
        assignin('base','plotData',plotData);
        assignin('base','sums',sums);
        x = [];
        for i = 1:size(plotData,2)
            x(i) = i;
        end
      
        axes(totalsAxes)
        a = scatter(x,sums,'filled');
        xlabel(totalsAxes,'Samples');
        scale = get(totalsAxes,'XTick');
        scaleY = get(totalsAxes,'YTick');
        
        
        getylim = ylim;
        getxlim = xlim; %fine
        addY1 = scaleY(2)-scaleY(1);
        add1 = (scale(2) - scale(1))*0.5; %fine
        
        
        axes(totalsAxes)
        xlim([-add1 getxlim(2)+add1]); %fine

        hold on;
       
        possibilities = 10;
        gap = (getylim(2)-getylim(1))/possibilities;
        strings = []; %going to have to convert the nums to strings at some point
        currentSel = getylim(1);
        while currentSel <= getylim(2)
            strings = [strings currentSel];
            currentSel = currentSel + gap;
        end
        
        
        lenStr = length(strings)
        stringsMin = strings(1:(lenStr-1));
        stringsMin = [getylim(1)-addY1 stringsMin]; %leave for now
        stringsMax = strings(2:lenStr);
        stringsMax = [stringsMax getylim(2)+addY1];
        set(minTotalMenu,'String',stringsMin);
        set(maxTotalMenu,'String',stringsMax);
        set(minTotalMenu,'Value',2);
        set(maxTotalMenu,'Value',length(stringsMax)-1);
        set(changeAboveString,'String',['0/' num2str(size(plotData,1))]);
        set(changeBelowString,'String',['0/' num2str(size(plotData,1))]);
            
        %graph 2
        
        secondGraphData = iqr(plotData);
        axes(quantileAxes);
        b = scatter(x,secondGraphData,'filled');
        xlabel(quantileAxes,'Samples');
        getylim2 = ylim;
        getxlim2 = xlim;
        scale = get(quantileAxes,'XTick');
        scaleY = get(quantileAxes,'YTick');
        addY2 = scaleY(2) - scaleY(1);
        add2 = (scale(2)-scale(1))*0.5;
        xlim([-add2 getxlim2(2)+add2]);
        
        
        
        hold on;
        
        possibilities = 10;
        gap = (getylim2(2)-getylim2(1))/possibilities;
        strings = [getylim2(1)];
        currentSel = getylim2(1);
        while currentSel <= getylim2(2)
            currentSel = currentSel + gap;
           
            strings = [strings currentSel];
            
        end
        
        lenStr = length(strings);
        stringsMin = strings(1:(lenStr-1));
        stringsMin = [getylim2(1)-addY2 stringsMin];
        stringsMax = strings(2:lenStr);
        stringsMax = [stringsMax getylim2(2)+ addY2];
        set(minIQRMenu,'String',stringsMin);
        set(maxIQRMenu,'String',stringsMax);
        set(minIQRMenu,'Value',2);
        set(maxIQRMenu,'Value',length(stringsMax)-1);
        
        
        
        
        %graph 3
        
        samples = [];
        for c = 1:size(plotData,2)
            aboveZeroCounts = 0;
            for r = 1:size(plotData,1)
                if plotData(r,c) ~= 0
                    aboveZeroCounts = aboveZeroCounts+1;
                end
            end
            samples = [samples aboveZeroCounts];
        end
        axes(nonZeroAxes)
        c = scatter(x,samples,'filled');
        xlabel(nonZeroAxes,'Samples');
        getylim3 = ylim;
        getxlim3 = xlim;
        scale = get(nonZeroAxes,'XTick');
        scaleY = get(nonZeroAxes,'YTick');
        addY3 = scaleY(2)-scaleY(1);
        add3 = (scale(2)-scale(1))*0.5;
        xlim([-add3 getxlim3(2)+add3]);
        
        hold on;
        
        possibilities = 10;
        gap = (getylim3(2)-getylim3(1))/possibilities;
        strings = [];
        currentSel = getylim3(1);
        while currentSel <= getylim3(2)
            strings = [strings currentSel];
            currentSel = currentSel + gap;
        end
        
        lenStr = length(strings);
        stringsMin = strings(1:lenStr-1);
        stringsMin = [getylim3(1)-addY3 stringsMin];
        stringsMax = strings(2:lenStr);
        stringsMax = [stringsMax getylim3(2) + addY3];
        set(minNonZeroMenu,'String',stringsMin);
        set(maxNonZeroMenu,'String',stringsMax);
        set(minNonZeroMenu,'Value',2);
        set(maxNonZeroMenu,'Value',length(stringsMax)-1);
        
        axes(totalsAxes) 
        val = 1;
        cutoff = quantile(sums,(val)/100);
        phl = plot([getxlim(1)-add1 getxlim(2)+add1],[cutoff cutoff]);
        set(phl,'Color','m','LineStyle','--','LineWidth',1.25);
        setappdata(quantileMenu1,'keepLine',phl);
        delete(a);
        a = scatter(x,sums,'filled','MarkerFaceColor','b');
        setappdata(quantileMenu1,'scatterData',a);
        axes(quantileAxes)
        cutoff = quantile(secondGraphData,(val)/100);
        phl = plot([getxlim2(1)-add2 getxlim(2)+add2],[cutoff cutoff]);
        set(phl,'Color','m','LineStyle','--','LineWidth',1.25);
        setappdata(quantileMenu2,'keepLine',phl);
        delete(b);
        b = scatter(x,secondGraphData,'filled','MarkerFaceColor','b');
        setappdata(quantileMenu2,'scatterData',b);
        axes(nonZeroAxes)
        cutoff = quantile(samples,(val)/100);
        phl = plot([getxlim3(1)-add3 getxlim3(2)+add2],[cutoff cutoff]);
        set(phl,'Color','m','LineStyle','--','LineWidth',1.25);
        setappdata(quantileMenu3,'keepLine',phl);
        delete(c)
        c = scatter(x,samples,'filled','MarkerFaceColor','b');
        setappdata(quantileMenu3,'scatterData',c);
        
        
        
  
        
     %% Tab 2 Layout - Box plot
       %change this on every other gui
    boxplotAxes = axes('Parent',TabHandles{2,1},'Units','pixels','position',[30 70 575 300]);
    set(boxplotAxes,'Units','normalized')
    lb = uicontrol('Parent',TabHandles{2,1},'Units','pixels','position',[625 210 150 150],'Style','listbox','String','','Value',1);
    set(lb,'Units','normalized')
    graphButton = uicontrol('Parent',TabHandles{2,1},'Units','pixels','position',[655 170 100 20],'Style','pushbutton','String','Plot Selected',...
        'callback',@call_graphButton);
    set(graphButton,'Units','normalized');
    boxPlotText = uicontrol('Parent',TabHandles{2,1},'Units','pixels','Style','text','position',[310 375 100 20],'String','Box Plot',...
        'FontSize',13,'FontWeight','bold','BackgroundColor',[1 1 1]);
    set(boxPlotText,'Units','normalized');
    minY = uicontrol('Parent',TabHandles{2,1},'Units','pixels','position',[120 435 75 20],'Style','popupmenu','String','Menu',...
        'callback',@call_minY);
    set(minY,'Units','normalized');
    maxY = uicontrol('Parent',TabHandles{2,1},'Units','pixels','position',[120 405 75 20],'Style','popupmenu','String','Menu',...
        'callback',@call_maxY);
    set(maxY,'Units','normalized');
    minYtext = uicontrol('Parent',TabHandles{2,1},'Units','pixels','position',[65 432.5 50 20],'Style','text','String','Min Y',...
        'FontSize',13,'HorizontalAlignment','left','BackgroundColor',[1 1 1],'callback',@call_minY);
    set(minYtext,'Units','normalized');
    maxYtext = uicontrol('Parent',TabHandles{2,1},'Units','pixels','position',[65 402.5 50 20],'Style','text','String','Max Y',...
        'FontSize',13,'HorizontalAlignment','left','BackgroundColor',[1 1 1],'callback',@call_minX);
    set(maxYtext,'Units','normalized');
    normalizedWithText = uicontrol('Parent',TabHandles{2,1},'Units','pixels','position',[400 432 120 20],'Style','text','String',...
        'Normalized with: ', 'FontSize',13,'HorizontalAlignment','left','BackgroundColor',[1 1 1],'Visible','off');
    set(normalizedWithText,'Units','normalized');
    normalChangeText = uicontrol('Parent',TabHandles{2,1},'Units','pixels','position',[505 432 130 20],'Style','text','String',...
        'Upper Quantile','BackgroundColor',[1 1 1],'HorizontalAlignment','left','FontSize',13,'Visible','off');
    set(normalChangeText,'Units','normalized');
    numiRNAText = uicontrol('Parent',TabHandles{2,1},'Units','pixels','position',[400 415 200 20],'Style','text','String',...
        'Number of miRNAs remaining: ','FontSize',13','HorizontalAlignment','left','BackgroundColor',[1 1 1],'Visible','off');
    set(numiRNAText,'Units','normalized');
    changemiRNA = uicontrol('Parent',TabHandles{2,1},'Units','pixels','position',[585 415 100 20],'Style','text','String',...
        '','FontSize',13,'BackgroundColor',[1 1 1],'HorizontalAlignment','left','BackgroundColor',[1 1 1],'Visible','off');
    set(changemiRNA,'Units','normalized');
    exportButton = uicontrol('Parent',TabHandles{2,1},'Units','pixels','position',[675 20 100 30],'Style','pushbutton','String',...
        'Export figure','callback',@call_export);
    set(exportButton,'Units','normalized');
    medianDev = uicontrol('Parent',TabHandles{2,1},'Units','pixels','position',[420 400 150 20],'Style','text','String',...
        'Median Dev: ', 'FontSize',13,'BackgroundColor',[1 1 1],'HorizontalAlignment','left');
    medianDevtext = uicontrol('Parent',TabHandles{2,1},'Units','pixels','position',[510 400 100 20],'Style','text','String',...
        '','FontSize',13,'BackgroundColor',[1 1 1],'HorizontalAlignment','left');
    medUpperQuantile = uicontrol('Parent',TabHandles{2,1},'Units','pixels','position',[600 400 150 20],'Style','text','String',...
        'UpQuan Dev: ', 'FontSize',13,'BackgroundColor',[1 1 1],'HorizontalAlignment','left');
    medUpperQuantiletext = uicontrol('Parent',TabHandles{2,1},'Units','pixels','position',[680 400 100 20],'Style','text','String',...
        '','FontSize',13,'BackgroundColor',[1 1 1],'HorizontalAlignment','left');
    medLowQuantile = uicontrol('Parent',TabHandles{2,1},'Units','pixels','position',[250 400 150 20],'Style','text','String',...
        'LowQuan Dev: ', 'FontSize',13,'BackgroundColor',[1 1 1],'HorizontalAlignment','left');
    medLowQuantiletext = uicontrol('Parent',TabHandles{2,1},'Units','pixels','position',[340 400 75 20],'Style','text','String',...
        '','FontSize',13,'BackgroundColor',[1 1 1],'HorizontalAlignment','left');
    
    meanDev = uicontrol('Parent',TabHandles{2,1},'Units','pixels','position',[420 375 150 20],'Style','text','String',...
        'Mean Dev: ', 'FontSize',13,'BackgroundColor',[1 1 1],'HorizontalAlignment','left');
    meanDevtext = uicontrol('Parent',TabHandles{2,1},'Units','pixels','position',[510 375 100 20],'Style','text','String',...
        '','FontSize',13,'BackgroundColor',[1 1 1],'HorizontalAlignment','left');
    meanUpperQuantile = uicontrol('Parent',TabHandles{2,1},'Units','pixels','position',[600 375 150 20],'Style','text','String',...
        'UpMean Dev: ', 'FontSize',13,'BackgroundColor',[1 1 1],'HorizontalAlignment','left');
    meanUpperQuantiletext = uicontrol('Parent',TabHandles{2,1},'Units','pixels','position',[680 375 100 20],'Style','text','String',...
        '','FontSize',13,'BackgroundColor',[1 1 1],'HorizontalAlignment','left');
    meanLowQuantile = uicontrol('Parent',TabHandles{2,1},'Units','pixels','position',[250 445 150 20],'Style','text','String',...
        'LowMean Dev: ', 'FontSize',13,'BackgroundColor',[1 1 1],'HorizontalAlignment','left');
    meanLowQuantiletext = uicontrol('Parent',TabHandles{2,1},'Units','pixels','position',[340 455 75 20],'Style','text','String',...
        '','FontSize',13,'BackgroundColor',[1 1 1],'HorizontalAlignment','left');
    
    
    increments = {'20','15','10','5','0','-5','-10','-15','-20','-25','-30'};
    set(minY,'String',increments);
    set(maxY,'String',increments);
    set(minY,'Value',5);
    set(maxY,'Value',5);
    
    
    
    
    
    if exist('technique') == 1 && exist('numiRNA') == 1 && exist('orig') == 1
        
        set(normalChangeText,'String',technique);
        set(normalChangeText,'Visible','on');
        set(changemiRNA,'String',[num2str(numiRNA) '/' num2str(orig)]);
        set(changemiRNA,'Visible','on');
        set(normalizedWithText,'Visible','on');
        set(numiRNAText,'Visible','on');
    elseif exist('technique') == 1
        set(normalChangeText,'String',technique);
        set(normalChangeText,'Visible','on');
        set(normalizedWithText,'Visible','on');
        
    end
    
    
    
    filenames = data(1,2:end);
    addToFiles = ['All' filenames];
    set(lb,'String',addToFiles);
    set(lb,'Max',length(addToFiles),'Min',0);
    axes(boxplotAxes);
    %boxplot(logTransform(plotData+0.001));
    
    medians = nanmedian(plotData);
    medOfMedians = median(medians);
  
    mediansCentered = abs(medians - medOfMedians);
    upperQuan = quantile(medians,0.75);
    mediansCentered(mediansCentered>upperQuan) = upperQuan;
   
    medDev = mad(mediansCentered,1);
    medDev = medDev/upperQuan;
    set(medianDevtext,'String',num2str(medDev), 'Units','normalized');
    
    
    upperquantiles = quantile(plotData,0.75,1);
    medOfMedians = median(upperquantiles)
    upperQuan = quantile(upperquantiles,0.75)
    mediansCentered = abs(upperquantiles - medOfMedians);
    %upperQuan = quantile(upperquantiles,0.75);
    mediansCentered(mediansCentered>upperQuan) = upperQuan;
   
    medDev = mad(mediansCentered,1);
    medDev = medDev/upperQuan;
    set(medUpperQuantiletext,'String',num2str(medDev),'Units','normalized');
    
    lowerquantiles = quantile(plotData,0.25,1);
    medOfMedians = median(lowerquantiles)
    upperQuan = quantile(lowerquantiles,0.75)
    mediansCentered = abs(lowerquantiles - medOfMedians);
    %upperQuan = quantile(upperquantiles,0.75);
    mediansCentered(mediansCentered>upperQuan) = upperQuan;
   
    medDev = mad(mediansCentered,1);
    medDev = medDev/upperQuan;
    set(medLowQuantiletext,'String',num2str(medDev),'Units','normalized');
    
    %% Mean calculations
    medians = nanmedian(plotData);
    medOfMedians = median(medians);
  
    mediansCentered = abs(medians - medOfMedians);
    upperQuan = quantile(medians,0.75);
    mediansCentered(mediansCentered>upperQuan) = upperQuan;
   
    medDev = mad(mediansCentered,0);
    medDev = medDev/upperQuan;
    set(meanDevtext,'String',num2str(medDev), 'Units','normalized');
    
    
    upperquantiles = quantile(plotData,0.75,1);
    medOfMedians = median(upperquantiles)
    upperQuan = quantile(upperquantiles,0.75)
    mediansCentered = abs(upperquantiles - medOfMedians);
    %upperQuan = quantile(upperquantiles,0.75);
    mediansCentered(mediansCentered>upperQuan) = upperQuan;
   
    medDev = mad(mediansCentered,0);
    medDev = medDev/upperQuan;
    set(meanUpperQuantiletext,'String',num2str(medDev),'Units','normalized');
    
    lowerquantiles = quantile(plotData,0.25,1);
    medOfMedians = median(lowerquantiles)
    upperQuan = quantile(lowerquantiles,0.75)
    mediansCentered = abs(lowerquantiles - medOfMedians);
    %upperQuan = quantile(upperquantiles,0.75);
    mediansCentered(mediansCentered>upperQuan) = upperQuan;
   
    medDev = mad(mediansCentered,0);
    medDev = medDev/upperQuan;
    set(meanLowQuantiletext,'String',num2str(medDev),'Units','normalized');
    
    
    %{
    One method:
    medians = nanmedian(logTransform(plotData))
    medDev = mad(medians,1);
    upperquantiles = quantile(logTransform(plotData),0.75,1);
    lowerquantiles = quantile(logTransform(plotData),0.25,1);
    set(medLowQuantiletext,'String',num2str(mad(lowerquantiles,1)),'Units','normalized');
    set(medUpperQuantiletext,'String',num2str(mad(upperquantiles,1)),'Units','normalized');
    %{
    medianOftheMedians = median(medians)
    for y = 1:length(medians)
        diff = medians(y) - medianOftheMedians;
    end
    medianOfTheVariation = nanmedian(diff);
    %}
    set(medianDevtext,'String',num2str(medDev), 'Units','normalized');
    %}
    
    %boxplot(logTransform(plotData),'Labels',filenames);
    %set(gca,'FontSize',10,'XTickLabelRotation',90);
    
    %Uncomment this when working on 2013 version of matlab
    plotData = replaceZeros(plotData,'lowval');
    
    hA = boxplot(logTransform(plotData),'Labels',filenames); %this is different in the normalized and depends for filtered counts gui
    hB = findobj(hTabFig,'Type','hggroup');
    %{
        hL = findobj(hB,'Type','text');
        set(hL,'Rotation',90,'FontWeight','bold')
    %}
    fontSize = 10;
    rotation = 90;
    
    text_h = findobj(hB, 'Type', 'text');
    for cnt = 1:length(text_h)
        set(text_h(cnt),    'FontSize', fontSize,...
            'Rotation', rotation, ...
            'String', filenames{length(filenames)-cnt+1}, ...
            'HorizontalAlignment', 'right',...
            'VerticalAlignment', 'middle');
    end
    ylim([-20 20])
    
    

    
   %% Call back for export button
    function call_export(hObject,eventdata,h)
        
        contents = cellstr(get(lb,'String')); %returns listbox1 contents as cell array
        selected = get(lb,'Value'); %returns selected item from listbox1
        selected = selected -1;
        if selected(1) == 0
            
            sel_cols = plotData;
            label = filenames;
            selected = [];
            for i = 1:size(plotData,2)
                selected = [selected i];
            end
            
            %selected is a vector with the indeces that pick out the columns to be
            %graphed
        else
            sel_cols = [];
            
            for t = 1:length(selected);
                sel_cols = [sel_cols, plotData(:,selected(t))];
            end
            label = [];
            for j = 1:length(selected)
                filenameAdd = char(filenames(selected(j)));
                filenameAdd = cellstr(filenameAdd);
                label = [label filenameAdd];
            end
            
            
        end
        figure;
        
        %boxplot(logTransform(sel_cols),'Labels',label);
        %set(gca,'FontSize',10,'XTickLabelRotation',90);
        
        %Uncomment this later in 2013 version
        
        width = 0.5;
        sh = 0.1; 
    
        pos = [];
        for t = 1:size(sel_cols,2)
            pos = [pos t];
        end
        
        wid = width * ones(1,length(pos));
    
        % boxplot
        figure
        boxplot(logTransform(sel_cols), ...
            'positions', pos,...
            'widths', wid) 
    
       
        text_h = findobj(gca, 'Type', 'text');
        rotation = 90;
    
        for cnt = 1:length(text_h)
        set(text_h(cnt),    'FontSize', fontSize,...
                            'Rotation', rotation, ...
                            'String', label{length(label)-cnt+1}, ...
                            'HorizontalAlignment', 'right')
        end
        squeeze = 0.2;
        left = 0.02;
        right = 1;
        bottom = squeeze;
        top = 1-squeeze;
        set(gca, 'OuterPosition', [left bottom right top])
       
    end
        



%%   Save the TabHandles in guidata
        guidata(hTabFig,TabHandles);

%%   Make Tab 1 active
        TabSellectCallback(0,0,1);
%%   Define the callbacks for the Tab Buttons
%    All callbacks go to the same function with the additional argument being the Tab number
        for CountTabs = 1:numTabs
            set(TabHandles{CountTabs,2}, 'callback', ...
                {@TabSellectCallback, CountTabs});
        end

        
    %% Call back for export 1 button
    function call_export1(hObject,eventdata,h)
        
        
        fig1 = figure;
        a = scatter(x,sums,'filled');
        xlabel('Samples');
        title('Totals');
        
       
        %fill
    end
    %% Call back for export 2 button
    function call_export2(hObject,eventdata,h)
        figure;
        b = scatter(x,secondGraphData,'filled');
        xlabel('Samples');
        title('Interquantile Range');
        %fill
    end
    %% Call back for export 3 button
    function call_export3(hObject,eventdata,h)
        figure;
        c = scatter(x,samples,'filled');
        xlabel('Samples');
        title('Interquantile Range');
        %fill
    end
        %% Call back for min Y tab page 2
        %Doesn't actually work
    function call_minY(hObject,eventdata,h)
        
        contents = cellstr(get(hObject,'String')); %returns minTotalmenu contents as cell array
        selected1 = contents{get(hObject,'Value')}; %returns selected item from minTotalmenu
        
        if isappdata(maxY,'currentSel')
            currentSel1 = getappdata(maxY,'currentSel');
            if currentSel1 < str2num(selected1)
                uiwait(errordlg('The value you selected is greater than the maximum value currently selected','Error','modal'));
                return;
            end
        end
        
        setappdata(minY,'currentSel',str2num(selected1));
        str2num(selected1)
        axes(boxplotAxes);
        yl1 = ylim;
        ylim([str2num(selected1) yl1(2)]);
    end
    
%% Call back for max Y tab page 2
    function call_maxY(hObject,eventdata,h)
        contents = cellstr(get(hObject,'String'));
        selected1 = contents{get(hObject,'Value')};
        if isappdata(minY,'currentSel')
            currentSel1 = getappdata(minY,'currentSel');
            if currentSel1 > str2num(selected1)
                uiwait(errordlg('The value you selected is less than the minimum value currently selected','Error','modal'));
                return;
            end
        end
        setappdata(maxY,'currentSel',str2num(selected1));
        str2num(selected1)
        axes(boxplotAxes);
        yl1 = ylim;
        ylim([yl1(1) str2num(selected1)]);
    end
                
        
        
%% Call back for quantile Menu 3

    function callback_quantileMenu3(hObject,eventdata,h)
        contents = cellstr(get(hObject,'String'));
        selected = contents{get(hObject,'Value')};
        selected = str2num(selected);
        
        if isappdata(quantileMenu3,'keepLine');
            previousLine = getappdata(quantileMenu3,'keepLine');
            delete(previousLine);
        end
        cutOff = quantile(samples,(selected)/100);
        axes(nonZeroAxes)
        getxLim = xlim;
        ph = plot([getxLim(1) getxLim(2)], [cutOff cutOff]);
        set(ph,'Color','m','LineStyle','--','LineWidth',1.25);
        c = getappdata(quantileMenu3,'scatterData');
        
        scatter(x,samples,'filled','MarkerFaceColor','b');
        setappdata(quantileMenu3,'keepLine',ph);
    end
%% Call back for quantile Menu 1
    function callback_quantileMenu1(hObject,eventdata,h)
        contents = cellstr(get(hObject,'String')); %returns menu1 contents as cell array
        selected = contents{get(hObject,'Value')}; %returns selected item from menu1
        selected = str2num(selected);
        %going to have to divide the selected value by 100
        
        
        if isappdata(quantileMenu1,'keepLine');
            previousLine = getappdata(quantileMenu1,'keepLine');
            delete(previousLine);
        end
        
        cutOff = quantile(sums,(selected)/100);
        axes(totalsAxes)
        getxLim = xlim;
        ph = plot([getxLim(1) getxLim(2)], [cutOff cutOff]);
        set(ph, 'Color', 'm', 'LineStyle','--', 'LineWidth',1.25);
        a = getappdata(quantileMenu1,'scatterData');
        
        scatter(x,sums,'filled','MarkerFaceColor','b');
        setappdata(quantileMenu1,'keepLine',ph);
        %fill in
    end
%% Call back for quantile Menu 2
    function callback_quantileMenu2(hObject,eventdata,h)
        contents = cellstr(get(hObject,'String')); %returns menu1 contents as cell array
        selected = contents{get(hObject,'Value')}; %returns selected item from menu1
        selected = str2num(selected);
        
        if isappdata(quantileMenu2,'keepLine')
            previousLine = getappdata(quantileMenu2,'keepLine');
            delete(previousLine);
        end
        
        cutOff = quantile(secondGraphData,(selected)/100);
        assignin('base','cutoff',cutOff);
        axes(quantileAxes);
        getxLim = xlim;
        ph = plot([getxLim(1) getxLim(2)],[cutOff cutOff]);
        set(ph,'Color','m','LineStyle','--','LineWidth',1.25);
        b = getappdata(quantileMenu2,'scatterData');
        
        scatter(x,secondGraphData,'filled','MarkerFaceColor','b');
        setappdata(quantileMenu2,'keepLine',ph);
        
        
        %fill in
    end

%% Call back for min nonZero Menu
    function callback_minNonZeroMenu(hObject,eventdata,h)
        
        contents = cellstr(get(hObject,'String')); %returns minTotalmenu contents as cell array
        selected1 = contents{get(hObject,'Value')}; %returns selected item from minTotalmenu
            if isappdata(maxNonZeroMenu,'currentSel')
                currentSel1 = getappdata(maxNonZeroMenu,'currentSel');
                if currentSel1 < str2num(selected1)
                    uiwait(errordlg('The value you selected is greater than the maximum value currently selected','Error','modal'));
                    return;
                end
            end
        
        setappdata(minNonZeroMenu,'currentSel',str2num(selected1));
        axes(nonZeroAxes);
        yl1 = ylim;
        ylim([str2num(selected1) yl1(2)]);
    end

%% Call back for max nonZero Menu
    function callback_maxNonZeroMenu(hObject,eventdata,h)
        contents = cellstr(get(hObject,'String'));
        selected1 = contents{get(hObject,'Value')};
        if isappdata(minNonZeroMenu,'currentSel')
            currentSel1 = getappdata(minNonZeroMenu,'currentSel');
            if currentSel1 > str2num(selected1)
                uiwait(errordlg('The value you selected is less than the minimum value selected','Error','modal'));
                return;
            end
        end
        setappdata(maxNonZeroMenu,'currentSel',str2num(selected1));
        axes(nonZeroAxes);
        yl1 = ylim;
        ylim([yl1(1) str2num(selected1)]);
    end
%% Call back for min Total Menu
    function call_minTotalMenu(hObject,eventdata,h)
        
        contents = cellstr(get(hObject,'String')); %returns minTotalmenu contents as cell array
        selected1 = contents{get(hObject,'Value')}; %returns selected item from minTotalmenu
            if isappdata(maxTotalMenu,'currentSel')
                currentSel1 = getappdata(maxTotalMenu,'currentSel');
                if currentSel1 < str2num(selected1)
                    uiwait(errordlg('The value you selected is greater than the maximum value currently selected','Error','modal'));
                    return;
                end
            end
        
        setappdata(minTotalMenu,'currentSel',str2num(selected1));
        axes(totalsAxes);
        yl1 = ylim;
        ylim([str2num(selected1) yl1(2)]);
        %fill in
    end
%% Call back for max Total Menu
    function call_maxTotalMenu(hObject,eventdata,h)
        
        contents = cellstr(get(hObject,'String'));
        selected = contents{get(hObject,'Value')};
        
        if isappdata(minTotalMenu,'currentSel');
            currentSel2 = getappdata(minTotalMenu,'currentSel');
            if currentSel2 > str2num(selected);
                uiwait(errordlg('The value you selected is less than the minimum value selected.','Error','modal'));
                return;
            end
        end
        setappdata(maxTotalMenu,'currentSel',str2num(selected));
        axes(totalsAxes);
        yl2 = ylim;
      
        ylim([yl2(1) str2num(selected)]);
        %fill in
    end
%% Call back for min IQR Menu
    function call_minIQRMenu(hObject,eventdata,h)
          
        contents = cellstr(get(hObject,'String'));
        selected = contents{get(hObject,'Value')};
        if isappdata(maxIQRMenu,'currentSel');
            currentSel3 = getappdata(maxIQRMenu,'currentSel');
            if currentSel3 < str2num(selected);
                uiwait(errordlg('The value you selected is greater than the maximum value selected','Error','modal'));
                return;
            end
        end
        setappdata(minIQRMenu,'currentSel',str2num(selected));
        axes(quantileAxes);
        yl3 = ylim;
        
        ylim([str2num(selected) yl3(2)]);
        %fill in
    end
%% Call back for max IQR Menu
    function call_maxIQRMenu(hObject,eventdata,h)
         
        contents = cellstr(get(hObject,'String'));
        selected = contents{get(hObject,'Value')};
        if isappdata(minIQRMenu,'currentSel');
            currentSel4 = getappdata(minIQRMenu,'currentSel');
            if currentSel4 > str2num(selected);
                uiwait(errordlg('The value you selected is less than the minimum value selected','Error','modal'));
                return;
            end
        end
        setappdata(maxIQRMenu,'currentSel',str2num(selected));
        axes(quantileAxes);
        yl4 = ylim;
        str2num(selected);
        ylim([yl4(1) str2num(selected)]);
        %fill in
    end
%% Call back for clear button, first tag page
    function clearQuality(hObject,eventdata,h)
        
        delete(findall(totalsAxes,'Type','hggroup','HandleVisibility','off'))
        delete(findall(quantileAxes,'Type','hggroup','HandleVisibility','off'))
        set(minTotalMenu,'Value',1)
        set(maxTotalMenu,'Value',1)
        set(minIQRMenu,'Value',1)
        set(maxIQRMenu,'Value',1)
        set(quantileMenu1,'Value',1)
        set(quantileMenu2,'Value',1)
        if isappdata(quantileMenu1,'keepLine')
            line = getappdata(quantileMenu1,'keepLine')
            delete(line)
            rmappdata(quantileMenu1,'keepLine')
        end
        if isappdata(quantileMenu2,'keepLine')
            line = getappdata(quantileMenu2,'keepLine')
            delete(line)
            rmappdata(quantileMenu2,'keepLine')
        end
        
        if isappdata(maxIQRMenu,'currentSel')
            rmappdata(maxIQRMenu,'currentSel')
        end
        if isappdata(minIQRMenu,'currentSel')
            rmappdata(minIQRMenu,'currentSel')
        end
        if isappdata(minTotalMenu,'currentSel')
            rmappdata(minTotalMenu,'currentSel')
        end
        if isappdata(maxTotalMenu,'currentSel')
            rmappdata(maxTotalMenu,'currentSel')
        end
        
        %fill in
    end

%% Call back for graph button
    function call_graphButton(hObject,eventdata,h)
        contents = cellstr(get(lb,'String')); %returns listbox1 contents as cell array
        selected = get(lb,'Value'); %returns selected item from listbox1
        selected = selected -1;
        if selected(1) == 0
            
            sel_cols = plotData;
            label = filenames;
            selected = [];
            for i = 1:size(plotData,2)
                selected = [selected i];
            end
            
            %selected is a vector with the indices that pick out the columns to be
            %graphed
        else
            sel_cols = [];
            
            for t = 1:length(selected);
                sel_cols = [sel_cols, plotData(:,selected(t))];
            end
            label = [];
            for j = 1:length(selected)
                filenameAdd = char(filenames(selected(j)));
                filenameAdd = cellstr(filenameAdd);
                label = [label filenameAdd];
            end
            
            
        end
        assignin('base','sel_cols',sel_cols);
        axes(boxplotAxes)
        cla reset
        axes(boxplotAxes)
        
        %boxplot(logTransform(sel_cols),'Labels',label);
        %set(gca,'FontSize',10,'XTickLabelRotation',90);
        
        %Uncomment this for the 2013 version
        xticks = cellstr(label);
        hA = boxplot(logTransform(sel_cols),'Labels',xticks); %this is different in the normalized and depends for filtered counts gui
        hB = findobj(hTabFig,'Type','hggroup');
        %{
        hL = findobj(hB,'Type','text');
        set(hL,'Rotation',90,'FontWeight','bold')
        %}
        fontSize = 10;
        rotation = 90;
        
        text_h = findobj(hB, 'Type', 'text');
        for cnt = 1:length(text_h)
            set(text_h(cnt),    'FontSize', fontSize,...
                'Rotation', rotation, ...
                'String', label{length(label)-cnt+1}, ...
                'HorizontalAlignment', 'right',...
                'VerticalAlignment', 'middle');
        end
        
        set(minY,'Value',5);
        set(maxY,'Value',5);
        %fill in
    end
    %% Function to add custom data tip
    function output_txt = myfunction(~,event_obj)
        
        
        
        target = get(event_obj,'Target');
        targetParent = get(target,'Parent');
        
        if isappdata(quantileMenu1,'keepLine')
            line = getappdata(quantileMenu1,'keepLine')
            
            if line == target
                'hi'
                return;
            end
        end
            
        if isappdata(quantileMenu2,'keepLine')
            %
        end
            
        if isappdata(quantileMenu3,'keepLine')
            %
        end
        
        %basically do nothing if it hovers over the histogram or boxplot
        if targetParent == totalsAxes
            pos = get(event_obj,'Position');
            nameToDisplay = filenames(pos(1));
            nameToDisplay = char(nameToDisplay);
            output_txt = {nameToDisplay};
        elseif targetParent == quantileAxes
            pos = get(event_obj,'Position');
            nameToDisplay = filenames(pos(1));
            nameToDisplay = char(nameToDisplay);
            output_txt = {nameToDisplay};
        elseif targetParent == nonZeroAxes
            pos = get(event_obj,'Position');
            nameToDisplay = filenames(pos(1));
            nameToDisplay = char(nameToDisplay);
            output_txt = {nameToDisplay};
        end
        
        
    end
    
    %% Call back for saving graphs
    function saveGraphs(hObject,eventdata,h)
        [FileName,PathName] = uiputfile({'*.jpeg;*.bmp;*.eps;.*fig'},'Save file','');
        fullname = fullfile(PathName,FileName);
        fh = figure;
        copyobj(totalsAxes, fh);
        saveas(fh, fullname);
        close(fh);
        
        %fill in
    end
        

end






%%   Callback for Tab Selection
function TabSellectCallback(~,~,SelectedTab)
%   All tab selection pushbuttons are greyed out and uipanels are set to
%   visible off, then the selected panel is made visible and it's selection
%   pushbutton is highlighted.
        

    %   Set up some varables
        TabHandles = guidata(gcf);
        if SelectedTab == 1
            datacursormode on
        else
            datacursormode off
        end
        NumberOfTabs = size(TabHandles,1)-2;
        White = TabHandles{NumberOfTabs+2,2};            % White      
        BGColor = TabHandles{NumberOfTabs+2,3};          % Light Grey
        
    %   Turn all tabs off
        for TabCount = 1:NumberOfTabs
            set(TabHandles{TabCount,1}, 'Visible', 'off');
            set(TabHandles{TabCount,2}, 'BackgroundColor', BGColor);
        end
        
    %   Enable the selected tab
        set(TabHandles{SelectedTab,1}, 'Visible', 'on');        
        set(TabHandles{SelectedTab,2}, 'BackgroundColor', White);

end
        