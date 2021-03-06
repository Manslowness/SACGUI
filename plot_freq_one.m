function [ handles ] = plot_freq_one(hObject, eventdata, handles,index,mode)
bdFcn=get(gca,'ButtonDownFcn');
tag=get(gca,'Tag');
UD=get(gca,'UserData');

if handles.Edata==0;state_new(hObject, eventdata, handles,'no_data_read_in');return;end
i=index;if index<=0;i=1;state_new(hObject, eventdata, handles,'plotting_first_one');end

if i>length(handles.sac);
    state_new(hObject, eventdata, handles,'plotting_done');return;
end
sac=handles.sac(i).sac;
[comp,freq]=sac_freq(sac.DATA1,sac.DELTA);
handles.sac(i).comp=comp;handles.sac(i).freq=freq;
switch mode
    case 'phase'
        y=angle(comp);
    case 'amp'
        y=abs(comp);
    case 'real'
        y=real(comp);
    case 'img'
        y=real(comp);
end
l=length(freq);lb=floor(l/2);
if get(handles.loglog,'Value')
loglog(freq(1:lb),y(1:lb));
else
    plot(freq(1:lb),y(1:lb));
end
name=sac.FILENAME;time=datestr(datenum(sac.NZYEAR,1,0)+sac.NZJDAY);
hold off;legend([mode,': ',name,' ',time]);xlabel('f/hz');
xlim([0,freq(lb)]);
UD.figure_index=i;
new_handles = gca; 

set(new_handles,'Tag',tag,'Layer','top','ButtonDownFcn',bdFcn,'UserData',UD);
eval(['handles.',tag,'=new_handles;']);
guidata(hObject, handles);
end

