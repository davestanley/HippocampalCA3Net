%%Function to calculate synchrony measure.
%%
%%Usage:
%%
%%K = get_me_kappa(filename, range, dt)
%%
%%       filename is a string. %d should be included
%%           like: filename = "valami%d.dat";
%%       range is a vector specifying files to be used
%%           like: range = 1:100;
%%       dt is binning interval, like: 1e-3

function K = get_me_kappa(filename, range, dt)

  sejtszam=length(range);

  for r = range
    fn = sprintf(filename,r);
%     fprintf (['fn = ' fn '\n']);
    fid = fopen(fn,'r','native');
    data = fscanf(fid,'%g',Inf);
    data = data(find(data));

    if (~exist('raw'))
      if (isempty(data))
        raw=0;
      else
        raw = data;
      end
    else
      di=size(data,1)-size(raw,1);
      if (di > 0)
        raw(size(raw,1)+1:size(raw,1)+di,:)=0;
      elseif (di < 0)
        data(size(data,1)+1:size(data,1)-di,:)=0;
      end
      raw = [raw data];
    end
    fclose(fid);
  end

  val = floor(raw/dt);
  raster = zeros(max(max(val)),sejtszam);

  m = 1;
  for r = range
    if (sum(val(:,r)) ~= 0)
      raster(val(find(val(:,r)),r),m) = 1;
      m=m+1;
    end
  end

  nevezok = sum(raster);

  K=0;

  for i = 1:m-1
    for j = 1:i-1
      K = K + sum(raster(:,i).*raster(:,j))/sqrt(nevezok(i)*nevezok(j));
    end
  end

  K= 2*K/(sejtszam*(sejtszam-1));

end