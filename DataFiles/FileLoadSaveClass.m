classdef FileLoadSaveClass < matlab.mixin.Copyable
    
    properties
        filename;
        fileformat;
        supportedFomats;
        err;
    end
    
    
    methods
        
        % ----------------------------------------------------------------------------------
        function obj = FileLoadSaveClass()
            obj.filename = '';
            obj.fileformat = '';
            obj.supportedFomats = struct( ...
                'matlab', {{'.mat','matlab','mat'}}, ...
                'hdf5', {{'hdf','.hdf','hdf5','.hdf5','hf5','.hf5','h5','.h5'}} ...
                );
            obj.err=0;
        end
        
        
        % ---------------------------------------------------------
        function varargout=Load(obj, filename, format)
            if ~exist('filename','var')
                filename = obj.filename;
            end
            
            if ~exist('format','var')
                format = obj.fileformat;
            elseif obj.Supported(format)
                obj.fileformat = format;
            end
            
            switch(lower(format))
                case obj.supportedFomats.matlab
                    if ismethod(obj, 'LoadMat')
                        obj.LoadMat(filename);
                    end
                case obj.supportedFomats.hdf5
                    if ismethod(obj, 'LoadHdf5')
                        
                        flds=ListHDF5fields(filename);
                        cnt=1; parent={};
                        for i=1:length(flds)
                            f=strsplit(flds{i},'/');
                            if(length(f)>1 && ~isempty(strfind(f{2},'nirs')))
                            parent{cnt}=['/' f{2}];
                            cnt=cnt+1;
                            end
                        end
                        parent=unique(parent);
                        for i=1:length(parent)
                            obj(i)=obj(1);
                            obj(i).LoadHdf5(filename,parent{i});
                        end
                    end
            end
            if(nargout>0)
                varargout={obj};
            elseif(length(parent)>1)
                warning(['multiple /nirs entries found; use snirf=snirf.load(''' filename ''');']);
            end
        end
        
        
        % ---------------------------------------------------------
        function Save(obj, filename, format)
            if ~exist('filename','var')
                filename = obj.filename;
            end
            
            if ~exist('format','var')
                format = obj.fileformat;
            end
            
            switch(lower(format))
                case obj.supportedFomats.matlab
                    if ismethod(obj, 'SaveMat')
                        obj.SaveMat(filename);
                    end
                case obj.supportedFomats.hdf5
                    if ismethod(obj, 'SaveHdf5')
                        obj.SaveHdf5(filename);
                    end
            end
        end
        
        
        % ---------------------------------------------------------
        function b = Supported(obj, format)
            b = true;
            switch(lower(format))
                case obj.supportedFomats.matlab
                    return;
                case obj.supportedFomats.hdf5
                    return;
            end
            b = false;
        end
        

        % -------------------------------------------------------
        function B = ne(obj, obj2)
            if obj==obj2
                B = false;
            else
                B = true;
            end
        end
        
    end
end