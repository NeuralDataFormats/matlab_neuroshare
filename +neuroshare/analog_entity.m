classdef analog_entity
    %
    %   Class:
    %   neuroshare.entity.analog
    
    %{
    'ns_GetAnalogData.m'
'ns_GetAnalogInfo.m'
    
    %}
    
    properties
        file_pointer
    end
    
    properties
        name
        n_samples
        fs
        units
    end
    
    methods
        function obj = analog_entity(file_pointer,label,count,entity_id)
            %
            %   obj = neuroshare.analog_entity(file_pointer,label,count,entity_id)
            
            obj.name = label;
            obj.n_samples = count;
            keyboard
            
            [result_code, nsAnalogInfo] = ns_GetAnalogInfo(file_pointer, entity_id);
            
            neuroshare.handleError(result_code)
            
            %TODO: Populate the analog info
            
            obj.fs = nsAnalogInfo.SampleRate;
            obj.units = nsAnalogInfo.Units;
            
            
            %         SampleRate: 32000
            %             MinVal: -3.5001e-04
            %             MaxVal: 3.5001e-04
            %              Units: 'V'
            %         Resolution: 1.0682e-08
            %          LocationX: 0
            %          LocationY: 0
            %          LocationZ: 0
            %       LocationUser: 0
            %     HighFreqCorner: 0
            %      HighFreqOrder: 0
            %     HighFilterType: 'unknown'
            %      LowFreqCorner: 0
            %       LowFreqOrder: 0
            %      LowFilterType: ''
            %          ProbeInfo: ''
            
        end
        function varargout = getData(obj,varargin)
            %[ns_RESULT, ContCount, Data] = ns_GetAnalogData(hFile, EntityID, StartIndex, IndexCount);
            
            

            in.return_object  = true;
            in.data_range     = [1 obj.n_samples];
            in.time_range     = []; 
            in.leave_raw      = false;
            in = sl.in.processVarargin(in,varargin);
            
            if isempty(in.time_range)
                %We populate this for comment retrieval
                in.time_range = (in.data_range-1)/obj.fs;
            else
                in.data_range(1) = floor(in.time_range(1)*obj.fs)+1;
                in.data_range(2) = ceil(in.time_range(2)*obj.fs)+1;
            end
            
            if any(in.data_range > obj.n_samples(record_id))
                error('Data requested out of range')
            end
            
            if in.data_range(1) > in.data_range(2)
                error('Specified data range must be increasing')
            end
            
            
            
            data = obj.sdk.getChannelData(...
                obj.file_h,...
                record_id,...
                obj.id,...
                in.data_range(1),...
                in.data_range(2)-in.data_range(1)+1,...
                in.get_as_samples,...
                'leave_raw',in.leave_raw);
            
            if isrow(data)
                data = data';
            end
            
            if in.return_object
                comments = obj.getRecordComments(record_id,'time_range',in.time_range);
                
                time_events = sci.time_series.time_events('comments',...
                    [comments.time],'values',[comments.id],...
                    'msgs',{comments.str});
                
                %TODO: This is not right if get_as_samples is false
                time_object = sci.time_series.time(...
                    obj.dt(record_id),...
                    length(data),...
                    'sample_offset',in.data_range(1));
                varargout{1} = sci.time_series.data(data,...
                    time_object,...
                    'units',obj.units{record_id},...
                    'channel_labels',obj.name,...
                    'history',sprintf('File: %s\nRecord: %d',obj.file_path,record_id),...
                    'events',time_events);
            else
                varargout{1} = data;
                if nargout == 2
                    varargout{2} = (0:(length(data)-1)).*obj.dt(record_id);
                end
            end
            
        end
    end
    
end

