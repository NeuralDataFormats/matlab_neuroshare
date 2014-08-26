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
    
    properties
    end
    
    methods
        function obj = entity_info(file_pointer,n_entities)
            [code_result, entity_info] = ns_GetEntityInfo(file_pointer,1:n_entities);
            keyboard
            
%     EntityLabel: 'CSC1'
%      EntityType: 2
%       ItemCount: 98572800
            
            
        end
    end
    
end

