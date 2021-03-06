function [ act ] = keypress(hObject, eventdata, handles,key)
act='';
name=get(hObject,'Tag');
if handles.pc==2;
switch key
    
    case {'x','o','f','p','s'}
        return;
        
    case 'n'
        handles.figure_index=handles.figure_index+handles.fnum;
        if handles.figure_index>length(handles.sac);
            handles.figure_index=handles.figure_index-handles.fnum;
            state_new(hObject, eventdata, handles,'plotting_done');
        end
        guidata(hObject, handles);
        plot_freq(hObject, eventdata, handles);
    case 'b'
    if strcmp(name,'plotsac')
    handles.figure_index=handles.figure_index-handles.fnum;
    if  handles.figure_index<=0
        handles.figure_index=1;
        state_new(hObject, eventdata, handles,'plotting_first_one');
    end
    guidata(hObject, handles);
    plot_freq(hObject, eventdata, handles);
    else
        uicontrol(handles.sacfile_browser);
    end
end
return
end


switch key
    case 'n'
        handles.figure_index=handles.figure_index+handles.fnum;
        if handles.figure_index>length(handles.sac);
            handles.figure_index=handles.figure_index-handles.fnum;
            state_new(hObject, eventdata, handles,'plotting_done');
        end
        guidata(hObject, handles);
        plot_on(hObject, eventdata, handles);
    case 'b'
    if strcmp(name,'plotsac')
    handles.figure_index=handles.figure_index-handles.fnum;
    if  handles.figure_index<=0
        handles.figure_index=1;
        state_new(hObject, eventdata, handles,'plotting_first_one');
    end
    guidata(hObject, handles);
    plot_on(hObject, eventdata, handles);
    else
        uicontrol(handles.sacfile_browser);
    end
    case 'x'
        p = ginput(2);
        if ismember({get(gca,'Tag')},handles.ftag)==0;return;end
        handle=gca;UD=handle.UserData;
        UD.ax(1)=min(p(:,1));
        UD.ax(2)=max(p(:,1));
        set(gca,'UserData',UD);
        guidata(hObject, handles);
        axis_update2( hObject,UD,handles);
    case 'o'
        for i=1:handles.fnum
            name=handles.ftag{i};
            eval(['temp=handles.',name,';']);
            UD=temp.UserData;
            if UD.pindex>1
            p=UD.point(UD.pindex-1).p;
            UD.pindex=UD.pindex-1;
            UD.ax(1)=min(p(:,1));
            UD.ax(2)=max(p(:,1));
            set(temp,'UserData',UD);
            set(temp,'XLim',UD.ax(1:2));
            guidata(hObject, handles);
            end
        end
    case {'f','p','s'}
        if ismember({get(hObject,'Tag')},{'plotsac','figure1'})
            p = ginput(1);hold on;
            if ismember({get(gca,'Tag')},handles.ftag)==0;return;end
            handle=gca;UD=handle.UserData;
            switch key
                
                case 'f'
                   handles.sac(UD.figure_index).sac.F=p(1);temp='F';
                case 'p'
                    handles.sac(UD.figure_index).sac.A=p(1);temp='P';
                case 's'
                    handles.sac(UD.figure_index).sac.T0=p(1);temp='S';
            end
            
        Y=get(gca,'Ylim');
        plot([p(1),p(1)],[Y(1)*0.8,Y(2)*0.8],'r');text(p(1),Y(2)*0.9,temp);hold off;
        guidata(hObject, handles);
        end
   case handles.ret
       %[name,'_Callback(hObject, eventdata, handles)']
        act=[name,'_Callback(hObject, eventdata, handles);'];
   case 'c'
       if ismember({get(hObject,'Tag')},{'state'})
        set(hObject,'String', {'state'},'Value',1);end
       if ismember({get(hObject,'Tag')},{'sacfile_lst'})
        set(hObject,'String', {'sacfile list'},'Value',1);end
       if ismember({get(hObject,'Tag')},'plotsac');
        creat_sacfigure(hObject, eventdata, handles,handles.fnum);end
    case 'w'
        temp='_temp';
        if handles.wo==1
            temp='';
        end
        for i=1:length(handles.sac)
            filename=[handles.sac(i).sac.FILENAME,'_temp_'];
            handles.sac(i).sac.FILENAME=filename;
            writesac(handles.sac(i).sac);
            movefile(filename,[handles.sac(i).filepath,temp]);
        end
    case 'r'
        act='readsacfile_Callback(hObject, eventdata, handles);';
   case 'q'
       close(gcbf);act='return;';
    case { '-', '+'}
        eval(['creat_sacfigure(hObject, eventdata, handles,handles.fnum',key,'1);']);
end
end

