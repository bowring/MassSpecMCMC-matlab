classdef MyMATLABClass < handle
    
    properties (Access = private)
        x % input variable
        y % input variable
        z % result variable
    end
    
    methods
        function this = MyMATLABClass()
            this.x = []; this.y = [];
        end
        
        function setInput(this, input)
            input = input(:);           
            if isnumeric(input) && numel(input) == 2
                this.x = input(1);
                this.y = input(2);
            end
        end
        
        function result = getResult(this)
            result = this.z;
        end
        
        function status = compute(this)
            try
                this.z = (this.x.^2 + this.y.^2)^0.5;
                status = true;
            catch
                status = false;
            end
        end
    end
    
end
