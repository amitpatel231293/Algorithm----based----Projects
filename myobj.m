function out = myobj(A,a,i,w,lambda)

resid = a(:,i) - A*w;
out = 0.5*norm(resid)^2 + lambda*norm(w)^2;