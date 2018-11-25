function X=norm4row(x)
G = diag([1e-7 1 1 1e1]);
X = x*G;
end