function main
close all;

%Rename save button to 'Export Data'
% load the data in the normalization tab at the same time you load the raw
% data
% rename reset on tab2, revert to original data
% rename launch, to general stats
% rename save button on tab page 2 to expost

%to change sample names - done
% - have listbox instead of preview and select which names to get changed
% make sure the reset button on page 1 resets names to original



%%%% NEW CHANGES
%make the change sample name window bigger, make it taller to view more
%titles in selection box

%change functionality of the change sample name gui, use word matching to
%remove specific part of a string

% add button to select all options in listbox (change sample names)
% revert to original names, change the name 'reset' to that

%change heading to 'select titles to rename'

%title above normalized table, 'Normalized with _______'

%Upper quantile, quantile(data>0,0.75)

%readAllFileLengths, line 44

%in the stats gui, add to heading, counts of miRNA > 0

%under num miRNA >, set normalized popupmenu

%show actual y value for popupmenu on stats page

%fix the showing of data string when point is on quantile line
%when clicking on white space, data string should disappear- don't know how
%to do this

%add axis descriptions to graphs, x axis

%pop up menu on boxplot page need to be normalized

%at the top of the boxplot, indicate what normalization is being used, and
% NEXT
%indicate how many miRNA like 1566/1566 miRNA remaining

% deal with the all option, with the listbox on the boxplot 

% call heatmap function, and add the code for it

%indication of what is in the table on the filtering page, like what
%normalization is currently applied

%have an indication that miRNAs ar rows and samples are columns

%Change tab title to "load data"

%change browse button name to load text files and have another button to be
%able to load already merged Data sets, look into have a button to open the
%import wizard to do this.

%when importing from excel merged data set, want T5 merged

% have the zoom divide on stats page.

%add 'export' button on boxplot page that sends your boxplot to a regular
%matlab figure window.

%REVERT to original button doesn't work



 numTabs = 5;
    tabLabels = {'Load Files';'FastQ';'Normalization';'Filtered Counts';'Feature Classifier'};
    if size(tabLabels,1) ~= numTabs
        uiwait(errordlg('Number of tabs and tab labels must be the same','Setup Error','modal'));
        return;
    end
    set(0,'Units','pixels')
    MaxMonitorX = 1280;
    MaxMonitorY = 800;
    
    %Set the figure window size values
    MainFigScale = .6;          % Change this value to adjust the figure size
    MaxWindowX = round(MaxMonitorX*MainFigScale);
    MaxWindowY = round(MaxMonitorY*MainFigScale);
    XBorder = (MaxMonitorX-MaxWindowX)/2;
    YBorder = (MaxMonitorY-MaxWindowY)/2;
    TabOffset = 0;              % This value offsets the tabs inside the figure.
    ButtonHeight = 40;
    PanelWidth = MaxWindowX-2*TabOffset+4;
    PanelHeight = MaxWindowY-ButtonHeight-2*TabOffset;
    ButtonWidth = round((PanelWidth-numTabs)/numTabs);
    
    white = [1 1 1];
    BGColor = 0.9*white;
    
    hTabFig = figure(...
            'Position',[ XBorder, YBorder, MaxWindowX, MaxWindowY ],... % XBorder, YBorder, MaxWindowX, MaxWindowY 
            'Units','normalized',...
            'NumberTitle', 'off',...
            'Name', 'Main',...
            'MenuBar', 'none',...
            'Resize', 'on',...
            'Renderer','zbuffer',... %this is so that when you plot a bar graph, the lines dont go over when you zoom in
            'DockControls', 'off',...
            'Color', white);
        
            
            tbh = uitoolbar('Parent',hTabFig);
            [img,map] = imread('11.gif');
            icon = ind2rgb(img,map);
            
            graphPush = uipushtool(tbh,'ToolTipString','General Statistics','Separator','on','Enable','on','ClickedCallback',@call_graphPush);
            set(graphPush,'cData',icon);
            
            [img,map] = imread('22.gif');
            icon = ind2rgb(img,map);
            savePush = uipushtool(tbh,'ToolTipString','Export Data','Separator','on','Enable','on','ClickedCallback',@call_savePush);
            set(savePush,'cData',icon);
            
            [img,map] = imread('75.gif');
            icon = ind2rgb(img,map);
            resetPush = uipushtool(tbh,'ToolTipString','Revert to original data','Separator','on','Enable','on','ClickedCallback',@call_resetPush);
            set(resetPush,'cData',icon);
            
            [img,map] = imread('treemapviewicon.gif');
            icon = ind2rgb(img,map);
            heatmapPush = uipushtool(tbh,'ToolTipString','Launch Heatmap','Separator','on','Enable','on','ClickedCallback',@call_heatmap);
            set(heatmapPush,'cData',icon);
            
            
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
        set(TabHandles{1,1},'Units','normalized');
        set(TabHandles{2,1},'Units','normalized');
        set(TabHandles{3,1},'Units','normalized');
        set(TabHandles{3,2},'Enable','on');
        set(TabHandles{4,1},'Units','normalized');
        set(TabHandles{4,2},'Enable','on');
        set(TabHandles{5,1},'Units','normalized');
        set(TabHandles{5,2},'Enable','on');
        
        %% Tab 1 Layout                                                                            %xdir%ydir%width%height
        browse1 = uicontrol('Parent',TabHandles{1,1},'Units','pixels','Style','pushbutton','position',[650 375 100 40],'String','Browse Directories',...
            'callback',@loadButton);
        set(browse1,'Units','normalized');
        tb = uitable('Parent',TabHandles{1,1},'Units','pixels','position',[25 25 600 335]);
        set(tb,'Units','normalized');
        texter = uicontrol('Parent',TabHandles{1,1},'Units','pixels','position',[25 370 450 25],'Style','text','BackgroundColor',[0 0.749019607 0.749019607]);
        set(texter,'Units','normalized');
        loadCounts = uicontrol('Parent',TabHandles{1,1},'Units','pixels','position',[25 400 300 20],'Style','text','String',...
            'Load counts from Partek:','BackgroundColor',[1 1 1],'FontSize',13.5,'HorizontalAlignment','left');
        set(loadCounts,'Units','normalized');            
        changeButton = uicontrol('Parent',TabHandles{1,1},'Units','pixels','Style','pushbutton','position',[650 200 100 50],...
            'String','<html>Change Sample<br/>Names','callback',@call_changeButton);
        set(changeButton,'Units','normalized');
        browseMerged = uicontrol('Parent',TabHandles{1,1},'Units','pixels','Style','pushbutton','position',[650 315 100 40],'String',...
            'Browse Merged','callback',@call_browseMerged);
        set(browseMerged,'Units','normalized');
        noteAboutImporting = uicontrol('Parent',TabHandles{1,1},'Units','pixels','Style','text','position',[25 3 500 20],'String',...
            'Note: When importing data, make sure rows represent miRNAs and columns represent samples.','BackgroundColor',[1 1 1],...
            'HorizontalAlignment','left');
        set(noteAboutImporting,'Units','normalized');
        %addClassButton = uicontrol('Parent',TabHandles{1,1},'Units','pixels','Style','pushbutton','position',[650 100 100 40],'String',...
        %    'Add Class Info','callback',@call_addClassInfo);
        %set(addClassButton,'Units','normalized');
        
        %disable buttons and tabs until data is loaded
        %indication that data is loading in the first table
        
        
        %% Tab 2 Layout
        browseFQ = uicontrol('Parent',TabHandles{2,1},'Units','pixels','Style','pushbutton','position',[650 385 100 40],'String','Browse','callback',...
            @browseFastQ);
        set(browseFQ,'Units','normalized');
        histaxes = axes('Parent',TabHandles{2,1},'Units','pixels','position',[105 125 475 250]);
        set(histaxes,'Units','normalized');
        bwdbutton = uicontrol('Parent',TabHandles{2,1},'Units','pixels','Style','pushbutton','position',[200 80 60 20],'String','<<<','callback',...
            @backButton); %'Clipping','on');
        set(bwdbutton,'Units','normalized');
        fwdbutton = uicontrol('Parent',TabHandles{2,1},'Units','pixels','Style','pushbutton','position',[425 80 60 20],'String','>>>','callback',...
            @forwardButton);
        set(fwdbutton,'Units','normalized');
        loadText = uicontrol('Parent',TabHandles{2,1},'Units','pixels','Style','text','position',[105 410 350 20],'String',...
            'Load FastQ data here:','FontSize',13,'HorizontalAlignment','left','BackgroundColor',[0.2 0.6 1]); 
        set(loadText,'Units','normalized');
        clButton = uicontrol('Parent',TabHandles{2,1},'Units','pixels','Style','pushbutton','position',[650 20 100 40],'String','Clear','callback',...
            @clearButton);
        set(clButton,'Units','normalized');
        enterYlim = uicontrol('Parent',TabHandles{2,1},'Units','pixels','Style','edit','position',[650 230 100 40],'BackgroundColor',[1 1 1],...
            'callback',@enterYinput);
        set(enterYlim,'Units','normalized');
        userPrompt = 'Enter Max Y Limit:';
        enterYText = uicontrol('Parent',TabHandles{2,1},'Units','pixels','Style','text','position',[650 270 100 20],'BackgroundColor',[1 1 1],'String',...
            userPrompt,'FontSize',12,'HorizontalAlignment','left');
        set(enterYText,'Units','normalized');
        userNotice = {'To return to';...
            'the original';...
            'axis, enter 0';};
        enterYnotice = uicontrol('Parent',TabHandles{2,1},'Units','pixels','Style','text','position',[650 160 100 60],'BackgroundColor',[1 1 1],'String',...
            userNotice,'FontSize',12,'HorizontalAlignment','left','callback',@userYinput);
        set(enterYnotice,'Units','normalized');
        trimText = uicontrol('Parent',TabHandles{2,1},'Units','pixels','Style','text','position',[175 40 100 20],'BackgroundColor',[1 1 1],'String',...
            'Trim Length:','FontSize',13,'HorizontalAlignment','left','FontWeight','bold');
        set(trimText,'Units','normalized');
        options = {'8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28',...
            '29','30','31','32','33','34','35','36','37','38','39','40','41','42','43','44','45','46','47','48','49','50'};
        maxPopUp = uicontrol('Parent',TabHandles{2,1},'Units','pixels','Style','popupmenu','position',[350 15 100 20],'String',options,...
            'callback',@maxMenu) ;
        set(maxPopUp,'Units','normalized');
        minPopUp = uicontrol('Parent',TabHandles{2,1},'Units','pixels','Style','popupmenu','position',[350 40 100 20],'String',options,...
            'callback',@minMenu);
        set(minPopUp,'Units','normalized');
        minText = uicontrol('Parent',TabHandles{2,1},'Units','pixels','Style','text','position',[270 40 75 20],'String','Min Length',...
            'FontSize',13,'BackgroundColor',[1 1 1]);
        set(minText,'Units','normalized');
        maxText = uicontrol('Parent',TabHandles{2,1},'Units','pixels','Style','text','position',[270 15 75 20],'String','Max Length',...
            'FontSize',13,'BackgroundColor',[1 1 1]);
        set(maxText,'Units','normalized');
        filename = uicontrol('Parent',TabHandles{2,1},'Units','pixels','Style','text','position',[135 380 300 20],'BackgroundColor',[0.925490196...
            0.839215686 0.839215686]);
        set(filename,'Units','normalized');
        countText = uicontrol('Parent',TabHandles{2,1},'Units','pixels','Style','text','position',[40 360 35 20],'BackgroundColor',[1 1 1],...
            'String','Counts','HorizontalAlignment','left');
        set(countText,'Units','normalized');
        
        %launch button rename to general stats
        
        %% Tab 3 page layout
        bg = uibuttongroup('Parent',TabHandles{3,1},'Units','pixels','position',[75 75 200 300]);
        set(bg,'Units','normalized');
        set(bg,'selectedObject',[]);
        tmmButton = uicontrol('Parent',bg,'Units','pixels','position',[20 270 75 20],'Style','radiobutton','String','TMM','Tag','TMM');
        set(tmmButton,'Units','normalized');
        upperQuantile = uicontrol('Parent',bg,'Units','pixels','position',[20 220 150 20],'Style','radiobutton','String','Upper Quantile',...
            'Tag','Upper Quantile');
        set(upperQuantile,'Units','normalized');
        totalCounts = uicontrol('Parent',bg,'Units','pixels','position',[20 170 160 20],'Style','radiobutton','String','Total Counts',...
            'Tag','Total Counts');
        set(totalCounts,'Units','normalized');
        medianRadio = uicontrol('Parent',bg,'Units','pixels','position',[20 120 150 20],'Style','radiobutton','String','Median',...
            'Tag','Median');
        set(medianRadio,'Units','normalized');
        deseq = uicontrol('Parent',bg,'Units','pixels','position',[20 70 150 20],'Style','radiobutton','String','DESEQ',...
            'Tag','DESEQ');
        set(deseq,'Units','normalized');
        tb2 = uitable('Parent',TabHandles{3,1},'Units','pixels','position',[350 75 395 300]);
        set(tb2,'Units','normalized');
        normalizeBut = uicontrol('Parent',TabHandles{3,1},'Units','pixels','position',[125 25 100 35],'Style','pushbutton','String','Normalize',...
            'callback',@call_normalize);
        set(normalizeBut,'Units','normalized');
        normHeading = uicontrol('Parent',TabHandles{3,1},'Units','pixels','position',[350 380 100 20],'Style','text','String','Normalized with:',...
            'BackgroundColor',[1 1 1],'FontSize',13,'HorizontalAlignment','left');
        set(normHeading,'Units','normalized');
        changeNormHeading = uicontrol('Parent',TabHandles{3,1},'Units','pixels','position',[450 380 125 20],'Style','text','String',...
            '','BackgroundColor',[1 1 1],'FontSize',13,'HorizontalAlignment','left');
        set(changeNormHeading,'Units','normalized');
        CVplotNormPage = uicontrol('Parent',TabHandles{3,1},'Units','pixels','position',[600 10 100 20],'Style','pushbutton',...
            'BackgroundColor',[1 0.2 0.3],'HorizontalAlignment','left','String','Plot CV','FontSize',13,'callback',@call_CVPlotNormed);
        set(CVplotNormPage,'Units','normalized');
        
        
        %Come back here and write callback for radio filter
        
        
        
        
        %% Tab page 4 Layout
        
        tb3 = uitable('Parent',TabHandles{4,1},'Units','pixels','position',[25 135 650 260]);
        set(tb3,'Units','normalized');
        nummiRNAString = uicontrol('Parent',TabHandles{4,1},'Units','pixels','position',[25 85 125 35],'Style','text',...
            'String','Number of miRNA:','HorizontalAlignment','left','FontSize',13,'BackgroundColor',[1 1 1]);
        set(nummiRNAString,'Units','normalized');
        filterByText = uicontrol('Parent',TabHandles{4,1},'Units','pixels','position',[25 55 75 35],'Style','text',...
            'String','Filter by','HorizontalAlignment','left','FontSize',13,'BackgroundColor',[1 1 1]);
        set(filterByText,'Units','normalized');
        changeingString = uicontrol('Parent',TabHandles{4,1},'Units','pixels','position',[150 85 40 35],'Style','text',...
            'String','','HorizontalAlignment','left','FontSize',13,'BackgroundColor',[1 1 1]);
        set(changeingString,'Units','normalized');
        enterString = uicontrol('Parent',TabHandles{4,1},'Units','pixels','position',[80 67 100 25],'Style','edit',...
            'FontSize',13,'HorizontalAlignment','left','BackgroundColor',[1 1 1]);
        set(enterString,'Units','normalized');
        quantileString = uicontrol('Parent',TabHandles{4,1},'Units','pixels','position',[180 55 75 35],'Style','text',...
            'String','quantile','BackgroundColor',[1 1 1],'FontSize',13,'HorizontalAlignment','left');
        set(quantileString,'Units','normalized');
        stringEnter = uicontrol('Parent',TabHandles{4,1},'Units','pixels','position',[25 45 215 25],'Style','text',...
            'String','(Enter a number between 1 and 100)','HorizontalAlignment','left','FontSize',11,'BackgroundColor',[1 1 1]);
        set(stringEnter,'Units','normalized');
        filterButton = uicontrol('Parent',TabHandles{4,1},'Units','pixels','position',[655 10 100 25],'Style',...
            'pushbutton','String','Filter','callback',@call_filterBut);
        set(filterButton,'Units','normalized');
        thresholdText = uicontrol('Parent',TabHandles{4,1},'Units','pixels','position',[25 15 300 25],'Style',...
            'text','String','Keep miRNAs with counts >= selected quantile in','HorizontalAlignment','left','FontSize',13,...
            'BackgroundColor',[1 1 1]);
        set(thresholdText,'Units','normalized');
        thresholdEditbox = uicontrol('Parent',TabHandles{4,1},'Units','pixels','position',[320 20 75 25],'Style',...
            'edit','FontSize',11,'HorizontalAlignment','left');
        set(thresholdEditbox,'Units','normalized','BackgroundColor',[1 1 1]);
        percentText = uicontrol('Parent',TabHandles{4,1},'Units','pixels','position',[400 16 100 25],'Style',...
            'text','String','% of samples','FontSize',13,'HorizontalAlignment','left','BackgroundColor',[1 1 1]);
        set(percentText,'Units','normalized');
        toggleFilter = uicontrol('Parent',TabHandles{4,1},'Units','pixels','position',[20 405 175 25],'Style',...
            'pushbutton','String','Show normalized data','HorizontalAlignment','left','FontSize',13,'BackgroundColor',...
            [1 0.6 0.4],'callback',@call_toggleFilter);
        set(toggleFilter,'Units','normalized');
        changeFiltHeading = uicontrol('Parent',TabHandles{4,1},'Units','pixels','position',[450 395 120 20],'Style','text',...
            'BackgroundColor',[1 1 1],'HorizontalAlignment','left','String','Normalized with:','FontSize',13);
        set(changeFiltHeading,'Units','normalized');
        toChangeFiltString = uicontrol('Parent',TabHandles{4,1},'Units','pixels','position',[560 395 100 20],'Style','text',...
            'BackgroundColor',[1 1 1],'String','','FontSize',13,'HorizontalAlignment','left');
        set(toChangeFiltString,'Units','normalized');
        sentenceCode = uicontrol('Parent',TabHandles{4,1},'Units','pixels','position',[370 75 250 30],'Style','text',...
            'BackgroundColor',[1 1 1],'FontSize',13,'HorizontalAlignment','left','String','Keeping miRNAs with counts above ~       in        % of samples');
        set(sentenceCode,'Units','normalized','Visible','off');
        xToFill = uicontrol('Parent',TabHandles{4,1},'Units','pixels','position',[592 75 50 30],'Style','text',...
            'BackgroundColor',[1 1 1],'FontSize',13,'HorizontalAlignment','left','String','xxxxxx','FontWeight','bold','Visible','off');
        set(xToFill,'Units','normalized');
        thresholdToFill = uicontrol('Parent',TabHandles{4,1},'Units','pixels','position',[385 77 25 15],'Style','text',...
            'BackgroundColor',[1 1 1],'FontSize',13,'String','10','FontWeight','bold','Visible','off');
        set(thresholdToFill,'Units','normalized');
        checkBoxStar = uicontrol('Parent',TabHandles{4,1},'Units','pixels','position',[22 5 200 20],'Style','checkbox','String',...
            'Remove STAR miRNA','HorizontalAlignment','left','BackgroundColor',[1 1 1],'FontSize',13);
        
        CVplot = uicontrol('Parent',TabHandles{4,1},'Units','pixels','position',[655 75 100 20],'Style','pushbutton',...
            'BackgroundColor',[1 0.2 0.3],'HorizontalAlignment','left','String','Plot CV','FontSize',13,'callback',@call_CVPlot);
        set(CVplot,'Units','normalized');
        
        numOutliers = uicontrol('Parent',TabHandles{4,1},'Units','pixels','position',[370 50 120 20],'Style','text',...
            'BackgroundColor',[1 1 1],'HorizontalAlignment','left','String','Number of outliers: ','FontSize',13);
        set(numOutliers,'Units','normalized');
        numOutliersText = uicontrol('Parent',TabHandles{4,1},'Units','pixels','position',[485 50 80 20],'Style','text',...
            'String','Test','BackgroundColor',[1 1 1],'HorizontalAlignment','left','FontSize',13);
        set(numOutliersText,'Units','normalized');
        calcOutliers = uicontrol('Parent',TabHandles{4,1},'Units','pixels','position',[655 50 100 20],'Style','pushbutton',...
            'String','Calc','callback',@call_CalcOutliers);
          
        
    function call_CalcOutliers(hObject,eventdata,h)
        normalized_data = get(tb3,'data');
        normed_without_text = cell2mat(normalized_data(2:end,2:end));
        medians = nanmedian(normed_without_text,2);
        
        %flat = reshape(normed_without_text,[size(normed_without_text,1)*size(normed_without_text,2),1]);
        
        upperQuan = quantile(medians,0.75);
        %upper,quan of the medians, upperquan and lowerquan then check if sample median is above
        %the upper limit
        lowerQuan = quantile(medians,0.25);
        alpha = 2.4;
        upperLimit = upperQuan + 2.4*(upperQuan-lowerQuan);
        
        lowerLimit = lowerQuan + 2.4*(upperQuan-lowerQuan);
        countOutliers = 0;
        for i = 1:size(normed_without_text,2)
            
            if nanmedian(normed_without_text(:,i)) > upperLimit || nanmedian(normed_without_text(:,i)) < lowerLimit
                countOutliers = countOutliers + 1;
            end
        end
        set(numOutliersText,'String',num2str(countOutliers));
    end
        
        
    function call_CVPlotNormed(hObject,eventdata,h)
        raw_data = get(tb,'data');
        raw_data = cell2mat(raw_data(2:end,2:end));
        normalized_data = get(tb2,'data');
        normalized_data = cell2mat(normalized_data(2:end,2:end));
        norm0_cv = (std(normalized_data,0,2)./mean(normalized_data,2)).*100;
        norm1_cv = (std(raw_data,0,2)./mean(raw_data,2)).*100;
        
        [f,xi] = ksdensity(norm0_cv);
        figure
        plot(xi,f,'r');
        hold on
        [f,xi] = ksdensity(norm1_cv);
        plot(xi,f,'g');
        xtag = get(get(bg,'SelectedObject'),'Tag');
        title([xtag,' (red) and Raw (green)']);
        xlabel('CV %');
        ylabel('Density');
    end
        

    function call_CVPlot(hObject,eventdata,h)
        raw_data = get(tb,'data');
        raw_data = cell2mat(raw_data(2:end,2:end));
        
        normalized_data = get(tb3,'data');
        normalized_data = cell2mat(normalized_data(2:end,2:end));
        %The coefficient of variation (CV) is the ratio of the standard deviation to the mean.
        norm0_cv = (std(normalized_data,0,2)./mean(normalized_data,2)).*100;
        norm1_cv = (std(raw_data,0,2)./mean(raw_data,2)).*100;
        
        %plot density
        [f,xi] = ksdensity(norm0_cv);
        figure
        plot(xi,f, 'r');
        %axis([-10 200 -0.001 0.012]);
        hold on
        [f,xi] = ksdensity(norm1_cv);
        plot(xi,f,'g');
        xtag  = get(get(bg,'SelectedObject'),'Tag');
        title([xtag, ' (red) and Raw (green)']);  
        xlabel('CV %');
        ylabel('Density');
    end


    
        
        
        %% Call back add class info button
    function call_addClassInfo(hObject,eventdata,h)
        rows = featureWizard;
        if rows == 0
            return;
        end
        rows = rows';
        tb1 = get(tb,'data')
        if ~isequal(tb1,[])
            tb1(1,:) = [];
            tb1 = [rows; tb1];
            set(tb,'data',tb1);
            if isappdata(normalizeBut,'normalFiles')
                normFiles = getappdata(normalizeBut,'normalFiles');
                normFiles(1,:) = [];
                normFiles = [rows; normFiles];
                setappdata(normalizeBut,'normalFiles',normFiles)
            end
            if isappdata(filterButton,'finalNorm')
                normFiles = getappdata(filterButton,'finalNorm');
                normFiles(1,:) = [];
                normFiles = [rows; normFiles];
                setappdata(filterButton,'finalNorm',normFiles);
            end
            if isappdata(filterButton,'finalRaw')
                normFiles = getappdata(filterButton,'finalRaw');
                normFiles(1,:) = [];
                normFiles = [rows; normFiles];
                setappdata(filterButton,'finalRaw',normFiles);
            end
            tb2dat = get(tb2,'data')
            if ~isequal(tb2,[])
                tb2dat(1,:) = [];
                tb2dat = [rows; tb2dat];
                set(tb2,'data',tb2dat);
            end
            tb3dat = get(tb3,'data')
            if ~isequal(tb3,[])
                tb3dat(1,:) = [];
                tb3dat = [rows; tb3dat];
                set(tb3,'data',tb3dat);
            end
                  
        end
        %fill in
    end
        %% Call back browse already merged files
    function call_browseMerged(hObject,eventdata,h)
        [file,dirname]=uigetfile({'*.*'});%'*.xls';'*.xlsx';'*.tsv';'*.txt';'*.normalized_results';'*.mirna.quantification.txt'});
        if isequal(dirname,0)
            return;
        end
        [~, ~, final] = xlsread([dirname '/' file]);
        final(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),final)) = {''};
        final(cellfun(@(x) strcmpi(x, 'N/A'),final)) = {NaN};
        for i = 1:size(final,1)
            if isequal(class(final{i,1}), 'double')
                final{i,1} = num2str(final{i,1});
            end
        end
        %dataset = uiimport([dirname '/' file]);
        class(final)
        set(tb,'data','');
        set(tb,'data',final);
        
%         data = dataset.data;
%         data = num2cell(data);
%         titles = dataset.textdata;
%         top = titles(1,:);
%         side = titles(2:end,1);
%         reconstructed = [side data];
%         final = [top; reconstructed];
         assignin('base','mergedData',final);
         set(tb,'data','');
         set(tb,'data',final);
         set(texter,'String',dirname,'FontSize',13,'HorizontalAlignment','left');
         setappdata(browse1,'files',final)
         setappdata(browse1,'dirname',dirname)
         setappdata(browse1,'backup',final)
         set(tb2,'data',final)
         set(tb3,'data',final)
         [nrows,ncols] = size(final);
         set(changeingString,'String',num2str(nrows-1));
         set(TabHandles{3,2},'Enable','on');
         set(TabHandles{4,2},'Enable','on');
         set(bg,'selectedObject',[]);
         set(changeNormHeading,'String','');
        
       
        %fill in
    end  
        
        %% Call back, toggle Filter button, tab pg 4
    function call_toggleFilter(hObject,eventdata,h)
        if ~isappdata(normalizeBut,'flag');
            return;
        end
        button_state = get(hObject,'Value');
        datatb2 = get(tb2,'data');
        %Max is 1 and Min is 0
        backCol = get(toggleFilter,'BackgroundColor');
        if backCol == [1 0.6 0.4] %pink
            if isappdata(filterButton,'finalNorm')
                filterNorm = getappdata(filterButton,'finalNorm');
                set(tb3,'data',[]);
                set(tb3,'data',filterNorm);
                set(changeingString,'String',num2str(size(filterNorm,1)-1));
                xtag  = get(get(bg,'SelectedObject'),'Tag');
                set(toChangeFiltString,'String',xtag);
                
            elseif ~isappdata(filterButton,'finalNorm') && ~isequal(datatb2,[]);
                set(tb3,'data',datatb2);
                set(changeingString,'String',num2str(size(datatb2,1)-1));
                xtag = get(get(bg,'SelectedObject'), 'Tag');
                set(toChangeFiltString,'String',xtag);
               
            else
                return;
            end
            set(toggleFilter,'String','Show raw data');
            set(toggleFilter,'BackgroundColor',[0.1490196078 0.7490196078 0.933333333]);
        elseif backCol == [0.1490196078 0.7490196078 0.933333333]; %blue
            if ~isappdata(filterButton,'finalRaw');
                orig = getappdata(browse1,'files');
                set(tb3,'data',orig);
                set(toChangeFiltString,'String','');
                
            else
                raw = getappdata(filterButton,'finalRaw');
                set(tb3,'data',raw);
                set(changeingString,'String',num2str(size(raw,1)-1));
               
            end
            set(toggleFilter,'String','Show normalized data');
            set(toggleFilter,'BackgroundColor',[1 0.6 0.4]);
        end          
        
    end
        
    
    %% Call back, heatmap push tool
    function call_heatmap(hObject,eventdata,h)
        
        if ~isappdata(browse1,'files')
            return;
        end
        
        tab = getappdata(savePush,'selectedTab');
        if tab == 1
            data = get(tb,'data');
            
            labels_mirnas = data(2:end,1);
            class(labels_mirnas)
            sample_labels = data(1,2:end);
            dataset = replaceZeros(cell2mat(data(2:end,2:end)),'lowval');
            dataset = logTransform(dataset);
            dataset = bsxfun(@minus,dataset,nanmedian(dataset));
            clustergram(dataset,'RowLabels',labels_mirnas,'ColumnLabels',sample_labels, ...
                'RowPDist', 'spearman', 'ColumnPDist', 'spearman', 'Cluster', 2, 'Colormap', myColourMap);
        elseif tab == 3
            data = get(tb2,'data');
            
            labels_mirnas = data(2:end,1);
            sample_labels = data(1,2:end);
            dataset =replaceZeros(cell2mat(data(2:end,2:end)),'lowval');
            dataset = logTransform(dataset);
            dataset = bsxfun(@minus,dataset,nanmedian(dataset));
            clustergram(dataset,'RowLabels',labels_mirnas,'ColumnLabels',sample_labels, ...
                'RowPDist', 'spearman', 'ColumnPDist', 'spearman', 'Cluster', 2, 'Colormap', myColourMap);
        elseif tab == 4
            data = get(tb3,'data');
            
            labels_mirnas = data(2:end,1);
            sample_labels = data(1,2:end);
            dataset = replaceZeros(cell2mat(data(2:end,2:end)),'lowval');
            dataset = logTransform(dataset);
            dataset = bsxfun(@minus,dataset,nanmedian(dataset));
            clustergram(dataset,'RowLabels',labels_mirnas,'ColumnLabels',sample_labels, ...
                'RowPDist', 'spearman', 'ColumnPDist', 'spearman', 'Cluster', 2, 'Colormap',myColourMap);
        end
        
    end
            
            
        %% Call back, toolbar, save push tool
    function call_savePush(hObject,eventdata,h)
        if ~isappdata(browse1,'files')
            return;
        end
            
        tab = getappdata(savePush,'selectedTab');
        %mergedDataOut = get(tb,'data'); %This will save with the changed sample titles
        [FileName,PathName] = uiputfile('*.txt','Save file','File Name');
        fname = fullfile(PathName, FileName);
        if isequal(FileName,0)
            return;
        end
        if tab == 1
            mergedDataOut = get(tb,'data'); %This will save with the changed sample titles
            saveThings(fname,mergedDataOut);  
        elseif tab == 3
            mergedDataOut = get(tb2,'data');
            saveThings(fname,mergedDataOut);
        elseif tab == 4
            mergedDataOut = get(tb3,'data');
            saveThings(fname,mergedDataOut);
        end
            %have an option for windows computers, to use xlswrite because its
            %quicker and more efficient
            %xlswrite(fname, mergedData)
            %fill in
            
            
            %fill in
        end
    

%% Call back, toolbar, reset push tool
% Make sure it resets the names in the other tables as well
    function call_resetPush(hObject,eventdata,h)
        tab = getappdata(savePush,'selectedTab');
        if tab == 1
            if isappdata(browse1,'oldFiles')
                mergedData = getappdata(browse1,'oldFiles');
                set(tb,'data',[]);
                set(tb,'data',mergedData);
                setappdata(browse1,'files',mergedData)
            else
                return;
            end
        elseif tab == 3
            if isappdata(browse1,'files')
                fileReads = getappdata(browse1,'files');
                set(tb2,'data',fileReads);
            else
                return;
            end
        elseif tab == 4
            if ~isappdata(browse1,'files')
                return;
            else
                files = getappdata(browse1,'files');
                set(sentenceCode,'Visible','off');
                set(xToFill,'Visible','off');
                set(thresholdToFill,'Visible','off');
                if get(toggleFilter,'BackgroundColor') == [0.1490196078 0.7490196078 0.933333333]             %<---------
                    set(thresholdEditbox,'String','');
                    set(enterString,'String','');
                    if ~isequal(get(tb2,'data'),[])
                        set(tb3,'data',get(tb2,'data'));
                        datatab2 = get(tb2,'data');
                        set(changeingString,'String',num2str(size(datatab2,1)-1));
                    else
                        return;
                    end
                    if isappdata(filterButton,'finalNorm')
                        rmappdata(filterButton,'finalNorm')
                    end
                    if isappdata(filterButton,'finalRaw')
                        rmappdata(filterButton,'finalRaw')
                    end
                else
                    set(tb3,'data',files);
                    [nrows,ncols] = size(files);
                    set(changeingString,'String',num2str(nrows-1));
                    set(toChangeFiltString,'String','');
                    set(enterString,'String','');
                    set(thresholdEditbox,'String','');
                    if isappdata(filterButton,'finalNorm')
                        rmappdata(filterButton,'finalNorm')
                    end
                    if isappdata(filterButton,'finalRaw')
                        rmappdata(filterButton,'finalRaw');
                    end
                end
            end
            
        end
    end
        %fill in
    
        %% Call back for toolbar graph button, launches the appropriate analysis GUI depending on the selected tab
    function call_graphPush(hObject,eventdata,h)
        tab = getappdata(savePush,'selectedTab');
        if tab == 1
            if isappdata(browse1,'files')
                mergedData = getappdata(browse1,'files');
                rawCounts(mergedData);
            else
                return;
            end
        elseif tab == 3
            
            tablDat = get(tb2,'data');
            if isequal(tablDat,[]) %this works
                return
            else
              xtag = get(get(bg,'SelectedObject'),'Tag');
              rawCounts(tablDat,xtag);
            end
        elseif tab == 4
            uiwait(msgbox('The data you are about to look at is the same that is displayed in the table. If you want to look at the normalized data, make sure you click on the toggle button above.','Info','modal'));
            analy = get(tb3,'data');
            mergedData = getappdata(browse1,'files');
            val = get(toggleFilter,'BackgroundColor');
            if isequal(analy,[])
                return;
            else
                if isappdata(normalizeBut,'flag')
                    xtag = get(get(bg,'SelectedObject'), 'Tag');
                    set(toChangeFiltString,'String',xtag);
                    size(analy,1)-1
                    size(mergedData,1)-1
                    rawCounts(analy,xtag,size(analy,1)-1,size(mergedData,1)-1);
                else
                    rawCounts(analy,'',size(analy,1)-1,size(mergedData,1)-1);
                end
            end
            
            %fill in
        end
    end
    

   
        
 

    %% Call back for filter button
    
    %Use normalized to do filtering, normalized data is necessary to filter
    
    function call_filterBut(hObject,eventdata,h)
        filterCut = get(enterString,'String');
        
        
        if isequal(filterCut,'')
            return;
        else
            filterCut = str2num(filterCut);
            thresholdSamp = get(thresholdEditbox,'String');
            thresholdSamp = str2num(thresholdSamp);
            
        end
        
        mergedData = get(tb,'data');
        
        isnormalized = get(tb2,'data');
        if ~isequal(isnormalized,[])
            mergedNumbers = cell2mat(isnormalized(2:end,2:end));
            if isappdata(normalizeBut,'flag')
                xtag = get(get(bg,'SelectedObject'), 'Tag');
                set(toChangeFiltString,'String',xtag);
            end
        else
            mergedNumbers = cell2mat(mergedData(2:end,2:end));
        end
        
        filterCut = filterCut/100;
        if isequal(thresholdSamp,'')
            [m,rt] = markLowCounts(mergedNumbers,filterCut);
        else
            [m,rt] = markLowCounts(mergedNumbers,filterCut,thresholdSamp);
        end
        rawMergedNumbers = cell2mat(mergedData(2:end,2:end));
        rawMergedNumbers(m,:) = [];
        colNames = mergedData(2:end,1);
        colNames(m) = [];
        numMiRNA = length(colNames);
        %(changeingString,'String',num2str(numMiRNA));
        sampleNames = mergedData(1,:);
        rawMergedNumbers = num2cell(rawMergedNumbers);
        concat = [colNames, rawMergedNumbers];
        final = [sampleNames; concat];
        %setappdata(filterButton,'finalRaw',final);
        set(tb3,'data',final);
        finalNorm = [];
        if isappdata(normalizeBut,'flag')
            normalFiles = get(tb2,'data');
            normalNumbers = cell2mat(normalFiles(2:end,2:end));
            if isequal(thresholdSamp,'')
                [m,rt] = markLowCounts(normalNumbers,filterCut);
            else
                [m,rt] = markLowCounts(normalNumbers,filterCut,thresholdSamp);
            end
            colNormNames = normalFiles(2:end,1);
            normalNumbers(m,:) = [];
            colNormNames(m) = [];
            sampleNames = normalFiles(1,:);
            normalNumbers = num2cell(normalNumbers);
            concatNorm = [colNormNames, normalNumbers];
            finalNorm = [sampleNames; concatNorm];
            %setappdata(filterButton,'finalNorm',finalNorm);
        end
        val = get(checkBoxStar,'Value');
        if val == 1
            temp = find(~cellfun(@isempty,strfind(final(2:end,1),'STAR')));
                final(temp+1,:) = [];
                if ~isequal(finalNorm,[])
                    finalNorm(temp+1,:) = [];
                end
                
        end
        setappdata(filterButton,'finalRaw',final);
        setappdata(filterButton,'finalNorm',finalNorm);
                
                
       
        val = get(toggleFilter,'BackgroundColor');
        if val == [0.1490196078 0.7490196078 0.933333333]
            set(tb3,'data',finalNorm);
            set(changeingString,'String',num2str(size(final,1)-1));
            if isappdata(normalizeBut,'flag')
                xtag = get(get(bg,'SelectedObject'), 'Tag');
                set(toChangeFiltString,'String',xtag);
            end    
        else
            set(tb3,'data',final);
            set(changeingString,'String',num2str(size(final,1)-1)); %need to change this
        end
        set(sentenceCode,'Visible','on');
        mergedOrigRaw = cell2mat(mergedData(2:end,2:end));
        [m,rt] = markLowCounts(mergedOrigRaw,filterCut);
        set(xToFill,'String',num2str(rt)); %need to change this
        set(xToFill,'Visible','on');
        if isequal(thresholdSamp,'');
            set(thresholdToFill,'String','1');
        else
            set(thresholdToFill,'String',num2str(thresholdSamp));
        end
        set(thresholdToFill,'Visible','on');
        
    end
            
        
    %% Call back for normalize button
    function call_normalize(~,~,~)
        
        if isappdata(browse1,'files') 
            %fileLengths = getappdata(browse1,'lengths');
            fileReads = getappdata(browse1,'files');
            dirname = getappdata(browse1,'dirname');
        else
            
            return;
        end
        setappdata(normalizeBut,'flag','true');
        fileHeadings = fileReads(1,2:end);
        fileColHeadings = fileReads(:,1); %includes the title 'miRNANAmes'
        fileReads1 = cell2mat(fileReads(2:end,2:end)); %all the files will need this to get logTransformed
        sums = nansum(fileReads1(:,1));
        rowsR = size(fileReads1,1);
        colsR = size(fileReads1,2);
        xtag = get(get(bg,'SelectedObject'), 'Tag');
        set(changeNormHeading,'String',xtag);
        normalized = zeros(rowsR,colsR);
        meanTotal = nanmean(nanmean(fileReads1));
        if isequal(xtag, 'TMM')
            normalized = cpm(fileReads,'TMM');
            %{
            factors = Tmm(fileReads);
            normalized = zeros(size(fileReads1));
            for t = 1:length(factors);
                normalized(:,t) = factors(t) * fileReads1(:,t);
            end
            %}
            normalized = num2cell(normalized);
            intermediate = [fileHeadings; normalized];
            things = [fileColHeadings, intermediate];
            
            set(tb2,'data',things);
            
            %add some more equations and things, plus I think you need the
            %miRNA lengths for this one
        elseif isequal(xtag,'DESEQ')
            
            factors = DeSeq(fileReads);
            normalized = zeros(size(fileReads1));
            for t = 1:length(factors)
                normalized(:,t) = factors(t) * fileReads1(:,t);
            end
            
            normalized = num2cell(normalized);
            intermediate = [fileHeadings; normalized];
            things = [fileColHeadings, intermediate];
            set(tb2,'data', things);
          
        elseif isequal(xtag,'Total Counts')
            
            normalized = normalizeSeqData(fileReads1,'rf',[]);
            normalized = num2cell(normalized);
            intermediate = [fileHeadings;normalized];
            things = [fileColHeadings,intermediate];
            set(tb2,'data',things);
            
        elseif isequal(xtag,'Median')
            normalized = normalizeSeqData(fileReads1,'med',[]);
          
            set(tb2,'data',normalized);
            normalized = num2cell(normalized);
            intermediate = [fileHeadings; normalized];
            things = [fileColHeadings, intermediate];
            set(tb2,'data',things);
            
                
            %do something
        elseif isequal(xtag,'Upper Quantile')
            
            normalized = normalizeSeqData(fileReads1,'uq',[]);
            
            set(tb2,'data',normalized);
            normalized = num2cell(normalized);
            intermediate = [fileHeadings; normalized];
            things = [fileColHeadings, intermediate];
            set(tb2,'data',things);
            
        
        else
            uiwait(msgbox('No selection made','Message','modal'));
        end
        tabDat = get(tb2,'data');
        setappdata(normalizeBut,'normalFiles',tabDat);
        orig = getappdata(browse1,'files');
        set(tb3,'data',orig);
        set(changeingString,'String',size(orig,1)-1)
        if isappdata(filterButton,'finalNorm') 
            rmappdata(filterButton,'finalNorm')
        end
        if isappdata(filterButton,'finalRaw')
            rmappdata(filterButton,'finalRaw')
        end
        set(toggleFilter,'BackgroundColor',[1 0.6 0.4]);
        set(toggleFilter,'String','Show normalized data');
        set(thresholdEditbox,'String','');
        set(enterString,'String','');
        set(toChangeFiltString,'String','');
            
    end   
            
        
     
   
        
    
        
        %% load Button first Tab Page 1
        %uiwait(warndlg('WARNING: In loading new data, you will reset the graphs from tab 3','Warning','modal'))
    function loadButton(hObject,eventdata,h)
       
        
        dirname = uigetdir('File Selector');
        if isequal(dirname,0)
            return;
        end
        
        filenames = readAllFiles(dirname);
        mergedData = combineSamples_v2(filenames);
        set(tb,'data',[]);
        set(tb,'data',mergedData);
        set(texter,'String',dirname,'FontSize',13,'HorizontalAlignment','left');
        set(bg,'selectedObject',[]);
        set(changeNormHeading,'String','');
        assignin('base','mergedData',mergedData)
        setappdata(browse1,'files',mergedData)
        setappdata(browse1,'dirname',dirname)
        setappdata(browse1,'backup',mergedData)
        set(tb2,'data',mergedData)
        set(tb3,'data',mergedData)
        [nrows,ncols] = size(mergedData);
        set(changeingString,'String',num2str(nrows-1));
        set(TabHandles{3,2},'Enable','on');
        set(TabHandles{4,2},'Enable','on');
        
    end

    %% Call back for change sample name button
    function call_changeButton(hObject,eventdata,h)
        if isappdata(browse1,'files')
            mergedData = getappdata(browse1,'files');
        else
            return;
        end
        setappdata(browse1,'oldFiles',mergedData)
        unchanged = getappdata(browse1,'backup');
        resetTitles = unchanged(1,2:end);
        sampleNames = mergedData(1,2:end);
        %sampleName = sampleNames(1);
        %sampleName = char(sampleName);
        newTitles = changeSampleName(sampleNames,resetTitles);
        
        mergedData(1,2:end) = newTitles;
        setappdata(browse1,'files',mergedData)
        set(tb,'data',mergedData); 
        gettb2 = get(tb2,'data');
        gettb2(1,2:end) = newTitles;
        set(tb2,'data',gettb2);
        gettb3 = get(tb3,'data');
        gettb3(1,2:end) = newTitles;
        set(tb3,'data',gettb3);
        if isappdata(filterButton,'finalRaw')
            finalRaw = getappdata(filterButton,'finalRaw');
            finalRaw(1,2:end) = newTitles;
            setappdata(filterButton,'finalRaw',finalRaw);
        end
        if isappdata(filterButton,'finalNorm')
            finalNorm = getappdata(filterButton,'finalNorm');
            finalNorm(1,2:end) = newTitles;
            setappdata(filterButton,'finalNorm',finalNorm);
        end
        if isappdata(browse1,'oldFiles')
            oldies = getappdata(browse1,'oldFiles');
            oldies(1,2:end) = newTitles;
            setappdata(browse1,'oldFiles',oldies);
        end
        if isappdata(normalizeBut,'normalFiles')
            normalFiles = getappdata(normalizeBut,'normalFiles')
            normalFiles(1,2:end) = newTitles;
            setappdata(browse1,'normalFiles',normalFiles);
        end
            
       
    end
    

    %% FASTQ CONTROLS
    
    %% Callback for browse for fastQ data
    function browseFastQ(~,~,~)
        %consider putting all this stuff in a function, in a different
        %file:
        dirname= uigetdir('File Selector');
        if isequal(dirname,0)
            uiwait(errordlg('You did not select an input directory','Error','modal'));
            return;
        end
        dirnamesall = struct2cell(dir(dirname));
        dirnames = dirnamesall(1,:);
        tmp1 = (regexpi(dirnames, '(\w*\.fastq)', 'match'));
        filenames_all = sort(dirnames(~cellfun(@isempty,tmp1)));
        ind = ismember(dirnames, filenames_all); %we get 4 and 5 for the trial fastq directory
        
        fileSizes_all = dirnamesall(:,ind);
        fileSizes = fileSizes_all(3,:);
        limit = quantile(cell2mat(fileSizes), 0.01);
        fileSizes = cell2mat(fileSizes);
        for i = 1:length(fileSizes)
            if fileSizes(i) < limit;
                uiwait(warndlg('File size found below the 1st quantile limit','Warning','modal'));
                break;
            end
        end
        
        out = readFastQ([dirname '/' filenames_all{1}]);
        mystruct(1).filename = filenames_all{1};
        mystruct(1).out = out;
        
        h = waitbar(0,'Please wait...');
        for i = 2:length(filenames_all)
            mystruct(i).filename = filenames_all{i};
            mystruct(i).out = readFastQ([dirname '/' filenames_all{i}]);
            waitbar(i/length(filenames_all));
        end
        
        close(h)
        uiwait(msgbox('Files finished loading')); 
        setappdata(browseFQ,'files',mystruct);
        setappdata(browseFQ,'fileCount',1);
        data = mystruct(1).out;
        data = cell2mat(data);
        maxi = nanmax(data);
        mini = nanmin(data);
        range = maxi - mini;
        cla(histaxes);
        [counts, binCenters] = hist(data,range);
        axes(histaxes);
        h = bar(binCenters, counts, 'BarWidth', 1);
        set(get(h,'parent'),'clipping','on');
        set(get(gca,'child'), 'FaceColor','c','EdgeColor','k');
        set(filename,'String',filenames_all{1});
        yl = ylim;
        setappdata(browseFQ,'maxCount',yl); %this works, can store things in here
        hold on
    end

    %% Callback for back Button
    function backButton(~,~,~)
        if isappdata(browseFQ, 'fileCount');
            files = getappdata(browseFQ, 'files');
            numFile = getappdata(browseFQ, 'fileCount');
            numFile = numFile - 1;
            if numFile == 0;
                numFile = length(files);
            end
            
            setappdata(browseFQ, 'fileCount', numFile);
            out = files(numFile).out;
            out = cell2mat(out);
            maxi = nanmax(out);
            mini = nanmin(out);
            range = maxi - mini;
            %range is now the number of bins needed for single unit bins
            cla reset
            set(enterYlim,'String','');
            set(maxPopUp,'Value',1);
            set(minPopUp,'Value',1);
            if isappdata(maxPopUp, 'previous')
                rmappdata(maxPopUp, 'previous');
            end
            if isappdata(minPopUp,'previous')
                rmappdata(minPopUp, 'previous');
            end
            [counts,binCenters] = hist(out,range);
            axes(histaxes);
            bar(binCenters,counts, 'BarWidth',1);
            set(get(gca,'child'),'FaceColor','c','EdgeColor','k');
            set(filename, 'String', files(numFile).filename);
            yl = ylim;
            setappdata(browseFQ, 'maxCount',yl);
            hold on
            
        else
            return;
        end
        
        %fill in
    end

%% Call back for forward button
    function forwardButton(~,~,~)
        if isappdata(browseFQ, 'fileCount')
            files = getappdata(browseFQ, 'files'); %file is a struct
            numFile = getappdata(browseFQ, 'fileCount');
            numFile = numFile +1;
            if numFile > length(files);
                numFile = 1;
            end
            setappdata(browseFQ, 'fileCount', numFile);
            out = files(numFile).out;
            out = cell2mat(out);
            maxi = nanmax(out);
            mini = nanmin(out);
            range = maxi - mini;
            %range is now the number of bins needed for single unit bins
            cla reset
            set(enterYlim,'String','');
            set(maxPopUp,'Value',1);
            set(minPopUp,'Value',1);
            if isappdata(maxPopUp, 'previous');
                rmappdata(maxPopUp, 'previous');
            end
            if isappdata(minPopUp,'previous')
                rmappdata(minPopUp, 'previous');
            end
            [counts,binCenters] = hist(out,range);
            axes(histaxes);
            bar(binCenters,counts, 'BarWidth',1);
            set(get(gca,'child'),'FaceColor','c','EdgeColor','k');
            set(filename, 'String', files(numFile).filename);
            yl = ylim;
            setappdata(browseFQ, 'maxCount',yl);
            hold on
            
        else
           return;
        end
        %fill in
    end

%% Call back for clear button
    function clearButton(~,~,~)
        
        %have to reset all the appdata fields to some original value
        %set(filename,'String','');
        set(enterYlim,'String','');
        
        set(maxPopUp,'Value',1);
        set(minPopUp,'Value',1);
        %only remove these if the exist, so need an if statement
        if isappdata(browseFQ,'files');
            rmappdata(browseFQ,'files');
        end
        if isappdata(browseFQ,'fileCount');
            rmappdata(browseFQ,'fileCount');
        end
        if isappdata(browseFQ, 'maxCount');
            rmappdata(browseFQ, 'maxCount');
        end
        if isappdata(maxPopUp, 'previous');
            rmappdata(maxPopUp, 'previous');
        end
        if isappdata(minPopUp,'previous');
            rmappdata(minPopUp, 'previous');
        end
        if isappdata(minPopUp,'currentSel');
            rmappdata(minPopUp,'currentSel');
        end
        if isappdata(maxPopUp, 'currentSel');
            rmappdata(maxPopUp, 'currentSel');
        end
        %fill in
    end

%% Call back for min popup menu
    function minMenu(hObject,~,~)
        if ~isappdata(browseFQ,'files');
            return;
        end
        contents = cellstr(get(hObject, 'String'));
        selected = contents{get(hObject,'Value')};
        
        setappdata(minPopUp,'currentSel',selected);
        if isappdata(maxPopUp,'currentSel') %there exists a current selection
            compare = str2num(getappdata(maxPopUp, 'currentSel'));
            current = str2num(selected);
            if (compare<current)
                uiwait(warndlg('Warning: The minimum value you have selected is greater than the maximum value selected','Warning','modal'));
                
            end
        end
        if isappdata(minPopUp, 'previous');
            previousLine = getappdata(minPopUp, 'previous');
            axes(histaxes);
            delete(previousLine);
            axes(histaxes);
            x = str2num(selected);
            setappdata(minPopUp,'currentSelMinPop',x)
            maxOfLine = getappdata(browseFQ, 'maxCount');
            ph = plot([x x], [0 maxOfLine(2)]);
            set(ph, 'Color', 'r', 'LineStyle', '--', 'LineWidth', 3);
            setappdata(minPopUp, 'previous', ph);
        else
            axes(histaxes);
            x = str2num(selected);
            setappdata(minPopUp,'currentSelMinPop',x)
            maxOfLine = getappdata(browseFQ, 'maxCount');
            ph = plot([x, x], [0 maxOfLine(2)]);   %change the four to the max of the histogram
            set(ph, 'Color', 'r', 'LineStyle', '--', 'LineWidth', 3);
            setappdata(minPopUp, 'previous', ph);
        end
        
        
        %fill in
    end

%% Call back for max popup menu
    function maxMenu(hObject,~,~)
        if ~isappdata(browseFQ,'files')
            return;
        end
        contents = cellstr(get(hObject, 'String'));
        selected = contents{get(hObject,'Value')};
        setappdata(maxPopUp,'currentSel',selected);
        
        if isappdata(minPopUp,'currentSel') %there exists a current selection
            compare = str2num(getappdata(minPopUp, 'currentSel'));
            current = str2num(selected);
            if compare>current
                uiwait(warndlg('Warning: The maximum value you have selected is less than the minimum value selected','Warning','modal'));
            end
        end
        
        
        if isappdata(maxPopUp, 'previous')
            previousLine = getappdata(maxPopUp, 'previous');
            axes(histaxes);
            delete(previousLine);
            contents = cellstr(get(hObject, 'String'));
            selected = contents{get(hObject, 'Value')};
            axes(histaxes);
            x = str2num(selected);
            setappdata(maxPopUp,'currentSelMaxPop',x)
            maxOfLine = getappdata(browseFQ, 'maxCount');
            ph = plot([x x], [0 maxOfLine(2)]);
            set(ph, 'Color', 'k', 'LineStyle', '--', 'LineWidth', 3);
            setappdata(maxPopUp, 'previous', ph);
        else
            contents = cellstr(get(hObject,'String')); %returns maxMenu contents as cell array
            selected = contents{get(hObject,'Value')}; %returns selected item from maxMenu
            axes(histaxes);
            x = str2num(selected);
            setappdata(maxPopUp,'currentSelMaxPop',x)
            maxOfLine = getappdata(browseFQ, 'maxCount');
            ph = plot([x, x], [0 maxOfLine(2)]);   %change the four to the max of the histogram
            set(ph, 'Color', 'k', 'LineStyle', '--', 'LineWidth', 3);
            setappdata(maxPopUp, 'previous', ph);
        end
        %fill in
    end

%% Call back for user input box
    function enterYinput(hObject,~,~)
        axisLimit = str2double(get(hObject,'String')); %returns contents of enterMaxY as a double
        axes(histaxes);
        set(histaxes,'clipping','on');
        if axisLimit ~= 0
            ylim([0 axisLimit]);
            if isappdata(minPopUp,'previous')
                %basically going to replot the line
                selected = getappdata(minPopUp,'currentSelMinPop')
                ph = plot([selected selected],[0 axisLimit])
                set(ph,'Color','r','LineStyle','--','LineWidth',3);
                setappdata(minPopUp,'previous',ph);
            end
            if isappdata(maxPopUp,'previous')
                selected = getappdata(maxPopUp,'currentSelMaxPop')
                ph = plot([selected selected],[0 axisLimit])
                set(ph,'Color','k','LineStyle','--','LineWidth',3);
                setappdata(maxPopUp,'previous',ph);
            end     
        else
            originalY = getappdata(browseFQ, 'maxCount');
            ylim(originalY);
        end
        %fill in
    end
    



    
        
        %%   Save the TabHandles in guidata
        guidata(hTabFig,TabHandles);
        
        %%   Make Tab 1 active
        TabSellectCallback(0,0,1);
        setappdata(savePush,'selectedTab',1)
        
        %   Define the callbacks for the Tab Buttons
        % All callbacks go to the same function with the additional argument being the Tab number
        for CountTabs = 1:numTabs
            set(TabHandles{CountTabs,2}, 'callback', ...
                {@TabSellectCallback, CountTabs});
        end
        
        
        
        
        
        
        %% Tab Select Callback function
    function TabSellectCallback(~,~,SelectedTab)
        setappdata(savePush,'selectedTab',SelectedTab)
        
        %   All tab selection pushbuttons are greyed out and uipanels are set to
        %   visible off, then the selected panel is made visible and it's selection
        %   pushbutton is highlighted.
        
        
        %   Set up some varables
        %previous = 1;
        TabHandles = guidata(gcf);
        %if isappdata(tb2,'previousTab')
         %   previous = getappdata(tb2,'previousTab')
        %end
        NumberOfTabs = size(TabHandles,1)-2;
        White = TabHandles{NumberOfTabs+2,2};            % White
        BGColor = TabHandles{NumberOfTabs+2,3};          % Light Grey
        
        %   Turn all tabs off
        for TabCount = 1:NumberOfTabs
            set(TabHandles{TabCount,1}, 'Visible', 'off');
            set(TabHandles{TabCount,2}, 'BackgroundColor', BGColor);
        end
        
        %   Enable the selected tab
       
        %position = get(TabHandles{previous,1},'Position')
        
        %set(TabHandles{SelectedTab,1},'Units','normalized');
        %set(TabHandles
        set(TabHandles{SelectedTab,1}, 'Visible', 'on');
        set(TabHandles{SelectedTab,2}, 'BackgroundColor', White);
        %setappdata(tb2,'previousTab',SelectedTab)
    end
end


        