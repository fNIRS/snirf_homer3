function valout2 = hd5read_safeStrArray(fname, name, val)

  valout2 = {};
try
    try
        valout2 = h5read(fname, name);
    catch
        cnt=1;
        valout={};
        while(1)
            try
                valout{cnt}= h5read(fname, [name num2str(cnt)]);
                cnt=cnt+1;
            catch
                break;
            end
        end
        
        
        for ii=1:length(valout)
            valout2{ii,1} = convertH5StrToStr(valout{ii});
        end
    end
catch
    switch(class(val))
        case 'char'
            valout2 = '';
        case 'cell'
            valout2 = {};
        otherwise
           valout2 = [];
    end
end
