clear all
clc
load('proj_fit_07')
X1 = id.X{1};
X2 = id.X{2};
Y = id.Y;

vX1 = val.X{1};
vX2 = val.X{2};
vY = val.Y;

mesh(id.X{1}, id.X{2}, id.Y);
hold on
mesh(val.X{1}, val.X{2}, val.Y);
title('Date intrare-iesire');

mseval=[];
mseid=[];
for m=1:10
    phi_id=[];
    for i=1:length(X1)
        for j=1:length(X2)
            phi_idlinie=[];
            for k=0:m
                for l=0:m
                    if k+l<=m
                        phi_idlinie=[phi_idlinie, (X1(i)^k*X2(j)^l)]; %fiecare element din X1 este inmultit cu fiecare element din X2
                    end
                end
            end
            phi_id=[phi_id; phi_idlinie];
        end
    end

Y_vector = reshape(Y,[],1);
Yt=Y';
theta=phi_id\Y_vector;
y_id=phi_id*theta;
phi_val=[];

for b=1:length(vX1)
    for a=1:length(vX2)
        phi_vallinie=[];
        for k=0:m
            for l=0:m
                if k+l<=m
                    phi_vallinie=[phi_vallinie,(vX1(b)^k * vX2(a)^l)];
                end
            end
        end
        phi_val=[phi_val; phi_vallinie];
    end
end

vYt=vY';
vY_vector=reshape(vY, [], 1);

Tetaa=phi_val\vY_vector;
y_val=phi_val*Tetaa;

r1=reshape(y_id,91,91);
min_len = min(length(y_id), length(Y_vector));
MSEi = (1/length(X1))*(sum(Y- r1).^2);
mseidf=sum(MSEi)/91;

r2=reshape(y_val,131,131);
min_len_val=min(length(y_val), length(vY_vector));
MSEv=(1/length(vX1))*(sum(vY-r2).^2);
msevalf=sum(MSEv)/131;

mseid = [mseid mseidf];
mseval = [mseval msevalf];
end

figure
mesh(reshape(y_id, size(id.Y)))
title('aproximare id')
figure
mesh(reshape(y_val, size(val.Y)))
title('aproximare val')
figure
[x,index]=min(mseval, [], 'all', 'linear');
plot(mseval)
hold on
plot(index, x,'r*')
title('MSE');
