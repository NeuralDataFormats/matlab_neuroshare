classdef analog_entity
    %
    %   Class:
    %   neuroshare.entity.analog
    
    %{
    'ns_GetAnalogData.m'
'ns_GetAnalogInfo.m'
    
    %}
    
    properties (Hidden)
        file_pointer %This gets passed into any mex calls we make.
        entity_id
        file_path
    end
    
    properties
        name
        n_samples
        fs
        units
    end
    
    properties
        %There are additional properties in this 
        raw_analog_info
    end
    
    methods
        function obj = analog_entity(file_path,file_pointer,label,count,entity_id)
            %
            %   obj = neuroshare.analog_entity(file_pointer,label,count,entity_id)
            
            obj.file_pointer = file_pointer;
            
            obj.name      = label;
            obj.n_samples = count;
            
            obj.entity_id = entity_id;
            
            [result_code, nsAnalogInfo] = ns_GetAnalogInfo(file_pointer, entity_id);
            
            obj.raw_analog_info = nsAnalogInfo;
            
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
            %
            %   Calling Forms:
            %   --------------
            %   data_object = getData(obj,varargin)
            %
            %   [raw_data,time] = getData(obj,varargin)
            %   
            %
            %   Optional Inputs:
            %   ----------------
            %   return_object :
            %   data_range :
            %   time_range :
            %   leave_raw : logical (default false)
            %       If true, the data are not converted to double.
            
            
            
            

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
            
            if any(in.data_range > obj.n_samples)
                error('Data requested out of range')
            end
            
            if in.data_range(1) > in.data_range(2)
                error('Specified data range must be increasing')
            end
                        
            %1 based indexing ...
            %[ns_RESULT, ContCount, Data] = ns_GetAnalogData(hFile, EntityID, StartIndex, IndexCount);
            n_samples_get = in.data_range(2) - in.data_range(1) + 1;
            [result_code, ~, data] = ns_GetAnalogData(obj.file_pointer, obj.entity_id, in.data_range(1), n_samples_get);
            
            if n_samples_get ~= length(data)
                error('# of samples requested: %d, does equal the length of the returned data: %d',n_samples_get,length(data))
            end
            
            neuroshare.handleError(result_code)

            if isrow(data)
                data = data';
            end
            
            if in.return_object
                
                time_object = sci.time_series.time(...
                    1/obj.fs,...
                    length(data),...
                    'sample_offset',in.data_range(1));
                varargout{1} = sci.time_series.data(data,...
                    time_object,...
                    'units',obj.units,...
                    'channel_labels',obj.name,...
                    'history',sprintf('File: %s',obj.file_path));
            else
                varargout{1} = data;
                if nargout == 2
                    varargout{2} = (0:(length(data)-1)).*1/obj.fs;
                end
            end
            
        end
    end
    
end

