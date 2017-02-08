function [v1 v2 v3]=sort3(w)
a=w(1)
b=w(2)
c=w(3)
if(a<=b)&&(a<=c)
    v1=a;
    if(b<=c)
        v2=b;
        v3=c;
    else
        v2=c;
        v3=b;
    end
end
if (b<=a)&&(b<=c)
    v1=b;
    if(a<=c)
        v2=a;
        v3=c;
    else
        v2=c;
        v3=a;
    end
end
if (c<=a)&&(c<=b)
    v1=c;
    if(a<=b)
        v2=a;
        v3=b;
    else
        v2=b;
        v3=a;
    end
end
end