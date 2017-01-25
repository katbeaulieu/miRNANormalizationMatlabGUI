function call_CVPlotNormed(raw_data,normalized_data)
        %raw_data = get(tb,'data');
        assignin('base','raw',raw_data(2:end,2:end))
        raw_data = raw_data(2:end,2:end);
        %assignin('base','raw',raw_data(2:end,:))
        %normalized_data = get(tb2,'data');
        normalized_data = normalized_data(:,2:end);
        norm0_cv = (std(normalized_data,0,2)./mean(normalized_data,2)).*100;
        norm1_cv = (std(raw_data,0,2)./mean(raw_data,2)).*100;
        
        [f,xi] = ksdensity(norm0_cv);
        figure
        plot(xi,f,'r');
        hold on
        [f,xi] = ksdensity(norm1_cv);
        plot(xi,f,'g');
        %xtag = get(get(bg,'SelectedObject'),'Tag');
        title(['DESeq',' (red) and Raw (green)']);
        xlabel('CV %');
        ylabel('Density');
    end