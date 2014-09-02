classdef entity_info < handle
    %
    %   Class:
    %   neuroshare.entity_info
    %
    %
    %   ???? What is a neural entity vs an analog entity???
    %   
    %   NOTE: After looking at this, it seems like file might be better of
    %   loading the entity info and then creating the entities which it
    %   actually holds on to, rather than holding onto the entity info.
    
    properties (Hidden)
       file_pointer 
    end
    
    properties
        labels
        types
        counts %Is this better as samples???
    end
    
    methods
        function obj = entity_info(file_pointer,n_entities)
            
            %Does this work receiving multiple files at once????
            
            %????? Can we get multiple entities at once????
            
            [result_code, entity_info] = ns_GetEntityInfo(file_pointer,1:n_entities);
            
            neuroshare.handleError(result_code);
            
            %???? Is this a structure array?
            obj.labels = {entity_info.EntityLabel};
            obj.types  = [entity_info.EntityType];
            obj.counts = [entity_info.ItemCount];
            
            obj.file_pointer = file_pointer;
%     EntityLabel: 'CSC1'
%      EntityType: 2
%       ItemCount: 98572800
            
            
        end
        function neural_entities = getNeuralEntities(obj)
           n_neural = sum(obj.types == 4); 
           neural_entities = [];
        end
        function analog_entities = getAnalogEntities(obj)
           I_analog = find(obj.types == 2);
           n_analog = length(I_analog);
           
           %TODO: If 0, return null object
           
           temp_obj_ca = cell(1,n_analog);
           for iChan = 1:n_analog
               cur_I = I_analog(iChan);
               temp_obj_ca{iChan} = neuroshare.analog_entity(...
                   obj.file_pointer,obj.labels{cur_I},obj.counts(cur_I),cur_I);
           end
           
           analog_entities = [temp_obj_ca{:}];
        end
        function segment_entities = getSegmentEntities(obj)
           n_segment = sum(obj.types == 3); 
           segment_entities = [];
        end
        function event_entities = getEventEntities(obj)
           n_event = sum(obj.types == 1);
           segment_entities = [];
        end
    end
    
end

